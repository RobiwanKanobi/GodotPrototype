# AGENTS.md

## Cursor Cloud specific instructions

This is a **Godot 4.6** GDScript game project (2D ant hill simulation). There are no traditional package managers, lockfiles, or dependency manifests.

### Engine

- **Godot 4.6.1** is installed at `/usr/local/bin/godot`.
- The project uses `GL Compatibility` renderer and targets web (HTML5/WASM) export.

### Lint / Validate

Validate all GDScript files with:
```sh
godot --headless --check-only --script <file.gd>
```

### Build (Web Export)

Export templates are installed at `~/.local/share/godot/export_templates/4.6.1.stable/`. To re-export the web build:
```sh
godot --headless --export-debug "Web" Builds/index.html
```

### Run / Test

Serve the web build locally with CORS headers required by WASM:
```sh
cd Builds && python3 -c "
from http.server import HTTPServer, SimpleHTTPRequestHandler
class H(SimpleHTTPRequestHandler):
    def end_headers(self):
        self.send_header('Cross-Origin-Opener-Policy','same-origin')
        self.send_header('Cross-Origin-Embedder-Policy','require-corp')
        super().end_headers()
HTTPServer(('0.0.0.0',8080),H).serve_forever()
" &
```
Then open `http://localhost:8080/index.html` in Chrome.

### Gotchas

- The GDAI MCP editor plugin (`addons/gdai-mcp-plugin-godot/`) requires native binaries that are gitignored. Its absence produces a harmless warning during import/export but does not affect the game.
- `godot --headless --import` must be run at least once to generate the `.godot/` cache directory before exporting.
- The web build **requires** `Cross-Origin-Opener-Policy` and `Cross-Origin-Embedder-Policy` headers; a plain `python3 -m http.server` will not work.
