# Clean Architecture Documentation

## Overview
This project follows **Clean Architecture** principles with clear separation of concerns across three main layers:

```
┌─────────────────────────────────────────┐
│         Presentation Layer              │  ← UI, Widgets, State Management
│  (Flutter/Material, BLoC/Cubit)        │
└──────────────┬──────────────────────────┘
               │ depends on ↓
┌──────────────▼──────────────────────────┐
│         Domain Layer                    │  ← Business Logic, Entities
│  (Pure Dart - No Framework)            │  ← Repository Interfaces
└──────────────┬──────────────────────────┘
               │ implemented by ↓
┌──────────────▼──────────────────────────┐
│         Data Layer                      │  ← Repository Implementations
│  (Models, Data Sources, API)           │  ← External Data Handling
└─────────────────────────────────────────┘
```

## Project Structure

```
lib/
├── domain/                          # Business Logic Layer (Pure Dart)
│   ├── entities/
│   │   └── random_image.dart       # Domain entity (framework-agnostic)
│   └── repositories/
│       └── random_image_repository.dart  # Repository interface
│
├── data/                            # Data Layer
│   ├── models/
│   │   └── random_image_model.dart # Data model (JSON serialization)
│   ├── datasources/
│   │   └── random_image_remote_data_source.dart  # Data source interface
│   ├── data_providers/
│   │   └── random_image_data.dart  # Data source implementation
│   └── repository/
│       └── random_image_repo.dart  # Repository implementation
│
├── business_logic/                  # State Management
│   └── cubit/
│       ├── random_image_cubit.dart # Cubit with DI
│       └── random_image_state.dart # States (extends Equatable)
│
├── presentation/                    # Presentation Layer
│   ├── models/
│   │   └── image_presentation_model.dart  # UI-specific models
│   ├── home/
│   │   └── home_screen.dart        # UI screens
│   └── widget/
│       ├── global_button.dart
│       └── image_loading.dart
│
└── core/                            # Shared Infrastructure
    ├── error/
    │   ├── failures.dart           # Failure types
    │   └── either.dart             # Either monad for error handling
    ├── network_manager.dart
    └── api_constant.dart
```

## Layer Responsibilities

### 1. Domain Layer (Pure Dart)
**Location:** `lib/domain/`

**Characteristics:**
- No Flutter dependencies
- No external package dependencies (except Equatable for value comparison)
- Contains business logic and rules
- Framework-agnostic

**Components:**

#### Entities (`domain/entities/`)
```dart
class RandomImage extends Equatable {
  final String url;
  const RandomImage({required this.url});
}
```
- Pure business objects
- Immutable
- No serialization logic

#### Repository Interfaces (`domain/repositories/`)
```dart
abstract class RandomImageRepository {
  Future<Either<Failure, RandomImage>> getRandomImage();
}
```
- Defines contracts
- Implementation details hidden
- Returns Either<Failure, Success> for error handling

### 2. Data Layer
**Location:** `lib/data/`

**Responsibilities:**
- Implements repository interfaces
- Handles API calls and data sources
- JSON serialization/deserialization
- Error handling and mapping

**Components:**

#### Models (`data/models/`)
```dart
class RandomImageModel {
  final String? url;

  factory RandomImageModel.fromJson(Map<String, dynamic> json);
  RandomImage toEntity();  // Converts to domain entity
}
```
- Handles JSON mapping
- Nullable fields (API might fail)
- Converts to domain entities

#### Data Sources (`data/datasources/` & `data/data_providers/`)
```dart
abstract class RandomImageRemoteDataSource {
  Future<RandomImageModel> getRandomImage();
}

class RandomImageDataImpl implements RandomImageRemoteDataSource {
  final NetworkManager networkManager;
  // Implementation with proper HTTP status code handling
}
```

#### Repository Implementation (`data/repository/`)
```dart
class RandomImageRepositoryImpl implements RandomImageRepository {
  final RandomImageRemoteDataSource remoteDataSource;

  @override
  Future<Either<Failure, RandomImage>> getRandomImage() async {
    try {
      final model = await remoteDataSource.getRandomImage();
      return Right(model.toEntity());
    } on TimeoutException {
      return Left(TimeoutFailure(...));
    } on SocketException {
      return Left(NetworkFailure(...));
    }
  }
}
```

### 3. Business Logic Layer
**Location:** `lib/business_logic/`

**Components:**

#### Cubit with Dependency Injection
```dart
class RandomImageCubit extends Cubit<RandomImageState> {
  final RandomImageRepository repository;  // ✓ Injected dependency

  RandomImageCubit({required this.repository}) : super(RandomImageInitial());

  Future<void> getRandomImage() async {
    emit(RandomImageLoading());
    final result = await repository.getRandomImage();
    result.fold(
      (failure) => emit(RandomImageError(errorMessage: failure.message)),
      (image) => emit(RandomImageLoaded(imageUrl: image.url)),
    );
  }
}
```

