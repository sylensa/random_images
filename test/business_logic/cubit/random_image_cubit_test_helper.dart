import 'package:mockito/annotations.dart';
import 'package:random_images/domain/usecases/check_cache_status.dart';
import 'package:random_images/domain/usecases/clear_cache.dart';
import 'package:random_images/domain/usecases/get_cached_image.dart';
import 'package:random_images/domain/usecases/get_random_image.dart';
import 'package:random_images/domain/usecases/refresh_image.dart';

@GenerateMocks([
  GetRandomImage,
  GetCachedImage,
  RefreshImage,
  ClearCache,
  CheckCacheStatus,
])
void main() {}
