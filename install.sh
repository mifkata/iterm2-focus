#!/usr/bin/env bash
set -euo pipefail

REPO_URL="https://github.com/mifkata/iterm2-focus.git"
TMP_DIR="/tmp/itermfocus-install"
APP_DIR="$HOME/bin/itermfocus.app"
BIN_LINK="$HOME/bin/itermfocus"

# --- Helpers ---

info() { printf "\033[1;34m==>\033[0m %s\n" "$1"; }
error() { printf "\033[1;31mError:\033[0m %s\n" "$1" >&2; exit 1; }

# --- Prerequisite checks ---

info "Checking prerequisites..."

[[ "$(uname -s)" == "Darwin" ]] || error "This installer only supports macOS."

command -v swift >/dev/null 2>&1 || error "swift not found. Install Xcode Command Line Tools: xcode-select --install"
command -v xcodebuild >/dev/null 2>&1 || error "xcodebuild not found. Install Xcode Command Line Tools: xcode-select --install"
command -v osascript >/dev/null 2>&1 || error "osascript not found. This should be available on all macOS systems."
command -v git >/dev/null 2>&1 || error "git not found. Install Xcode Command Line Tools: xcode-select --install"

# --- Download source ---

info "Cloning repository to ${TMP_DIR}..."
rm -rf "$TMP_DIR"
git clone --depth 1 "$REPO_URL" "$TMP_DIR"

# --- Build ---

info "Building with Swift Package Manager..."
cd "$TMP_DIR"
swift build -c release

# --- Create .app bundle ---

info "Installing to ${APP_DIR}..."
mkdir -p "${APP_DIR}/Contents/MacOS"
cp ".build/release/itermfocus" "${APP_DIR}/Contents/MacOS/itermfocus"
chmod +x "${APP_DIR}/Contents/MacOS/itermfocus"
cp "Resources/Info.plist" "${APP_DIR}/Contents/Info.plist"

# --- Register URL scheme ---

info "Registering URL scheme with Launch Services..."
/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -f "$APP_DIR"

# --- Symlink CLI ---

info "Creating symlink at ${BIN_LINK}..."
ln -sf "${APP_DIR}/Contents/MacOS/itermfocus" "$BIN_LINK"

# --- Cleanup ---

info "Cleaning up..."
rm -rf "$TMP_DIR"

# --- PATH check ---

if [[ ":$PATH:" != *":$HOME/bin:"* ]]; then
    printf "\n\033[1;33mNote:\033[0m ~/bin is not in your PATH. Add it with:\n"
    printf "  export PATH=\"\$HOME/bin:\$PATH\"\n\n"
fi

info "Done! itermfocus has been installed."
printf "  App bundle: %s\n" "$APP_DIR"
printf "  CLI:        %s\n" "$BIN_LINK"
printf "  URL scheme: itermfocus://\n"
