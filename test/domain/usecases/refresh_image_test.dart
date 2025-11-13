import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:random_images/core/error/either.dart';
import 'package:random_images/core/error/failures.dart';
import 'package:random_images/domain/entities/random_image.dart';
import 'package:random_images/domain/usecases/refresh_image.dart';
import 'package:random_images/domain/usecases/usecase.dart';

import 'get_random_image_test.mocks.dart';

void main() {
  late RefreshImage useCase;
  late MockRandomImageRepository mockRepository;

  setUp(() {
    mockRepository = MockRandomImageRepository();
    useCase = RefreshImage(repository: mockRepository);
  });

  const testImageUrl = 'https://example.com/fresh-image.jpg';
  const testRandomImage = RandomImage(url: testImageUrl);

  group('RefreshImage', () {
    test('should force refresh image from remote', () async {
      // arrange
      when(mockRepository.refreshImage())
          .thenAnswer((_) async => const Right(testRandomImage));

      // act
      final result = await useCase(const NoParams());

      // assert
      expect(result.isRight(), true);
      expect(result.getRight(), testRandomImage);
      verify(mockRepository.refreshImage());
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return failure when refresh fails', () async {
      // arrange
      const failure = NetworkFailure('No internet connection');
      when(mockRepository.refreshImage())
          .thenAnswer((_) async => const Left(failure));

      // act
      final result = await useCase(const NoParams());

      // assert
      expect(result.isLeft(), true);
      expect(result.getLeft(), failure);
    });
  });
}
