import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:random_images/core/error/either.dart';
import 'package:random_images/core/error/failures.dart';
import 'package:random_images/domain/entities/random_image.dart';
import 'package:random_images/domain/repositories/random_image_repository.dart';
import 'package:random_images/domain/usecases/get_random_image.dart';
import 'package:random_images/domain/usecases/usecase.dart';

import 'get_random_image_test.mocks.dart';

@GenerateMocks([RandomImageRepository])
void main() {
  late GetRandomImage useCase;
  late MockRandomImageRepository mockRepository;

  setUp(() {
    mockRepository = MockRandomImageRepository();
    useCase = GetRandomImage(repository: mockRepository);
  });

  const testImageUrl = 'https://example.com/test-image.jpg';
  const testRandomImage = RandomImage(url: testImageUrl);

  group('GetRandomImage', () {
    test('should get random image from the repository', () async {
      // arrange
      when(mockRepository.getRandomImage())
          .thenAnswer((_) async => const Right(testRandomImage));

      // act
      final result = await useCase(const NoParams());

      // assert
      expect(result.isRight(), true);
      expect(result.getRight(), testRandomImage);
      verify(mockRepository.getRandomImage());
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return NetworkFailure when repository fails with network error',
        () async {
      // arrange
      const failure = NetworkFailure('No internet connection');
      when(mockRepository.getRandomImage())
          .thenAnswer((_) async => const Left(failure));

      // act
      final result = await useCase(const NoParams());

      // assert
      expect(result.isLeft(), true);
      expect(result.getLeft(), failure);
      verify(mockRepository.getRandomImage());
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return ServerFailure when repository fails with server error',
        () async {
      // arrange
      const failure = ServerFailure('Server error');
      when(mockRepository.getRandomImage())
          .thenAnswer((_) async => const Left(failure));

      // act
      final result = await useCase(const NoParams());

      // assert
      expect(result.isLeft(), true);
      expect(result.getLeft(), failure);
      verify(mockRepository.getRandomImage());
    });

    test('should return TimeoutFailure when repository fails with timeout',
        () async {
      // arrange
      const failure = TimeoutFailure('Request timeout');
      when(mockRepository.getRandomImage())
          .thenAnswer((_) async => const Left(failure));

      // act
      final result = await useCase(const NoParams());

      // assert
      expect(result.isLeft(), true);
      expect(result.getLeft(), failure);
      verify(mockRepository.getRandomImage());
    });
  });
}
