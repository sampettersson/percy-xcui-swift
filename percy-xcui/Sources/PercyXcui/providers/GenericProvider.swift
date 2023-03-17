
import Foundation
import UIKit

public class GenericProvider {
    let cliWrapper: CliWrapper
    
    var metadata: Metadata = Metadata(options: ScreenshotOptions())
    
    public init() {
        self.cliWrapper = CliWrapper()
    }

    public func screenshot(name: String, options: ScreenshotOptions) throws {
        self.metadata = Metadata(options: options)
        let tag = getTag(options: options)
        let tiles = try captureTiles()
        let response = try cliWrapper.postScreenshot(name: name, tag: tag, tiles: tiles)
        Log.info(msg: "Please check screenshot `\(name)` : \(response["link"] ?? "Error link not found")")
    }
    
    private func captureTiles() throws -> [Tile] {
        let statusbar = metadata.statBarHeight()
        let navbar = metadata.navBarHeight()
        let header = 0
        let footer = 0
        var array: [Tile] = []

        let content = try ScreenshotController().takeScreenshot();
        array.append(Tile(content: content, statusBarHeight: Int(statusbar), navBarHeight: navbar, headerHeight: header, footerHeight: footer, fullScreen: false))
        return array
    }

    
    private func getTag(options: ScreenshotOptions) -> [String: Any] {
        let jsonObject: [String: Any] = [
            "name": metadata.deviceName(),
            "osName": metadata.osName(),
            "osVersion": metadata.platformVersion(),
            "width": metadata.deviceScreenWidth(),
            "height": metadata.deviceScreenHeight(),
            "orientation": metadata.orientation(),
            "fullscreen": options.fullScreen
        ]
        return jsonObject
    }
}
