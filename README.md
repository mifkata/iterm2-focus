# itermfocus

Focus an iTerm2 window, tab, and pane by session ID. Works as both a CLI tool and a macOS URL scheme handler.

## Prerequisites

- macOS 12 (Monterey) or later
- Xcode Command Line Tools (`xcode-select --install`)
- iTerm2

## Install

**One-liner** (clones, builds, and installs to `~/bin`):

```bash
curl -fsSL https://raw.githubusercontent.com/mifkata/iterm2-focus/main/install.sh | bash
```

**From source:**

```bash
git clone https://github.com/mifkata/iterm2-focus.git
cd iterm2-focus
make install
```

Both methods install to `~/bin/itermfocus.app` with a CLI symlink at `~/bin/itermfocus`. Make sure `~/bin` is in your `PATH`:

```bash
export PATH="$HOME/bin:$PATH"
```

## Uninstall

```bash
make uninstall
```

## Usage

### CLI

Pass an iTerm2 session ID directly:

```bash
itermfocus <session-id>
```

The session ID can be a full `ITERM_SESSION_ID` value (e.g. `w0t0p0:F0A1B2C3-D4E5-6F78-9A0B-C1D2E3F4A5B6`) or just the UUID portion. The tool extracts the UUID automatically.

To get the current session ID inside iTerm2:

```bash
echo $ITERM_SESSION_ID
```

### URL Scheme

```
itermfocus://?sessionId=<session-id>
```

This is registered automatically during installation via macOS Launch Services. The app runs in the background, focuses the matching session, and terminates.

### Integration with terminal-notifier

[terminal-notifier](https://github.com/julienXX/terminal-notifier) supports opening a URL when a notification is clicked. Combine it with `itermfocus` to jump back to the originating terminal session:

```bash
terminal-notifier \
  -title "Task Complete" \
  -message "Build finished" \
  -open "itermfocus://?sessionId=${ITERM_SESSION_ID}"
```

When clicked, the notification focuses the iTerm2 window, tab, and pane where the command was run.

**Example — notify after a long build:**

```bash
make build && terminal-notifier \
  -title "Build Succeeded" \
  -message "Ready to test" \
  -open "itermfocus://?sessionId=${ITERM_SESSION_ID}"
```

**Example — shell function for reusable notifications:**

```bash
notify() {
  terminal-notifier \
    -title "${1:-Done}" \
    -message "${2:-Task finished}" \
    -open "itermfocus://?sessionId=${ITERM_SESSION_ID}"
}

# Usage:
long-running-command; notify "Finished" "long-running-command completed"
```

## Development

### Build

```bash
make build
```

### Test

```bash
make test
```

### Debug

Run directly from the build output:

```bash
swift build
.build/debug/itermfocus <session-id>
```

### Clean

```bash
make clean
```
