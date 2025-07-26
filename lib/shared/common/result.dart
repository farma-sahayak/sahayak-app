import 'package:mobile/shared/common/error.dart';

class Result<T> {
  final T? data;
  final AppError? error;

  const Result.success(this.data) : error = null;
  const Result.failure(this.error) : data = null;

  bool get isSuccess => error == null;
  bool get isFailure => error != null;

  @override
  String toString() {
    return 'Result(data: $data, error: $error)';
  }
}
