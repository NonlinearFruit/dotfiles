/**
 * Cursor Rules Extension for pi
 *
 * Implements the Cursor Rules spec: https://docs.cursor.com/context/rules
 *
 * Scans .cursor/rules/**\/*.{md,mdc} and applies them based on frontmatter:
 *
 *   ---
 *   description: "..."    # shown to agent so it can decide to load the rule
 *   globs: "src/**\/*.ts" # comma-separated or YAML list
 *   alwaysApply: false    # if true, rule is always injected
 *   ---
 *
 * Four rule types (per Cursor spec):
 *   1. Always Apply          (alwaysApply: true)  -> full body prepended to system prompt every turn
 *   2. Apply to Specific Files (globs set)         -> body injected as a steer when a tool touches a matching path
 *   3. Apply Intelligently   (description only)   -> indexed in system prompt with description; agent reads it via `read`
 *   4. Apply Manually        (no metadata)        -> indexed in system prompt; user can @-mention to pull it in
 *
 * Additional features:
 *   /cursor-rules           -> list loaded rules
 *   /cursor-rules reload    -> rescan .cursor/rules
 *   @rule-name in user input -> inline-expands that rule's contents (manual trigger)
 *
 * Placement:
 *   - Global:  ~/.pi/agent/extensions/cursor-rules-extension.ts
 *   - Project: .pi/extensions/cursor-rules-extension.ts
 */

import * as fs from "node:fs";
import * as path from "node:path";
import type { ExtensionAPI, ExtensionContext } from "@mariozechner/pi-coding-agent";

// ---------- Types ----------

type RuleKind = "always" | "glob" | "intelligent" | "manual";

interface CursorRule {
  /** Rule name, derived from filename without extension (relative, slash-separated). */
  name: string;
  absPath: string;
  /** Path relative to project root (for display). */
  relPath: string;
  description?: string;
  /** Parsed globs (empty array if none). */
  globs: string[];
  alwaysApply: boolean;
  body: string;
  kind: RuleKind;
}

// ---------- Frontmatter parsing ----------

/**
 * Minimal YAML-frontmatter parser supporting just what Cursor rules use:
 *   description: string (quoted or bare, single-line)
 *   globs: string | [list] | csv
 *   alwaysApply: true | false
 * Returns { data, body }. If no frontmatter, data is empty and body is the full input.
 */
function parseFrontmatter(source: string): {
  data: { description?: string; globs?: string | string[]; alwaysApply?: boolean };
  body: string;
} {
  const match = source.match(/^---\r?\n([\s\S]*?)\r?\n---\r?\n?([\s\S]*)$/);
  if (!match) return { data: {}, body: source };

  const [, fm, body] = match;
  const data: { description?: string; globs?: string | string[]; alwaysApply?: boolean } = {};

  const lines = fm.split(/\r?\n/);
  for (let i = 0; i < lines.length; i++) {
    const line = lines[i];
    const m = line.match(/^([A-Za-z_][\w-]*)\s*:\s*(.*)$/);
    if (!m) continue;
    const [, key, rawVal] = m;
    const val = rawVal.trim();

    if (key === "description") {
      data.description = stripQuotes(val);
    } else if (key === "alwaysApply") {
      data.alwaysApply = /^true$/i.test(val);
    } else if (key === "globs") {
      // Inline forms: "a,b", ["a","b"], a (bare)
      if (val.startsWith("[") && val.endsWith("]")) {
        data.globs = val
          .slice(1, -1)
          .split(",")
          .map((s) => stripQuotes(s.trim()))
          .filter(Boolean);
      } else if (val === "") {
        // Possibly a YAML block list on subsequent lines: "  - pattern"
        const list: string[] = [];
        let j = i + 1;
        while (j < lines.length) {
          const ln = lines[j];
          const lm = ln.match(/^\s*-\s*(.+)$/);
          if (!lm) break;
          list.push(stripQuotes(lm[1].trim()));
          j++;
        }
        if (list.length) {
          data.globs = list;
          i = j - 1;
        }
      } else {
        data.globs = stripQuotes(val);
      }
    }
  }

  return { data, body: body ?? "" };
}

function stripQuotes(s: string): string {
  if (
    (s.startsWith('"') && s.endsWith('"')) ||
    (s.startsWith("'") && s.endsWith("'"))
  ) {
    return s.slice(1, -1);
  }
  return s;
}

/** Convert a (possibly OS-native) path to forward-slash form for display and glob matching. */
function toPosix(p: string): string {
  return p.split(path.sep).join("/");
}

