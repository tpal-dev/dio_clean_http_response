import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio_clean_http_response/src/core/http_failures_localization/http_failures_localization.dart';
import 'package:dio_clean_http_response/src/core/http_failures_localization/http_failures_localization_default._impl.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'http_failure.freezed.dart';

/// [Freezed] union types to cover all Dio Exceptions
@freezed
class HttpFailure with _$HttpFailure {
  const HttpFailure._();

  const factory HttpFailure.connectionTimeout([DioException? error, StackTrace? stackTrace]) = _ConnectTimeout;

  const factory HttpFailure.sendTimeout([DioException? error, StackTrace? stackTrace]) = _SendTimeout;

  const factory HttpFailure.receiveTimeout([DioException? error, StackTrace? stackTrace]) = _ReceiveTimeout;

  const factory HttpFailure.requestCancel([DioException? error, StackTrace? stackTrace]) = _RequestCancelled;

  const factory HttpFailure.noInternetConnection([SocketException? error, StackTrace? stackTrace]) =
      _NoInternetConnection;

  const factory HttpFailure.unableToProcessData([Object? error, StackTrace? stackTrace]) = _UnableToProcessData;

  const factory HttpFailure.unexpectedError([Object? error, StackTrace? stackTrace]) = _UnexpectedError;

  const factory HttpFailure.informationalResponse([DioException? error, StackTrace? stackTrace, int? statusCode]) =
      _InformationalResponse;

  const factory HttpFailure.redirectionMessage([DioException? error, StackTrace? stackTrace, int? statusCode]) =
      _RedirectionMessage;

  const factory HttpFailure.clientError([DioException? error, StackTrace? stackTrace, int? statusCode]) = _ClientError;

  const factory HttpFailure.serverError([DioException? error, StackTrace? stackTrace, int? statusCode]) = _ServerError;

  const factory HttpFailure.badCertificate([DioException? error, StackTrace? stackTrace]) = _BadCertificate;

  const factory HttpFailure.connectionError([DioException? error, StackTrace? stackTrace]) = _ConnectionError;

  const factory HttpFailure.unknown([Object? error, StackTrace? stackTrace]) = _UnknownException;

  // ignore: recursive_getters
  int? get statusCode => statusCode;

  String message({
    bool showLog = true,
    HttpFailuresLocalization localization = const HttpFailuresLocalizationDefaultImpl(),
  }) {
    if (showLog) log(message(localization: localization), error: error, stackTrace: stackTrace);

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
