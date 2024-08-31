enum ApiStatus { loading, success, error, none }

class Status<T> {
  final ApiStatus apiStatus;
  final T? data;
  final Object? exception;
  Status({required this.apiStatus, this.data, this.exception});
  factory Status.success({required T data}) {
    return Status<T>(apiStatus: ApiStatus.success, data: data);
  }
  factory Status.error({
    Object? exception,
  }) {
    return Status<T>(
      apiStatus: ApiStatus.error,
      exception: exception,
    );
  }
  factory Status.loading() {
    return Status<T>(
      apiStatus: ApiStatus.loading,
    );
  }
  factory Status.none() {
    return Status<T>(apiStatus: ApiStatus.none);
  }
}
