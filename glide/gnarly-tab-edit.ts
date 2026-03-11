// TODO: Reorder tabs by changing line order (including pinned tabes)
//     - Pinned tabs should not be closeable
// TODO: Update url of a tab
// TODO: Pin/unpin tabs
glide.excmds.create({ name: "tab_edit", description: "Edit tabs in a text editor" }, async () => {
  const tabs = await get_list_of_current_tabs()
  const tempfile = await save_tabs_to_temp_file(tabs)
  await let_user_edit_file_and_wait_for_exit(tempfile)
  const updated_tabs = await get_list_of_tab_ids_from_file(tempfile)
  const tabs_to_keep = updated_tabs.map(t => t.id)
  await close_unwanted_tabs(tabs, tabs_to_keep)
  await open_new_tabs(updated_tabs)
});

async function get_list_of_current_tabs() {
  return await browser.tabs.query({})
}

async function save_tabs_to_temp_file(tabs) {
  const tab_lines = tabs
    .toSorted((a, b) => a.index - b.index)
    .map((tab) => {
      return JSON.stringify({
        title: tab.title?.replace(/\n/g, " ") || "No Title",
        url: tab.url || "about:blank",
        id: tab.id,
        index: tab.index,
        active: tab.active,
        pinned: tab.pinned,
      })
    });
  const tempfile = await mktemp("glide_tab_edit.XXXXXX")
  await glide.fs.write(tempfile, tab_lines.join("\n"));
  return tempfile
}

async function let_user_edit_file_and_wait_for_exit(tempfile) {
  const edit_cmd = await glide.process.execute("gnome-text-editor", [
     "--standalone",
     tempfile,
   ]);
  const edit_result = await edit_cmd.wait();
  if (edit_result.exit_code !== 0) {
    throw new Error(`Editor command failed with exit code ${edit_result.exit_code}`);
  }
}

async function get_list_of_tab_ids_from_file(tempfile) {
  const edited_content = await glide.fs.read(tempfile, "utf8")
  const tabs_to_keep = edited_content
    .split("\n")
    .filter((line) => line.trim().length > 0)
    .filter((line) => !line.startsWith("//"))
    .map((line) => JSON.parse(line))
  return tabs_to_keep
}

async function close_unwanted_tabs(current_tabs, tabs_to_keep) {
  const tab_ids_to_close = current_tabs
    .filter((tab) => tab.id && !tabs_to_keep.includes(tab.id))
    .map((tab) => tab.id)
    .filter((id): id is number => id !== undefined);
  await browser.tabs.remove(tab_ids_to_close);
}

async function open_new_tabs(updated_tabs) {
  updated_tabs
    .filter(t => !t.id)
    .forEach(async t => await browser.tabs.create({url: t.url}))
}

async function mktemp(template) {
  const mktemp_cmd = await glide.process.execute("mktemp", ["-t", template, "--suffix", "json"]);
  return (await mktemp_cmd.stdout.text()).trim();
}
