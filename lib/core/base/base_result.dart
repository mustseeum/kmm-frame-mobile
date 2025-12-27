enum ResponseStatus {
  Success,
  Error,
  Unreachable,
  requestCancelled,
  redirection, // For 302 responses
  unprocessableEntity, // For 422 responses
  unauthenticated, // For 401 responses
}

enum ResultStatus { init, loaded, failed }

const String defaultError = 'Unknown error';

class BaseResult<T> {
  final ResponseStatus status;
  final T? data;
  final String errorMessage;
  final T? errData;

  BaseResult(
    this.status,
    this.data, {
    this.errorMessage = defaultError,
    this.errData,
  });

  // Success response
  static BaseResult<T> success<T>(T data) =>
      BaseResult(ResponseStatus.Success, data);

  // General failure response
  static BaseResult<T> failed<T>({
    int? code = -1,
    T? error,
    String? message,
    T? data,
  }) {
    if (code! >= 400 && code < 500) {
      return BaseResult(
        ResponseStatus.Error,
        error,
        errorMessage: message ?? defaultError,
      );
    } else {
      return BaseResult(
        ResponseStatus.Error,
        error,
        errorMessage: message ?? defaultError,
      );
    }
  }

  // Timeout response
  static BaseResult<T> timeout<T>(String? message) => BaseResult(
    ResponseStatus.Unreachable,
    null,
    errorMessage: message ?? defaultError,
  );

  // Request canceled response
  static BaseResult<T> requestCanceled<T>({String? message}) => BaseResult(
    ResponseStatus.requestCancelled,
    null,
    errorMessage: message ?? defaultError,
  );

  // 302 Redirection response
  static BaseResult<T> redirection<T>(String location) => BaseResult(
    ResponseStatus.redirection,
    null,
    errorMessage: 'Redirection to $location',
  );

  // 422 Unprocessable Entity response
  static BaseResult<T> unprocessableEntity<T>(String? message, T? error) =>
      BaseResult(
        ResponseStatus.unprocessableEntity,
        error,
        errorMessage: message ?? 'Unprocessable Entity',
      );

  // 401 Unauthenticated Entity response
  static BaseResult<T> unauthenticated<T>(String? message, T? error) =>
      BaseResult(
        ResponseStatus.unauthenticated,
        error,
        errorMessage: message ?? 'Unauthenticated Entity',
      );
}
