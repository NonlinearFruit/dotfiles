#!/usr/bin/env nu

[
  "#!/usr/bin/env nu"
  ""
  "def --wrapped main [...rest] {"
  "  nu -c $'use toolkit.nu; toolkit ($rest | str join ' ')'"
  "}"
]
| str join (char newline)
| save toolkit.nu
chmod +x toolkit.nu
