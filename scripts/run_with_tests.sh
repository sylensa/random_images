#!/bin/bash

# Run app with pre-run tests
# Usage: ./scripts/run_with_tests.sh [flutter_run_args]

set -e  # Exit on error

# Run pre-run checks
./scripts/pre_run.sh

# If checks passed, run the app
echo "🚀 Starting app..."
flutter run "$@"
