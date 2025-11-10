// https://github.com/RobertCraigie/dotfiles/tree/main/glide

// firefox.yml
glide.prefs.set(
  "browser.startup.homepage",
  "https://glide-browser.app/cookbook",
);
glide.prefs.set(
  "signon.rememberSignons",
  false,
);

// https://github.com/glide-browser/glide/discussions/63
glide.keymaps.set("normal", "gT", "tab_prev");
glide.keymaps.set("normal", "gt", "tab_next");
glide.keymaps.set(["command", "insert"], "<C-h>", "keys <Backspace>");

// https://addons.mozilla.org
glide.addons.install(
  "https://addons.mozilla.org/firefox/downloads/file/4598854/ublock_origin-1.67.0.xpi",
);
glide.addons.install(
  "https://addons.mozilla.org/firefox/downloads/file/4599707/bitwarden_password_manager-2025.10.0.xpi",
);

let previousTabId: number | undefined;
let currentTabId: number | undefined;
browser.tabs.onActivated.addListener((activeInfo) => {
  currentTabId = activeInfo.tabId
  previousTabId = activeInfo.previousTabId;
});
glide.excmds.create({ name: "bd", description: "[b]uffer [d]elete -> deletes current tab" }, async () => {
  if (currentTabId) {
    browser.tabs.remove(currentTabId);
  }
});
glide.excmds.create({ name: "b#", description: "[b]uffer [#]alternate -> switches to previously active tab" }, async () => {
  if (previousTabId) {
    await browser.tabs.update(previousTabId, { active: true })
  }
});

glide.keymaps.set("normal", "<leader>d", async () => {
  const clone_url = glide.ctx.url + ".git"
  const git_path = glide.path.join(glide.path.home_dir, "projects")
  await glide.process.execute("git", ["-C", git_path, "clone", clone_url])
  await browser.notifications.create({ type: "basic", title: "glide config", message: "Repo is cloned!" })
}, { description: "clone ([d]ownload) git repo" })

glide.keymaps.set("normal", "gx", async () => {
  const [owner, repo] = glide.ctx.url.pathname.split("/").slice(1, 3);
  if (!owner || !repo) throw new Error("current URL is not a github repo");
  const repo_path = glide.path.join(glide.path.home_dir, "projects", repo);
  await glide.process.execute("tmux", ["new-window", "-t", "nonlinearfruit:", "-c", repo_path]);
  await browser.notifications.create({ type: "basic", title: "glide config", message: "Tmux tab created" })
}, { description: "open repo in tmux" });

