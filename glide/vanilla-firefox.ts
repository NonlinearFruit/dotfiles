// Standard Firefox configuration
glide.prefs.set("browser.startup.page", 3); // Open previous windows and tabs
glide.prefs.set("signon.rememberSignons", false);
glide.prefs.set("extensions.formautofill.creditCards.enabled", false);
glide.prefs.set("extensions.formautofill.addresses.enabled", false);
glide.prefs.set("ui.systemUsesDarkTheme", 1);
glide.prefs.set("browser.tabs.splitView.enabled", true);
// Disable "Alt" key from toggling top menu
glide.prefs.set("ui.key.menuAccessKeyFocuses", false)
glide.prefs.set("media.videocontrols.picture-in-picture.video-toggle.enabled", true);

glide.prefs.set("privacy.donottrackheader.enabled", true);
glide.prefs.set("browser.crashReports.unsubmittedCheck.autoSubmit2", false);
glide.prefs.set("dom.security.https_only_mode", true);

glide.prefs.set("browser.gesture.swipe.left", null);
glide.prefs.set("browser.gesture.swipe.right", null);
glide.prefs.set("browser.gesture.pinch.in", null);
glide.prefs.set("browser.gesture.pinch.in.shift", null);
glide.prefs.set("browser.gesture.pinch.out", null);
glide.prefs.set("browser.gesture.pinch.out.shift", null);
glide.prefs.set("browser.gesture.swipe.down", null);
glide.prefs.set("browser.gesture.swipe.up", null);
glide.prefs.set("browser.gesture.tap", null);
glide.prefs.set("browser.gesture.twist.end", null);
glide.prefs.set("browser.gesture.twist.left", null);
glide.prefs.set("browser.gesture.twist.right", null);

// https://addons.mozilla.org
glide.addons.install(
  "https://addons.mozilla.org/firefox/downloads/file/4598854/ublock_origin-1.67.0.xpi", { private_browsing_allowed: true },
);
glide.addons.install(
  "https://addons.mozilla.org/firefox/downloads/file/4599707/bitwarden_password_manager-2025.10.0.xpi",
);

glide.search_engines.add({
  name: "Brave",
  keyword: "b",
  search_url: "https://search.brave.com/search?q={searchTerms}",
  is_default: true
})
