/// Dio extension for cleaner HTTP response and error/exception handling through functional programming (Either type pattern).
/// Say goodbye to tedious try-catch blocks.
/// All possible exceptions are elegantly covered using [HttpFailure] (Freezed sealed class/union types) with predefined messages.
/// These patterns are well-established, inspired by Reso Coder's TDD/DDD tutorials."

/// Functional Error Handling [Either] is an alternative to Nullable value and Exceptions. More info about either https://pub.dev/packages/either_dart
/// HTTP failure scenarios as [HttpFailure] freezed sealed class / union types. More info about union types and sealed classes https://pub.dev/packages/freezed#union-types-and-sealed-classes

library dio_clean_http_response;

export 'src/dio_clean_http_response_extension.dart';
export 'src/utils/http_failure.dart';
export 'src/utils/http_failures_localization/http_failures_localization.dart';
export 'src/utils/http_failures_localization/http_failures_localization_default_impl.dart';
export 'src/utils/either.dart';
