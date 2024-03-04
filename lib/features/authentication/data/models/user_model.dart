import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:news_app/features/authentication/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    String name = "",
    String email = "",
    String uid = "",
  }) : super(
          name: name,
          email: email,
          uid: uid,
        );

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'],
      email: json['email'],
      uid: json['uid'],
    );
  }

  factory UserModel.fromSnapshot(DocumentSnapshot snapshot) {
    return UserModel(
      name: snapshot.get('name'),
      email: snapshot.get('email'),
      uid: snapshot.get('uid'),
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      "name": name,
      "email": email,
      "uid": uid,
    };
  }
}
