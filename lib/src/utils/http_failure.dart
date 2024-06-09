import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio_clean_http_response/dio_clean_http_response.dart';

/// This sealed class represents a set of subtypes to cover all Dio Exceptions.
/// Each type corresponds to a specific HTTP failure scenario.

sealed class HttpFailure {
  const HttpFailure(this.stackTrace);

  final StackTrace? stackTrace;
  Object? get error => UnimplementedError('error getter must be overridden');

  /// Method to get a localized error message based on the type of HTTP failure.
  /// If showLog is true, it logs the error message along with additional information.
  /// The `localization` parameter allows customization of the error messages. Default is [HttpFailuresLocalizationDefaultImpl].
  ///
  /// Usage:
  /// ```dart
  /// // Assuming an instance of HttpFailure is created as httpFailure
  /// httpFailure.message(); // Logs and returns default english localized error message.
  /// ```
  ///
  /// Customize logging and localization:
  /// ```dart
  /// // Create an instance of the custom localization class
  /// final HttpFailuresLocalization myLocalization = MyHttpFailuresLocalization();
  /// // Assuming an instance of HttpFailure is created as httpFailure
  /// httpFailure.message(
  ///   showLog: true, // Log the error message
  ///   localization: myLocalization, // Use custom localization
  /// );
  /// ```
  ///
  /// Note: Ensure to replace `MyHttpFailuresLocalization` with your custom implementation.

  String message({
    bool showLog =
        false, // Flag to determine whether to show logs or not. Default is false.
    HttpFailuresLocalization localization =
        const HttpFailuresLocalizationDefaultImpl(),
  }) {
    // If showLog is true, log the localized error message along with additional information.
    if (showLog) {
      log(message(localization: localization),
          error: error, stackTrace: stackTrace);
    }

    // Map different HTTP failure scenarios to their corresponding localized error messages.
    return switch (this) {
      ConnectionTimeout _ => localization.connectionTimeout,
      SendTimeout() => localization.sendTimeout,
      ReceiveTimeout() => localization.receiveTimeout,
      RequestCancelled() => localization.requestCancel,
      NoInternetConnection() => localization.noInternetConnection,
      UnableToProcessData() => localization.unableToProcessData,
      UnexpectedError() => localization.unexpectedError,
      InformationalResponse() => localization.informationalResponse,
      RedirectionMessage() => localization.redirectionMessage,
      ClientError() => localization.clientError,
      ServerError() => localization.serverError,
      BadCertificate() => localization.badCertificate,
      ConnectionError() => localization.connectionError,
      UnknownException() => localization.unknown,
    };
  }

  // }
}

class ConnectionTimeout extends HttpFailure {
  ConnectionTimeout(this.error, super.stackTrace);
  @override
  final DioException? error;
}

class SendTimeout extends HttpFailure {
  SendTimeout(this.error, super.stackTrace);
  @override
  final DioException? error;
}

class ReceiveTimeout extends HttpFailure {
  ReceiveTimeout(this.error, super.stackTrace);
  @override
  final DioException? error;
}

class RequestCancelled extends HttpFailure {
  RequestCancelled(this.error, super.stackTrace);

  @override
  final DioException? error;
}

class NoInternetConnection extends HttpFailure {
  NoInternetConnection(this.error, super.stackTrace);
  @override
  final SocketException? error;
}

class UnableToProcessData extends HttpFailure {
  UnableToProcessData(this.error, super.stackTrace);
  @override
  final Object? error;
}

class UnexpectedError extends HttpFailure {
  UnexpectedError(this.error, super.stackTrace);
  @override
  final Object? error;
}

class InformationalResponse extends HttpFailure {
  InformationalResponse(this.error, super.stackTrace, this.statusCode);
  @override
  final DioException? error;
  final int? statusCode;
}

class RedirectionMessage extends HttpFailure {
  RedirectionMessage(this.error, super.stackTrace, this.statusCode);
  @override
  final DioException? error;
  final int? statusCode;
}

class ClientError extends HttpFailure {
  ClientError(this.error, super.stackTrace, this.statusCode);
  @override
  final DioException? error;
  final int? statusCode;
}

class ServerError extends HttpFailure {
  ServerError(this.error, super.stackTrace, this.statusCode);
  @override
  final DioException? error;
  final int? statusCode;
}

class BadCertificate extends HttpFailure {
  BadCertificate(this.error, super.stackTrace);
  @override
  final DioException? error;
}

class ConnectionError extends HttpFailure {
  ConnectionError(this.error, super.stackTrace);
  @override
  final DioException? error;
}

class UnknownException extends HttpFailure {
  UnknownException(this.error, super.stackTrace);
  @override
  final Object? error;
}
