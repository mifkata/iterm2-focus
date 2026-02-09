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
  -open "itermfocus://session?sessionId=${ITERM_SESSION_ID}"
```

When clicked, the notification focuses the iTerm2 window, tab, and pane where the command was run.

**Example — reusable notify wrapper script (`.claude/hooks/notifier.sh`):**

```sh
#!/bin/sh
REPO_ROOT="$(cd "$(git rev-parse --git-common-dir)/.." && pwd)"
REPO_NAME="$(basename "$REPO_ROOT")"
BRANCH="$(git rev-parse --abbrev-ref HEAD)"

TITLE="$REPO_NAME/$BRANCH"

terminal-notifier \
    -title "$TITLE" -message "$1" -group "$TITLE" -remove "$TITLE" \
    -open "itermfocus://session?sessionId=$ITERM_SESSION_ID"
```

This derives the notification title from the current repo and branch, and clicking the notification focuses the originating iTerm2 session.

**Example — In combination with Claude Code hooks (`.claude/settings.json`):**

```json
{
  "hooks": {
    "Notification": [
      {
        "matcher": "permission_prompt",
        "hooks": [
          {
            "type": "command",
            "command": ".claude/hooks/notifier.sh \"Waiting for user…\""
          }
        ]
      }
    ],
    "Stop": [
      {
        "matcher": "*",
        "hooks": [
          {
            "type": "command",
            "command": ".claude/hooks/notifier.sh \"Ready!\""
          }
        ]
      }
    ]
  }
}
```

With this setup, Claude Code sends a desktop notification whenever it needs approval or finishes a task. Clicking the notification jumps you straight back to the correct iTerm2 session.

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
