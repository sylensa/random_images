import 'package:random_images/data/models/random_image_model.dart';

/// Abstract data source interface
abstract class RandomImageRemoteDataSource {
  Future<RandomImageModel> getRandomImage();
}
