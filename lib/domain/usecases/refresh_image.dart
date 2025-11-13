import 'package:random_images/core/error/either.dart';
import 'package:random_images/core/error/failures.dart';
import 'package:random_images/domain/entities/random_image.dart';
import 'package:random_images/domain/repositories/random_image_repository.dart';
import 'package:random_images/domain/usecases/usecase.dart';

/// Use case for force refreshing image
/// Bypasses cache and always fetches from remote
/// Useful for pull-to-refresh functionality
class RefreshImage implements UseCase<RandomImage, NoParams> {
  final RandomImageRepository repository;

  RefreshImage({required this.repository});

  @override
  Future<Either<Failure, RandomImage>> call(NoParams params) async {
    return await repository.refreshImage();
  }
}
