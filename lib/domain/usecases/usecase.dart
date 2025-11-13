import 'package:random_images/core/error/either.dart';
import 'package:random_images/core/error/failures.dart';

/// Base use case interface
/// Params can be NoParams if no parameters needed
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

/// Used when use case doesn't need parameters
class NoParams {
  const NoParams();
}
