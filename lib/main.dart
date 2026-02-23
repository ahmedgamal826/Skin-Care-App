import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/Services/App/app.service.dart';
import 'core/Services/Auth/auth.service.dart';
import 'core/Services/Auth/src/Providers/auth_provider.dart';
import 'core/Services/Firebase/firebase.service.dart';
import 'core/localization/app_localizations.dart';
import 'core/localization/locale_provider.dart';
import 'features/authentication/presentation/pages/landing.screen.dart';
import 'features/home/presentation/pages/home.screen.dart';
import 'theme.dart';
import 'util.dart';

/// Global locale provider instance accessible throughout the app.
final LocaleProvider localeProvider = LocaleProvider();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await App.initialize(AppEnvironment.dev);

  await FirebaseService.initialize();

  // Load the user's saved language preference
  await localeProvider.loadSavedLocale();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // Rebuild the app whenever the locale changes
    localeProvider.addListener(_onLocaleChanged);
  }

  void _onLocaleChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    localeProvider.removeListener(_onLocaleChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = createTextTheme(context, "Roboto", "Roboto");
    MaterialTheme theme = MaterialTheme(textTheme);

    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // ─── Localization Setup ───────────────────────────────────
      locale: localeProvider.locale,
      supportedLocales: const [
        Locale('en'),
        Locale('ar'),
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      // ─── Theme ────────────────────────────────────────────────
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: theme.light().colorScheme,
        textTheme: textTheme,
      ),

      // ─── Home / Auth ──────────────────────────────────────────
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
