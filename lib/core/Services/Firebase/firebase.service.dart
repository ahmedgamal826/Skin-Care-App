// ignore_for_file: depend_on_referenced_packages
//t2 Core Packages Imports
import 'package:firebase_core/firebase_core.dart';

//t2 Dependancies Imports
//t3 Services
// import '../Error Handling/error_handling.service.dart';
import '../Error Handling/error_handling.service.dart';
import '../Logging/logging.service.dart';
//t3 Models
import '../../../firebase_options.dart';
//t1 Exports

class FirebaseService {
  static Future<FirebaseApp> initialize() async {
    try {
      if (Firebase.apps.isNotEmpty) {
        final app = Firebase.app();
        LoggingService.log("Firebase App already initialized: ${app.name}");
        return app;
      }

      final app = await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      LoggingService.log("Firebase App Initialized: ${app.name}");
      return app;
    } catch (e, s) {
      ErrorHandlingService.handle(e, 'FirebaseService/initialize',
          stackTrace: s);
      rethrow;
    }
  }
}
