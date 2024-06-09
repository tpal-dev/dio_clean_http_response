# Dio Clean HTTP Response

[![Pub Version](https://img.shields.io/pub/v/dio_clean_http_response)](https://pub.dev/packages/dio_clean_http_response)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://opensource.org/licenses/MIT)

[Dio Clean HTTP Response](link_to_your_repo) is a Dart package that simplifies handling HTTP responses when using the Dio library. It provides clean, structured, and customizable error handling for various HTTP failure scenarios.

## Index

- [Motivation](#motivation)
- [Features](#features)
- [Usage](#usage)
- [Installation](#installation)
- [Either Type](#either-type)
- [HttpFailure Class](#httpfailure-class)
- [HttpFailuresLocalization Class](#httpfailureslocalization-class)
- [Contributions](#contributions)
- [License](#license)

## Motivation

Developing applications that interact with APIs often involves handling HTTP responses, including potential errors and data parsing. The Dio Clean HTTP Response package aims to simplify and streamline this process by providing an extension on `Future<Response>`.

The motivation behind this package is to offer a clean and consistent way to convert Dio HTTP responses into either successful model instances or comprehensive error handling using HttpFailure sealed class and function programming pattern (Either type pattern) for Either monads as `Future<Either<HttpFailure, TModel>>` (`TModel` - generic type)

Key Goals

- Simplicity: Make the process of handling Dio HTTP responses straightforward and easy to implement.
- Consistency: Ensure a consistent pattern for converting responses into either successful results or detailed failure instances.
- Error Handling: Provide a robust mechanism for handling different HTTP failure scenarios with the HttpFailure class.

## Features

- **Clean API Integration:** Seamlessly integrate clean HTTP response handling into your Dio requests, making error management more robust and maintainable. (`Either` type pattern)

- **Structured Error Handling:** Easily manage Dio Exceptions using a set of subtypes of `HttpFailure` sealed class, each representing a specific HTTP failure scenario.

- **Localization Support:** Customize error messages for different scenarios with the ability to provide your own localization implementation.

## Usage

```dart
import 'package:dio/dio.dart';
import 'package:dio_clean_http_response/src/dio_clean_http_response_extension.dart';

class PostModel {
  final int id;
  final int userId;
  final String title;
  final String body;

  const PostModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json["id"] as int,
      userId: json["userId"] as int,
      title: json["title"] as String,
      body: json["body"] as String,
    );
  }

  @override
  String toString() => '🟩\nPOST $id \nuserId: $userId \ntitle: $title \nbody:$body\n';
}

void main() async {
  final httpClient = Dio(
    BaseOptions(
      baseUrl: 'https://jsonplaceholder.typicode.com',
    ),
  );

  final postModelOrFailure = await httpClient.get('/posts/1').fromJson(PostModel.fromJson);

  postModelOrFailure.fold(
    (failure) => print(failure.message()),
    (postModel) => print(postModel),
  );

  final postModelsListOrFailure = await httpClient.get('/posts').fromJsonAsList(PostModel.fromJson);

  postModelsListOrFailure.fold(
    (failure) => print(failure.message()),
    (postModelsList) => print(postModelsList),
  );
}


```

### Installation

Add the following to your `pubspec.yaml` file:

```yaml
dependencies:
  dio_clean_http_response: ^2.0.0
  dio: ^5.4.0
```

Then run:

```bash
pub get
```

## Either Type

Functional Error Handling `Either` is an alternative to Nullable value and Exceptions. More info about either https://pub.dev/packages/either_dart | https://pub.dev/packages/either_dart

## HttpFailure Sealed class

The `HttpFailure` sealed class represents a set of subtypes covering all Dio Exceptions for different HTTP failure scenarios. More info about sealed class https://dart.dev/language/class-modifiers#sealed

## HttpFailuresLocalization Class

The `HttpFailuresLocalization` abstract class defining a contract for providing localized error messages for different HTTP failure scenarios. Implementations should define getters to retrieve localized error messages for each scenario.

The `HttpFailuresLocalizationDefaultImpl` class provides default localized error messages for different HTTP failure scenarios.

## Contributions

We welcome contributions! If you find a bug or have a feature request, please open an issue. Pull requests are also appreciated.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
