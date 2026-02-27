// Config docs: https://glide-browser.app/config
// API docs: https://glide-browser.app/api
// Default config files: https://github.com/glide-browser/glide/tree/main/src/glide/browser/base/content/plugins
// Default keymappings: https://github.com/glide-browser/glide/blob/main/src/glide/browser/base/content/plugins/keymaps.mts
// Creator's dotfiles: https://github.com/RobertCraigie/dotfiles/tree/main/glide
// Firefox Javascript APIS (use browser.*): https://developer.mozilla.org/en-US/docs/Mozilla/Add-ons/WebExtensions/Browser_support_for_JavaScript_APIs

glide.o.hint_size = "18px"

// firefox.yml
glide.prefs.set("browser.startup.page", 3); // Open previous windows and tabs
glide.prefs.set("signon.rememberSignons", false);
glide.prefs.set("ui.systemUsesDarkTheme", 1);
glide.prefs.set("browser.tabs.splitView.enabled", true);

// https://github.com/glide-browser/glide/discussions/63
glide.keymaps.set("normal", "gT", "tab_prev");
glide.keymaps.set("normal", "gt", "tab_next");
glide.keymaps.set(["command", "insert"], "<C-h>", "keys <Backspace>");
glide.keymaps.set("normal", "-", "go_up");

// https://addons.mozilla.org
glide.addons.install(
  "https://addons.mozilla.org/firefox/downloads/file/4598854/ublock_origin-1.67.0.xpi",
);
glide.addons.install(
  "https://addons.mozilla.org/firefox/downloads/file/4599707/bitwarden_password_manager-2025.10.0.xpi",
);

glide.autocmds.create("ModeChanged", "*", ({ new_mode }) => {
  const mode_colors: Record<keyof GlideModes, string> = {
    "command": "#689F38", // Green
    "hint": "#00796B", // Teal
    "ignore": "#FF5252", // Red
    "insert": "#FBC02D", // Yellow
    "normal": "#9E9E9E", // Gray
    "op-pending": "#FF8F00", // Orange
    "visual": "#7B1FA2", // Purple
  }
  browser.theme.update({ colors: { frame: mode_colors[new_mode] } });
});

let previousTabId: number | undefined;
browser.tabs.onActivated.addListener((activeInfo) => {
  previousTabId = activeInfo.previousTabId;
});
glide.excmds.create({ name: "bd", description: "[b]uffer [d]elete -> deletes current tab"}, () => {
  glide.excmds.execute("tab_close")
})

glide.excmds.create({ name: "b#", description: "[b]uffer [#]alternate -> switches to previously active tab" }, async () => {
  if (previousTabId) {
    await browser.tabs.update(previousTabId, { active: true })
  }
});

glide.excmds.create({ name: "noh", description: "[no] [h]ighlight -> clears find highlights" }, async () => {
  await browser.find.removeHighlighting()
});

// https://github.com/glide-browser/glide/discussions/93#discussioncomment-14918102
glide.keymaps.set(["normal", "insert"], "<C-,>", "blur", { description: "Go to normal mode without focus on a specific element" })

glide.autocmds.create("UrlEnter", { hostname: "github.com" }, ({ tab_id }) => {
  glide.buf.keymaps.set("normal", "<leader>d", async () => {
    await browser.notifications.create({ type: "basic", title: "glide config", message: "Download started..." })
    const clone_url = glide.ctx.url + ".git"
    const git_path = glide.path.join(glide.path.home_dir, "projects")
    await glide.process.execute("git", ["-C", git_path, "clone", clone_url])
    await browser.notifications.create({ type: "basic", title: "glide config", message: "Repo is cloned!" })
  }, { description: "clone ([d]ownload) git repo" })

  glide.buf.keymaps.set("normal", "gx", async () => {
    const [owner, repo] = glide.ctx.url.pathname.split("/").slice(1, 3);
    if (!owner || !repo) throw new Error("current URL is not a github repo");
    const repo_path = glide.path.join(glide.path.home_dir, "projects", repo);
    await glide.process.execute("tmux", ["new-window", "-t", "nonlinearfruit:", "-c", repo_path]);
    await browser.notifications.create({ type: "basic", title: "glide config", message: "Tmux tab created" })
  }, { description: "open repo in tmux" });
});

glide.autocmds.create("UrlEnter", { hostname: "www.youtube.com" }, ({ tab_id }) => {
  glide.buf.keymaps.set("normal", "<leader>d", async () => {
    await browser.notifications.create({ type: "basic", title: "glide config", message: "Download started..." })
    const video_url = glide.ctx.url
    await glide.process.execute("nix-shell", ["--packages", "yt-dlp", "--run", "yt-dlp --cookies-from-browser vivaldi --paths ~/Downloads/youtube " + video_url])
    await browser.notifications.create({ type: "basic", title: "glide config", message: "Video is downloaded!" })
  }, { description: "[d]ownload youtube video" })
});

