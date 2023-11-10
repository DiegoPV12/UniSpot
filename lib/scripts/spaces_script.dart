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
      name: 'Sala de Computo',
      capacity: 50,
      description: 'Amplia sala con proyector y aire acondicionado.',
      type: 'Sala de Computo',
      imageUrl:
          'https://firebasestorage.googleapis.com/v0/b/univalle-reservation.appspot.com/o/spaces_images%2FComputo.png?alt=media&token=a21add67-d4cf-475a-a16f-0af429a5b81f&_gl=1*662r6s*_ga*MTcyOTI3MjcwOC4xNjk3MTUxODYy*_ga_CW55HF8NVT*MTY5OTQxMzgwMi4yMi4xLjE2OTk0MTcxNDYuNjAuMC4w',
      availableTimeSlots: ['9:00 - 11:00', '11:00 - 13:00'],
    ),
    SpaceModel(
      uid: 'CH-001',
      name: 'Cancha de Fútbol',
      capacity: 50,
      description: 'Cancha de Fútbol 7 con pasto artificial.',
      type: 'Exteriores',
      imageUrl:
          'https://firebasestorage.googleapis.com/v0/b/univalle-reservation.appspot.com/o/spaces_images%2FCancha.png?alt=media&token=2c149422-448e-4d56-92c5-4065777c84ee&_gl=1*1k5yciu*_ga*MTcyOTI3MjcwOC4xNjk3MTUxODYy*_ga_CW55HF8NVT*MTY5OTQxMzgwMi4yMi4xLjE2OTk0MTcxMjIuMTcuMC4w',
      availableTimeSlots: ['9:00 - 11:00', '11:00 - 13:00'],
    ),
    SpaceModel(
      uid: 'T-002',
      name: 'Sala de Computo',
      capacity: 50,
      description: 'Amplia sala con proyector y aire acondicionado.',
      type: 'Sala de Computo',
      imageUrl:
          'https://firebasestorage.googleapis.com/v0/b/univalle-reservation.appspot.com/o/spaces_images%2FComputo.png?alt=media&token=a21add67-d4cf-475a-a16f-0af429a5b81f&_gl=1*662r6s*_ga*MTcyOTI3MjcwOC4xNjk3MTUxODYy*_ga_CW55HF8NVT*MTY5OTQxMzgwMi4yMi4xLjE2OTk0MTcxNDYuNjAuMC4w',
      availableTimeSlots: ['9:00 - 11:00', '11:00 - 13:00'],
    ),
    SpaceModel(
      uid: 'T-002',
      name: 'Sala de Computo',
      capacity: 50,
      description: 'Amplia sala con proyector y aire acondicionado.',
      type: 'Sala de Computo',
      imageUrl:
          'https://firebasestorage.googleapis.com/v0/b/univalle-reservation.appspot.com/o/spaces_images%2FComputo.png?alt=media&token=a21add67-d4cf-475a-a16f-0af429a5b81f&_gl=1*662r6s*_ga*MTcyOTI3MjcwOC4xNjk3MTUxODYy*_ga_CW55HF8NVT*MTY5OTQxMzgwMi4yMi4xLjE2OTk0MTcxNDYuNjAuMC4w',
      availableTimeSlots: ['9:00 - 11:00', '11:00 - 13:00'],
    ),
    SpaceModel(
      uid: 'T-003',
      name: 'Sala de Computo',
      capacity: 50,
      description: 'Amplia sala con proyector y aire acondicionado.',
      type: 'Sala de Computo',
      imageUrl:
          'https://firebasestorage.googleapis.com/v0/b/univalle-reservation.appspot.com/o/spaces_images%2FComputo.png?alt=media&token=a21add67-d4cf-475a-a16f-0af429a5b81f&_gl=1*662r6s*_ga*MTcyOTI3MjcwOC4xNjk3MTUxODYy*_ga_CW55HF8NVT*MTY5OTQxMzgwMi4yMi4xLjE2OTk0MTcxNDYuNjAuMC4w',
      availableTimeSlots: ['9:00 - 11:00', '11:00 - 13:00'],
    ),
    SpaceModel(
      uid: 'T-005',
      name: 'Sala de Computo',
      capacity: 50,
      description: 'Amplia sala con proyector y aire acondicionado.',
      type: 'Sala de Computo',
      imageUrl:
          'https://firebasestorage.googleapis.com/v0/b/univalle-reservation.appspot.com/o/spaces_images%2FComputo.png?alt=media&token=a21add67-d4cf-475a-a16f-0af429a5b81f&_gl=1*662r6s*_ga*MTcyOTI3MjcwOC4xNjk3MTUxODYy*_ga_CW55HF8NVT*MTY5OTQxMzgwMi4yMi4xLjE2OTk0MTcxNDYuNjAuMC4w',
      availableTimeSlots: ['9:00 - 11:00', '11:00 - 13:00'],
    ),
    SpaceModel(
      uid: 'CH-002',
      name: 'Cancha de Fútbol',
      capacity: 50,
      description: 'Cancha de Fútbol 7 con pasto artificial.',
      type: 'Exteriores',
      imageUrl:
          'https://firebasestorage.googleapis.com/v0/b/univalle-reservation.appspot.com/o/spaces_images%2FCancha.png?alt=media&token=2c149422-448e-4d56-92c5-4065777c84ee&_gl=1*1k5yciu*_ga*MTcyOTI3MjcwOC4xNjk3MTUxODYy*_ga_CW55HF8NVT*MTY5OTQxMzgwMi4yMi4xLjE2OTk0MTcxMjIuMTcuMC4w',
      availableTimeSlots: ['9:00 - 11:00', '11:00 - 13:00'],
    ),
    SpaceModel(
      uid: 'CH-003',
      name: 'Cancha de Fútbol',
      capacity: 50,
      description: 'Cancha de Fútbol 7 con pasto artificial.',
      type: 'Exteriores',
      imageUrl:
          'https://firebasestorage.googleapis.com/v0/b/univalle-reservation.appspot.com/o/spaces_images%2FCancha.png?alt=media&token=2c149422-448e-4d56-92c5-4065777c84ee&_gl=1*1k5yciu*_ga*MTcyOTI3MjcwOC4xNjk3MTUxODYy*_ga_CW55HF8NVT*MTY5OTQxMzgwMi4yMi4xLjE2OTk0MTcxMjIuMTcuMC4w',
      availableTimeSlots: ['9:00 - 11:00', '11:00 - 13:00'],
    ),
    SpaceModel(
      uid: 'CH-004',
      name: 'Cancha de Fútbol',
      capacity: 50,
      description: 'Cancha de Fútbol 7 con pasto artificial.',
      type: 'Exteriores',
      imageUrl:
          'https://firebasestorage.googleapis.com/v0/b/univalle-reservation.appspot.com/o/spaces_images%2FCancha.png?alt=media&token=2c149422-448e-4d56-92c5-4065777c84ee&_gl=1*1k5yciu*_ga*MTcyOTI3MjcwOC4xNjk3MTUxODYy*_ga_CW55HF8NVT*MTY5OTQxMzgwMi4yMi4xLjE2OTk0MTcxMjIuMTcuMC4w',
      availableTimeSlots: ['9:00 - 11:00', '11:00 - 13:00'],
    ),
    SpaceModel(
      uid: 'CH-005',
      name: 'Cancha de Fútbol',
      capacity: 50,
      description: 'Cancha de Fútbol 7 con pasto artificial.',
      type: 'Exteriores',
      imageUrl:
          'https://firebasestorage.googleapis.com/v0/b/univalle-reservation.appspot.com/o/spaces_images%2FCancha.png?alt=media&token=2c149422-448e-4d56-92c5-4065777c84ee&_gl=1*1k5yciu*_ga*MTcyOTI3MjcwOC4xNjk3MTUxODYy*_ga_CW55HF8NVT*MTY5OTQxMzgwMi4yMi4xLjE2OTk0MTcxMjIuMTcuMC4w',
      availableTimeSlots: ['9:00 - 11:00', '11:00 - 13:00'],
    ),
    SpaceModel(
      uid: 'AU-001',
      name: 'Auditorio',
      capacity: 50,
      description: 'Auditorio de excelente acustica',
      type: 'Auditorios',
      imageUrl:
          'https://firebasestorage.googleapis.com/v0/b/univalle-reservation.appspot.com/o/spaces_images%2Fauditorio.png?alt=media&token=1391ff98-528a-4122-b6a8-ee2d5d1d2024',
      availableTimeSlots: ['9:00 - 11:00', '11:00 - 13:00'],
    ),
    SpaceModel(
      uid: 'AU-002',
      name: 'Auditorio',
      capacity: 50,
      description: 'Auditorio de excelente acustica',
      type: 'Auditorios',
      imageUrl:
          'https://firebasestorage.googleapis.com/v0/b/univalle-reservation.appspot.com/o/spaces_images%2Fauditorio.png?alt=media&token=1391ff98-528a-4122-b6a8-ee2d5d1d2024',
      availableTimeSlots: ['9:00 - 11:00', '11:00 - 13:00'],
    ),
    SpaceModel(
      uid: 'AU-003',
      name: 'Auditorio',
      capacity: 50,
      description: 'Auditorio de excelente acustica',
      type: 'Auditorios',
      imageUrl:
          'https://firebasestorage.googleapis.com/v0/b/univalle-reservation.appspot.com/o/spaces_images%2Fauditorio.png?alt=media&token=1391ff98-528a-4122-b6a8-ee2d5d1d2024',
      availableTimeSlots: ['9:00 - 11:00', '11:00 - 13:00'],
    ),
    SpaceModel(
      uid: 'AU-004',
      name: 'Auditorio',
      capacity: 50,
      description: 'Auditorio de excelente acustica',
      type: 'Auditorios',
      imageUrl:
          'https://firebasestorage.googleapis.com/v0/b/univalle-reservation.appspot.com/o/spaces_images%2Fauditorio.png?alt=media&token=1391ff98-528a-4122-b6a8-ee2d5d1d2024',
      availableTimeSlots: ['9:00 - 11:00', '11:00 - 13:00'],
    ),
  ];

  for (var space in dummySpaces) {
    var spaceRef =
        FirebaseFirestore.instance.collection('spaces').doc(space.uid);
    batch.set(spaceRef, space.toMap());
  }

  await batch.commit();
  print('Todos los espacios han sido añadidos con éxito');
}
