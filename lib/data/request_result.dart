class RequestResult<T> {
  final bool success;
  final T data;
  final AppointWebserviceError error;
  final int statusCode;

  RequestResult({
    this.success,
    this.data,
    this.error,
    this.statusCode,
  });

  factory RequestResult.success(T data) =>
      RequestResult(success: true, data: data, statusCode: 200);

  factory RequestResult.failed(AppointWebserviceError error, int statusCode) =>
      RequestResult(success: false, error: error, statusCode: statusCode);
}

class AppointWebserviceError {
  final String error;
  final String errorDescription;

  AppointWebserviceError({
    this.error,
    this.errorDescription,
  });

  AppointWebserviceError.fromJson(Map<String, dynamic> json)
      : error = json['error'] ?? json['message'],
        errorDescription = json['error_description'];
}
