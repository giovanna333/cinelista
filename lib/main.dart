import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart'; // gerado pelo comando `flutterfire configure`
import 'models/movie.dart';
import 'routes.dart';
import 'screens/auth_gate.dart';
import 'screens/movie_form_screen.dart';
import 'screens/register_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const CineListaApp());
}

class CineListaApp extends StatelessWidget {
  const CineListaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CineLista',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
      // O AuthGate decide: logado -> Home | deslogado -> Login
      home: const AuthGate(),
      routes: {
        AppRoutes.register: (_) => const RegisterScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == AppRoutes.movieForm) {
          final movie = settings.arguments as Movie?;
          return MaterialPageRoute(builder: (_) => MovieFormScreen(movie: movie));
        }
        return null;
      },
    );
  }
}
