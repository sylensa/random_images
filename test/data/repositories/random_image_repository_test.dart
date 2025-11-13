import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:random_images/core/error/either.dart';
import 'package:random_images/core/error/failures.dart';
import 'package:random_images/data/datasources/random_image_local_data_source.dart';
import 'package:random_images/data/datasources/random_image_remote_data_source.dart';
import 'package:random_images/data/models/random_image_model.dart';
import 'package:random_images/data/repository/random_image_repo.dart';
import 'package:random_images/domain/entities/random_image.dart';

import 'random_image_repository_test.mocks.dart';

@GenerateMocks([RandomImageRemoteDataSource, RandomImageLocalDataSource])
void main() {
  late RandomImageRepositoryImpl repository;
  late MockRandomImageRemoteDataSource mockRemoteDataSource;
  late MockRandomImageLocalDataSource mockLocalDataSource;

  setUp(() {
    mockRemoteDataSource = MockRandomImageRemoteDataSource();
    mockLocalDataSource = MockRandomImageLocalDataSource();
    repository = RandomImageRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
    );
  });

  const testImageUrl = 'https://example.com/test-image.jpg';
  const testModel = RandomImageModel(url: testImageUrl);
  const testEntity = RandomImage(url: testImageUrl);

  group('getRandomImage', () {
    test('should return RandomImage when remote call is successful', () async {
      // arrange
      when(mockRemoteDataSource.getRandomImage())
          .thenAnswer((_) async => testModel);
      when(mockLocalDataSource.cacheImage(any))
          .thenAnswer((_) async => Future.value());

      // act
      final result = await repository.getRandomImage();

      // assert
      expect(result.isRight(), true);
      expect(result.getRight(), testEntity);
      verify(mockRemoteDataSource.getRandomImage());
      verify(mockLocalDataSource.cacheImage(testModel));
    });

    test('should cache data when remote call is successful', () async {
      // arrange
      when(mockRemoteDataSource.getRandomImage())
          .thenAnswer((_) async => testModel);
      when(mockLocalDataSource.cacheImage(any))
          .thenAnswer((_) async => Future.value());

      // act
      await repository.getRandomImage();

      // assert
      verify(mockLocalDataSource.cacheImage(testModel));
    });

    test('should return NetworkFailure when SocketException occurs', () async {
      // arrange
      when(mockRemoteDataSource.getRandomImage()).thenThrow(SocketException(''));
      when(mockLocalDataSource.getLastImage()).thenAnswer((_) async => null);

      // act
      final result = await repository.getRandomImage();

      // assert
      expect(result.isLeft(), true);
      expect(result.getLeft(), isA<NetworkFailure>());
      verify(mockRemoteDataSource.getRandomImage());
    });

    test('should return cached data when SocketException occurs and cache exists',
        () async {
      // arrange
      when(mockRemoteDataSource.getRandomImage()).thenThrow(SocketException(''));
      when(mockLocalDataSource.getLastImage())
          .thenAnswer((_) async => testModel);

      // act
      final result = await repository.getRandomImage();

      // assert
      expect(result.isRight(), true);
      expect(result.getRight(), testEntity);
      verify(mockRemoteDataSource.getRandomImage());
      verify(mockLocalDataSource.getLastImage());
    });

    test('should return ServerFailure when remote returns server error',
        () async {
      // arrange
      when(mockRemoteDataSource.getRandomImage())
          .thenThrow(Exception('Server error: 500'));
      when(mockLocalDataSource.getLastImage()).thenAnswer((_) async => null);

      // act
      final result = await repository.getRandomImage();

      // assert
      expect(result.isLeft(), true);
      expect(result.getLeft(), isA<ServerFailure>());
    });

    test('should return cached data when server error occurs and cache exists',
        () async {
      // arrange
      when(mockRemoteDataSource.getRandomImage())
          .thenThrow(Exception('Server error: 500'));
      when(mockLocalDataSource.getLastImage())
          .thenAnswer((_) async => testModel);

      // act
      final result = await repository.getRandomImage();

      // assert
      expect(result.isRight(), true);
      expect(result.getRight(), testEntity);
      verify(mockLocalDataSource.getLastImage());
    });
  });
}
