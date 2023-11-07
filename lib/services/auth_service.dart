import 'package:firebase_auth/firebase_auth.dart';
import 'user_service.dart';

class AuthService {
  // SINGLETON ------------------------------
  final FirebaseAuth _auth = FirebaseAuth.instance;
  AuthService._privateConstructor();
  static final AuthService _instance = AuthService._privateConstructor();
  static AuthService get instance => _instance;
  // ----------------------------------------

  final UserService userService = UserService.instance;

  String? validateEmail(String email) {
    if (email.isEmpty) {
      return 'Por favor ingrese su correo';
    } else if (!email.contains('@')) {
      return 'Por favor ingrese un correo válido';
    } else if (!email.endsWith('@est.univalle.edu')) {
      return 'Solo se aceptan correos del dominio @est.univalle.edu';
    }
    return null;
  }

  String? validatePassword(String password) {
    if (password.isEmpty) {
      return 'Por favor ingrese una contraseña';
    } else if (password.length < 6) {
      return 'La contraseña debe tener al menos 6 caracteres';
    }
    return null;
  }

  Future<User?> registerWithEmailAndPassword(
      String email, String password, String username) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? newUser = userCredential.user;
      await newUser?.sendEmailVerification();

      if (newUser != null) {
        await userService.saveUserToFirestore(newUser, username);
      }

      return newUser;
    } catch (e) {
      return null;
    }
  }

  Future<bool> loginWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (!userCredential.user!.emailVerified) {
        return false;
      }

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Stream<User?> get userStream => _auth.authStateChanges();

  Future<User?> getCurrentUser() async {
    return _auth.currentUser;
  }

  Future<User?> refreshUser() async {
    await _auth.currentUser?.reload();
    return _auth.currentUser;
  }
}
