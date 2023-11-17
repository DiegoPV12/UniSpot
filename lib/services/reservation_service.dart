import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/reservation_model.dart';

class ReservationService {
  final CollectionReference reservationsRef =
      FirebaseFirestore.instance.collection('reservations');

  // SINGLETON ------------------------------
  ReservationService._privateConstructor();
  static final ReservationService _instance =
      ReservationService._privateConstructor();
  static ReservationService get instance => _instance;
  // ----------------------------------------

  Future<void> createReservation({
    required String spaceId,
    required String reason,
    String? additionalNotes,
    String? timeSlot,
    required bool useMaterial,
    required Timestamp day,
  }) async {
    Map<String, Timestamp> times = _convertTimeSlot(timeSlot, day);

    // Verificar la disponibilidad antes de crear la reserva
    bool isAvailable = await _checkSpaceAvailability(
        spaceId, times['startTime']!, times['endTime']!);
    if (!isAvailable) {
      throw Exception('El espacio ya está reservado para este horario');
    }

    String currentUserId = FirebaseAuth.instance.currentUser!.uid;

    // Crea un nuevo documento y obtiene su referencia
    DocumentReference reservationRef = await reservationsRef.add({
      'userId': currentUserId,
      'spaceId': spaceId,
      'startTime': times['startTime'],
      'endTime': times['endTime'],
      'status': 'pending',
      'reason': reason,
      'additionalNotes': additionalNotes ?? '',
      'useMaterial': useMaterial,
      'day': day,
    });

    // Actualiza el documento recién creado con su propio UID
    await reservationRef.update({
      'uid': reservationRef.id,
    });
  }

  Map<String, Timestamp> _convertTimeSlot(String? timeSlot, Timestamp day) {
    DateTime dayDate = day.toDate();
    List<String> times = timeSlot!.split(' - ');
    DateTime startTime = DateTime(dayDate.year, dayDate.month, dayDate.day,
        int.parse(times[0].split(':')[0]), int.parse(times[0].split(':')[1]));
    DateTime endTime = DateTime(dayDate.year, dayDate.month, dayDate.day,
        int.parse(times[1].split(':')[0]), int.parse(times[1].split(':')[1]));

    return {
      'startTime': Timestamp.fromDate(startTime),
      'endTime': Timestamp.fromDate(endTime),
    };
  }

  Future<bool> _checkSpaceAvailability(
      String spaceId, Timestamp startTime, Timestamp endTime) async {
    DateTime startDate = DateTime(
      startTime.toDate().year,
      startTime.toDate().month,
      startTime.toDate().day,
    );
    DateTime endDate = DateTime(
      endTime.toDate().year,
      endTime.toDate().month,
      endTime.toDate().day,
    );

    QuerySnapshot snapshot =
        await reservationsRef.where('spaceId', isEqualTo: spaceId).get();

    for (var doc in snapshot.docs) {
      DateTime existingStart = DateTime(
        doc['startTime'].toDate().year,
        doc['startTime'].toDate().month,
        doc['startTime'].toDate().day,
      );
      DateTime existingEnd = DateTime(
        doc['endTime'].toDate().year,
        doc['endTime'].toDate().month,
        doc['endTime'].toDate().day,
      );
      String existingStatus = doc['status'];

      // Solo restringir nuevas reservas si existe una aprobada en el mismo horario
      if (existingStatus != 'pending' &&
          startDate.isAtSameMomentAs(existingStart) &&
          endDate.isAtSameMomentAs(existingEnd)) {
        if (!(endTime.seconds <= doc['startTime'].seconds ||
            startTime.seconds >= doc['endTime'].seconds)) {
          return false; // No disponible debido a una reserva aprobada
        }
      }
    }
    return true; // Disponible o solo reservas pendientes en el horario
  }

  Future<ReservationModel> getReservation(String uid) async {
    DocumentSnapshot doc = await reservationsRef.doc(uid).get();
    if (doc.exists) {
      return ReservationModel.fromDocument(doc);
    }
    throw Exception('La reserva no existe');
  }

  // Puedes agregar otros métodos como updateReservation, deleteReservation...
}
