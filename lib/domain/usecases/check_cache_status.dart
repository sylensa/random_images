import 'package:random_images/domain/repositories/random_image_repository.dart';

/// Use case for checking if cached image exists
/// Useful for showing cache status in UI or deciding initial load strategy
class CheckCacheStatus {
  final RandomImageRepository repository;

  CheckCacheStatus({required this.repository});

  Future<bool> call() async {
    return await repository.hasCachedImage();
  }
}
