# Makefile for Random Images Flutter Project

.PHONY: help test run build clean analyze pre-run

help: ## Show this help message
	@echo 'Usage: make [target]'
	@echo ''
	@echo 'Available targets:'
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'

test: ## Run all tests
	@echo "🧪 Running tests..."
	@flutter test --reporter compact
	@echo "✅ All tests passed!"

analyze: ## Run static analysis
	@echo "🔍 Running static analysis..."
	@flutter analyze --no-pub
	@echo "✅ Analysis complete!"

pre-run: test analyze ## Run tests and analysis before running app
	@echo "✅ All checks passed! Ready to run."

run: pre-run ## Run app (tests must pass first)
	@echo "🚀 Starting app..."
	@flutter run

run-debug: pre-run ## Run app in debug mode (tests must pass first)
	@echo "🚀 Starting app in debug mode..."
	@flutter run --debug

run-release: pre-run ## Run app in release mode (tests must pass first)
	@echo "🚀 Starting app in release mode..."
	@flutter run --release

build-apk: test ## Build APK (tests must pass first)
	@echo "📦 Building APK..."
	@flutter build apk --release
	@echo "✅ APK built successfully!"

build-ios: test ## Build iOS (tests must pass first)
	@echo "📦 Building iOS..."
	@flutter build ios --release
	@echo "✅ iOS built successfully!"

clean: ## Clean build artifacts
	@echo "🧹 Cleaning..."
	@flutter clean
	@echo "✅ Cleaned!"

get: ## Get dependencies
	@echo "📦 Getting dependencies..."
	@flutter pub get
	@echo "✅ Dependencies installed!"

generate: ## Generate code (mocks, etc.)
	@echo "⚙️  Generating code..."
	@dart run build_runner build --delete-conflicting-outputs
	@echo "✅ Code generated!"

check: test analyze ## Run all checks (tests + analysis)
	@echo "✅ All checks passed!"

# Default target
.DEFAULT_GOAL := help
