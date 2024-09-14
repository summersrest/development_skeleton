import 'package:example/entity/safe_convert.dart';

class ArticleEntity {
  int id;
  int userId;
  String userNickname;
  String userImageUrl;
  String timestamp;
  String text;
  List<String> images;
  int readings;
  int likes;

  ArticleEntity({
    this.id = 0,
    this.userId = 0,
    this.userNickname = "",
    this.userImageUrl = "",
    this.timestamp = "",
    this.text = "",
    required this.images,
    this.readings = 0,
    this.likes = 0,
  });

  factory ArticleEntity.fromJson(Map<String, dynamic>? json) => ArticleEntity(
    id: asInt(json, 'id'),
    userId: asInt(json, 'userId'),
    userNickname: asString(json, 'userNickname'),
    userImageUrl: asString(json, 'userImageUrl'),
    timestamp: asString(json, 'timestamp'),
    text: asString(json, 'text'),
    images: asList(json, 'images').map((e) => e.toString()).toList(),
    readings: asInt(json, 'readings'),
    likes: asInt(json, 'likes'),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'userNickname': userNickname,
    'userImageUrl': userImageUrl,
    'timestamp': timestamp,
    'text': text,
    'images': images.map((e) => e).toList(),
    'readings': readings,
    'likes': likes,
  };
}

