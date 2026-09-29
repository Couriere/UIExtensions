SIMULATOR ?= iPhone 17 Pro

.PHONY: ui-tests

# Runs all UI tests on the simulator with this name on the newest installed iOS runtime.
# Override the device with `make ui-tests SIMULATOR="iPhone 16"`.
ui-tests:
	@id=$$(xcrun simctl list devices available iOS | grep -E '^ +$(SIMULATOR) [(]' | tail -1 | grep -oE '[0-9A-F-]{36}'); \
	test -n "$$id" || { echo "No available simulator named \"$(SIMULATOR)\""; exit 1; }; \
	xcodebuild test \
		-project UITests/UIExtensionsUITests.xcodeproj \
		-scheme Host \
		-parallel-testing-enabled YES \
		-destination "platform=iOS Simulator,id=$$id"
