enum ApiStatus { loading, success, error, none }

abstract class ApiStatusInterface {
  ApiStatus get apiStatus;
}

class Status<T> implements ApiStatusInterface {
  @override
  final ApiStatus apiStatus;
  final T? data;
  final Object? exception;
  const Status({required this.apiStatus, this.data, this.exception});
  factory Status.success({required T data}) {
    return Status<T>(apiStatus: ApiStatus.success, data: data);
  }
  factory Status.error({Object? exception, T? data}) {
    return Status<T>(
        apiStatus: ApiStatus.error, exception: exception, data: data);
  }
  factory Status.loading({T? data}) {
    return Status<T>(apiStatus: ApiStatus.loading, data: data);
  }
  factory Status.none() {
    return Status<T>(apiStatus: ApiStatus.none);
  }
}
