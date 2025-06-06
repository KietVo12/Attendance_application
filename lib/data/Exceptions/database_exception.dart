class CreateDataException implements Exception {
  final String message;
  CreateDataException(this.message);
  @override
  String toString() => 'CreateData Error: $message';
}
class GetDataException implements Exception {
  final String message;
  GetDataException(this.message);
  @override
  String toString() => 'CreateData Error: $message';
}