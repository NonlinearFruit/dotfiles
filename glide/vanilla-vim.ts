// Configuration that mimics Vanilla Vim

// https://github.com/glide-browser/glide/discussions/63
glide.keymaps.set("normal", "gT", "tab_prev", { description: "[g]o to previous [T]ab" });
glide.keymaps.set("normal", "gt", "tab_next", { description: "[g]o to next [t]ab" });
for (let i = 1; i < 10; i++) {
	glide.keymaps.set("normal", `${i}gt`, `tab ${i - 1}`, { description: `[g]o to [t]ab ${i}` })
	glide.keymaps.set("normal", `${i}gT`, `tab ${i * -1}`, { description: `[g]o to [T]ab ${i} from the end` }) // Technically gT should go {count} tabs backwards, but last, second to last, etc is more helpful
};
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

glide.keymaps.set("normal", "<C-w>q", "tab_close", { description: "[w]indow [c]lose => closes the current tab" })

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
    const split_tabs = glide.unstable.split_views.get(tab_id)
    if (!split_tabs) return
    const other_tab = split_tabs.tabs.filter(t => t.id !== tab_id)[0]
    await browser.tabs.update(other_tab.id, { active: true })
}, { description: 'oh [w]indow my [w]indow => switch which window in split is focused' })
