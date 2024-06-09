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
  String toString() =>
      '🟩\nPOST $id \nuserId: $userId \ntitle: $title \nbody:$body\n';
}

void main() async {
  final httpClient = Dio(
    BaseOptions(
      baseUrl: '',
      validateStatus: (status) => status != 400,
    ),
  );

  // On 200 OK returns model

  final postModelOrFailure = await httpClient
      .get('https://jsonplaceholder.typicode.com/posts/1')
      .fromJson(PostModel.fromJson);

  postModelOrFailure.fold(
    (failure) => print(failure.message()),
    (postModel) => print(postModel),
  );

  final postModelsListOrFailure = await httpClient
      .get('https://jsonplaceholder.typicode.com//posts')
      .fromJsonAsList(PostModel.fromJson);

  postModelsListOrFailure.fold(
    (failure) => print(failure.message()),
    (postModelsList) => print(postModelsList),
  );

  // On 400 Status code when [ValidateStatus] is on then returns HttpFailure.clientError
  // [ValidateStatus] defines whether the request is considered to be successful with the given status code. The request will be treated as succeed if the callback returns true.

  final postModelOrFailure400 = await httpClient
      .get('https://httpstat.us/400')
      .fromJson(PostModel.fromJson);

  postModelOrFailure400.fold(
    (failure) => print(failure.message()),
    (postModel) => print(postModel),
  );

  // On 503 Status code when [ValidateStatus] is off status code is ignored and expects data then returns HttpFailure.unableToProcessData
  // [ValidateStatus] defines whether the request is considered to be successful with the given status code. The request will be treated as succeed if the callback returns true.
  final postModelsListOrFailure400 = await httpClient
      .get('https://httpstat.us/503')
      .fromJsonAsList(PostModel.fromJson);

  postModelsListOrFailure400.fold(
    (failure) => print(failure.message()),
    (postModelsList) => print(postModelsList),
  );

  // ====================================================
  // All possible test cases are available in test folder
  // ====================================================
}
