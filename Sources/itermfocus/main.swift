import AppKit

if CommandLine.arguments.count > 1 {
    let sessionId = CommandLine.arguments[1]
    let success = ITerm2Focuser.focus(sessionId: sessionId)
    exit(success ? 0 : 1)
} else {
    let app = NSApplication.shared
    let delegate = AppDelegate()
    app.delegate = delegate
    app.run()
}
