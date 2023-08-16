sealed class Either<E extends Exception, S> {
  const Either();
}

final class Failure<E extends Exception, S> extends Either<E, S> {
  final E exception;

  const Failure(this.exception);
}

final class Success<E extends Exception, S> extends Either<E, S> {
  final S value;

  const Success(this.value);
}
