// swift-tools-version:5.1
import PackageDescription

let package = Package(
	name: "UIExtensions",
	platforms: [ .iOS( .v9 ), .tvOS( .v11 ) ],
	products: [
		.library( name: "UIExtensions", targets: ["UIExtensions"]),
	],
	targets: [
		.target( name: "UIExtensions", dependencies: [], path: "Sources" ),
		.testTarget(
			name: "UIExtensionsTests",
			dependencies: ["UIExtensions"], path: "UIExtensionsTests"),
	],
	swiftLanguageVersions: [ .v5 ]
)
