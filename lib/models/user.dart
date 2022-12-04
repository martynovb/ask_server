import 'package:dbcrypt/dbcrypt.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  String email;
  @JsonKey(ignore: true)
  String? password;
  String? firstName;
  String? lastName;

  User({required this.email, this.password, this.firstName, this.lastName});

  void setPassword(String password) {
    this.password = new DBCrypt().hashpw(password, new DBCrypt().gensalt());
  }

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  User fromJson(Map<String, dynamic> json) => User.fromJson(json);
}
