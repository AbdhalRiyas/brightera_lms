import 'package:app/src/services/firebase_service.dart';

bool isUserAuthenticated() => FirebaseService().currentUser != null;
