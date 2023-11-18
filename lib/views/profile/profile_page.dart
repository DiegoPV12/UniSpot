import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/user_model.dart';
import '../../services/user_service.dart';
import '../../widgets/profile/profile_widget.dart';
import '../../widgets/shared/navbar.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final UserService userService = UserService.instance;
  final currentUserUid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 233, 201, 213),
        title: const Text(
          'Perfil de Usuario',
          style: TextStyle(fontWeight: FontWeight.w100),
        ),
        centerTitle: true,
      ),
      bottomNavigationBar: CustomNavigationBar(
        currentIndex: 1, 
        navigationContext: context,
      ),
      body: FutureBuilder<UserModel>(
        future: userService.getUserFromFirestore(currentUserUid),
        builder: (BuildContext context, AsyncSnapshot<UserModel> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('El usuario no existe.'));
          }

          UserModel user = snapshot.data!;

          return ProfileWidget(user: user);
        },
      ),
    );
  }
}
