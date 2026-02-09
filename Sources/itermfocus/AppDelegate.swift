import AppKit

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationWillFinishLaunching(_ notification: Notification) {
        NSAppleEventManager.shared().setEventHandler(
            self,
            andSelector: #selector(handleGetURL(_:withReplyEvent:)),
            forEventClass: AEEventClass(kInternetEventClass),
            andEventID: AEEventID(kAEGetURL)
        )
    }

    func applicationDidFinishLaunching(_ notification: Notification) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            NSApplication.shared.terminate(nil)
        }
    }

    @objc func handleGetURL(_ event: NSAppleEventDescriptor, withReplyEvent replyEvent: NSAppleEventDescriptor) {
        guard let urlString = event.paramDescriptor(forKeyword: keyDirectObject)?.stringValue,
              let components = URLComponents(string: urlString),
              let sessionId = components.queryItems?.first(where: { $0.name == "sessionId" })?.value else {
            FileHandle.standardError.write(Data("Invalid URL or missing sessionId parameter\n".utf8))
            NSApplication.shared.terminate(nil)
            return
        }

        ITerm2Focuser.focus(sessionId: sessionId)
        NSApplication.shared.terminate(nil)
    }
}
