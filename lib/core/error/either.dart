/// Functional programming Either type for error handling
/// Left represents failure, Right represents success
abstract class Either<L, R> {
  const Either();

  bool isLeft() => this is Left<L, R>;
  bool isRight() => this is Right<L, R>;

  L? getLeft() => isLeft() ? (this as Left<L, R>).value : null;
  R? getRight() => isRight() ? (this as Right<L, R>).value : null;

  T fold<T>(T Function(L) onLeft, T Function(R) onRight) {
    if (this is Left<L, R>) {
      return onLeft((this as Left<L, R>).value);
    } else {
      return onRight((this as Right<L, R>).value);
    }
  }
}

class Left<L, R> extends Either<L, R> {
  final L value;
  const Left(this.value);
}

class Right<L, R> extends Either<L, R> {
  final R value;
  const Right(this.value);
}
