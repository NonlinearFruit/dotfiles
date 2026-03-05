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

