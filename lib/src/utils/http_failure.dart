import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio_clean_http_response/dio_clean_http_response.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'http_failure.freezed.dart';

/// This class represents a set of [Freezed] union types to cover all Dio Exceptions.
/// Each type corresponds to a specific HTTP failure scenario.
@freezed
class HttpFailure with _$HttpFailure {
  const HttpFailure._();

  // Factory constructors for different HTTP failure scenarios, each associated with a specific type

  /// Represents a connection timeout HTTP failure.
  const factory HttpFailure.connectionTimeout([DioException? error, StackTrace? stackTrace]) = ConnectionTimeout;

  /// Represents a send timeout HTTP failure.
  const factory HttpFailure.sendTimeout([DioException? error, StackTrace? stackTrace]) = SendTimeout;

  /// Represents a receive timeout HTTP failure.
  const factory HttpFailure.receiveTimeout([DioException? error, StackTrace? stackTrace]) = ReceiveTimeout;

  /// Represents a request cancellation HTTP failure.
  const factory HttpFailure.requestCancel([DioException? error, StackTrace? stackTrace]) = RequestCancelled;

  /// Represents a no internet connection HTTP failure.
  const factory HttpFailure.noInternetConnection([SocketException? error, StackTrace? stackTrace]) =
      NoInternetConnection;

  /// Represents an unable to process data HTTP failure.
  const factory HttpFailure.unableToProcessData([Object? error, StackTrace? stackTrace]) = UnableToProcessData;

  /// Represents an unexpected error HTTP failure.
  const factory HttpFailure.unexpectedError([Object? error, StackTrace? stackTrace]) = UnexpectedError;

  /// Represents an informational response HTTP failure.
  const factory HttpFailure.informationalResponse([DioException? error, StackTrace? stackTrace, int? statusCode]) =
      InformationalResponse;

  /// Represents a redirection message HTTP failure.
  const factory HttpFailure.redirectionMessage([DioException? error, StackTrace? stackTrace, int? statusCode]) =
      RedirectionMessage;

  /// Represents a client error HTTP failure.
  const factory HttpFailure.clientError([DioException? error, StackTrace? stackTrace, int? statusCode]) = ClientError;

  /// Represents a server error HTTP failure.
  const factory HttpFailure.serverError([DioException? error, StackTrace? stackTrace, int? statusCode]) = ServerError;

  /// Represents a bad certificate HTTP failure.
  const factory HttpFailure.badCertificate([DioException? error, StackTrace? stackTrace]) = BadCertificate;

  /// Represents a connection error HTTP failure.
  const factory HttpFailure.connectionError([DioException? error, StackTrace? stackTrace]) = ConnectionError;

  /// Represents an unknown HTTP failure.
  const factory HttpFailure.unknown([Object? error, StackTrace? stackTrace]) = UnknownException;

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
  ///   showLog: false, // Do not log the error message
  ///   localization: myLocalization, // Use custom localization
  /// );
  /// ```
  ///
  /// Note: Ensure to replace `MyHttpFailuresLocalization` with your custom implementation.

  String message({
    bool showLog = true, // Flag to determine whether to show logs or not. Default is true.
    HttpFailuresLocalization localization = const HttpFailuresLocalizationDefaultImpl(),
  }) {
    // If showLog is true, log the localized error message along with additional information.
    if (showLog) log(message(localization: localization), error: error, stackTrace: stackTrace);

    // Map different HTTP failure scenarios to their corresponding localized error messages.
    return map(
      connectionTimeout: (_) => localization.connectionTimeout,
      sendTimeout: (_) => localization.sendTimeout,
      receiveTimeout: (_) => localization.receiveTimeout,
      requestCancel: (_) => localization.requestCancel,
      noInternetConnection: (_) => localization.noInternetConnection,
      unableToProcessData: (_) => localization.unableToProcessData,
      unexpectedError: (_) => localization.unexpectedError,
      informationalResponse: (_) => localization.informationalResponse,
      redirectionMessage: (_) => localization.redirectionMessage,
      clientError: (_) => localization.clientError,
      serverError: (_) => localization.serverError,
      badCertificate: (_) => localization.badCertificate,
      connectionError: (_) => localization.connectionError,
      unknown: (_) => localization.unknown,
    );
  }
}
