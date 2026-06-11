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
glide.prefs.set("network.trr.mode", 3); // DNS over HTTPS
glide.prefs.set("network.trr.uri", "https://mozilla.cloudflare-dns.com/dns-query");

// https://addons.mozilla.org
glide.addons.install(
  "https://addons.mozilla.org/firefox/downloads/file/4598854/ublock_origin-1.67.0.xpi",
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
