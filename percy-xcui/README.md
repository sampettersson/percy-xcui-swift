# percy-xcui-swift
XCUI Swift SDK for App Percy

[Percy](https://percy.io) visual testing [XCUI Test](https://developer.apple.com/documentation/xctest/user_interface_tests)

Note: We dont support XCTest as no UI is rendered for XCTest. We support only XCUI Test

## Installation
Include the dependency in xcode package manager

1. Right click on any item in `Project Navigator`
2. Click `Add Packages...`
3. Search top right with this repo URL
4. Include package
5. Go to your project properties -> select XCUI test project target
6. Go to `Build Phases` tab
7. Under `Target Dependencies` press `+` and select `PercyXcui` dependency
8. Under `Link Library with Binaries` press `+` and select `PercyXcui` dependency

## Usage

This is an example test using the `screenshot` function.

```swift
import XCTest
import PercyXcui // importing the package

final class MyAppUITests: XCTestCase {
    func testExample() throws {
        // launch application
        let app = XCUIApplication()
        app.launch()

        // take screenshot
        let percy = AppPercy()
        try percy.screenshot(name: "abc")
    }
}
```

Running the test above normally will result in the following log:

```sh-session
[percy:sdk] Percy CLI is not running, disabling screenshots.
```
Running with App Automate will capture the screenshots as expected.

## Configuration

```swift
screenshot(name: String, options: ScreenshotOptions = ScreenshotOptions())
```

- `name` (**required**) - The screenshot name; must be unique to each screenshot
- `options ScreenshotOptions` (**optional**) 
  - `fullscreen`: if the app is currently in fullscreen
  - `statusBarHeight`: In px if you want to override SDK
  - `navigationBarHeight`: In px if you want to override SDK
