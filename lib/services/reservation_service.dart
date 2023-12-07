import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/reservation_model.dart';

class ReservationService {
  final CollectionReference reservationsRef =
      FirebaseFirestore.instance.collection('reservations');

  ReservationService._privateConstructor();
  static final ReservationService _instance =
      ReservationService._privateConstructor();
  static ReservationService get instance => _instance;

  Future<void> createReservation({
    required String spaceId,
    required String reason,
    String? additionalNotes,
    required bool useMaterial,
    required DateTime day,
    required TimeOfDay startTime,
    required TimeOfDay endTime,
  }) async {
    DateTime startDateTime = DateTime(
      day.year,
      day.month,
      day.day,
      startTime.hour,
      startTime.minute,
    );
    DateTime endDateTime = DateTime(
      day.year,
      day.month,
      day.day,
      endTime.hour,
      endTime.minute,
    );

    bool isAvailable = await _checkSpaceAvailability(
        spaceId,
        Timestamp.fromDate(startDateTime),
        Timestamp.fromDate(endDateTime),
    );
    if (!isAvailable) {
      throw Exception('El espacio ya está reservado para este horario');
    }

    String currentUserId = FirebaseAuth.instance.currentUser!.uid;

    DocumentReference reservationRef = await reservationsRef.add({
      'userId': currentUserId,
      'spaceId': spaceId,
      'startTime': Timestamp.fromDate(startDateTime),
      'endTime': Timestamp.fromDate(endDateTime),
      'status': 'pending',
      'reason': reason,
      'additionalNotes': additionalNotes ?? '',
      'useMaterial': useMaterial,
      'day': Timestamp.fromDate(day),
    });

    await reservationRef.update({
      'uid': reservationRef.id,
    });
  }

  Future<void> updateReservation(ReservationModel reservation) async {
    await reservationsRef.doc(reservation.uid).update(reservation.toJson());
  }

  Future<void> cancelReservation(String reservationId) async {
    await reservationsRef.doc(reservationId).delete();
  }

  Future<bool> _checkSpaceAvailability(
      String spaceId, Timestamp startTime, Timestamp endTime) async {
    QuerySnapshot snapshot = await reservationsRef
        .where('spaceId', isEqualTo: spaceId)
        .get();

    for (var doc in snapshot.docs) {
      DateTime existingStart = doc['startTime'].toDate();
      DateTime existingEnd = doc['endTime'].toDate();

      if (existingEnd.isAfter(startTime.toDate()) &&
          existingStart.isBefore(endTime.toDate())) {
        return false;
      }
    }
    return true;
  }

  Future<ReservationModel> getReservation(String uid) async {
    DocumentSnapshot doc = await reservationsRef.doc(uid).get();
    if (doc.exists) {
      return ReservationModel.fromDocument(doc);
    }
    throw Exception('La reserva no existe');
  }

  Future<List<ReservationModel>> getReservationsByUserId(String userId) async {
    QuerySnapshot querySnapshot =
        await reservationsRef.where('userId', isEqualTo: userId).get();
    return querySnapshot.docs
        .map((doc) => ReservationModel.fromDocument(doc))
        .toList();
  }

  Future<void> changeReservationStatus(String reservationId, String newStatus) async {
    await FirebaseFirestore.instance
        .collection('reservations')
        .doc(reservationId)
        .update({'status': newStatus});
  }

  Future<List<ReservationModel>> getAllReservations() async {
    QuerySnapshot querySnapshot = await reservationsRef.get();
    return querySnapshot.docs
        .map((doc) => ReservationModel.fromDocument(doc))
        .toList();
  }

  Future<List<ReservationModel>> getApprovedReservations() async {
    QuerySnapshot querySnapshot = await reservationsRef
        .where('status', isEqualTo: 'approved')
        .get();
    return querySnapshot.docs
        .map((doc) => ReservationModel.fromDocument(doc))
        .toList();
  }
}
