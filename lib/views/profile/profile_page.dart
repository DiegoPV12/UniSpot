import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/reservation_model.dart';
import '../../models/user_model.dart';
import '../../services/user_service.dart';
import '../../services/reservation_service.dart';
import '../../widgets/profile/profile_widget.dart';
import '../../widgets/profile/reservation_card_widget.dart';
import '../../widgets/shared/navbar.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final UserService userService = UserService.instance;
  final ReservationService reservationService = ReservationService.instance;
  final currentUserUid = FirebaseAuth.instance.currentUser!.uid;
  String selectedFilter = 'Todas';

  void refreshReservations() {
    setState(() {});
  }

  void _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).pushReplacementNamed('/login');
    } catch (e) {
      print('Error al cerrar sesión: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: const Color.fromARGB(255, 233, 201, 213),
        title: const Text(
          'Perfil de Usuario',
          style: TextStyle(fontWeight: FontWeight.w100),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _signOut(context),
          ),
        ],
      ),
      bottomNavigationBar: CustomNavigationBar(
        currentIndex: 1,
        navigationContext: context,
      ),
      body: Column(
        children: [
          FutureBuilder<UserModel>(
            future: userService.getUserFromFirestore(currentUserUid),
            builder: (BuildContext context, AsyncSnapshot<UserModel> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator(color: Color.fromRGBO(129, 40, 75, 1),));
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              if (!snapshot.hasData) {
                return const Center(child: Text('El usuario no existe.'));
              }
              UserModel user = snapshot.data!;
              return ProfileWidget(user: user); // Tu widget de perfil de usuario
            },
          ),
          const SizedBox(height: 20),
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
              future: reservationService.getReservationsByUserId(currentUserUid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: Color.fromRGBO(129, 40, 75, 1),));
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No hay reservas.'));
                }
                List<ReservationModel> reservations = snapshot.data!;
                reservations.sort((a, b) => b.day.compareTo(a.day)); // Ordena por fecha más reciente

                reservations = reservations.where((reservation) {
                  switch (selectedFilter) {
                    case 'Pendientes':
                      return reservation.status == 'pending';
                    case 'Aprobadas':
                      return reservation.status == 'approved';
                    case 'Rechazadas':
                    case 'Canceladas':
                      return reservation.status == 'rejected' || reservation.status == 'cancelled';
                    case 'Todas':
                    default:
                      return true;
                  }
                }).toList();

                return ListView.builder(
                  itemCount: reservations.length,
                  itemBuilder: (context, index) {
                    return ReservationCardWidget(
                      reservation: reservations[index],
                      onReservationCancelled: refreshReservations,
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
