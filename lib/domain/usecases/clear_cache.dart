import 'package:random_images/core/error/either.dart';
import 'package:random_images/core/error/failures.dart';
import 'package:random_images/domain/repositories/random_image_repository.dart';
import 'package:random_images/domain/usecases/usecase.dart';

/// Use case for clearing cached images
/// Useful for freeing up storage or resetting app state
class ClearCache implements UseCase<bool, NoParams> {
  final RandomImageRepository repository;

  ClearCache({required this.repository});

  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    return await repository.clearCache();
  }
}
