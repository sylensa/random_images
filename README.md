# Random Images App

A production-ready Flutter application demonstrating **Clean Architecture** principles with comprehensive testing and offline-first capabilities.

## Features

- ✅ Single screen UI with centered square images
- ✅ Dynamic background color extraction from images
- ✅ Loading states with smooth animations
- ✅ Error handling with graceful fallbacks
- ✅ Light/Dark mode support
- ✅ Accessibility features
- ✅ **Offline-first architecture** with caching
- ✅ **Clean Architecture** with proper layer separation
- ✅ **Dependency Injection** using get_it
- ✅ **Comprehensive unit tests** (18 tests passing)

## Architecture

This project follows **Clean Architecture** with clear separation of concerns. See [ARCHITECTURE.md](ARCHITECTURE.md) for detailed documentation.

```
Presentation → Business Logic → Domain ← Data
     ↓              ↓              ↑        ↑
   UI Logic    State Mgmt    Use Cases  Repository
```

### Key Components

- **Domain Layer**: Pure Dart entities, use cases, and repository interfaces
- **Data Layer**: Repository implementations, data sources (remote/local), models
- **Business Logic Layer**: Cubits with dependency injection
- **Presentation Layer**: UI, widgets, presentation models

## Testing

✅ **18 tests passing** covering:
- Domain layer (use cases)
- Data layer (repositories)
- Business logic (cubits)

```bash
flutter test                    # Run all tests
flutter test --coverage         # Run with coverage
```

## Dependencies

### Production
- `get_it` - Dependency injection
- `flutter_bloc` - State management
- `equatable` - Value equality
- `cached_network_image` - Image caching
- `palette_generator_master` - Color extraction

### Dev
- `mockito` - Mocking framework
- `bloc_test` - Cubit testing
- `build_runner` - Code generation

## Getting Started

```bash
# Install dependencies
flutter pub get

# Run the app
flutter run

# Run tests
flutter test

# Build release
flutter build apk --release
```

## Clean Architecture Benefits

1. **Testable**: Easy to mock and test each layer
2. **Maintainable**: Clear separation of concerns
3. **Scalable**: Add features without breaking existing code
4. **Independent**: Business logic independent of frameworks
5. **Offline Support**: Automatic caching with fallbacks

## Documentation

- [ARCHITECTURE.md](ARCHITECTURE.md) - Detailed architecture guide
- [test/](test/) - Test examples

---

**Built with** ❤️ **using Flutter and Clean Architecture**
