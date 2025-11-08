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
