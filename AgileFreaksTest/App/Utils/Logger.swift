import OSLog

enum Log {
    enum Category: String {
        case app
        case home
    }

    private static let subsystem = Bundle.main.bundleIdentifier ?? "AgileFreaksTest"

    private static func osLogger(_ category: Category) -> Logger {
        Logger(subsystem: subsystem, category: category.rawValue)
    }

    static func debug(_ message: String, category: Category = .app) {
        #if DEBUG
        osLogger(category).debug("\(message, privacy: .public)")
        #endif
    }

    static func info(_ message: String, category: Category = .app) {
        osLogger(category).info("\(message, privacy: .public)")
    }

    static func error(_ message: String, category: Category = .app) {
        osLogger(category).error("\(message, privacy: .public)")
    }
}
