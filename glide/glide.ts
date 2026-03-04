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

glide.include("vanilla-vim.ts")
glide.include("vanilla-firefox.ts")

glide.o.hint_size = "18px"

glide.keymaps.set("normal", "-", "go_up");

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

// Always normal mode when switching tabs
browser.tabs.onActivated.addListener(async (activeInfo) => {
  await new Promise((resolve) => setTimeout(resolve, 100));
  await glide.excmds.execute("mode_change normal");
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

glide.keymaps.del("normal", "<leader>f")
glide.keymaps.set("normal", "gf", "hint --location=browser-ui", { description: "[g]lobal [f]ind for browser ui clickables" })
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

glide.keymaps.set("normal", "gs", () => {
    glide.hints.show({
        selector: "div, section, article, aside, nav, ul, ol, pre, code, main, textarea, [class*='scroll']",

        pick: async ({ content, hints }) => {
            const results = await content.map((element: HTMLElement) => {
                const style = window.getComputedStyle(element);

                const overflowY = style.overflowY;
                const overflowX = style.overflowX;
                const isScrollableStyle =
                    (overflowY === 'auto' || overflowY === 'scroll') ||
                    (overflowX === 'auto' || overflowX === 'scroll');

                const canScroll =
                    element.scrollHeight > element.clientHeight ||
                    element.scrollWidth > element.clientWidth;

                const hasScrollClass = element.className.includes("scroll");
                const isNotRoot = element !== document.body && element !== document.documentElement;

                return (isScrollableStyle || hasScrollClass) && canScroll && isNotRoot;
            });

            const filteredHints = hints.filter((_, i) => results[i]);

            if (filteredHints.length === 0) {
                glide.excmds.execute("hints_remove");
                glide.excmds.execute("mode_change normal");
            }

            return filteredHints;
        },

        action: async ({ content }) => {
            await content.execute((element: HTMLElement) => {
                element.scrollIntoView({ block: "center", behavior: "smooth" });

                if (!element.hasAttribute("tabindex")) {
                    element.setAttribute("tabindex", "-1");
                }
                element.focus();

                const originalOutline = element.style.outline;
                element.style.outline = "2px solid red";
                setTimeout(() => {
                    element.style.outline = originalOutline;
                }, 600);
            });
        }
    });
}, { description: "Focus scrollable elements" });
