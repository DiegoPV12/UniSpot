import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart'; // Importa flutter_spinkit para animaciones de carga
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

  void refreshReservations() {
    setState(() {
      // Esto reconstruirá el widget y volverá a buscar todas las reservas
    });
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: SpinKitFadingCircle(
        color: Colors.deepPurple,
        size: 50.0,
      ),
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
              return ProfileWidget(user: adminUser); // Widget de perfil del admin
            },
          ),
          const SizedBox(height: 20),
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
                return ListView.builder(
                  itemCount: reservations.length,
                  itemBuilder: (context, index) {
                    return AdminReservationCardWidget(
                      reservation: reservations[index],
                      onReservationChanged: refreshReservations,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
