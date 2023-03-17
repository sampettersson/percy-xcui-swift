import Foundation

public class AppPercy {
    // global config options
    static var ignoreErrors = true
    static var allowedDevices = [String]()
    static func setLogLevel(level: String = "info") {
        Log.logLevel = level
    }
    
    
    let cliWrapper: CliWrapper
    var isPercyEnabled: Bool

    public init() {
        self.cliWrapper =  CliWrapper();
        self.isPercyEnabled = cliWrapper.healthcheck()
    }
    
    public func screenshot(name: String, options: ScreenshotOptions = ScreenshotOptions()) throws {
        if (!isPercyEnabled) {
            return
        }
        
        let provider = GenericProvider()
        do {
            try provider.screenshot(name: name, options: options)
        } catch let error {
            Log.error(msg: "[\(name)] Error while capturing screenshot : \(error)")
            if (!AppPercy.ignoreErrors) {
                throw error
            }
        }
    }
}
