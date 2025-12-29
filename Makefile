# Makefile for Bolu iOS App
# Usage: make build, make run, make clean

.PHONY: build run clean simulator list-devices

SCHEME = Bolu
PROJECT = Bolu.xcodeproj
SIMULATOR = iPhone 14 Pro Max

# List available simulators
list-devices:
	@echo "Available simulators:"
	@xcrun simctl list devices available | grep -i "iphone"

# Get device ID for simulator
get-device:
	@xcrun simctl list devices available | grep -i "pro max" | head -1 | sed -E 's/.*\(([^)]+)\).*/\1/'

# Build the project
build:
	@echo "🔨 Building $(SCHEME)..."
	@xcodebuild \
		-project $(PROJECT) \
		-scheme $(SCHEME) \
		-configuration Debug \
		clean build \
		CODE_SIGN_IDENTITY="" \
		CODE_SIGNING_REQUIRED=NO \
		CODE_SIGNING_ALLOWED=NO
	@echo "✅ Build complete!"

# Run on simulator
run: build
	@echo "📱 Getting simulator..."
	@DEVICE_ID=$$(xcrun simctl list devices available | grep -i "pro max" | head -1 | sed -E 's/.*\(([^)]+)\).*/\1/'); \
	if [ -z "$$DEVICE_ID" ]; then \
		DEVICE_ID=$$(xcrun simctl list devices available | grep -i "iphone" | head -1 | sed -E 's/.*\(([^)]+)\).*/\1/'); \
	fi; \
	echo "🚀 Running on simulator: $$DEVICE_ID"; \
	xcrun simctl boot $$DEVICE_ID 2>/dev/null || true; \
	open -a Simulator; \
	sleep 3; \
	APP_PATH=$$(find ~/Library/Developer/Xcode/DerivedData -name "Bolu.app" -type d | head -1); \
	if [ -z "$$APP_PATH" ]; then \
		echo "❌ App not found. Building..."; \
		xcodebuild -project $(PROJECT) -scheme $(SCHEME) -destination "id=$$DEVICE_ID" build; \
		APP_PATH=$$(find ~/Library/Developer/Xcode/DerivedData -name "Bolu.app" -type d | head -1); \
	fi; \
	xcrun simctl install $$DEVICE_ID $$APP_PATH; \
	BUNDLE_ID=$$(xcodebuild -showBuildSettings -project $(PROJECT) -scheme $(SCHEME) | grep PRODUCT_BUNDLE_IDENTIFIER | head -1 | awk '{print $$3}'); \
	xcrun simctl launch $$DEVICE_ID $$BUNDLE_ID; \
	echo "✅ App launched!"

# Clean build artifacts
clean:
	@echo "🧹 Cleaning..."
	@xcodebuild -project $(PROJECT) -scheme $(SCHEME) clean
	@rm -rf ~/Library/Developer/Xcode/DerivedData/Bolu-*
	@echo "✅ Clean complete!"

# Open project in Xcode
open:
	@open $(PROJECT)

# Help
help:
	@echo "Available commands:"
	@echo "  make build         - Build the project"
	@echo "  make run           - Build and run on simulator"
	@echo "  make clean         - Clean build artifacts"
	@echo "  make open          - Open project in Xcode"
	@echo "  make list-devices  - List available simulators"
	@echo "  make help          - Show this help"

