// Gnarly Tab Edit: edit tabs in a text editor
// Features:
// - Opens current tabs in the configured text editor
// - Deleting a line => Deletes the tab
// - Reordering lines => Reorders tabs
// - Adding a line (with "url": "...") => Creates new tab
// - Setting active true => Focuses the tab
// - Setting pinned to true/false => pins/unpins the tab
glide.excmds.create({ name: "tab_edit", description: "Edit tabs in a text editor" }, async () => {
  const tabs = await get_list_of_current_tabs()
  const tempfile = await save_tabs_to_temp_file(tabs)
  await let_user_edit_file_and_wait_for_exit(tempfile)
  const updated_tabs = await get_list_of_tabs_from_file(tempfile)
  await close_unwanted_tabs(tabs, updated_tabs)
  await update_tab_url(tabs, updated_tabs)
  await update_tab_pinned_ness(tabs, updated_tabs)
  await update_focused_tab(tabs, updated_tabs)
  await open_new_tabs_and_adjust_order(updated_tabs)
});

async function get_list_of_current_tabs() {
  return await browser.tabs.query({})
}

async function save_tabs_to_temp_file(tabs) {
  const tab_lines = tabs
    .toSorted((a, b) => a.index - b.index)
    .map(stringify);
  const tempfile = await mktemp("glide_tab_edit.XXXXXX")
  await glide.fs.write(tempfile, tab_lines.join("\n"));
  return tempfile
}

async function let_user_edit_file_and_wait_for_exit(tempfile) {
  const edit_cmd = await glide.process.execute("wezterm", [
     "start",
     "--",
     "nvim",
     tempfile,
   ]);
  const edit_result = await edit_cmd.wait();
  if (edit_result.exit_code !== 0) {
    throw new Error(`Editor command failed with exit code ${edit_result.exit_code}`);
  }
}

async function get_list_of_tabs_from_file(tempfile) {
  const edited_content = await glide.fs.read(tempfile, "utf8")
  const tabs_to_keep = edited_content
    .split("\n")
    .filter((line) => line.trim().length > 0)
    .filter((line) => !line.startsWith("//"))
    .map((line) => JSON.parse(line))
  return tabs_to_keep
}

async function close_unwanted_tabs(current_tabs, updated_tabs) {
  const tabs_to_keep = updated_tabs.map(t => t.id)
  const tab_ids_to_close = current_tabs
    .filter(hasId)
    .filter(t => !tabs_to_keep.includes(t.id))
    .map(t => t.id)
  await browser.tabs.remove(tab_ids_to_close)
}

async function update_tab_url(current_tabs, updated_tabs) {
  updated_tabs
    .filter(hasId)
    .filter(ut => find(current_tabs, ut.id).url != ut.url)
    .forEach(async t => await browser.tabs.update(t.id, {url: t.url}))
}

async function update_tab_pinned_ness(current_tabs, updated_tabs) {
  updated_tabs
    .filter(hasId)
    .filter(ut => find(current_tabs, ut.id).pinned != ut.pinned)
    .forEach(async t => await browser.tabs.update(t.id, {pinned: t.pinned}))
}

async function update_focused_tab(current_tabs, updated_tabs) {
  updated_tabs
    .filter(hasId)
    .filter(t => t.active)
    .filter(ut => find(current_tabs, ut.id).active != ut.active)
    .forEach(async t => await browser.tabs.update(t.id, {active: t.active}))
}

async function open_new_tabs_and_adjust_order(updated_tabs) {
  updated_tabs
    .forEach(async (t, i) => {
      if (t.id === undefined) {
        await browser.tabs.create({
          url: t.url,
          index: i,
          active: t.active,
          pinned: t.pinned
        })
      } else {
        await browser.tabs.move(t.id, {index: i})
      }
    })
}

async function mktemp(template) {
  const mktemp_cmd = await glide.process.execute("mktemp", ["-t", template, "--suffix", ".json"]);
  return (await mktemp_cmd.stdout.text()).trim();
}

function hasId(tab) {
  return tab?.id !== undefined
}

function find(list, id) {
  return list.find(i => i.id === id)
}

function stringify(tab) {
  const id = JSON.stringify(tab.id).padStart(4, " ")
  const title = JSON.stringify(tab.title?.replace(/\n/g, " ").substring(0,40)).padEnd(42, " ")
  const active = JSON.stringify(tab.active).padStart(5, " ")
  const pinned = JSON.stringify(tab.pinned).padStart(5, " ")
  const url = JSON.stringify(tab.url)
  return `{"id":${id},"title":${title},"active":${active},"pinned":${pinned},"url":${url}}`
}
