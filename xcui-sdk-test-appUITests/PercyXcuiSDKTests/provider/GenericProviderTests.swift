import XCTest

@testable import PercyXcui

final class GenericProviderTests: XCTestCase {
  var provider: GenericProvider = GenericProvider()

  override func setUp() {
    let app = XCUIApplication()
    app.launch()

    provider = GenericProvider()
    Log.logLevel = "debug"
  }

  override func tearDown() {
    NetworkHelpers.stop()
    super.tearDown()
  }

  func testScreenshot() throws {
    NetworkHelpers.start(requests: [
      NetworkHelpers.stubHealthcheck(), NetworkHelpers.stubPostComparison()
    ])

    try provider.screenshot(name: "abc", options: ScreenshotOptions())
  }

  func testScreenshotThrowsIfCLIError() throws {
    NetworkHelpers.start(requests: [
      NetworkHelpers.stubHealthcheck(), NetworkHelpers.stubPostComparison(success: false)
    ])

    XCTAssertThrowsError(try provider.screenshot(name: "abc", options: ScreenshotOptions())) { error in
      XCTAssertTrue(error is AppPercyError)
    }
  }

}
