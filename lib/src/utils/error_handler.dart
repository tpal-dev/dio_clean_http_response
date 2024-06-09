import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio_clean_http_response/dio_clean_http_response.dart';
import 'package:meta/meta.dart';

/// The `ErrorHandler` class provides utility methods for handling Dio HTTP responses and converting them
/// into [HttpFailure] or [Response] types.
@internal
class ErrorHandler {
  /// Converts a Dio HTTP response into an [Either<HttpFailure, Response>] type.
  /// Handles different types of exceptions, such as [SocketException] and [DioException],
  /// and maps them to corresponding [HttpFailure] instances.
  ///
  /// Usage:
  /// ```dart
  /// final dioResponse = Dio().get('https://example.com');
  /// final result = await ErrorHandler.dioHttpResponse(dioResponse);
  ///
  /// result.fold(
  ///   (failure) => print('HTTP Failure: $failure'),
  ///   (response) => print('HTTP Response: $response'),
  /// );
  /// ```
  static Future<Either<HttpFailure, Response>> dioHttpResponse(Future<Response> dioHttpResponse) async {
    try {
      return Right(await dioHttpResponse);
    } on SocketException catch (error, stackTrace) {
      return Left(NoInternetConnection(error, stackTrace));
    } on DioException catch (error, stackTrace) {
      return Left(_handleDioException(error, stackTrace));
    } catch (error, stackTrace) {
      return Left(UnexpectedError(error, stackTrace));
    }
  }

  /// Handles a [DioException] and maps it to a specific [HttpFailure] instance based on the exception type.
  static HttpFailure _handleDioException(DioException error, StackTrace stackTrace) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return ConnectionTimeout(error, stackTrace);
      case DioExceptionType.sendTimeout:
        return SendTimeout(error, stackTrace);
      case DioExceptionType.cancel:
        return RequestCancelled(error, stackTrace);
      case DioExceptionType.receiveTimeout:
        return ReceiveTimeout(error, stackTrace);
      case DioExceptionType.badResponse:
        return _handleBadResponseException(error, stackTrace);
      case DioExceptionType.badCertificate:
        return ReceiveTimeout(error, stackTrace);
      case DioExceptionType.connectionError:
        return ConnectionError(error, stackTrace);
      case DioExceptionType.unknown:
        return UnknownException(error, stackTrace);
      default:
        return UnknownException(error, stackTrace);
    }
  }

  /// Handles a [DioExceptionType.badResponse] and maps it to a specific [HttpFailure] instance based on the HTTP status code.
  static HttpFailure _handleBadResponseException(DioException error, StackTrace stackTrace) {
    final statusCode = error.response?.statusCode;
    if (statusCode == null) {
      return UnknownException(error, stackTrace);
    } else if (statusCode >= 100 && statusCode <= 199) {
      return InformationalResponse(error, stackTrace, statusCode);
    } else if (statusCode >= 300 && statusCode <= 399) {
      return RedirectionMessage(error, stackTrace, statusCode);
    } else if (statusCode >= 400 && statusCode <= 499) {
      return ClientError(error, stackTrace, statusCode);
    } else if (statusCode >= 500 && statusCode <= 599) {
      return ServerError(error, stackTrace, statusCode);
    } else {
      return UnknownException(error, stackTrace);
    }
  }
}
