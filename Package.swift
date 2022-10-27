// swift-tools-version:5.1
import PackageDescription

let package = Package(
	name: "UIExtensions",
	platforms: [ .iOS( .v11 ), .tvOS( .v11 ), .macOS( .v10_13 ) ],
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
