import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'core/Services/App/app.service.dart';
import 'core/Services/Auth/auth.service.dart';
import 'core/Services/Auth/src/Providers/auth_provider.dart';
import 'core/Services/Firebase/firebase.service.dart';
import 'features/authentication/presentation/pages/landing.screen.dart';
import 'features/home/presentation/pages/home.screen.dart';
import 'theme.dart';
import 'util.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await App.initialize(AppEnvironment.dev);

  await FirebaseService.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = createTextTheme(context, "Roboto", "Roboto");
    MaterialTheme theme = MaterialTheme(textTheme);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: theme.light().colorScheme,
        textTheme: textTheme,
      ),
      home: StreamBuilder(
        stream: AuthService(
          authProvider: FirebaseAuthProvider(
            firebaseAuth: FirebaseAuth.instance,
          ),
        ).isUserLoggedIn(),
        builder: (builder, snapshot) {
          if (snapshot.hasData && snapshot.data == true) {
            return const HomeScreen();
          } else {
            return const LandingScreen();
          }
        },
      ),
    );
  }
}
