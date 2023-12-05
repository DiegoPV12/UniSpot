// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import '../../models/reservation_model.dart';
import '../../models/space_model.dart';
import '../../services/space_service.dart';
import '../../services/reservation_service.dart';
import '/views/reservation_form/reservation_form.dart';

class ReservationCardWidget extends StatelessWidget {
  final ReservationModel reservation;
  final VoidCallback onReservationCancelled;

  const ReservationCardWidget({
    Key? key,
    required this.reservation,
    required this.onReservationCancelled,
  }) : super(key: key);

  String _formatDateTime(Timestamp timestamp) {
    var date = timestamp.toDate();
    return DateFormat('d MMM yyyy', 'es').format(date).toUpperCase();
  }

  String _formatTime(Timestamp timestamp) {
    var date = timestamp.toDate();
    return DateFormat('HH:mm', 'es').format(date);
  }

  void _navigateToEditForm(BuildContext context) {
    SpaceService.instance
        .getSpaceFromFirestore(reservation.spaceId)
        .then((space) {
      Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) =>
                ReservationDetailsForm(space: space, reservation: reservation)),
      );
    }).catchError((error) {});
  }

  void _showCancelConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Cancelar Reserva'),
          content: Text('¿Estás seguro de que quieres cancelar esta reserva?'),
          actions: <Widget>[
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
                onReservationCancelled();
              },
            ),
            TextButton(
              child: Text('Sí'),
              onPressed: () {
                Navigator.of(context).pop();
                ReservationService.instance
                    .changeReservationStatus(reservation.uid, 'cancelled')
                    .then((_) {
                  onReservationCancelled();
                }).catchError((error) {
                  // Manejar el error
                });
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('es_ES', null);

    return FutureBuilder<SpaceModel>(
      future: SpaceService.instance.getSpaceFromFirestore(reservation.spaceId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(color: Color.fromRGBO(129, 40, 75, 1),));
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData) {
          return Center(child: Text('No data available'));
        }
        SpaceModel space = snapshot.data!;

        Widget reservationCard = Card(
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
                  backgroundImage: NetworkImage(space.imageUrl.isNotEmpty
                      ? space.imageUrl[0]
                      : 'assets/placeholder.jpg'),
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
                        color: (reservation.status == 'cancelled' ||
                                reservation.status == 'rejected')
                            ? Colors.red
                            : (reservation.status == 'pending'
                                ? Colors.orange
                                : Colors.green),
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    reservation.status == 'pending'
                        ? IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () => _navigateToEditForm(context),
                          )
                        : Container(),
                  ],
                ),
              ],
            ),
          ),
        );

        // Solo permite deslizar si la reserva no está en estado 'cancelled' ni 'approved'
        bool isSwipeable = reservation.status != 'cancelled' &&
            reservation.status != 'approved';

        return isSwipeable
            ? Dismissible(
                key: Key(reservation.uid),
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Icon(Icons.delete, color: Colors.white),
                ),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) {
                  _showCancelConfirmation(context);
                },
                child: reservationCard,
              )
            : reservationCard;
      },
    );
  }
}
