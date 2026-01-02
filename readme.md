# C2B Markdown Editor

A desktop Markdown editor I built while learning Qt 6. Split-pane editor with live preview that saves both `.md` source and printable HTML with a table of contents.

**This is a learning project.** Figuring out Qt as I go. It works, but don't expect production code.

## What it does

- Edit Markdown, see HTML preview in real-time
- Saves `.md` and auto-generates `.html` with TOC

The goal: take markdown chunks and turn them into one readable document with navigation.

## Building it

Need Qt 6.10+ with WebEngine, WebChannel, and Quick.
```bash
# Get md4c
mkdir -p extensions/md4c && cd extensions/md4c
curl -L https://github.com/mity/md4c/archive/refs/tags/release-0.5.2.tar.gz | tar xz --strip-components=1
cd ../..

# Build
mkdir build && cd build
cmake ..
cmake --build .
```

Or open `CMakeLists.txt` in Qt Creator and build there.

## Structure
```
C2B/
├── CMakeLists.txt
├── main.cpp
├── Main.qml
├── app/                    # C++ backend (file I/O, Markdown, HTML)
├── components/             # QML UI components
├── theme/                  # Dark theme singleton
└── extensions/md4c/        # Vendored Markdown parser
```

QML for UI, C++ for file operations and Markdown processing.

## What's missing

- No syntax highlighting
- No undo/redo
- Basic error handling
- Simple TOC generation
- Single document only

It's a learning project. The point was understanding Qt, not building VS Code.

## License

No expectations
