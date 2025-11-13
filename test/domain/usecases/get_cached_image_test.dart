import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:random_images/core/error/either.dart';
import 'package:random_images/core/error/failures.dart';
import 'package:random_images/domain/entities/random_image.dart';
import 'package:random_images/domain/usecases/get_cached_image.dart';
import 'package:random_images/domain/usecases/usecase.dart';

import 'get_random_image_test.mocks.dart';

void main() {
  late GetCachedImage useCase;
  late MockRandomImageRepository mockRepository;

  setUp(() {
    mockRepository = MockRandomImageRepository();
    useCase = GetCachedImage(repository: mockRepository);
  });

  const testImageUrl = 'https://example.com/cached-image.jpg';
  const testRandomImage = RandomImage(url: testImageUrl);

  group('GetCachedImage', () {
    test('should get cached image from repository without network call', () async {
      // arrange
      when(mockRepository.getCachedImage())
          .thenAnswer((_) async => const Right(testRandomImage));

      // act
      final result = await useCase(const NoParams());

      // assert
      expect(result.isRight(), true);
      expect(result.getRight(), testRandomImage);
      verify(mockRepository.getCachedImage());
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return failure when no cache exists', () async {
      // arrange
      const failure = UnknownFailure('No cached image found');
      when(mockRepository.getCachedImage())
          .thenAnswer((_) async => const Left(failure));

      // act
      final result = await useCase(const NoParams());

      // assert
      expect(result.isLeft(), true);
      expect(result.getLeft(), failure);
    });
  });
}
