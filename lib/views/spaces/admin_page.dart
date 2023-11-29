import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../models/reservation_model.dart';
import '../../services/reservation_service.dart';
import '../../widgets/profile/profile_widget.dart';
import '../../models/user_model.dart';
import '../../services/user_service.dart';
import '/widgets/profile/admin_reservation_card.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final UserService userService = UserService.instance;
  final ReservationService reservationService = ReservationService.instance;
  String selectedFilter = 'Todas';

  void refreshReservations() {
    setState(() {});
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: SpinKitFadingCircle(
        color: Colors.deepPurple,
        size: 50.0,
      ),
    );
  }

  Widget _buildReservationsSection(String title, List<ReservationModel> reservations) {
    if (reservations.isEmpty) return Container();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        ...reservations.map((reservation) => AdminReservationCardWidget(
          reservation: reservation,
          onReservationChanged: refreshReservations,
        )).toList(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 233, 201, 213),
        title: const Text('Panel de Administración'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          FutureBuilder<UserModel>(
            future: userService.getUserFromFirestore(FirebaseAuth.instance.currentUser!.uid),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return _buildLoadingIndicator();
              }
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
              if (!snapshot.hasData) {
                return const Text('Usuario no disponible');
              }
              UserModel adminUser = snapshot.data!;
              return ProfileWidget(user: adminUser);
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: DropdownButton<String>(
              isExpanded: true,
              value: selectedFilter,
              items: <String>['Todas', 'Pendientes', 'Aprobadas', 'Rechazadas', 'Canceladas']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedFilter = newValue!;
                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder<List<ReservationModel>>(
              future: reservationService.getAllReservations(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return _buildLoadingIndicator();
                }
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('No hay reservas.');
                }

                List<ReservationModel> reservations = snapshot.data!;
                reservations.sort((a, b) => b.day.compareTo(a.day));

                reservations = reservations.where((reservation) {
                  switch (selectedFilter) {
                    case 'Pendientes':
                      return reservation.status == 'pending';
                    case 'Aprobadas':
                      return reservation.status == 'approved';
                    case 'Rechazadas':
                      return reservation.status == 'rejected';
                    case 'Canceladas':
                      return reservation.status == 'cancelled';
                    case 'Todas':
                    default:
                      return true;
                  }
                }).toList();

                return ListView(
                  children: [
                    _buildReservationsSection('Pendientes', reservations.where((r) => r.status == 'pending').toList()),
                    _buildReservationsSection('Aprobadas', reservations.where((r) => r.status == 'approved').toList()),
                    _buildReservationsSection('Rechazadas', reservations.where((r) => r.status == 'rejected').toList()),
                    _buildReservationsSection('Canceladas', reservations.where((r) => r.status == 'cancelled').toList()),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
