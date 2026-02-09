APP_NAME := itermfocus
APP_DIR := $(HOME)/bin/$(APP_NAME).app
BIN_LINK := $(HOME)/bin/$(APP_NAME)
LSREGISTER := /System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister

.PHONY: build test install uninstall clean

build:
	swift build -c release

test:
	swift test

install: build
	mkdir -p "$(APP_DIR)/Contents/MacOS"
	cp .build/release/$(APP_NAME) "$(APP_DIR)/Contents/MacOS/$(APP_NAME)"
	chmod +x "$(APP_DIR)/Contents/MacOS/$(APP_NAME)"
	cp Resources/Info.plist "$(APP_DIR)/Contents/Info.plist"
	$(LSREGISTER) -f "$(APP_DIR)"
	ln -sf "$(APP_DIR)/Contents/MacOS/$(APP_NAME)" "$(BIN_LINK)"

uninstall:
	rm -rf "$(APP_DIR)"
	rm -f "$(BIN_LINK)"

clean:
	swift package clean
