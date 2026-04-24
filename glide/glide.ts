// # Notes
// `:map` to show all bindings as a webpage
// `:repl` to open an interactive browser dev console
//     - Application Menu > More Tools > Browser Toolbox for full dev tools at the browser level
//
// # Resources
// Config docs: https://glide-browser.app/config
// API docs: https://glide-browser.app/api
// Default config files: https://github.com/glide-browser/glide/tree/main/src/glide/browser/base/content/plugins
// Default keymappings: https://github.com/glide-browser/glide/blob/main/src/glide/browser/base/content/plugins/keymaps.mts
// Creator's dotfiles: https://github.com/RobertCraigie/dotfiles/tree/main/glide
// Firefox Javascript APIS (use browser.*): https://developer.mozilla.org/en-US/docs/Mozilla/Add-ons/WebExtensions/Browser_support_for_JavaScript_APIs

glide.include("gnarly-scrollable-picker.ts")
glide.include("gnarly-tab-edit.ts")
glide.include("gnarly-text-edit.ts")
glide.include("vanilla-firefox.ts")
glide.include("vanilla-glide.ts")
glide.include("vanilla-vim.ts")

glide.keymaps.set("normal", "-", "go_up");

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
}, { description: "[y]ank [f]ound links" })

glide.keymaps.set("normal", "<leader>/b", "commandline_show tab ", { description: "Search[/] open tabs ([b]uffers)" });

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

glide.keymaps.set("normal", "<<", async ({ tab_id }) => {
  const tab = await browser.tabs.get(tab_id);
  if (tab.index > 0) {
    await browser.tabs.move(tab_id, { index: tab.index - 1 });
  }
}, { description: "[<<] Move tab left" });

glide.keymaps.set("normal", ">>", async ({ tab_id }) => {
  const tab = await browser.tabs.get(tab_id);
  await browser.tabs.move(tab_id, { index: tab.index + 1 });
}, { description: "[>>] Move tab right" });
