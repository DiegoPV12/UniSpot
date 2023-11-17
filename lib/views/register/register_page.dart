import 'package:flutter/material.dart';
import 'package:unispot/services/auth_service.dart';

import '../../widgets/shared/input_decoration_widget.dart';
import '../../widgets/shared/password_decoration.dart';
import '../login/login_page.dart';
import 'splash_screen.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isPasswordVisible = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign Up"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Image.asset(
                  'assets/UnivalleLogo.png',
                  width: 180,
                  height: 180,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Center(child: Text('Nombre de usuario')),
                      ),
                      TextFormField(
                        controller: _usernameController,
                        decoration: BaseInputDecoration()
                            .getDecoration(),
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Por favor ingrese un nombre de usuario';
                          }
                          return null;
                        },
                      ),
                      const Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Center(child: Text('Correo electrónico')),
                      ),
                      TextFormField(
                        controller: _emailController,
                        decoration: BaseInputDecoration()
                            .getDecoration(),
                        validator: (value) =>
                            _authService.validateEmail(value ?? ''),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Center(child: Text('Contraseña')),
                      ),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: !_isPasswordVisible,
                        decoration: PasswordInputDecoration().getDecoration(
                          hintText: 'Contraseña',
                          isPasswordVisible: _isPasswordVisible,
                          onToggleVisibility: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                        validator: (value) =>
                            _authService.validatePassword(value!),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('¿Ya tienes una cuenta? '),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()),
                      );
                    },
                    child: const Text(
                      'Inicia sesión',
                      style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: SizedBox(
                  width: 320,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final navigator = Navigator.of(context);

                        dynamic result =
                            await _authService.registerWithEmailAndPassword(
                                _emailController.text,
                                _passwordController.text,
                                _usernameController.text);

                        if (result == null) {
                        } else {
                          navigator.pushReplacement(
                            MaterialPageRoute(
                                builder: (context) => const SplashScreen()),
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color.fromRGBO(129, 40, 75, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Registrarse',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
