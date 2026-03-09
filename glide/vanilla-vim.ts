// Configuration that mimics Vanilla Vim

// https://github.com/glide-browser/glide/discussions/63
glide.keymaps.set("normal", "gT", "tab_prev");
glide.keymaps.set("normal", "gt", "tab_next");
glide.keymaps.set("normal", "1gt", "tab 0");
glide.keymaps.set("normal", "2gt", "tab 1");
glide.keymaps.set("normal", "3gt", "tab 2");
glide.keymaps.set("normal", "4gt", "tab 3");
glide.keymaps.set("normal", "5gt", "tab 4");
glide.keymaps.set("normal", "6gt", "tab 5");
glide.keymaps.set("normal", "7gt", "tab 6");
glide.keymaps.set("normal", "8gt", "tab 7");
glide.keymaps.set("normal", "9gt", "tab 8");
glide.keymaps.set("normal", "1gT", "tab -1"); // Technically gT should go {count} tabs backwards, but last, second to last, etc is more helpful
glide.keymaps.set("normal", "2gT", "tab -2");
glide.keymaps.set("normal", "3gT", "tab -3");
glide.keymaps.set("normal", "4gT", "tab -4");
glide.keymaps.set("normal", "5gT", "tab -5");
glide.keymaps.set("normal", "6gT", "tab -6");
glide.keymaps.set("normal", "7gT", "tab -7");
glide.keymaps.set("normal", "8gT", "tab -8");
glide.keymaps.set("normal", "9gT", "tab -9");
glide.excmds.create({ name: "tabo", description: "[tab] [o]nly -> deletes all non-active non-pinned tabs"}, async () => {
  const tabs_to_close = await browser.tabs.query({active: false, pinned: false})
  browser.tabs.remove(tabs_to_close.map(t => t.id));
})

let previousTabId: number | undefined;
browser.tabs.onActivated.addListener((activeInfo) => {
  previousTabId = activeInfo.previousTabId;
});

glide.excmds.create({ name: "b#", description: "[b]uffer [#]alternate -> switches to previously active tab" }, async () => {
  if (previousTabId) {
    await browser.tabs.update(previousTabId, { active: true })
  }
});

glide.excmds.create({ name: "bd", description: "[b]uffer [d]elete -> deletes current tab"}, () => {
  glide.excmds.execute("tab_close")
})

glide.keymaps.set(["command", "insert"], "<C-h>", "keys <Backspace>");

glide.keymaps.set("normal", "/", () => glide.findbar.open({mode: "normal", highlight_all: true}), { description: "[/] Search text on page" });
glide.keymaps.set("normal", "n", () => glide.findbar.next_match(), { description: "[n]ext match on page" });
glide.keymaps.set("normal", "N", () => glide.findbar.previous_match(), { description: "[N] previous match on page" });
glide.excmds.create({ name: "noh", description: "[no] [h]ighlight -> clears find highlights" }, async () => {
  await browser.find.removeHighlighting()
});

glide.keymaps.set("normal", "u", "undo");
glide.keymaps.set("normal", "<C-r>", "redo");

// Split windows
glide.excmds.create({
    name: 'vs',
    description: '[v]ertical [s]plit => Pick another tab to split view with',
}, async () => {
    const activeTab = await glide.tabs.active()
    if (activeTab.pinned) return // Can't split pinned tabs at present
    const tabs = await glide.tabs.query({ active: false, pinned: false })
    glide.commandline.show({
        title: "Show other",
        options: tabs.map(t => ({
            label: t.title,
            async execute() {
                glide.unstable.split_views.create([activeTab.id, t.id])
            }
        })),
    })
})
glide.keymaps.set('normal', '<C-w>v', 'vs', { description: '[w]indow [v]ertical split => Pick another tab to split view with' })
glide.keymaps.set('normal', '<C-w>c', ({ tab_id }) => {
    glide.unstable.split_views.separate(tab_id)
}, { description: '[w]indow [c]lose current split (without closing any tabs)' })
glide.keymaps.set('normal', '<C-w><C-w>', async ({ tab_id }) => {
    const split_tabs = await glide.unstable.split_views.get(tab_id)
    if (!split_tabs) return
    const other_tab = split_tabs.tabs.filter(t => t.id !== tab_id)[0]
    await browser.tabs.update(other_tab.id, { active: true })
}, { description: 'oh [w]indow my [w]indow => switch which window in split is focused' })
