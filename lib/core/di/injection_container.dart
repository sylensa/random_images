import 'package:get_it/get_it.dart';
import 'package:random_images/business_logic/cubit/random_image_cubit.dart';
import 'package:random_images/core/network_manager.dart';
import 'package:random_images/data/data_providers/random_image_data.dart';
import 'package:random_images/data/datasources/random_image_local_data_source.dart';
import 'package:random_images/data/datasources/random_image_remote_data_source.dart';
import 'package:random_images/data/repository/random_image_repo.dart';
import 'package:random_images/domain/repositories/random_image_repository.dart';
import 'package:random_images/domain/usecases/check_cache_status.dart';
import 'package:random_images/domain/usecases/clear_cache.dart';
import 'package:random_images/domain/usecases/get_cached_image.dart';
import 'package:random_images/domain/usecases/get_random_image.dart';
import 'package:random_images/domain/usecases/refresh_image.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service locator instance
final sl = GetIt.instance;

/// Initialize all dependencies
/// Call this once at app startup
Future<void> initializeDependencies() async {
  // ============ External Dependencies ============
  // SharedPreferences - must be async
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  // Network Manager - singleton
  sl.registerLazySingleton<NetworkManager>(() => NetworkManager.instance);

  // ============ Data Sources ============
  sl.registerLazySingleton<RandomImageRemoteDataSource>(
    () => RandomImageDataImpl(
      networkManager: sl<NetworkManager>(),
    ),
  );

  sl.registerLazySingleton<RandomImageLocalDataSource>(
    () => RandomImageLocalDataSourceImpl(
      sharedPreferences: sl<SharedPreferences>(),
    ),
  );

  // ============ Repositories ============
  sl.registerLazySingleton<RandomImageRepository>(
    () => RandomImageRepositoryImpl(
      remoteDataSource: sl<RandomImageRemoteDataSource>(),
      localDataSource: sl<RandomImageLocalDataSource>(),
    ),
  );

  // ============ Use Cases ============
  sl.registerLazySingleton<GetRandomImage>(
    () => GetRandomImage(
      repository: sl<RandomImageRepository>(),
    ),
  );

  sl.registerLazySingleton<GetCachedImage>(
    () => GetCachedImage(
      repository: sl<RandomImageRepository>(),
    ),
  );

  sl.registerLazySingleton<RefreshImage>(
    () => RefreshImage(
      repository: sl<RandomImageRepository>(),
    ),
  );

  sl.registerLazySingleton<ClearCache>(
    () => ClearCache(
      repository: sl<RandomImageRepository>(),
    ),
  );

  sl.registerLazySingleton<CheckCacheStatus>(
    () => CheckCacheStatus(
      repository: sl<RandomImageRepository>(),
    ),
  );

  // ============ Cubits ============
  // Factory - creates new instance each time (for multiple screens)
  sl.registerFactory<RandomImageCubit>(
    () => RandomImageCubit(
      getRandomImage: sl<GetRandomImage>(),
      getCachedImage: sl<GetCachedImage>(),
      refreshImage: sl<RefreshImage>(),
      clearCache: sl<ClearCache>(),
      checkCacheStatus: sl<CheckCacheStatus>(),
    ),
  );
}