#### States (Equatable)
```dart
abstract class RandomImageState extends Equatable {
  const RandomImageState();
}

class RandomImageLoaded extends RandomImageState {
  final String imageUrl;
  const RandomImageLoaded({required this.imageUrl});

  @override
  List<Object?> get props => [imageUrl];
}
```

### 4. Presentation Layer
**Location:** `lib/presentation/`

**Responsibilities:**
- UI rendering
- User interaction
- UI-specific concerns (colors, animations)
- Widget composition

**Key Principles:**
- Color extraction happens in presentation layer (not in Cubit)
- Uses BlocListener + BlocBuilder pattern
- Presentation models for UI-specific data

```dart
class ImagePresentationModel {
  final String imageUrl;
  final Color? backgroundColor;  // ✓ UI concern in presentation layer
}
```

## Dependency Injection

**Location:** `lib/main.dart`

```dart
void _setupDependencies() {
  // Data Source
  final dataSource = RandomImageDataImpl(
    networkManager: NetworkManager.instance,
  );

  // Repository
  final repository = RandomImageRepositoryImpl(
    remoteDataSource: dataSource,
  );

  // Cubit with injected repository
  BlocProvider<RandomImageCubit>(
    create: (context) => RandomImageCubit(repository: repository),
  );
}
```

**Benefits:**
- Easy testing (mock dependencies)
- Loose coupling
- Single Responsibility Principle
- Dependency Inversion Principle

## Error Handling

### Either Monad Pattern
```dart
abstract class Either<L, R> {
  T fold<T>(T Function(L) onLeft, T Function(R) onRight);
}

// Usage
result.fold(
  (failure) => handleError(failure),
  (success) => handleSuccess(success),
);
```

### Failure Hierarchy
```dart
abstract class Failure {
  final String message;
}

class NetworkFailure extends Failure {}
class ServerFailure extends Failure {}
class TimeoutFailure extends Failure {}
```

## Key Improvements from Previous Architecture

### Before (Violations):
❌ Model contained Flutter `Color` type
❌ Cubit extracted colors (UI concern)
❌ Direct instantiation: `RandomImageRepo randomImageRepo = RandomImageRepo()`
❌ Repository returned nullable without error info
❌ No abstractions between layers
❌ States didn't extend Equatable

### After (Clean Architecture):
✅ Domain entities are framework-agnostic
✅ Color extraction in presentation layer
✅ Dependency injection throughout
✅ Either<Failure, Success> error handling
✅ Abstract interfaces with implementations
✅ States extend Equatable for efficient comparison
✅ Proper separation of concerns

## Testing Strategy

### Unit Tests (Domain Layer)
```dart
test('RandomImage entity equality', () {
  final image1 = RandomImage(url: 'test.jpg');
  final image2 = RandomImage(url: 'test.jpg');
  expect(image1, equals(image2));
});
```

### Repository Tests (Data Layer)
```dart
test('getRandomImage returns Right on success', () async {
  // Arrange
  final mockDataSource = MockRandomImageRemoteDataSource();
  final repository = RandomImageRepositoryImpl(remoteDataSource: mockDataSource);

  // Act
  final result = await repository.getRandomImage();

  // Assert
  expect(result.isRight(), true);
});
```

### Cubit Tests (Business Logic)
```dart
blocTest<RandomImageCubit, RandomImageState>(
  'emits [Loading, Loaded] when getRandomImage succeeds',
  build: () => RandomImageCubit(repository: mockRepository),
  act: (cubit) => cubit.getRandomImage(),
  expect: () => [
    RandomImageLoading(),
    RandomImageLoaded(imageUrl: 'test.jpg'),
  ],
);
```

## Dependency Flow

```
HomeScreen → RandomImageCubit → RandomImageRepository → RemoteDataSource → NetworkManager
   (UI)         (State Mgmt)         (Interface)           (Implementation)      (HTTP)
```

**Key Rule:** Dependencies point inward
- Presentation depends on Domain
- Data implements Domain interfaces
- Domain depends on nothing

## Benefits Achieved

1. **Testability**: Easy to mock dependencies
2. **Maintainability**: Clear separation of concerns
3. **Scalability**: Easy to add features without affecting existing code
4. **Independence**: Business logic independent of frameworks
5. **Flexibility**: Easy to swap implementations (e.g., switch from HTTP to GraphQL)

## Next Steps for Scaling

1. Add use cases layer between Cubit and Repository
2. Implement `get_it` or `injectable` for DI
3. Add unit/integration tests
4. Implement local caching (add local data source)
5. Add data transformation use cases
6. Implement repository pattern for other features

---

**Note:** For small projects, this might seem like over-engineering. However, as the app grows, this architecture ensures maintainability and testability at scale.
