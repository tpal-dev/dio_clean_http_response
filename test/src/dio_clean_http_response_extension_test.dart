import 'package:dio_clean_http_response/dio_clean_http_response.dart';
import 'package:test/test.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class UserModel {
  final int id;
  final String name;

  UserModel({
    required this.id,
    required this.name,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }
}

void main() {
  group('HttpResponseDioExtension', () {
    final requestOptions = RequestOptions(path: '/data', validateStatus: (status) => true);
    final data = {'id': 1, 'name': 'John Doe'};
    final dataList = [
      {'id': 1, 'name': 'John Doe'},
      {'id': 2, 'name': 'Jane Doe'}
    ];

    Future<Never> futureDioException(DioExceptionType type, {Response? response}) {
      return Future.delayed(
        Duration(microseconds: 10),
        () => throw DioException(
          response: response,
          requestOptions: requestOptions,
          type: type,
        ),
      );
    }

    group('fromJson', () {
      test('should return Right<UserModel> when conversion is successful', () async {
        // Arrange
        final dioResponse = Response<Map<String, dynamic>>(
          data: data,
          statusCode: 200,
          requestOptions: requestOptions,
        );
        // Act
        final result = await Future.value(dioResponse).fromJson(UserModel.fromJson);
        // Assert
        expect(result, isA<Right<HttpFailure, UserModel>>());
        expect(result.fold(id, id), isA<UserModel>());
      });

      test('should return Left<HttpFailure.unableToProcessData> when conversion fails', () async {
        // Arrange
        final dioResponse = Response<Map<String, dynamic>>(
          data: {'id': 'invalid', 'name': 'John Doe'},
          statusCode: 200,
          requestOptions: requestOptions,
        );
        // Act
        final result = await Future.value(dioResponse).fromJson(UserModel.fromJson);
        // Assert
        expect(result, isA<Left<HttpFailure, UserModel>>());
        expect(result.fold(id, id), isA<UnableToProcessData>());
      });

      test('should return Left<HttpFailure.connectionTimeout> on DioExceptionType.connectionTimeout', () async {
        // Arrange
        final dioResponse = futureDioException(DioExceptionType.connectionTimeout);

        // Act
        final result = await dioResponse.fromJson(UserModel.fromJson);

        // Assert
        expect(result, isA<Left<HttpFailure, UserModel>>());
        expect(result.fold(id, id), isA<ConnectionTimeout>());
      });

      test('should return HttpFailure.sendTimeout on DioExceptionType.sendTimeout', () async {
        // Arrange
        final dioResponse = futureDioException(DioExceptionType.sendTimeout);

        // Act
        final result = await dioResponse.fromJson(UserModel.fromJson);

        // Assert
        expect(result, isA<Left<HttpFailure, UserModel>>());
        expect(result.fold(id, id), isA<SendTimeout>());
      });

      test('should return HttpFailure.requestCancel on DioExceptionType.cancel', () async {
        // Arrange
        final dioResponse = futureDioException(DioExceptionType.cancel);

        // Act
        final result = await dioResponse.fromJson(UserModel.fromJson);

        // Assert
        expect(result, isA<Left<HttpFailure, UserModel>>());
        expect(result.fold(id, id), isA<RequestCancelled>());
      });

      test('should return HttpFailure.receiveTimeout on DioExceptionType.receiveTimeout', () async {
        // Arrange
        final dioResponse = futureDioException(DioExceptionType.receiveTimeout);

        // Act
        final result = await dioResponse.fromJson(UserModel.fromJson);

        // Assert
        expect(result, isA<Left<HttpFailure, UserModel>>());
        expect(result.fold(id, id), isA<ReceiveTimeout>());
      });

      test('should return HttpFailure.receiveTimeout on DioExceptionType.connectionError', () async {
        // Arrange
        final dioResponse = futureDioException(DioExceptionType.connectionError);

        // Act
        final result = await dioResponse.fromJson(UserModel.fromJson);

        // Assert
        expect(result, isA<Left<HttpFailure, UserModel>>());
        expect(result.fold(id, id), isA<ConnectionError>());
      });

      test('should return HttpFailure.unknown on DioExceptionType.unknown', () async {
        // Arrange
        final dioResponse = futureDioException(DioExceptionType.unknown);

        // Act
        final result = await dioResponse.fromJson(UserModel.fromJson);

        // Assert
        expect(result, isA<Left<HttpFailure, UserModel>>());
        expect(result.fold(id, id), isA<UnknownException>());
      });

      test('should return Left<HttpFailure.unknown> on DioExceptionType.badResponse with status code null  ', () async {
        // Arrange
        final dioResponse = futureDioException(DioExceptionType.badResponse,
            response: Response<Map<String, dynamic>>(
              requestOptions: RequestOptions(validateStatus: (status) => status != null),
              statusCode: null,
            ));
        // Act
        final result = await dioResponse.fromJson(UserModel.fromJson);
        // Assert
        expect(result, isA<Left<HttpFailure, UserModel>>());
        expect(result.fold(id, id), isA<UnknownException>());
      });

      test('should return Left<HttpFailure.informationalResponse> on status code 100', () async {
        // Arrange
        final dioResponse = futureDioException(DioExceptionType.badResponse,
            response: Response<Map<String, dynamic>>(
              requestOptions: RequestOptions(validateStatus: (status) => status != 100),
              statusCode: 100,
            ));
        // Act
        final result = await dioResponse.fromJson(UserModel.fromJson);
        // Assert
        expect(result, isA<Left<HttpFailure, UserModel>>());
        expect(result.fold(id, id), isA<InformationalResponse>());
      });

      test('should return Left<HttpFailure.redirectionMessage> on status code 300', () async {
        // Arrange
        final dioResponse = futureDioException(DioExceptionType.badResponse,
            response: Response<Map<String, dynamic>>(
              requestOptions: RequestOptions(validateStatus: (status) => status != 300),
              statusCode: 300,
            ));
        // Act
        final result = await dioResponse.fromJson(UserModel.fromJson);
        // Assert
        expect(result, isA<Left<HttpFailure, UserModel>>());
        expect(result.fold(id, id), isA<RedirectionMessage>());
      });
      test('should return Left<HttpFailure.clientError> on status code 400', () async {
        // Arrange
        final dioResponse = futureDioException(DioExceptionType.badResponse,
            response: Response<Map<String, dynamic>>(
              requestOptions: RequestOptions(validateStatus: (status) => status != 400),
              statusCode: 400,
            ));
        // Act
        final result = await dioResponse.fromJson(UserModel.fromJson);
        // Assert
        expect(result, isA<Left<HttpFailure, UserModel>>());
        expect(result.fold(id, id), isA<ClientError>());
      });

      test('should return Left<HttpFailure.serverError> on status code 500', () async {
        // Arrange
        final dioResponse = futureDioException(DioExceptionType.badResponse,
            response: Response<Map<String, dynamic>>(
              requestOptions: RequestOptions(validateStatus: (status) => status != 500),
              statusCode: 500,
            ));
        // Act
        final result = await dioResponse.fromJson(UserModel.fromJson);
        // Assert
        expect(result, isA<Left<HttpFailure, UserModel>>());
        expect(result.fold(id, id), isA<ServerError>());
      });
    });

    group('fromJsonAsList', () {
      test('should return Right<List<UserModel>> when conversion is successful', () async {
        // Arrange

        final dioResponse = Response<List<dynamic>>(
          data: dataList,
          statusCode: 200,
          requestOptions: requestOptions,
        );

        // Act
        final result = await Future.value(dioResponse).fromJsonAsList(UserModel.fromJson);

        // Assert
        expect(result, isA<Right<HttpFailure, List<UserModel>>>());
        expect(result.fold(id, id), isA<List<UserModel>>());
      });

      test('should return Left<HttpFailure.unableToProcessData> when conversion fails for at least one field',
          () async {
        // Arrange
        final dioResponse = Response<List<dynamic>>(
          data: [
            {'id': 1, 'name': 'John Doe'},
            {'id': 'invalid', 'name': 'Jane Doe'}
          ],
          statusCode: 200,
          requestOptions: requestOptions,
        );

        // Act
        final result = await Future.value(dioResponse).fromJsonAsList(UserModel.fromJson);

        // Assert
        expect(result, isA<Left<HttpFailure, List<UserModel>>>());
        expect(result.fold(id, id), isA<UnableToProcessData>());
      });

      test('should return Left<HttpFailure.connectionTimeout> on DioExceptionType.connectionTimeout', () async {
        // Arrange
        final dioResponse = futureDioException(DioExceptionType.connectionTimeout);

        // Act
        final result = await dioResponse.fromJsonAsList(UserModel.fromJson);

        // Assert
        expect(result, isA<Left<HttpFailure, List<UserModel>>>());
        expect(result.fold(id, id), isA<ConnectionTimeout>());
      });

      test('should return HttpFailure.sendTimeout on DioExceptionType.sendTimeout', () async {
        // Arrange
        final dioResponse = futureDioException(DioExceptionType.sendTimeout);

        // Act
        final result = await dioResponse.fromJsonAsList(UserModel.fromJson);

        // Assert
        expect(result, isA<Left<HttpFailure, List<UserModel>>>());
        expect(result.fold(id, id), isA<SendTimeout>());
      });

      test('should return HttpFailure.requestCancel on DioExceptionType.cancel', () async {
        // Arrange
        final dioResponse = futureDioException(DioExceptionType.cancel);

        // Act
        final result = await dioResponse.fromJsonAsList(UserModel.fromJson);

        // Assert
        expect(result, isA<Left<HttpFailure, List<UserModel>>>());
        expect(result.fold(id, id), isA<RequestCancelled>());
      });

      test('should return HttpFailure.receiveTimeout on DioExceptionType.receiveTimeout', () async {
        // Arrange
        final dioResponse = futureDioException(DioExceptionType.receiveTimeout);

        // Act
        final result = await dioResponse.fromJsonAsList(UserModel.fromJson);

        // Assert
        expect(result, isA<Left<HttpFailure, List<UserModel>>>());
        expect(result.fold(id, id), isA<ReceiveTimeout>());
      });

      test('should return HttpFailure.receiveTimeout on DioExceptionType.connectionError', () async {
        // Arrange
        final dioResponse = futureDioException(DioExceptionType.connectionError);

        // Act
        final result = await dioResponse.fromJsonAsList(UserModel.fromJson);

        // Assert
        expect(result, isA<Left<HttpFailure, List<UserModel>>>());
        expect(result.fold(id, id), isA<ConnectionError>());
      });

      test('should return HttpFailure.unknown on DioExceptionType.unknown', () async {
        // Arrange
        final dioResponse = futureDioException(DioExceptionType.unknown);

        // Act
        final result = await dioResponse.fromJsonAsList(UserModel.fromJson);

        // Assert
        expect(result, isA<Left<HttpFailure, List<UserModel>>>());
        expect(result.fold(id, id), isA<UnknownException>());
      });

      test('should return Left<HttpFailure.unknown> on DioExceptionType.badResponse with status code null  ', () async {
        // Arrange
        final dioResponse = futureDioException(DioExceptionType.badResponse,
            response: Response<Map<String, dynamic>>(
              requestOptions: RequestOptions(validateStatus: (status) => status != null),
              statusCode: null,
            ));
        // Act
        final result = await dioResponse.fromJsonAsList(UserModel.fromJson);
        // Assert
        expect(result, isA<Left<HttpFailure, List<UserModel>>>());
        expect(result.fold(id, id), isA<UnknownException>());
      });

      test('should return Left<HttpFailure.informationalResponse> on status code 100', () async {
        // Arrange
        final dioResponse = futureDioException(DioExceptionType.badResponse,
            response: Response<Map<String, dynamic>>(
              requestOptions: RequestOptions(validateStatus: (status) => status != 100),
              statusCode: 100,
            ));
        // Act
        final result = await dioResponse.fromJsonAsList(UserModel.fromJson);
        // Assert
        expect(result, isA<Left<HttpFailure, List<UserModel>>>());
        expect(result.fold(id, id), isA<InformationalResponse>());
      });

      test('should return Left<HttpFailure.redirectionMessage> on status code 300', () async {
        // Arrange
        final dioResponse = futureDioException(DioExceptionType.badResponse,
            response: Response<Map<String, dynamic>>(
              requestOptions: RequestOptions(validateStatus: (status) => status != 300),
              statusCode: 300,
            ));
        // Act
        final result = await dioResponse.fromJsonAsList(UserModel.fromJson);
        // Assert
        expect(result, isA<Left<HttpFailure, List<UserModel>>>());
        expect(result.fold(id, id), isA<RedirectionMessage>());
      });
      test('should return Left<HttpFailure.clientError> on status code 400', () async {
        // Arrange
        final dioResponse = futureDioException(DioExceptionType.badResponse,
            response: Response<Map<String, dynamic>>(
              requestOptions: RequestOptions(validateStatus: (status) => status != 400),
              statusCode: 400,
            ));
        // Act
        final result = await dioResponse.fromJsonAsList(UserModel.fromJson);
        // Assert
        expect(result, isA<Left<HttpFailure, List<UserModel>>>());
        expect(result.fold(id, id), isA<ClientError>());
      });

      test('should return Left<HttpFailure.serverError> on status code 500', () async {
        // Arrange
        final dioResponse = futureDioException(DioExceptionType.badResponse,
            response: Response<Map<String, dynamic>>(
              requestOptions: RequestOptions(validateStatus: (status) => status != 500),
              statusCode: 500,
            ));
        // Act
        final result = await dioResponse.fromJsonAsList(UserModel.fromJson);
        // Assert
        expect(result, isA<Left<HttpFailure, List<UserModel>>>());
        expect(result.fold(id, id), isA<ServerError>());
      });
    });
  });
}
