import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final CollectionReference usersRef = FirebaseFirestore.instance.collection('users');

  Future<void> saveUserToFirestore(User user, String username) async {
    DocumentSnapshot doc = await usersRef.doc(user.uid).get();

    if (!doc.exists) {
      await usersRef.doc(user.uid).set({
        'uid': user.uid,  
        'email': user.email,
        'username': username,
        'avatarURL':'UnivalleLogo.png'
      });
    }
  }

}
