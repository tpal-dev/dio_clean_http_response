import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:dio_clean_http_response/src/core/http_failure.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

@internal
class ErrorHandler {
  static Future<Either<HttpFailure, Response>> dioHttpResponse(Future<Response> dioHttpResponse) async {
    try {
      return Right(await dioHttpResponse);
    } on SocketException catch (error, stackTrace) {
      return Left(HttpFailure.noInternetConnection(error, stackTrace));
    } on DioException catch (error, stackTrace) {
      return Left(_handleDioException(error, stackTrace));
    } catch (error, stackTrace) {
      return Left(HttpFailure.unexpectedError(error, stackTrace));
    }
  }

  static HttpFailure _handleDioException(DioException error, StackTrace stackTrace) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return HttpFailure.connectionTimeout(error, stackTrace);
      case DioExceptionType.sendTimeout:
        return HttpFailure.sendTimeout(error, stackTrace);
      case DioExceptionType.cancel:
        return HttpFailure.requestCancel(error, stackTrace);
      case DioExceptionType.receiveTimeout:
        return HttpFailure.receiveTimeout(error, stackTrace);
      case DioExceptionType.badResponse:
        return _handleBadResponseException(error, stackTrace);
      case DioExceptionType.badCertificate:
        return HttpFailure.receiveTimeout(error, stackTrace);
      case DioExceptionType.connectionError:
        return HttpFailure.receiveTimeout(error, stackTrace);
      case DioExceptionType.unknown:
        return HttpFailure.unknown(error, stackTrace);
    }
  }

  static HttpFailure _handleBadResponseException(DioException error, StackTrace stackTrace) {
    final statusCode = error.response?.statusCode;
    if (statusCode == null) {
      return HttpFailure.unknown(error, stackTrace);
    } else if (statusCode >= 100 && statusCode <= 199) {
      return HttpFailure.informationalResponse(error, stackTrace);
    } else if (statusCode >= 300) {
      return HttpFailure.redirectionMessage(error, stackTrace, statusCode);
    } else if (statusCode >= 400) {
      return HttpFailure.clientError(error, stackTrace, statusCode);
    } else if (statusCode >= 500 && statusCode <= 599) {
      return HttpFailure.serverError(error, stackTrace, statusCode);
    } else {
      return HttpFailure.unknown(error, stackTrace);
    }
  }
}
