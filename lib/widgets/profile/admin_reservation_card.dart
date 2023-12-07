import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import '../../models/reservation_model.dart';
import '../../models/space_model.dart';
import '../../services/space_service.dart';
import '../../services/reservation_service.dart';
import '../../services/user_service.dart';
import '../../models/user_model.dart';
import '../../services/email_service.dart';

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

  void _changeReservationStatus(
      BuildContext context, String newStatus, String userEmail) {
    ReservationService.instance
        .changeReservationStatus(reservation.uid, newStatus)
        .then((_) {
      // Notificar al usuario por correo electrónico
      EmailService.sendEmail(
        to: userEmail, // Usa el correo electrónico pasado como parámetro
        subject: 'Estado de tu Reserva en UniSpot',
        body: 'Tu reserva ha sido ${newStatus == 'approved' ? 'aprobada' : 'rechazada'}.',
      );
      onReservationChanged();
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
          return const Center(child: CircularProgressIndicator(color: Color.fromRGBO(129, 40, 75, 1),));
        }
        if (spaceSnapshot.hasError) {
          return Center(child: Text('Error: ${spaceSnapshot.error}'));
        }
        if (!spaceSnapshot.hasData) {
          return const Center(child: Text('No data available'));
        }
        SpaceModel space = spaceSnapshot.data!;

        return FutureBuilder<UserModel>(
          future: UserService.instance.getUserFromFirestore(reservation.userId),
          builder: (context, userSnapshot) {
            if (userSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(color: Color.fromRGBO(129, 40, 75, 1),));
            }
            if (userSnapshot.hasError || !userSnapshot.hasData) {
              return const Center(child: Text('Usuario no disponible'));
            }
            UserModel user = userSnapshot.data!;

            return Card(
              color: Colors.white,
              elevation: 2,
              margin:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '${space.name}: ${space.uid}',
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Divider(),
                    RichText(
                      text: TextSpan(
                        style: DefaultTextStyle.of(context).style,
                        children: [
                          const WidgetSpan(
                            child: Icon(CupertinoIcons.calendar, size: 16),
                          ),
                          const TextSpan(
                            text: ' Fecha: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: _formatDateTime(reservation.day)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    RichText(
                      text: TextSpan(
                        style: DefaultTextStyle.of(context).style,
                        children: [
                          const WidgetSpan(
                            child: Icon(CupertinoIcons.clock, size: 16),
                          ),
                          const TextSpan(
                            text: ' Hora: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                              text:
                                  '${_formatTime(reservation.startTime)} - ${_formatTime(reservation.endTime)}'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    RichText(
                      text: TextSpan(
                        style: DefaultTextStyle.of(context).style,
                        children: [
                          const WidgetSpan(
                            child: Icon(Icons.person, size: 16),
                          ),
                          const TextSpan(
                            text: ' Usuario: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: user.username),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    RichText(
                      text: TextSpan(
                        style: DefaultTextStyle.of(context).style,
                        children: [
                          const WidgetSpan(
                            child: Icon(Icons.info_outline, size: 16),
                          ),
                          const TextSpan(
                            text: ' Estado: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: reservation.status.toUpperCase()),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    RichText(
                      text: TextSpan(
                        style: DefaultTextStyle.of(context).style,
                        children: [
                          const WidgetSpan(
                            child: Icon(Icons.rate_review, size: 16),
                          ),
                          const TextSpan(
                            text: ' Razón: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: reservation.reason),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    RichText(
                      text: TextSpan(
                        style: DefaultTextStyle.of(context).style,
                        children: [
                          const WidgetSpan(
                            child: Icon(Icons.notes, size: 16),
                          ),
                          const TextSpan(
                            text: ' Notas adicionales: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: reservation.additionalNotes ?? 'N/A'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    RichText(
                      text: TextSpan(
                        style: DefaultTextStyle.of(context).style,
                        children: [
                          const WidgetSpan(
                            child: Icon(Icons.build_circle, size: 16),
                          ),
                          const TextSpan(
                            text: ' Solicita material: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: reservation.useMaterial ? 'Sí' : 'No',
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (reservation.status == 'pending') ...[
                          Ink(
                            decoration: const ShapeDecoration(
                              color: Colors.green,
                              shape: CircleBorder(),
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.check, color: Colors.white),
                              onPressed: () => _changeReservationStatus(
                                  context,
                                  'approved',
                                  user.email), // Pasar el email del usuario
                            ),
                          ),
                          const SizedBox(width: 8),
                          Ink(
                            decoration: const ShapeDecoration(
                              color: Colors.red,
                              shape: CircleBorder(),
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.close, color: Colors.white),
                              onPressed: () => _changeReservationStatus(
                                  context,
                                  'rejected',
                                  user.email), // Pasar el email del usuario
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