function normalizeGlobs(g: string | string[] | undefined): string[] {
  if (!g) return [];
  const arr = Array.isArray(g) ? g : g.split(",");
  return arr.map((s) => s.trim()).filter(Boolean);
}

// ---------- Rule discovery ----------

function findRuleFiles(dir: string): string[] {
  const results: string[] = [];
  if (!fs.existsSync(dir)) return results;

  const walk = (current: string) => {
    let entries: fs.Dirent[];
    try {
      entries = fs.readdirSync(current, { withFileTypes: true });
    } catch {
      return;
    }
    for (const e of entries) {
      const p = path.join(current, e.name);
      if (e.isDirectory()) walk(p);
      else if (e.isFile() && (e.name.endsWith(".mdc") || e.name.endsWith(".md"))) {
        results.push(p);
      }
    }
  };
  walk(dir);
  return results;
}

function loadRule(absPath: string, rulesDir: string, projectRoot: string): CursorRule | null {
  let raw: string;
  try {
    raw = fs.readFileSync(absPath, "utf8");
  } catch {
    return null;
  }

  const { data, body } = parseFrontmatter(raw);
  const relFromRules = toPosix(path.relative(rulesDir, absPath));
  const name = relFromRules.replace(/\.(md|mdc)$/i, "");
  const relPath = toPosix(path.relative(projectRoot, absPath));
  const globs = normalizeGlobs(data.globs);
  const alwaysApply = data.alwaysApply === true;

  let kind: RuleKind;
  if (alwaysApply) kind = "always";
  else if (globs.length > 0) kind = "glob";
  else if (data.description && data.description.trim().length > 0) kind = "intelligent";
  else kind = "manual";

  return {
    name,
    absPath,
    relPath,
    description: data.description,
    globs,
    alwaysApply,
    body: body.trim(),
    kind,
  };
}

// ---------- Glob matching ----------

/**
 * Test a filesystem path against a Cursor-style glob.
 * Paths are matched both relative-to-project and as-given.
 * Uses Node 22+ path.matchesGlob when available, else a regex fallback.
 */
function matchesGlob(filePath: string, projectRoot: string, pattern: string): boolean {
  const candidates = new Set<string>();
  candidates.add(filePath);
  if (path.isAbsolute(filePath)) {
    const rel = toPosix(path.relative(projectRoot, filePath));
    if (rel && !rel.startsWith("..")) candidates.add(rel);
  } else {
    candidates.add(toPosix(filePath));
  }

  const pat = pattern.startsWith("./") ? pattern.slice(2) : pattern;
  const nativeMatchesGlob = (path as unknown as { matchesGlob?: (p: string, g: string) => boolean })
    .matchesGlob;

  for (const c of candidates) {
    if (nativeMatchesGlob) {
      try {
        if (nativeMatchesGlob(c, pat)) return true;
        // Also try with leading **/ so "*.ts" matches nested files, mirroring gitignore/cursor ergonomics.
        if (!pat.includes("/") && nativeMatchesGlob(c, `**/${pat}`)) return true;
      } catch {
        // fall through to regex
      }
    }
    if (globToRegex(pat).test(c)) return true;
    if (!pat.includes("/") && globToRegex(`**/${pat}`).test(c)) return true;
  }
  return false;
}

function globToRegex(glob: string): RegExp {
  let re = "";
  for (let i = 0; i < glob.length; i++) {
    const c = glob[i];
    if (c === "*") {
      if (glob[i + 1] === "*") {
        // ** matches any number of path segments
        re += ".*";
        i++;
        if (glob[i + 1] === "/") i++;
      } else {
        re += "[^/]*";
      }
    } else if (c === "?") re += "[^/]";
    else if ("/.+^$(){}|\\".includes(c)) re += `\\${c}`;
    else if (c === "[") {
      // pass through char class
      const end = glob.indexOf("]", i);
      if (end === -1) re += "\\[";
      else {
        re += glob.slice(i, end + 1);
        i = end;
      }
    } else re += c;
  }
  return new RegExp(`^${re}$`);
}

// ---------- Input helpers ----------

/**
 * Tool name -> list of input field names that may contain paths we care about.
 * Unknown tools fall back to DEFAULT_PATH_FIELDS.
 */
const TOOL_PATH_FIELDS: Record<string, readonly string[]> = {
  read: ["path"],
  write: ["path"],
  edit: ["path"],
  multi_edit: ["path"],
  "multi-edit": ["path"],
};
const DEFAULT_PATH_FIELDS = ["path", "file", "filename"] as const;

