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

  const ReservationCardWidget({
    Key? key,
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

  void _navigateToEditForm(BuildContext context) {
    SpaceService.instance
        .getSpaceFromFirestore(reservation.spaceId)
        .then((space) {
      Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) =>
                ReservationDetailsForm(space: space, reservation: reservation)),
      );
    }).catchError((error) {
      // Manejar error en caso de que la consulta falle
    });
  }

  void _cancelReservation(BuildContext context) {
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
              },
            ),
            TextButton(
              child: Text('Sí'),
              onPressed: () {
                ReservationService.instance
                    .cancelReservation(reservation.uid)
                    .then((_) {
                  // Cierra el diálogo
                  Navigator.of(context).pop();
                  // Implementar lógica adicional si es necesario, como actualizar la UI
                  // Por ejemplo, puedes eliminar la reserva cancelada de la lista de reservas
                  removeReservation(reservation);
                }).catchError((error) {
                  // Manejar el error
                  Navigator.of(context).pop(); // Cierra el diálogo
                });
              },
            ),
          ],
        );
      },
    );
  }

  // Define un método para eliminar la reserva cancelada de la lista
  void removeReservation(ReservationModel reservation) {
    // Implementa esta lógica según tu estructura de datos
    // Por ejemplo, si tienes una lista llamada reservations, puedes hacer:
    // reservations.remove(reservation);
    // Asegúrate de tener acceso a la lista de reservas en el estado de tu widget
  }

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('es_ES', null);

    return FutureBuilder<SpaceModel>(
      future: SpaceService.instance.getSpaceFromFirestore(reservation.spaceId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData) {
          return Center(child: Text('No data available'));
        }
        SpaceModel space = snapshot.data!;

        return Dismissible(
          key: Key(reservation.uid),
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Icon(Icons.delete, color: Colors.white),
          ),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) {
            _cancelReservation(context);
          },
          child: Card(
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
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => _navigateToEditForm(context),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
