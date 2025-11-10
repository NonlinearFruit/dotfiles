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
