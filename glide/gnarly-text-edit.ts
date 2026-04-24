// Gnarly Text Edit: edit the currently focused editable element in nvim
// Features:
// - Grabs the text content of the focused <textarea>, <input>, or contenteditable
// - Dumps it to a temp markdown file
// - Opens it in nvim via wezterm and waits for the editor to exit
// - Replaces the element's content with the edited file contents
glide.excmds.create({ name: "text_edit", description: "Edit the focused editable element in nvim" }, async () => {
  if (!(await glide.ctx.is_editing())) {
    throw new Error("No editable element is focused");
  }

  const tab = await glide.tabs.active();
  const original = await glide.content.execute(read_focused_text, { tab_id: tab });

  const tempfile = await mktemp("glide_text_edit.XXXXXX");
  await glide.fs.write(tempfile, original);

  await let_user_edit_file_and_wait_for_exit(tempfile);

  let edited = await glide.fs.read(tempfile, "utf8");
  // `glide.fs.write` above does not append a trailing newline, but many editors
  // (including nvim) will add one on save. Strip a single trailing newline so
  // round-tripping an unchanged buffer is a no-op.
  if (edited.endsWith("\n") && !original.endsWith("\n")) {
    edited = edited.slice(0, -1);
  }

  await glide.content.execute(write_focused_text, { tab_id: tab, args: [edited] });
});

glide.keymaps.set(["normal", "insert"], "<C-x><C-e>", "text_edit", {
  description: "Edit the focused editable element in nvim",
});

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

async function mktemp(template) {
  const mktemp_cmd = await glide.process.execute("mktemp", ["-t", template, "--suffix", ".md"]);
  return (await mktemp_cmd.stdout.text()).trim();
}

// --- Content-process helpers ---------------------------------------------

function read_focused_text(): string {
  const el = document.activeElement as HTMLElement | null;
  if (!el) return "";
  if (el instanceof HTMLTextAreaElement || el instanceof HTMLInputElement) {
    return el.value ?? "";
  }
  if ((el as HTMLElement).isContentEditable) {
    // innerText preserves visible line breaks better than textContent
    return (el as HTMLElement).innerText ?? "";
  }
  return "";
}

function write_focused_text(text: string): void {
  const el = document.activeElement as HTMLElement | null;
  if (!el) return;

  if (el instanceof HTMLTextAreaElement || el instanceof HTMLInputElement) {
    // Use the native value setter so frameworks like React pick up the change.
    const proto =
      el instanceof HTMLTextAreaElement
        ? HTMLTextAreaElement.prototype
        : HTMLInputElement.prototype;
    const setter = Object.getOwnPropertyDescriptor(proto, "value")?.set;
    if (setter) {
      setter.call(el, text);
    } else {
      el.value = text;
    }
    el.dispatchEvent(new Event("input", { bubbles: true }));
    el.dispatchEvent(new Event("change", { bubbles: true }));
    return;
  }

  if (el.isContentEditable) {
    // Prefer execCommand so the site's undo stack / input listeners fire.
    el.focus();
    const sel = el.ownerDocument.getSelection();
    if (sel) {
      const range = el.ownerDocument.createRange();
      range.selectNodeContents(el);
      sel.removeAllRanges();
      sel.addRange(range);
    }
    if (!document.execCommand("insertText", false, text)) {
      el.innerText = text;
      el.dispatchEvent(new InputEvent("input", { bubbles: true, inputType: "insertText", data: text }));
    }
  }
}
