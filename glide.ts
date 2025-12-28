// Config docs: https://glide-browser.app/config
// API docs: https://glide-browser.app/api
// Default config files: https://github.com/glide-browser/glide/tree/main/src/glide/browser/base/content/plugins
// Default keymappings: https://github.com/glide-browser/glide/blob/main/src/glide/browser/base/content/plugins/keymaps.mts
// Creator's dotfiles: https://github.com/RobertCraigie/dotfiles/tree/main/glide

glide.o.hint_size = "18px"

// firefox.yml
glide.prefs.set("browser.startup.page", 3); // Open previous windows and tabs
glide.prefs.set("signon.rememberSignons", false);
glide.prefs.set("ui.systemUsesDarkTheme", 1);

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
glide.keymaps.set("normal", "/", "keys <C-f>");
