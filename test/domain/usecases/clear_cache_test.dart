import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:random_images/core/error/either.dart';
import 'package:random_images/core/error/failures.dart';
import 'package:random_images/domain/usecases/clear_cache.dart';
import 'package:random_images/domain/usecases/usecase.dart';

import 'get_random_image_test.mocks.dart';

void main() {
  late ClearCache useCase;
  late MockRandomImageRepository mockRepository;

  setUp(() {
    mockRepository = MockRandomImageRepository();
    useCase = ClearCache(repository: mockRepository);
  });

  group('ClearCache', () {
    test('should clear cache successfully', () async {
      // arrange
      when(mockRepository.clearCache())
          .thenAnswer((_) async => const Right(true));

      // act
      final result = await useCase(const NoParams());

      // assert
      expect(result.isRight(), true);
      expect(result.getRight(), true);
      verify(mockRepository.clearCache());
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return failure when clear cache fails', () async {
      // arrange
      const failure = UnknownFailure('Failed to clear cache');
      when(mockRepository.clearCache())
          .thenAnswer((_) async => const Left(failure));

      // act
      final result = await useCase(const NoParams());

      // assert
      expect(result.isLeft(), true);
      expect(result.getLeft(), failure);
    });
  });
}
