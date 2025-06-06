import 'package:play_ground_app/utils/result.dart';

abstract class Respository<T, KEY_TYPE> {
  Future<Result<List<T>>> getAll();
  Future<Result<List<T>>> getById(KEY_TYPE key);
  Future<Result> create(T item);
  Future<Result<T>> update(KEY_TYPE key, T item);
  Future<Result<T>> delete(KEY_TYPE key);
}