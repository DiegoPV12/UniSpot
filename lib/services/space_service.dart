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
        'type': space.type,
        'imageUrl': space.imageUrl, 
      });
    } else {
      await spacesRef.doc(space.uid).update({
        'name': space.name,
        'capacity': space.capacity,
        'description': space.description,
        'type': space.type,
        'imageUrl': space.imageUrl, 
      });
    }
  }

  Future<SpaceModel> getSpaceFromFirestore(String uid) async {
    DocumentSnapshot doc = await spacesRef.doc(uid).get();
    return SpaceModel.fromDocumentSnapshot(doc);
  }


  Future<List<SpaceModel>> loadAllSpaces() async {
    QuerySnapshot querySnapshot = await spacesRef.get();
    return querySnapshot.docs
        .map((doc) => SpaceModel.fromDocumentSnapshot(doc))
        .toList();
  }

  Future<List<SpaceModel>> filterSpacesByType(String type) async {
    QuerySnapshot querySnapshot = 
        await spacesRef.where('type', isEqualTo: type).get();
    return querySnapshot.docs
        .map((doc) => SpaceModel.fromDocumentSnapshot(doc))
        .toList();
  }
}
