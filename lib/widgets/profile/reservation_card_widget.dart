import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import '../../models/reservation_model.dart';
import '../../models/space_model.dart';
import '../../services/space_service.dart';

class ReservationCardWidget extends StatelessWidget {
  final ReservationModel reservation;

  const ReservationCardWidget({
    super.key,
    required this.reservation,
  });

  String _formatDateTime(Timestamp timestamp) {
    var date = timestamp.toDate();
    return DateFormat('d MMM yyyy', 'es').format(date).toUpperCase();
  }

  String _formatTime(Timestamp timestamp) {
    var date = timestamp.toDate();
    return DateFormat('HH:mm', 'es').format(date);
  }

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('es_ES', null);

    return FutureBuilder<SpaceModel>(
      future: SpaceService.instance.getSpaceFromFirestore(reservation.spaceId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return const Text('Error al cargar los datos del espacio');
        }
        if (!snapshot.hasData) {
          return const Text('Espacio no encontrado');
        }
        SpaceModel space = snapshot.data!;

        return Card(
          surfaceTintColor: const Color.fromARGB(255, 233, 201, 213),
          elevation: 5,
          margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
          child: Container(
            width: double.infinity,
            height: 120.0,
            padding: const EdgeInsets.all(15.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                CircleAvatar(
                  backgroundImage: NetworkImage(space.imageUrl),
                  radius: 35.0,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          space.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15.0,
                          ),
                        ),
                        const SizedBox(height: 5.0),
                        Text(
                          _formatDateTime(reservation.day),
                          style: const TextStyle(
                            fontSize: 14.0,
                          ),
                        ),
                        const SizedBox(height: 5.0),
                        Text(
                          '${_formatTime(reservation.startTime)} - ${_formatTime(reservation.endTime)}',
                        )
                      ],
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      reservation.status.toUpperCase(),
                      style: TextStyle(
                        color: reservation.status == 'pending'
                            ? Colors.orange
                            : Colors.green,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
