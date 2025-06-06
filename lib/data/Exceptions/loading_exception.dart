class LoadingException implements Exception {
  final String message;
  LoadingException(this.message);
  @override
  String toString() => 'Lỗi Khi Tải Dữ Liệu';
}