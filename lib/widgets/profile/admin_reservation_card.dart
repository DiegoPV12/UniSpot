import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import '../../models/reservation_model.dart';
import '../../models/space_model.dart';
import '../../services/space_service.dart';
import '../../services/reservation_service.dart';

class AdminReservationCardWidget extends StatelessWidget {
  final ReservationModel reservation;
  final VoidCallback onReservationChanged;

  const AdminReservationCardWidget({
    Key? key,
    required this.reservation,
    required this.onReservationChanged,
  }) : super(key: key);

  String _formatDateTime(Timestamp timestamp) {
    var date = timestamp.toDate();
    return DateFormat('d MMM yyyy', 'es').format(date).toUpperCase();
  }

  String _formatTime(Timestamp timestamp) {
    var date = timestamp.toDate();
    return DateFormat('HH:mm', 'es').format(date);
  }

  void _changeReservationStatus(BuildContext context, String newStatus) {
    ReservationService.instance
        .changeReservationStatus(reservation.uid, newStatus)
        .then((_) {
          onReservationChanged(); // Refresca la lista de reservas
        }).catchError((error) {
          // Manejar el error
        });
  }

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('es_ES', null);

    return FutureBuilder<SpaceModel>(
      future: SpaceService.instance.getSpaceFromFirestore(reservation.spaceId),
      builder: (context, spaceSnapshot) {
        if (spaceSnapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CupertinoActivityIndicator());
        }
        if (spaceSnapshot.hasError) {
          return Center(child: Text('Error: ${spaceSnapshot.error}'));
        }
        if (!spaceSnapshot.hasData) {
          return Center(child: Text('No data available'));
        }
        SpaceModel space = spaceSnapshot.data!;

        Color lightWineColor = Color.fromARGB(255, 255, 255, 255);

        return Card(
          color: lightWineColor,
          elevation: 2,
          margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  space.name,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Divider(),
                Row(
                  children: [
                    Icon(CupertinoIcons.calendar, size: 16),
                    SizedBox(width: 8),
                    Text(_formatDateTime(reservation.day)),
                  ],
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Icon(CupertinoIcons.clock, size: 16),
                    SizedBox(width: 8),
                    Text(
                        '${_formatTime(reservation.startTime)} - ${_formatTime(reservation.endTime)}'),
                  ],
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Icon(CupertinoIcons.mail, size: 16),
                    SizedBox(width: 8),
                    Text('Usuario: ${reservation.userId}'), 
                  ],
                ),
                SizedBox(height: 4),
                Text('Estado: ${reservation.status.toUpperCase()}'),
                SizedBox(height: 4),
                Text('Razón: ${reservation.reason}'),
                SizedBox(height: 4),
                Text('Notas adicionales: ${reservation.additionalNotes}'), 
                SizedBox(height: 4),
                Text('Uso de material: ${reservation.useMaterial ? "Sí" : "No"}'), 
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (reservation.status == 'pending') ...[
                      Ink(
                        decoration: ShapeDecoration(
                          color: Colors.green, 
                          shape: CircleBorder(),
                        ),
                        child: IconButton(
                          icon: Icon(Icons.check, color: Colors.white),
                          onPressed: () => _changeReservationStatus(context, 'approved'),
                        ),
                      ),
                      SizedBox(width: 8),
                      Ink(
                        decoration: ShapeDecoration(
                          color: Colors.red,
                          shape: CircleBorder(),
                        ),
                        child: IconButton(
                          icon: Icon(Icons.close, color: Colors.white),
                          onPressed: () => _changeReservationStatus(context, 'rejected'),
                        ),
                      ),
                    ]
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
