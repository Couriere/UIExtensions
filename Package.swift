// swift-tools-version:6.0
import PackageDescription

let package = Package(
	name: "UIExtensions",
	platforms: [ .iOS( .v15 ), .tvOS( .v15 ), .macOS( .v12 ), .watchOS( .v9 ) ],
	products: [
		.library( name: "UIExtensions", targets: ["UIExtensions"]),
	],
	targets: [
		.target( name: "UIExtensions", dependencies: [], path: "Sources" ),
		.testTarget(
			name: "UIExtensionsTests",
			dependencies: [ "UIExtensions" ],
			path: "UIExtensionsTests"
		),
	],
	swiftLanguageModes: [ .v5, .v6 ]
)
