import PercyXcui
import XCTest

final class XcuiSdkTestAppUITests: XCTestCase {

  override func setUpWithError() throws {
    continueAfterFailure = false
  }

  override func tearDownWithError() throws {
  }

  func testExample() throws {
    // UI tests must launch the application that they test.
    let app = XCUIApplication()
    app.launch()

    let percy = AppPercy()
    try percy.screenshot(name: "abc")

  }
}