/** Extract tool-argument paths that matter for glob rule activation. */
function extractToolPaths(toolName: string, input: unknown): string[] {
  if (!input || typeof input !== "object") return [];
  const obj = input as Record<string, unknown>;
  const fields = TOOL_PATH_FIELDS[toolName] ?? DEFAULT_PATH_FIELDS;
  const paths: string[] = [];
  for (const field of fields) {
    const v = obj[field];
    if (typeof v === "string" && v.length > 0) paths.push(v.replace(/^@/, ""));
  }
  return paths;
}

// ---------- System prompt assembly ----------

const SECTION_HEADER =
  "## Cursor Rules\nProject-specific rules loaded from `.cursor/rules/` (Cursor Rules spec). Follow these when they apply.";

function renderAlwaysRule(r: CursorRule): string {
  return `<rule name="${r.name}" path="${r.relPath}">\n${r.body}\n</rule>`;
}

function renderGlobRuleLine(r: CursorRule): string {
  const desc = r.description ? ` — ${r.description}` : "";
  const globs = r.globs.map((g) => `\`${g}\``).join(", ");
  return `- \`${r.relPath}\` (globs: ${globs})${desc}`;
}

function renderIntelligentRuleLine(r: CursorRule): string {
  return `- \`${r.relPath}\` — ${r.description ?? ""}`;
}

function renderManualRuleLine(r: CursorRule): string {
  return `- \`@${r.name}\` → \`${r.relPath}\``;
}

interface Section {
  heading: string;
  preamble?: string;
  bodies: string[];
}

function sectionFor(kind: RuleKind, rules: CursorRule[]): Section | null {
  const matching = rules.filter((r) => r.kind === kind);
  if (matching.length === 0) return null;
  switch (kind) {
    case "always":
      return { heading: "Always-applied rules", bodies: matching.map(renderAlwaysRule) };
    case "glob":
      return {
        heading: "File-scoped rules (auto-load when you touch a matching file)",
        preamble:
          "These rules will be injected automatically when a tool reads, writes, or edits a matching path. " +
          "You may also read them proactively with the `read` tool.",
        bodies: matching.map(renderGlobRuleLine),
      };
    case "intelligent":
      return {
        heading: "Available rules (load when relevant)",
        preamble: "Use the `read` tool on the path to load a rule's full contents when relevant to the task.",
        bodies: matching.map(renderIntelligentRuleLine),
      };
    case "manual":
      return {
        heading: "Manual rules (loaded only when referenced by @name)",
        bodies: matching.map(renderManualRuleLine),
      };
  }
}

function formatSection(section: Section): string {
  const lines: string[] = [`### ${section.heading}`];
  if (section.preamble) lines.push(section.preamble);
  lines.push("", ...section.bodies);
  return lines.join("\n");
}

const RULE_KIND_ORDER: readonly RuleKind[] = ["always", "glob", "intelligent", "manual"];

function buildSystemPromptSection(rules: CursorRule[]): string {
  const sections = RULE_KIND_ORDER.map((kind) => sectionFor(kind, rules)).filter(
    (s): s is Section => s !== null,
  );
  return [SECTION_HEADER, ...sections.map(formatSection)].join("\n\n");
}

// ---------- Extension entry ----------

