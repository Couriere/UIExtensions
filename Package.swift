// swift-tools-version:6.0
import PackageDescription

let package = Package(
	name: "UIExtensions",
	platforms: [ .iOS( .v18 ), .tvOS( .v18 ), .macOS( .v15 ), .watchOS( .v11 ) ],
	products: [
		.library( name: "UIExtensions", targets: ["UIExtensions"]),
	],
	targets: [
		.target( name: "UIExtensions", dependencies: [], path: "Sources" ),
		.testTarget(
			name: "UIExtensionsTests",
			dependencies: [ "UIExtensions" ],
			path: "UIExtensionsTests",
		),
	],
	swiftLanguageModes: [ .v6 ],
)
