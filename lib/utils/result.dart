
sealed class Result<T> {
  const Result();
  const factory Result.ok(T value) = Ok._;
  const factory Result.error(T value) = Error._;
}

class Ok<T> extends Result<T> {
  final T value;

  const Ok._(this.value);
}

class Error<T> extends Result<T> {
  final T value;
  const Error._(this.value);
}