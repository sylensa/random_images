import 'package:random_images/core/error/either.dart';
import 'package:random_images/core/error/failures.dart';
import 'package:random_images/domain/entities/random_image.dart';
import 'package:random_images/domain/repositories/random_image_repository.dart';
import 'package:random_images/domain/usecases/usecase.dart';

/// Use case for getting a random image
/// Encapsulates the business logic of fetching random images
/// Can add additional logic like caching, analytics, etc.
class GetRandomImage implements UseCase<RandomImage, NoParams> {
  final RandomImageRepository repository;

  GetRandomImage({required this.repository});

  @override
  Future<Either<Failure, RandomImage>> call(NoParams params) async {
    return await repository.getRandomImage();
  }
}
