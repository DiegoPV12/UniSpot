import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileService {
  final ImagePicker _picker = ImagePicker();
  File? _avatar;
  final _firebaseStorage = FirebaseStorage.instance;
  final _auth = FirebaseAuth.instance;
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  File? get avatar => _avatar;

  // Obtener imagen del avatar
  Future<File?> getAvatarImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      _avatar = File(pickedFile.path);
      return _avatar;
    } else {
      print('No image selected.');
      return null;
    }
  }

  // Subir el avatar a Firebase Storage
  Future<String?> uploadAvatarToFirebase() async {
    if (_avatar != null) {
      String email = _auth.currentUser!.email!;
      email = email.replaceAll(".", "_");
      final ref = _firebaseStorage.ref().child(email).child('avatar.jpg');
      await ref.putFile(_avatar!);
      return await ref.getDownloadURL();
    } else {
      return null;
    }
  }

 Future<String?> updateUserProfile(
      {String? newUsername, ImageSource? imageSource}) async {
    final uid = _auth.currentUser!.uid;
    Map<String, dynamic> updateData = {};

    if (newUsername != null) {
      updateData['username'] = newUsername;
    }

   String? avatarUrl;
    if (imageSource != null) {
      final pickedFile = await _picker.pickImage(source: imageSource);
      if (pickedFile != null) {
        _avatar = File(pickedFile.path);
        avatarUrl = await uploadAvatarToFirebase();
        if (avatarUrl != null) {
          updateData['avatarURL'] = avatarUrl;
        }
      }
    }

    if (updateData.isNotEmpty) {
      await usersCollection.doc(uid).update(updateData);
    }
    return avatarUrl;
  }
}
