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
