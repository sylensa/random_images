import 'dart:async';
import 'dart:io';
import 'package:random_images/core/error/either.dart';
import 'package:random_images/core/error/failures.dart';
import 'package:random_images/data/datasources/random_image_local_data_source.dart';
import 'package:random_images/data/datasources/random_image_remote_data_source.dart';
import 'package:random_images/domain/entities/random_image.dart';
import 'package:random_images/domain/repositories/random_image_repository.dart';

/// Repository implementation with offline-first caching
/// Tries remote first, falls back to cache on error
class RandomImageRepositoryImpl implements RandomImageRepository {
  final RandomImageRemoteDataSource remoteDataSource;
  final RandomImageLocalDataSource localDataSource;

  RandomImageRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, RandomImage>> getRandomImage() async {
    try {
      // Try to fetch from remote
      final model = await remoteDataSource.getRandomImage();

      // Cache the successful response
      await localDataSource.cacheImage(model);

      final entity = model.toEntity();
      return Right(entity);
    } on TimeoutException {
      // On timeout, try to return cached data
      return await _getCachedImageOr(
        const TimeoutFailure('Request timeout. Please try again.'),
      );
    } on SocketException {
      // On network error, try to return cached data
      return await _getCachedImageOr(
        const NetworkFailure('No internet connection. Please check your network.'),
      );
    } on Exception catch (e) {
      if (e.toString().contains('Server error')) {
        return await _getCachedImageOr(ServerFailure(e.toString()));
      } else if (e.toString().contains('Client error') ||
          e.toString().contains('not found')) {
        return await _getCachedImageOr(ServerFailure(e.toString()));
      } else {
        return await _getCachedImageOr(
          const UnknownFailure('Something went wrong. Please try again.'),
        );
      }
    } catch (e) {
      return await _getCachedImageOr(
        UnknownFailure('Unexpected error: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, RandomImage>> getCachedImage() async {
    try {
      final cachedModel = await localDataSource.getLastImage();
      if (cachedModel != null && cachedModel.url != null) {
        return Right(cachedModel.toEntity());
      }
      return const Left(UnknownFailure('No cached image found'));
    } catch (e) {
      return Left(UnknownFailure('Failed to get cached image: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, RandomImage>> refreshImage() async {
    // Same as getRandomImage - always fetches from remote
    return await getRandomImage();
  }

  @override
  Future<Either<Failure, bool>> clearCache() async {
    try {
      await localDataSource.clearCache();
      return const Right(true);
    } catch (e) {
      return Left(UnknownFailure('Failed to clear cache: ${e.toString()}'));
    }
  }

  @override
  Future<bool> hasCachedImage() async {
    try {
      return await localDataSource.hasCachedImage();
    } catch (_) {
      return false;
    }
  }

  /// Helper method to get cached image or return failure
  Future<Either<Failure, RandomImage>> _getCachedImageOr(Failure failure) async {
    try {
      final cachedModel = await localDataSource.getLastImage();
      if (cachedModel != null && cachedModel.url != null) {
        return Right(cachedModel.toEntity());
      }
      return Left(failure);
    } catch (_) {
      return Left(failure);
    }
  }
}
