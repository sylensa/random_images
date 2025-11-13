import 'package:random_images/core/error/either.dart';
import 'package:random_images/core/error/failures.dart';
import 'package:random_images/domain/entities/random_image.dart';

/// Abstract repository interface - defines contract
/// Implementation details are in data layer
abstract class RandomImageRepository {
  /// Get a random image from remote, cache on success
  Future<Either<Failure, RandomImage>> getRandomImage();

  /// Get cached image without making network request
  Future<Either<Failure, RandomImage>> getCachedImage();

  /// Force refresh - fetch new image and update cache
  Future<Either<Failure, RandomImage>> refreshImage();

  /// Clear all cached images
  Future<Either<Failure, bool>> clearCache();

  /// Check if cache exists
  Future<bool> hasCachedImage();
}
