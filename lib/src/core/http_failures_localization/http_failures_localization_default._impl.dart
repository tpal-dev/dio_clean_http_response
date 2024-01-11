import 'package:dio_clean_http_response/src/core/http_failures_localization/http_failures_localization.dart';

class HttpFailuresLocalizationDefaultImpl implements HttpFailuresLocalization {
  const HttpFailuresLocalizationDefaultImpl();
  @override
  String get badCertificate => "The server's SSL certificate is not valid, possibly expired or self-signed.";

  @override
  String get clientError => "The server encountered an error while processing the request from the client.";

  @override
  String get connectionError => "Failed to establish a connection with the server.";

  @override
  String get connectionTimeout => "The connection to the server timed out.";

  @override
  String get informationalResponse => "Received an informational response from the server.";

  @override
  String get noInternetConnection => "No internet connection available.";

  @override
  String get receiveTimeout => "Timed out while waiting for data to be received from the server.";

  @override
  String get redirectionMessage => "Received a redirection message from the server.";

  @override
  String get requestCancel => "The request was canceled.";

  @override
  String get sendTimeout => "Timed out while waiting to send data to the server.";

  @override
  String get serverError => "The server encountered an internal error while processing the request.";

  @override
  String get unableToProcessData => "Failed to process the received data from the server.";

  @override
  String get unexpectedError => "An unexpected error occurred during the request.";

  @override
  String get unknown => "An unknown error occurred.";
}
