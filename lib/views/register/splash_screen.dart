import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../services/auth_service.dart';
import '../profile/profile_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AuthService _authService = AuthService.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(129, 40, 75, 1),
      body: StreamBuilder(
        stream: Stream.periodic(const Duration(seconds: 5)),
        builder: (context, snapshot) {
          return FutureBuilder<User?>(
            future: _authService.refreshUser(),
            builder: (context, futureSnapshot) {
              if (futureSnapshot.hasData &&
                  futureSnapshot.data!.emailVerified) {
                Future.delayed(Duration.zero, () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                        builder: (context) => const ProfilePage()),
                  );
                });
              }
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Verificación de Correo",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Card(
                        elevation: 0,
                        color: Color(0xFFECDFE4),
                        child: SizedBox(
                          height: 200,
                          width: 300,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(
                                  color: Color.fromRGBO(129, 40, 75, 1)),
                              Padding(
                                padding: EdgeInsets.all(20.0),
                                child: Text(
                                  "Hemos enviado un correo de verificación. Por favor, verifica tu correo electrónico y sigue las instrucciones.",
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
