// swift-tools-version:5.1
import PackageDescription

let package = Package(
	name: "UIExtensions",
	platforms: [ .iOS( .v13 ), .tvOS( .v13 ), .macOS( .v10_15 ), .watchOS( .v6 ) ],
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
	swiftLanguageVersions: [ .v5 ]
)
