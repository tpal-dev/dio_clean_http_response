/// Abstract class defining a contract for providing localized error messages
/// for different HTTP failure scenarios. Implementations should define
/// getters to retrieve localized error messages for each scenario.
///
abstract class HttpFailuresLocalization {
  /// Gets the localized error message for a connection timeout scenario.
  String get connectionTimeout;

  /// Gets the localized error message for a send timeout scenario.
  String get sendTimeout;

  /// Gets the localized error message for a receive timeout scenario.
  String get receiveTimeout;

  /// Gets the localized error message for a request cancellation scenario.
  String get requestCancel;

  /// Gets the localized error message for a scenario with no internet connection.
  String get noInternetConnection;

  /// Gets the localized error message for an unable to process data scenario.
  String get unableToProcessData;

  /// Gets the localized error message for an unexpected error scenario.
  String get unexpectedError;

  /// Gets the localized error message for an informational response scenario.
  String get informationalResponse;

  /// Gets the localized error message for a redirection message scenario.
  String get redirectionMessage;

  /// Gets the localized error message for a client error scenario.
  String get clientError;

  /// Gets the localized error message for a server error scenario.
  String get serverError;

  /// Gets the localized error message for a bad certificate scenario.
  String get badCertificate;

  /// Gets the localized error message for a connection error scenario.
  String get connectionError;

  /// Gets the localized error message for an unknown error scenario.
  String get unknown;
}
