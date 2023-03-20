import Foundation

class Log {
    static var logLevel = "info"
    
    static func info(msg: String) {
        logfmt(msg: msg)
    }
    
    static func debug(msg: String) {
        if (logLevel != "debug") {
            return
        }
        
        logfmt(msg: msg, level: "debug")
    }
    
    static func error(msg: String) {
        logfmt(msg: msg, level: "error")
    }
    
    static func logfmt(msg: String, level: String = "info") {
        print(NSString(format: "[percy:sdk][%@] %@", level, msg))
    }
}
