#!/bin/bash

# Pre-run script - Ensures tests pass before running the app
# Usage: ./scripts/pre_run.sh

set -e  # Exit on error

echo "🔍 Pre-run checks starting..."
echo ""

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_info() {
    echo -e "${YELLOW}ℹ️  $1${NC}"
}

# Step 1: Run tests
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🧪 Running tests..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
if flutter test --reporter compact; then
    print_success "All tests passed!"
else
    print_error "Tests failed! Please fix failing tests before running the app."
    exit 1
fi
echo ""

# Step 2: Run static analysis
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🔍 Running static analysis..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
if flutter analyze --no-pub; then
    print_success "Static analysis passed!"
else
    print_error "Static analysis found issues! Please fix them before running the app."
    exit 1
fi
echo ""

# All checks passed
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
print_success "All pre-run checks passed!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
print_info "You can now run the app with: flutter run"
echo ""
