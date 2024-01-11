import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:dio_clean_http_response/src/core/error_handler.dart';
import 'package:dio_clean_http_response/src/core/http_failure.dart';

extension HttpResponseDioExtension on Future<Response> {
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

  Future<Either<HttpFailure, List<TModel>>> fromJsonAsList<TModel>(
    TModel Function(Map<String, dynamic>) fromJsonList,
  ) async {
    return (await ErrorHandler.dioHttpResponse(this)).fold(
      (httpFailure) => Left(httpFailure),
      (response) {
        try {
          final List<dynamic> res = response.data;
          final ddd = res.map((e) => fromJsonList((e))).toList();
          return Right(ddd);
        } catch (error, stackTrace) {
          return Left(HttpFailure.unableToProcessData(error, stackTrace));
        }
      },
    );
  }
}
