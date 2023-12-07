import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:unispot/firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:unispot/services/space_service.dart';
import 'views/register/register_page.dart';
import 'views/spaces/bloc/spaces_bloc.dart';
import 'views/login/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await initializeDateFormatting('es_ES', null);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<SpacesBloc>(
          create: (context) => SpacesBloc(spaceService: SpaceService.instance),
          dispose: (context, bloc) => bloc.close(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          fontFamily: 'Inter',
          textSelectionTheme: const TextSelectionThemeData(
            selectionHandleColor: Color.fromARGB(255, 129, 40, 75),
          ),
        ),
        home: const MyHomePage(title: 'Flutter Demo Home Page'),
        routes: {
          '/login': (context) => const LoginPage(),
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return const RegisterPage();
  }
}
