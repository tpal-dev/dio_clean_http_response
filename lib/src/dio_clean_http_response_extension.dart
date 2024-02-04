import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:dio_clean_http_response/dio_clean_http_response.dart';
import 'package:dio_clean_http_response/src/utils/error_handler.dart';

/// An extension on `Future<Response>` providing methods for handling Dio HTTP responses and converting them
/// into [Either<HttpFailure, TModel>] or [Either<HttpFailure, List<TModel>] types.
extension HttpResponseDioExtension on Future<Response> {
  /// Converts a Dio HTTP response into an [Either<HttpFailure, TModel>] type using a custom `fromJson` method.
  ///
  /// Usage:
  /// ```dart
  /// final httpClient = Dio(
  ///   BaseOptions(
  ///     baseUrl: 'https://example.com/api',
  ///   ),
  /// );
  ///
  /// final yourModelOrFailure = await httpClient.get('/data/1').fromJson(YourModel.fromJson);
  ///
  /// yourModelOrFailure.fold(
  ///   (failure) => print(failure.message()),
  ///   (yourModel) => print(yourModel),
  /// );
  /// ```
  ///
  /// Full example:
  /// ```dart
  /// import 'package:dio/dio.dart';
  /// import 'package:dio_clean_http_response/src/dio_clean_http_response_extension.dart';
  ///
  /// class PostModel {
  ///   final int id;
  ///   final int userId;
  ///   final String title;
  ///   final String body;
  ///
  ///   const PostModel({
  ///     required this.id,
  ///     required this.userId,
  ///     required this.title,
  ///     required this.body,
  ///   });
  ///
  ///   factory PostModel.fromJson(Map<String, dynamic> json) {
  ///     return PostModel(
  ///       id: json["id"] as int,
  ///       userId: json["userId"] as int,
  ///       title: json["title"] as String,
  ///       body: json["body"] as String,
  ///     );
  ///   }
  ///
  ///   @override
  ///   String toString() => '🟩\nPOST $id \nuserId: $userId \ntitle: $title \nbody:$body\n';
  /// }
  ///
  /// void main() async {
  ///   final httpClient = Dio(
  ///     BaseOptions(
  ///       baseUrl: 'https://jsonplaceholder.typicode.com',
  ///     ),
  ///   );
  ///
  ///   final postModelOrFailure = await httpClient.get('/posts/1').fromJson(PostModel.fromJson);
  ///
  ///   postModelOrFailure.fold(
  ///     (failure) => print(failure.message()),
  ///     (postModel) => print(postModel),
  ///   );
  ///
  ///   final postModelsListOrFailure = await httpClient.get('/posts').fromJsonAsList(PostModel.fromJson);
  ///
  ///   postModelsListOrFailure.fold(
  ///     (failure) => print(failure.message()),
  ///     (postModelsList) => print(postModelsList),
  ///   );
  /// }
  /// ```
  Future<Either<HttpFailure, TModel>> fromJson<TModel>(
    TModel Function(Map<String, dynamic>) fromJson,
  ) async {
    return (await ErrorHandler.dioHttpResponse(this)).fold(
      (httpFailure) => Left(httpFailure),
      (response) {
        try {
          return Right(fromJson(response.data));
        } catch (error, stackTrace) {
          return Left(HttpFailure.unableToProcessData(error, stackTrace));
        }
      },
    );
  }

  /// Converts a Dio HTTP response into an [Either<HttpFailure, List<TModel>>] type using a custom `fromJsonAsList` method.
  ///
  /// Usage:
  /// ```dart
  /// final httpClient = Dio(
  ///   BaseOptions(
  ///     baseUrl: 'https://example.com/api',
  ///   ),
  /// );
  ///
  /// final yourModelsListOrFailure = await httpClient.get('/data').fromJsonAsList(YourModel.fromJson);
  ///
  /// yourModelsListOrFailure.fold(
  ///   (failure) => print(failure.message()),
  ///   (yourModelsList) => print(yourModelsList),
  /// );
  /// ```
  ///
  /// Full example:
  /// ```dart
  /// import 'package:dio/dio.dart';
  /// import 'package:dio_clean_http_response/src/dio_clean_http_response_extension.dart';
  ///
  /// class PostModel {
  ///   final int id;
  ///   final int userId;
  ///   final String title;
  ///   final String body;
  ///
  ///   const PostModel({
  ///     required this.id,
  ///     required this.userId,
  ///     required this.title,
  ///     required this.body,
  ///   });
  ///
  ///   factory PostModel.fromJson(Map<String, dynamic> json) {
  ///     return PostModel(
  ///       id: json["id"] as int,
  ///       userId: json["userId"] as int,
  ///       title: json["title"] as String,
  ///       body: json["body"] as String,
  ///     );
  ///   }
  ///
  ///   @override
  ///   String toString() => '🟩\nPOST $id \nuserId: $userId \ntitle: $title \nbody:$body\n';
  /// }
  ///
  /// void main() async {
  ///   final httpClient = Dio(
  ///     BaseOptions(
  ///       baseUrl: 'https://jsonplaceholder.typicode.com',
  ///     ),
  ///   );
  ///
  ///   final postModelOrFailure = await httpClient.get('/posts/1').fromJson(PostModel.fromJson);
  ///
  ///   postModelOrFailure.fold(
  ///     (failure) => print(failure.message()),
  ///     (postModel) => print(postModel),
  ///   );
  ///
  ///   final postModelsListOrFailure = await httpClient.get('/posts').fromJsonAsList(PostModel.fromJson);
  ///
  ///   postModelsListOrFailure.fold(
  ///     (failure) => print(failure.message()),
  ///     (postModelsList) => print(postModelsList),
  ///   );
  /// }
  /// ```
  Future<Either<HttpFailure, List<TModel>>> fromJsonAsList<TModel>(
    TModel Function(Map<String, dynamic>) fromJson,
  ) async {
    return (await ErrorHandler.dioHttpResponse(this)).fold(
      (httpFailure) => Left(httpFailure),
      (response) {
        try {
          final List<dynamic> responseData = response.data;
          final listResult = responseData.map((item) => fromJson(item)).toList();
          return Right(listResult);
        } catch (error, stackTrace) {
          return Left(HttpFailure.unableToProcessData(error, stackTrace));
        }
      },
    );
  }
}
