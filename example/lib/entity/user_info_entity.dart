import 'package:example/entity/safe_convert.dart';

class UserInfoEntity {
  int id;
  String token;
  String username;
  String password;
  String nickname;
  String imageUrl;
  int gender;
  String birthday;
  String email;
  String phone;
  List<String> address;

  UserInfoEntity({
    this.id = 0,
    this.token = "",
    this.username = "",
    this.password = "",
    this.nickname = "",
    this.imageUrl = "",
    this.gender = 0,
    this.birthday = "",
    this.email = "",
    this.phone = "",
    required this.address,
  });

  factory UserInfoEntity.fromJson(Map<String, dynamic>? json) => UserInfoEntity(
    id: asInt(json, 'id'),
    token: asString(json, 'token'),
    username: asString(json, 'username'),
    password: asString(json, 'password'),
    nickname: asString(json, 'nickname'),
    imageUrl: asString(json, 'imageUrl'),
    gender: asInt(json, 'gender'),
    birthday: asString(json, 'birthday'),
    email: asString(json, 'email'),
    phone: asString(json, 'phone'),
    address: asList(json, 'address').map((e) => e.toString()).toList(),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'token': token,
    'username': username,
    'password': password,
    'nickname': nickname,
    'imageUrl': imageUrl,
    'gender': gender,
    'birthday': birthday,
    'email': email,
    'phone': phone,
    'address': address.map((e) => e).toList(),
  };
}

