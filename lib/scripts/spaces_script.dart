import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:unispot/firebase_options.dart';
import 'package:unispot/models/space_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  var batch = FirebaseFirestore.instance.batch();

  var dummySpaces = [
    SpaceModel(
      uid: 'T-001',
      name: 'Centro de Computo 1',
      capacity: 50,
      description: 'Amplia sala con proyector y aire acondicionado.',
      type: 'Centro de Computo',
      imageUrl: [
        'https://firebasestorage.googleapis.com/v0/b/univalle-reservation.appspot.com/o/spaces_images%2FComputo2.png?alt=media&token=0220d0b8-a063-41e9-8dc0-393c925adc14',
        'https://firebasestorage.googleapis.com/v0/b/univalle-reservation.appspot.com/o/spaces_images%2FComputo3.png?alt=media&token=a0bf7b20-c85f-40fe-b0ed-79538ac37359'
      ],
    ),
    SpaceModel(
      uid: 'T-002',
      name: 'Centro de Computo 2',
      capacity: 50,
      description: 'Amplia sala con proyector y aire acondicionado.',
      type: 'Centro de Computo',
      imageUrl: [
        'https://firebasestorage.googleapis.com/v0/b/univalle-reservation.appspot.com/o/spaces_images%2FComputo2.png?alt=media&token=0220d0b8-a063-41e9-8dc0-393c925adc14',
        'https://firebasestorage.googleapis.com/v0/b/univalle-reservation.appspot.com/o/spaces_images%2FComputo3.png?alt=media&token=a0bf7b20-c85f-40fe-b0ed-79538ac37359'
      ],
    ),
    SpaceModel(
      uid: 'T-003',
      name: 'Centro de Computo 3',
      capacity: 50,
      description: 'Amplia sala con proyector y aire acondicionado.',
      type: 'Centro de Computo',
      imageUrl: [
        'https://firebasestorage.googleapis.com/v0/b/univalle-reservation.appspot.com/o/spaces_images%2FComputo2.png?alt=media&token=0220d0b8-a063-41e9-8dc0-393c925adc14',
        'https://firebasestorage.googleapis.com/v0/b/univalle-reservation.appspot.com/o/spaces_images%2FComputo3.png?alt=media&token=a0bf7b20-c85f-40fe-b0ed-79538ac37359'
      ],
    ),
    SpaceModel(
      uid: 'T-004',
      name: 'Centro de Computo 4',
      capacity: 50,
      description: 'Amplia sala con proyector y aire acondicionado.',
      type: 'Centro de Computo',
      imageUrl: [
        'https://firebasestorage.googleapis.com/v0/b/univalle-reservation.appspot.com/o/spaces_images%2FComputo2.png?alt=media&token=0220d0b8-a063-41e9-8dc0-393c925adc14',
        'https://firebasestorage.googleapis.com/v0/b/univalle-reservation.appspot.com/o/spaces_images%2FComputo3.png?alt=media&token=a0bf7b20-c85f-40fe-b0ed-79538ac37359'
      ],
    ),
    
    SpaceModel(
      uid: 'CH-001',
      name: 'Cancha de Fútbol',
      capacity: 50,
      description: 'Cancha de Fútbol 7 con pasto natural.',
      type: 'Exteriores',
      imageUrl: [
        'https://firebasestorage.googleapis.com/v0/b/univalle-reservation.appspot.com/o/spaces_images%2FCancha2.jpeg?alt=media&token=f14e8f8b-4452-4a9d-aaad-7ee726fb2259',
        'https://firebasestorage.googleapis.com/v0/b/univalle-reservation.appspot.com/o/spaces_images%2FCancha3.png?alt=media&token=8a90d762-6706-4133-ad1f-afc185e55a09'
      ],
    ),

    SpaceModel(
      uid: 'AU-001',
      name: 'Auditorio Principal',
      capacity: 200,
      description: 'Auditorio de excelente acustica y gran capacidad.',
      type: 'Auditorios',
      imageUrl: [
        'https://firebasestorage.googleapis.com/v0/b/univalle-reservation.appspot.com/o/spaces_images%2FAuditorio2.png?alt=media&token=93fcfd6d-0de8-493e-9df0-d8193ed00cd8',
        'https://firebasestorage.googleapis.com/v0/b/univalle-reservation.appspot.com/o/spaces_images%2FAuditorio3.png?alt=media&token=e39e0c7a-145b-4ce9-b694-d059f3c2190b'
      ],
    ),
  ];

  for (var space in dummySpaces) {
    var spaceRef =
        FirebaseFirestore.instance.collection('spaces').doc(space.uid);
    batch.set(spaceRef, space.toMap());
  }

  await batch.commit();
  // ignore: avoid_print
  print('Todos los espacios han sido añadidos con éxito');
}
