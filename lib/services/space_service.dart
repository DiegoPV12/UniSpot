import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/space_model.dart';

class SpaceService {
  final CollectionReference spacesRef =
      FirebaseFirestore.instance.collection('spaces');

  // SINGLETON ------------------------------
  SpaceService._privateConstructor();
  static final SpaceService _instance = SpaceService._privateConstructor();
  static SpaceService get instance => _instance;
  // ----------------------------------------

  Future<void> saveSpaceToFirestore(SpaceModel space) async {
    DocumentSnapshot doc = await spacesRef.doc(space.uid).get();

    if (!doc.exists) {
      await spacesRef.doc(space.uid).set({
        'uid': space.uid,
        'name': space.name,
        'capacity': space.capacity,
        'description': space.description,
        'imageURL': 'assets/UnivalleLogo.png',
        'availableTimeSlots': space.availableTimeSlots
      });
    }
  }

  Future<SpaceModel> getSpaceFromFirestore(String uid) async {
    DocumentSnapshot doc = await spacesRef.doc(uid).get();
    if (doc.exists) {
      return SpaceModel.fromDocument(doc);
    }
    throw Exception('El espacio no existe');
  }

  Future<List<SpaceModel>> filterSpacesByType(String type) async {
    QuerySnapshot querySnapshot =
        await spacesRef.where('type', isEqualTo: type).get();
    return querySnapshot.docs
        .map((doc) => SpaceModel.fromDocument(doc))
        .toList();
  }

  Future<List<SpaceModel>> loadAllSpaces() async {
    QuerySnapshot querySnapshot = await spacesRef.get();
    return querySnapshot.docs
        .map((doc) => SpaceModel.fromDocument(doc))
        .toList();
  }

  Future<void> updateSpace(SpaceModel space) async {
    await spacesRef.doc(space.uid).update(space.toMap());
  }

  Future<void> deleteSpace(String uid) async {
    await spacesRef.doc(uid).delete();
  }
}
