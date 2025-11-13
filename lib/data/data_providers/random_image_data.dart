import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:random_images/core/api_constant.dart';
import 'package:random_images/core/network_manager.dart';
import 'package:random_images/data/datasources/random_image_remote_data_source.dart';
import 'package:random_images/data/models/random_image_model.dart';

/// Implementation of remote data source
class RandomImageDataImpl implements RandomImageRemoteDataSource {
  final NetworkManager networkManager;

  RandomImageDataImpl({required this.networkManager});

  @override
  Future<RandomImageModel> getRandomImage() async {
    final response = await networkManager.request(
      NetworkRequestType.get,
      endpoint: APIConst.GET_RANDOM_IMAGE,
    );

    if (response == null) {
      throw Exception('No response from server');
    }

    if (response.statusCode == 200) {
      return RandomImageModel.fromJson(jsonDecode(response.body));
    } else if (response.statusCode >= 500) {
      throw Exception('Server error: ${response.statusCode}');
    } else if (response.statusCode == 404) {
      throw Exception('Image not found');
    } else if (response.statusCode >= 400) {
      throw Exception('Client error: ${response.statusCode}');
    } else {
      throw Exception('Unexpected error: ${response.statusCode}');
    }
  }
}

