import 'package:cloud_firestore/cloud_firestore.dart';

class SpaceModel {
  final String uid;
  final String name;
  final int capacity;
  final String description;
  final String type;
  final List<String> imageUrl;


  SpaceModel({
    required this.uid,
    required this.name,
    required this.capacity,
    required this.description,
    required this.type,
    this.imageUrl = const [],

  });

  factory SpaceModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    return SpaceModel(
      uid: doc.id,
      name: doc['name'],
      capacity: doc['capacity'],
      description: doc['description'],
      type: doc['type'],
      imageUrl: List<String>.from(doc['imageUrl']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'capacity': capacity,
      'description': description,
      'type': type,
      'imageUrl': imageUrl,
    };
  }
}
