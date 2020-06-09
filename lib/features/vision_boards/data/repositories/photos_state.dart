class PhotosState<T> {
  PhotosState._();
  factory PhotosState.success(T value) = SuccessState<T>;
  factory PhotosState.error(T msg) = ErrorState<T>;
}

class ErrorState<T> extends PhotosState<T> {
  ErrorState(this.msg) : super._();
  final T msg;
}

class SuccessState<T> extends PhotosState<T> {
  SuccessState(this.value) : super._();
  final T value;
}
