import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:random_images/business_logic/cubit/random_image_cubit.dart';
import 'package:random_images/core/error/either.dart';
import 'package:random_images/core/error/failures.dart';
import 'package:random_images/domain/entities/random_image.dart';
import 'package:random_images/domain/usecases/usecase.dart';

import 'random_image_cubit_test_helper.mocks.dart';

void main() {
  late MockGetRandomImage mockGetRandomImage;
  late MockGetCachedImage mockGetCachedImage;
  late MockRefreshImage mockRefreshImage;
  late MockClearCache mockClearCache;
  late MockCheckCacheStatus mockCheckCacheStatus;

  setUp(() {
    mockGetRandomImage = MockGetRandomImage();
    mockGetCachedImage = MockGetCachedImage();
    mockRefreshImage = MockRefreshImage();
    mockClearCache = MockClearCache();
    mockCheckCacheStatus = MockCheckCacheStatus();
  });

  const testImageUrl = 'https://example.com/test-image.jpg';
  const testRandomImage = RandomImage(url: testImageUrl);

  group('RandomImageCubit', () {
    test('initial state should be RandomImageInitial', () {
      // arrange
      final cubit = RandomImageCubit(
        getRandomImage: mockGetRandomImage,
        getCachedImage: mockGetCachedImage,
        refreshImage: mockRefreshImage,
        clearCache: mockClearCache,
        checkCacheStatus: mockCheckCacheStatus,
      );

      // assert
      expect(cubit.state, const RandomImageInitial());
    });

    blocTest<RandomImageCubit, RandomImageState>(
      'emits [Loading, Loaded] when fetchRandomImage is successful',
      build: () {
        when(mockGetRandomImage(any))
            .thenAnswer((_) async => const Right(testRandomImage));
        return RandomImageCubit(
          getRandomImage: mockGetRandomImage,
          getCachedImage: mockGetCachedImage,
          refreshImage: mockRefreshImage,
          clearCache: mockClearCache,
          checkCacheStatus: mockCheckCacheStatus,
        );
      },
      act: (cubit) => cubit.fetchRandomImage(),
      expect: () => const [
        RandomImageLoading(),
        RandomImageLoaded(imageUrl: testImageUrl),
      ],
      verify: (_) {
        verify(mockGetRandomImage(const NoParams()));
      },
    );

    blocTest<RandomImageCubit, RandomImageState>(
      'emits [Loading, Error] when fetchRandomImage fails with NetworkFailure',
      build: () {
        when(mockGetRandomImage(any))
            .thenAnswer((_) async => const Left(NetworkFailure('No internet')));
        return RandomImageCubit(
          getRandomImage: mockGetRandomImage,
          getCachedImage: mockGetCachedImage,
          refreshImage: mockRefreshImage,
          clearCache: mockClearCache,
          checkCacheStatus: mockCheckCacheStatus,
        );
      },
      act: (cubit) => cubit.fetchRandomImage(),
      expect: () => const [
        RandomImageLoading(),
        RandomImageError(errorMessage: 'No internet'),
      ],
    );

    blocTest<RandomImageCubit, RandomImageState>(
      'emits [Loading, Error] when fetchRandomImage fails with ServerFailure',
      build: () {
        when(mockGetRandomImage(any))
            .thenAnswer((_) async => const Left(ServerFailure('Server error')));
        return RandomImageCubit(
          getRandomImage: mockGetRandomImage,
          getCachedImage: mockGetCachedImage,
          refreshImage: mockRefreshImage,
          clearCache: mockClearCache,
          checkCacheStatus: mockCheckCacheStatus,
        );
      },
      act: (cubit) => cubit.fetchRandomImage(),
      expect: () => const [
        RandomImageLoading(),
        RandomImageError(errorMessage: 'Server error'),
      ],
    );

    blocTest<RandomImageCubit, RandomImageState>(
      'emits [Loading, Error] when fetchRandomImage fails with TimeoutFailure',
      build: () {
        when(mockGetRandomImage(any))
            .thenAnswer((_) async => const Left(TimeoutFailure('Timeout')));
        return RandomImageCubit(
          getRandomImage: mockGetRandomImage,
          getCachedImage: mockGetCachedImage,
          refreshImage: mockRefreshImage,
          clearCache: mockClearCache,
          checkCacheStatus: mockCheckCacheStatus,
        );
      },
      act: (cubit) => cubit.fetchRandomImage(),
      expect: () => const [
        RandomImageLoading(),
        RandomImageError(errorMessage: 'Timeout'),
      ],
    );

    blocTest<RandomImageCubit, RandomImageState>(
      'calls GetRandomImage use case when fetchRandomImage is called',
      build: () {
        when(mockGetRandomImage(any))
            .thenAnswer((_) async => const Right(testRandomImage));
        return RandomImageCubit(
          getRandomImage: mockGetRandomImage,
          getCachedImage: mockGetCachedImage,
          refreshImage: mockRefreshImage,
          clearCache: mockClearCache,
          checkCacheStatus: mockCheckCacheStatus,
        );
      },
      act: (cubit) => cubit.fetchRandomImage(),
      verify: (_) {
        verify(mockGetRandomImage(const NoParams())).called(1);
      },
    );

    blocTest<RandomImageCubit, RandomImageState>(
      'emits correct states when fetchRandomImage is called multiple times',
      build: () {
        when(mockGetRandomImage(any))
            .thenAnswer((_) async => const Right(testRandomImage));
        return RandomImageCubit(
          getRandomImage: mockGetRandomImage,
          getCachedImage: mockGetCachedImage,
          refreshImage: mockRefreshImage,
          clearCache: mockClearCache,
          checkCacheStatus: mockCheckCacheStatus,
        );
      },
      act: (cubit) async {
        await cubit.fetchRandomImage();
        await cubit.fetchRandomImage();
      },
      expect: () => const [
        RandomImageLoading(),
        RandomImageLoaded(imageUrl: testImageUrl),
        RandomImageLoading(),
        RandomImageLoaded(imageUrl: testImageUrl),
      ],
      verify: (_) {
        verify(mockGetRandomImage(const NoParams())).called(2);
      },
    );
  });
}
