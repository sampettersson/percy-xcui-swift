import XCTest
@testable import PercyXcui

final class MetadataTests: XCTestCase {
    var meta: Metadata = Metadata()

    override func setUp() {
        meta = Metadata()
    }
    
    func testOsName() throws {
        XCTAssertEqual(meta.osName(), "iOS")
    }
    
    func testOrientation() throws {
        XCUIDevice.shared.orientation = UIDeviceOrientation.portrait
        XCTAssertEqual(XCUIDevice.shared.orientation.isPortrait, true)

        XCTAssertEqual(meta.orientation(), "portrait")
        
        XCUIDevice.shared.orientation = UIDeviceOrientation.landscapeLeft
        XCTAssertEqual(meta.orientation(), "landscape")
        
        // reset
        XCUIDevice.shared.orientation = UIDeviceOrientation.portrait
    }
    
    func testDeviceScreenWidth() throws {
        XCTAssertEqual(meta.deviceScreenWidth(), UIScreen.main.bounds.width * UIScreen.main.scale)
    }

    func testDeviceScreenHeight() throws {
        XCTAssertEqual(meta.deviceScreenHeight(), UIScreen.main.bounds.height * UIScreen.main.scale)
    }
    
    func testStatusBarHeight() throws {
        XCTAssertEqual(meta.statBarHeight(), Int(UIApplication.shared.statusBarFrame.height * UIScreen.main.scale))
        
        // with options set
        let options = ScreenshotOptions()
        options.statusBarHeight = 100
        meta = Metadata(options: options)
        XCTAssertEqual(meta.statBarHeight(), options.statusBarHeight)
    }
    
    func testNavigationBarHeight() throws {
        XCTAssertEqual(meta.navBarHeight(), 0)
        
        // with options set
        let options = ScreenshotOptions()
        options.navigationBarHeight = 100
        meta = Metadata(options: options)
        XCTAssertEqual(meta.navBarHeight(), options.navigationBarHeight)
    }
    
    func testDeviceName() throws {
        XCTAssertTrue(meta.deviceName().contains("iPhone"))
    }
}
