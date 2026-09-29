# UI Tests

UI tests for the SwiftUI components of UIExtensions. SwiftPM cannot host UI tests,
so they run against a small iOS app that links the package.

- `UIExtensionsUITests.xcodeproj` — the checked-in Xcode project and shared `Host` scheme.
- `Host` — the app. Each component has its own screen in `Host/Screens`.
  Launched without arguments, the app shows a catalog of all screens.
- `HostUITests` — the UI tests.
- `Shared` — screen and accessibility identifiers compiled into both targets.

## Running

From the repository root:

```bash
make ui-tests
```

It runs all UI tests on the newest iOS runtime's iPhone 17 Pro.
Pick another device with `make ui-tests SIMULATOR="iPhone 16"`.

The command reports results in the terminal without opening a simulator window.
Tests run in parallel when Xcode can distribute them across simulator workers.

Or open `UIExtensionsUITests.xcodeproj` and run the `Host` scheme tests.
Close the root package in Xcode first: a package cannot be open in two windows at once.
You can rerun a failed test directly from Xcode to inspect it visually.

## Adding a test

1. Add a case to `ScreenID` and the accessibility identifiers of the screen to `Shared/ScreenID.swift`.
2. Add the screen to `Host/Screens` and to `ScreenID.view` in `Host/HostApp.swift`.
3. Add a test class to the `HostUITests` target in Xcode that starts with `launch( .yourScreen )`.
   New files created outside Xcode must also be added to that target in the project navigator.

Screens should let the test drive asynchronous work instead of waiting for timeouts.
For example, `LoaderScreen` suspends every load until the test taps Complete or Fail.
