import 'dart:convert';
import 'package:random_images/domain/entities/random_image.dart';

RandomImageModel randomImageModelFromJson(String str) => RandomImageModel.fromJson(json.decode(str));

String randomImageModelToJson(RandomImageModel data) => json.encode(data.toJson());

/// Data model - handles JSON serialization
/// Maps to domain entity
class RandomImageModel {
  final String? url;
  final String? detail;

  const RandomImageModel({
    this.url,
    this.detail,
  });

  factory RandomImageModel.fromJson(Map<String, dynamic> json) => RandomImageModel(
    url: json["url"],
    detail: json["detail"],
  );

  Map<String, dynamic> toJson() => {
    "url": url,
    "detail": detail,
  };

  /// Convert data model to domain entity
  RandomImage toEntity() {
    if (url == null || url!.isEmpty) {
      throw Exception('Invalid image URL');
    }
    return RandomImage(url: url!);
  }
}
