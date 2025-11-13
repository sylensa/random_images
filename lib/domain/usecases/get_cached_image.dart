import 'package:random_images/core/error/either.dart';
import 'package:random_images/core/error/failures.dart';
import 'package:random_images/domain/entities/random_image.dart';
import 'package:random_images/domain/repositories/random_image_repository.dart';
import 'package:random_images/domain/usecases/usecase.dart';

/// Use case for getting cached image without network request
/// Useful for offline mode or quick app startup
class GetCachedImage implements UseCase<RandomImage, NoParams> {
  final RandomImageRepository repository;

  GetCachedImage({required this.repository});

  @override
  Future<Either<Failure, RandomImage>> call(NoParams params) async {
    return await repository.getCachedImage();
  }
}
