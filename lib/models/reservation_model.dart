import 'package:cloud_firestore/cloud_firestore.dart';

class ReservationModel {
  final String uid;
  final String userId;
  final String spaceId;
  final Timestamp startTime;
  final Timestamp endTime;
  final String status;
  final String reason;
  final String additionalNotes;
  final bool useMaterial;
  final Timestamp day; // Suponiendo que el día se guarda como Timestamp

  ReservationModel({
    required this.uid,
    required this.userId,
    required this.spaceId,
    required this.startTime,
    required this.endTime,
    required this.reason,
    this.status = 'pending',
    this.additionalNotes = '',
    required this.useMaterial,
    required this.day,
  });

  factory ReservationModel.fromDocument(DocumentSnapshot doc) {
    return ReservationModel(
      uid: doc['uid'],
      userId: doc['userId'],
      spaceId: doc['spaceId'],
      startTime: doc['startTime'],
      endTime: doc['endTime'],
      status: doc['status'],
      reason: doc['reason'],
      additionalNotes: doc['additionalNotes'],
      useMaterial: doc['useMaterial'],
      day: doc['day'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'userId': userId,
      'spaceId': spaceId,
      'startTime': startTime,
      'endTime': endTime,
      'status': status,
      'additionalNotes': additionalNotes,
      'reason':reason,
      'useMaterial': useMaterial,
      'day': day,
    };
  }
}
