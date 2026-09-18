import { isToolCallEventType } from "@mariozechner/pi-coding-agent";

export default function (pi) {
  pi.on("tool_call", async (event, ctx) => {
    if (!isToolCallEventType("edit", event)) return;

    const error = validateEdits(event.input.edits);
    if (error) {
      ctx.ui.notify(error, "error");
      return { block: true, reason: "Invalid edit parameters" };
    }
  });
}

function validateEdits(edits) {
  if (!Array.isArray(edits)) {
    return "❌ edits must be an array";
  }

  if (edits.length === 0) return null;

  for (let i = 0; i < edits.length; i++) {
    const item = edits[i];

    if (!isValidEditItem(item)) {
      return `❌ Edit ${i}: must have oldText (string) and newText (string)`;
    }

    const jsonError = trySerializeEdit(item);
    if (jsonError) {
      return `❌ Edit ${i} has JSON serialization error:\n  ${jsonError}\n\n` +
             `Common cause: Unescaped quotes in oldText or newText.\n` +
             `Tip: Break into smaller edits or escape special characters.`;
    }
  }

  const overlapError = findOverlap(edits);
  if (overlapError) {
    return `❌ ${overlapError}\n\n` +
           `Solution: Ensure each oldText is unique and non-overlapping.`;
  }

  return null;
}

function isValidEditItem(item) {
  if (typeof item !== "object" || item === null) return false;
  return typeof item.oldText === "string" && typeof item.newText === "string";
}

function trySerializeEdit(edit) {
  try {
    JSON.stringify({ edits: [edit] });
    return null;
  } catch (err) {
    return err.message;
  }
}

function findOverlap(edits) {
  for (let i = 0; i < edits.length; i++) {
    for (let j = i + 1; j < edits.length; j++) {
      const a = edits[i].oldText;
      const b = edits[j].oldText;

      if (a === b) {
        return `Edits ${i} and ${j}: identical oldText`;
      }

      if (a.includes(b) || b.includes(a)) {
        return `Edits ${i} and ${j}: overlapping oldText (one contains the other)`;
      }
    }
  }

  return null;
}
