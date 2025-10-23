import Foundation
import SwiftUICore

enum LogLevel: String {
    case debug = "🐛DEBUG| "
    case info = "ℹ️INFO| "
    case warning = "⚠️WARNING| "
    case error = "❌ERROR| "
}

protocol LoggerProtocol {
    func log(message: String, logLevel: LogLevel)
}

final class Logger: LoggerProtocol {
    static let logger = Logger()
    private let fileManager: FileManager
    
    private init() {
        fileManager = FileManager.default
        createTheLogFileIfNeeded()
    }
    
    func log(message: String, logLevel: LogLevel = .debug) {
        let logFileURL = getTheLogFile()
        let log = "[" + time() + "] " + logLevel.rawValue + message + "\n"
        do {
            if let data = log.data(using: .utf8) {
                try writeLogToFile(message: data)
            }
        } catch {
            fileManager.createFile(atPath: logFileURL.path(), contents: log.data(using: .utf8))
        }
        
    }
    
    func createTheLogFileIfNeeded() {
        let content = "\n[\(time())] \(LogLevel.info.rawValue)CryptoCheker starting!\n".data(using: .utf8)
        let logFileURL = getTheLogFile()
        if !fileManager.fileExists(atPath: logFileURL.path()) {
            fileManager.createFile(atPath: logFileURL.path(), contents: content)
            return
        }
        do {
            if let data = content {
                try writeLogToFile(message: data)
            }
        } catch {
            fileManager.createFile(atPath: logFileURL.path(), contents: content)
        }
    }
    
    func getTheLogFile() -> URL {
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsURL.appendingPathComponent("CryptoChecker.log")
    }
    
    private func time() -> String {
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.string(from: now)
    }
    
    private func writeLogToFile(message: Data) throws {
        let fileHandler = try FileHandle(forWritingTo: getTheLogFile())
        try fileHandler.seekToEnd()
        try fileHandler.write(contentsOf: message)
        try fileHandler.close()
    }
}

struct LoggerKey: EnvironmentKey {
    static let defaultValue: LoggerProtocol = Logger.logger
}

extension EnvironmentValues {
    var logger: LoggerProtocol {
        get { self[LoggerKey.self] }
        set { self[LoggerKey.self] = newValue }
    }
}
