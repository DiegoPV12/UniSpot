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
  final Timestamp day;
  final String? timeSlot;  

  ReservationModel({
    required this.uid,
    required this.userId,
    required this.spaceId,
    required this.startTime,
    required this.endTime,
    this.status = 'pending',
    required this.reason,
    this.additionalNotes = '',
    required this.useMaterial,
    required this.day,
    this.timeSlot,
  });

 factory ReservationModel.fromDocument(DocumentSnapshot doc) {
  return ReservationModel(
    uid: doc['uid'] ?? '',
    userId: doc['userId'] ?? '',
    spaceId: doc['spaceId'] ?? '',
    startTime: doc['startTime'] ?? Timestamp.now(),
    endTime: doc['endTime'] ?? Timestamp.now(),
    status: doc['status'] ?? 'pending',
    reason: doc['reason'] ?? '',
    additionalNotes: doc['additionalNotes'] ?? '',
    useMaterial: doc['useMaterial'] ?? false,
    day: doc['day'] ?? Timestamp.now(),
  );
}


  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'userId': userId,
      'spaceId': spaceId,
      'startTime': startTime,
      'endTime': endTime,
      'status': status,
      'reason': reason,
      'additionalNotes': additionalNotes,
      'useMaterial': useMaterial,
      'day': day,
      'timeSlot': timeSlot, 
    };
  }

  // Método copyWith para facilitar la actualización de instancias
  ReservationModel copyWith({
    String? uid,
    String? userId,
    String? spaceId,
    Timestamp? startTime,
    Timestamp? endTime,
    String? status,
    String? reason,
    String? additionalNotes,
    bool? useMaterial,
    Timestamp? day,
    String? timeSlot, 
  }) {
    return ReservationModel(
      uid: uid ?? this.uid,
      userId: userId ?? this.userId,
      spaceId: spaceId ?? this.spaceId,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      status: status ?? this.status,
      reason: reason ?? this.reason,
      additionalNotes: additionalNotes ?? this.additionalNotes,
      useMaterial: useMaterial ?? this.useMaterial,
      day: day ?? this.day,
      timeSlot: timeSlot ?? this.timeSlot,  
    );
  }
}