export default function cursorRulesExtension(pi: ExtensionAPI) {
  let rules: CursorRule[] = [];
  let projectRoot = process.cwd();
  let rulesDir = "";
  /** Names of glob-rules already injected this session to avoid spam. */
  const injectedGlobRules = new Set<string>();

  const reloadRules = (ctx?: ExtensionContext) => {
    projectRoot = ctx?.cwd ?? process.cwd();
    rulesDir = path.join(projectRoot, ".cursor", "rules");
    const files = findRuleFiles(rulesDir);
    const loaded: CursorRule[] = [];
    for (const f of files) {
      const r = loadRule(f, rulesDir, projectRoot);
      if (r) loaded.push(r);
    }
    loaded.sort((a, b) => a.name.localeCompare(b.name));
    rules = loaded;
    injectedGlobRules.clear();
  };

  pi.on("session_start", async (_event, ctx) => {
    reloadRules(ctx);
    if (rules.length > 0) {
      ctx.ui.notify(`cursor-rules: loaded ${rules.length} rule(s) from .cursor/rules/`, "info");
    }
  });

  pi.on("before_agent_start", async (event) => {
    if (rules.length === 0) return;
    return { systemPrompt: `${event.systemPrompt}\n\n${buildSystemPromptSection(rules)}\n` };
  });

  // Glob rules auto-load: when a file-touching tool hits a matching path, steer the rule body in.
  pi.on("tool_call", async (event, _ctx) => {
    if (rules.length === 0) return;
    const globRules = rules.filter((r) => r.kind === "glob" && !injectedGlobRules.has(r.name));
    if (globRules.length === 0) return;

    const candidates = extractToolPaths(event.toolName, event.input);
    if (candidates.length === 0) return;

    const toInject: CursorRule[] = [];
    for (const r of globRules) {
      for (const c of candidates) {
        if (r.globs.some((g) => matchesGlob(c, projectRoot, g))) {
          toInject.push(r);
          injectedGlobRules.add(r.name);
          break;
        }
      }
    }

    for (const r of toInject) {
      pi.sendMessage(
        {
          customType: "cursor-rules",
          content:
            `Applying cursor rule **${r.name}** (matched globs: ${r.globs.join(", ")}) ` +
            `because a tool accessed a matching file.\n\n<rule name="${r.name}" path="${r.relPath}">\n${r.body}\n</rule>`,
          display: true,
          details: { rule: r.name, path: r.relPath, globs: r.globs },
        },
        { deliverAs: "steer" },
      );
    }
  });

  // Manual rules activate by @name reference in user input; expand them inline before the LLM sees the prompt.
  pi.on("input", async (event, _ctx) => {
    if (rules.length === 0) return;
    const text = event.text;
    // Match @name or @folder/name tokens that correspond to manual rules.
    const manualByName = new Map(rules.filter((r) => r.kind === "manual").map((r) => [r.name, r]));
    if (manualByName.size === 0) return;

    const mentioned = new Set<string>();
    const re = /(^|\s)@([A-Za-z0-9_\-./]+)/g;
    let m: RegExpExecArray | null;
    while ((m = re.exec(text)) !== null) {
      if (manualByName.has(m[2])) mentioned.add(m[2]);
    }
    if (mentioned.size === 0) return;

    const appendix = Array.from(mentioned)
      .map((n) => {
        const r = manualByName.get(n)!;
        return `<rule name="${r.name}" path="${r.relPath}">\n${r.body}\n</rule>`;
      })
      .join("\n\n");

    return {
      action: "transform",
      text: `${text}\n\n---\nReferenced cursor rules:\n\n${appendix}`,
    };
  });

  pi.registerCommand("cursor-rules", {
    description: "List / reload Cursor rules from .cursor/rules/",
    getArgumentCompletions: (prefix) => {
      const items = [
        { value: "reload", label: "reload — rescan .cursor/rules" },
        { value: "show ", label: "show <name> — print a rule's body" },
        ...rules.map((r) => ({ value: `show ${r.name}`, label: `show ${r.name}` })),
      ];
      const filtered = items.filter((i) => i.value.startsWith(prefix));
      return filtered.length > 0 ? filtered : null;
    },
    handler: async (args, ctx) => {
      const arg = (args ?? "").trim();

      if (arg === "reload") {
        reloadRules(ctx);
        ctx.ui.notify(`cursor-rules: reloaded ${rules.length} rule(s)`, "info");
        return;
      }

      const SHOW_PREFIX = "show ";
      if (arg.startsWith(SHOW_PREFIX)) {
        const name = arg.slice(SHOW_PREFIX.length).trim();
        const r = rules.find((x) => x.name === name);
        if (!r) {
          ctx.ui.notify(`No rule named "${name}"`, "error");
          return;
        }
        ctx.ui.notify(`--- ${r.relPath} (${r.kind}) ---\n${r.body}`, "info");
        return;
      }

      if (rules.length === 0) {
        ctx.ui.notify(
          `No rules found. Expected markdown files in ${rulesDir || ".cursor/rules/"}`,
          "info",
        );
        return;
      }

      const lines = [
        `cursor-rules: ${rules.length} rule(s) in ${path.relative(projectRoot, rulesDir) || ".cursor/rules"}`,
        "",
      ];
      for (const r of rules) {
        const tag = `[${r.kind}]`.padEnd(14);
        const extra =
          r.kind === "glob"
            ? `globs=${r.globs.join(",")}`
            : r.kind === "intelligent"
              ? (r.description ?? "")
              : r.kind === "manual"
                ? `@${r.name}`
                : "";
        lines.push(`${tag} ${r.relPath}${extra ? `  — ${extra}` : ""}`);
      }
      ctx.ui.notify(lines.join("\n"), "info");
    },
  });
}
