import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;
  final String username;
  final String avatarURL;

  UserModel({
    required this.uid,
    required this.email,
    required this.username,
    this.avatarURL = '',
  });

  factory UserModel.fromDocument(DocumentSnapshot doc) {
    return UserModel(
      uid: doc['uid'],
      email: doc['email'],
      username: doc['username'],
      avatarURL: doc['avatarURL'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'username': username,
      'avatarURL': avatarURL,
    };
  }
}
