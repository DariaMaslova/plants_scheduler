abstract class Result<T> {
  Result();

  factory Result.success(T data) {
    return _Success(data);
  }

  factory Result.failure({code, message}) {
    return _Failure(
      code: code,
      message: message
    );
  }

  onSuccess(Function(T) lambda);
  onError(Function(int, String) lambda);
  Result<R> map<R>(R Function(T) mapper);
}

class _Success<T> extends Result<T> {
  final T data;

  _Success(this.data);

  @override
  onSuccess(Function(T p1) lambda) {
    lambda.call(data);
  }

  @override
  onError(Function(int p1, String p2) lambda) {
  }

  @override
  Result<R> map<R>(R Function(T p1) mapper) {
    return Result.success(mapper.call(data));
  }
}

class _Failure<T> extends Result<T> {
  final int code;
  final String message;

  _Failure({this.code, this.message});

  @override
  onSuccess(Function(T p1) lambda) {
  }

  @override
  onError(Function(int p1, String p2) lambda) {
    lambda.call(code, message);
  }

  @override
  Result<R> map<R>(R Function(T p1) mapper) {
    return Result.failure(
      code: code,
      message: message,
    );
  }
}