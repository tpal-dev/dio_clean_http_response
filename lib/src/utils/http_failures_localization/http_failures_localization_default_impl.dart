import 'package:dio_clean_http_response/dio_clean_http_response.dart';

/// Default implementation of the [HttpFailuresLocalization] abstract class.
/// Provides default localized error messages for different HTTP failure scenarios.
class HttpFailuresLocalizationDefaultImpl implements HttpFailuresLocalization {
  const HttpFailuresLocalizationDefaultImpl();

  // Getter methods providing default localized error messages for each HTTP failure scenario

  /// Gets the localized error message for a bad certificate scenario.
  @override
  String get badCertificate => "The server's SSL certificate is not valid, possibly expired or self-signed.";

  /// Gets the localized error message for a client error scenario.
  @override
  String get clientError => "The server encountered an error while processing the request from the client.";

  /// Gets the localized error message for a connection error scenario.
  @override
  String get connectionError => "Failed to establish a connection with the server.";

  /// Gets the localized error message for a connection timeout scenario.
  @override
  String get connectionTimeout => "The connection to the server timed out.";

  /// Gets the localized message for an informational response scenario.
  @override
  String get informationalResponse => "Received an informational response from the server.";

  /// Gets the localized error message for a scenario with no internet connection.
  @override
  String get noInternetConnection => "No internet connection available.";

  /// Gets the localized error message for a receive timeout scenario.
  @override
  String get receiveTimeout => "Timed out while waiting for data to be received from the server.";

  /// Gets the localized error message for a redirection message scenario.
  @override
  String get redirectionMessage => "Received a redirection message from the server.";

  /// Gets the localized error message for a request cancellation scenario.
  @override
  String get requestCancel => "The request was canceled.";

  /// Gets the localized error message for a send timeout scenario.
  @override
  String get sendTimeout => "Timed out while waiting to send data to the server.";

  /// Gets the localized error message for a server error scenario.
  @override
  String get serverError => "The server encountered an internal error while processing the request.";

  /// Gets the localized error message for an unable to process data scenario.
  @override
  String get unableToProcessData => "Failed to process the received data from the server.";

  /// Gets the localized error message for an unexpected error scenario.
  @override
  String get unexpectedError => "An unexpected error occurred during the request.";

  /// Gets the localized error message for an unknown error scenario.
  @override
  String get unknown => "An unknown error occurred.";
}
