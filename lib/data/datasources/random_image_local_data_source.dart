import 'dart:convert';
import 'package:random_images/data/models/random_image_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Abstract local data source for caching
abstract class RandomImageLocalDataSource {
  /// Get last cached image URL
  Future<RandomImageModel?> getLastImage();

  /// Cache an image URL
  Future<void> cacheImage(RandomImageModel model);

  /// Clear all cached images
  Future<void> clearCache();

  /// Check if cache exists
  Future<bool> hasCachedImage();
}

/// Implementation using SharedPreferences for simple caching
class RandomImageLocalDataSourceImpl implements RandomImageLocalDataSource {
  static const String cachedImageKey = 'CACHED_RANDOM_IMAGE';

  final SharedPreferences sharedPreferences;

  RandomImageLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<RandomImageModel?> getLastImage() async {
    try {
      final jsonString = sharedPreferences.getString(cachedImageKey);
      if (jsonString != null) {
        return RandomImageModel.fromJson(jsonDecode(jsonString));
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get cached image');
    }
  }

  @override
  Future<void> cacheImage(RandomImageModel model) async {
    try {
      await sharedPreferences.setString(
        cachedImageKey,
        jsonEncode(model.toJson()),
      );
    } catch (e) {
      throw Exception('Failed to cache image');
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await sharedPreferences.remove(cachedImageKey);
    } catch (e) {
      throw Exception('Failed to clear cache');
    }
  }

  @override
  Future<bool> hasCachedImage() async {
    try {
      return sharedPreferences.containsKey(cachedImageKey);
    } catch (e) {
      return false;
    }
  }
}