glide.autocmds.create("UrlEnter", { hostname: "www.vimgolf.com" }, ({ tab_id }) => {
  glide.buf.keymaps.set("normal", "<leader>d", async () => {
    const parts = glide.ctx.url.pathname.split("/")
    const challenge = parts[parts.length -1]
    await glide.process.execute("nu", ["~/projects/vim-golf/toolkit.nu", "download-challenge", challenge])
    await browser.notifications.create({ type: "basic", title: "glide config", message: "Golf is downloaded!" })
  }, { description: "[d]ownload vim golf" })
});

glide.autocmds.create("UrlEnter", { hostname: "projecteuler.net" }, ({ tab_id }) => {
  glide.buf.keymaps.set("normal", "<leader>d", async () => {
    const challenge = glide.ctx.url.pathname.split("=")[1]
    await glide.process.execute("nu", ["~/projects/project-euler/toolkit.nu", "download-challenge", challenge])
    await browser.notifications.create({ type: "basic", title: "glide config", message: "Problem is downloaded!" })
  }, { description: "[d]ownload Project Euler problem" })
});

glide.keymaps.set("normal", "yf", () => {
  glide.hints.show({
    action: async (target: any) => {
      if (target.href) {
        await navigator.clipboard.writeText(target.href)
      }
    }
  })
})

glide.keymaps.set("normal", "/", () => glide.findbar.open({mode: "normal", highlight_all: true}));
glide.keymaps.set("normal", "n", () => glide.findbar.next_match());
glide.keymaps.set("normal", "N", () => glide.findbar.previous_match());
glide.keymaps.set("normal", "<leader>/b", "commandline_show tab ", { description: "Search[/] open tabs ([b]uffers)" });

glide.excmds.create({ name: "tab_edit", description: "Edit tabs in a text editor" }, async () => {
	const tabs = await browser.tabs.query({ pinned: false });

	const tab_lines = tabs.map((tab) => {
		const title = tab.title?.replace(/\n/g, " ") || "No Title";
		const url = tab.url || "about:blank";
		return `${tab.id}: ${title} (${url})`;
	});

	const mktempcmd = await glide.process.execute("mktemp", ["-t", "glide_tab_edit.XXXXXX"]);

	let stdout = "";
	for await (const chunk of mktempcmd.stdout) {
		stdout += chunk;
	}
	const temp_filepath = stdout.trim();

	tab_lines.unshift("// Delete the corresponding lines to close the tabs");
	tab_lines.unshift("// vim: ft=qute-tab-edit");
	tab_lines.unshift("");
	await glide.fs.write(temp_filepath, tab_lines.join("\n"));

	console.log("Temp file created at:", temp_filepath);

	const editcmd = await glide.process.execute("gnome-text-editor", [
	   "--standalone",
	   temp_filepath,
	 ]);

	const cp = await editcmd.wait();
	if (cp.exit_code !== 0) {
		throw new Error(`Editor command failed with exit code ${cp.exit_code}`);
	}
	console.log("Edit complete");

	// read the edited file
	const edited_content = await glide.fs.read(temp_filepath, "utf8");
	const edited_lines = edited_content
		.split("\n")
		.filter((line) => line.trim().length > 0)
		.filter((line) => !line.startsWith("//"));

	const tabs_to_keep = edited_lines.map((line) => {
		const tab_id = line.split(":")[0];
		return Number(tab_id);
	});

	const tab_ids_to_close = tabs
		.filter((tab) => tab.id && !tabs_to_keep.includes(tab.id))
		.map((tab) => tab.id)
		.filter((id): id is number => id !== undefined);
	await browser.tabs.remove(tab_ids_to_close);
});

glide.keymaps.set("normal", "yc", () =>
  glide.hints.show({
    selector: "pre,code",
    async action(target) {
      console.log(target)
      const text = (await target.content.execute((target) => target.textContent)).trim()
      console.log(text)
      if (text) {
        await navigator.clipboard.writeText(text);
      }
    }
  }),
  { description: "[y]ank [c]ode -> Shows hints on all preformated text and places the selected codeblock in clipboard" }
)

glide.excmds.create({ name: "tabo", description: "[tab] [o]nly -> deletes all non-active non-pinned tabs"}, async () => {
  const tabs_to_close = await browser.tabs.query({active: false, pinned: false})
  browser.tabs.remove(tabs_to_close.map(t => t.id));
})

glide.search_engines.add({
  name: "Brave",
  keyword: "b",
  search_url: "https://search.brave.com/search?q={searchTerms}",
  is_default: true
})
