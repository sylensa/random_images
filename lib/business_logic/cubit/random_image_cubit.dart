import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:random_images/domain/usecases/check_cache_status.dart';
import 'package:random_images/domain/usecases/clear_cache.dart';
import 'package:random_images/domain/usecases/get_cached_image.dart';
import 'package:random_images/domain/usecases/get_random_image.dart';
import 'package:random_images/domain/usecases/refresh_image.dart';
import 'package:random_images/domain/usecases/usecase.dart';
part 'random_image_state.dart';

/// Cubit with use case dependency injection
/// Follows clean architecture by depending on use cases, not repositories
class RandomImageCubit extends Cubit<RandomImageState> {
  final GetRandomImage getRandomImage;
  final GetCachedImage getCachedImage;
  final RefreshImage refreshImage;
  final ClearCache clearCache;
  final CheckCacheStatus checkCacheStatus;

  RandomImageCubit({
    required this.getRandomImage,
    required this.getCachedImage,
    required this.refreshImage,
    required this.clearCache,
    required this.checkCacheStatus,
  }) : super(const RandomImageInitial());

  /// Fetch a random image (uses cache fallback on error)
  Future<void> fetchRandomImage() async {
    emit(const RandomImageLoading());

    final result = await getRandomImage(const NoParams());

    result.fold(
      (failure) => emit(RandomImageError(errorMessage: failure.message)),
      (randomImage) => emit(RandomImageLoaded(imageUrl: randomImage.url)),
    );
  }

  /// Load cached image without making network request
  Future<void> loadCachedImage() async {
    emit(const RandomImageLoading());

    final result = await getCachedImage(const NoParams());

    result.fold(
      (failure) => emit(RandomImageError(errorMessage: failure.message)),
      (randomImage) => emit(RandomImageLoaded(
        imageUrl: randomImage.url,
        isFromCache: true,
      )),
    );
  }

  /// Force refresh - always fetches from remote
  Future<void> forceRefresh() async {
    emit(const RandomImageLoading());

    final result = await refreshImage(const NoParams());

    result.fold(
      (failure) => emit(RandomImageError(errorMessage: failure.message)),
      (randomImage) => emit(RandomImageLoaded(imageUrl: randomImage.url)),
    );
  }

  /// Clear all cached images
  Future<void> clearImageCache() async {
    final result = await clearCache(const NoParams());

    result.fold(
      (failure) {
        // Optionally emit error, or just ignore
        if (state is RandomImageLoaded) {
          // Keep current state
        } else {
          emit(RandomImageError(errorMessage: failure.message));
        }
      },
      (success) {
        // Cache cleared successfully
        // Could emit a specific state or just stay in current state
      },
    );
  }

  /// Check if cache exists
  Future<bool> hasCachedImage() async {
    return await checkCacheStatus();
  }
}
