import Foundation

enum ITerm2Focuser {
    static func extractUUID(from sessionId: String) -> String {
        if sessionId.contains(":") {
            return String(sessionId.split(separator: ":").last ?? Substring(sessionId))
        }
        return sessionId
    }

    @discardableResult
    static func focus(sessionId: String) -> Bool {
        let uuid = extractUUID(from: sessionId)

        let script = """
        tell application "iTerm2"
            repeat with w in windows
                repeat with t in tabs of w
                    repeat with s in sessions of t
                        if unique id of s is "\(uuid)" then
                            select t
                            select s
                            set index of w to 1
                            activate
                            return "ok"
                        end if
                    end repeat
                end repeat
            end repeat
            return "not found"
        end tell
        """

        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/osascript")
        process.arguments = ["-e", script]

        let stdout = Pipe()
        let stderr = Pipe()
        process.standardOutput = stdout
        process.standardError = stderr

        do {
            try process.run()
            process.waitUntilExit()
        } catch {
            FileHandle.standardError.write(Data("Failed to run osascript: \(error)\n".utf8))
            return false
        }

        if process.terminationStatus != 0 {
            let errorData = stderr.fileHandleForReading.readDataToEndOfFile()
            if let errorMessage = String(data: errorData, encoding: .utf8), !errorMessage.isEmpty {
                FileHandle.standardError.write(Data("osascript error: \(errorMessage)".utf8))
            }
            return false
        }

        let outputData = stdout.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: outputData, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

        if output == "not found" {
            FileHandle.standardError.write(Data("Session not found: \(uuid)\n".utf8))
            return false
        }

        return true
    }
}
