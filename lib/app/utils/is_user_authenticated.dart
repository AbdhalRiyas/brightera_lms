import 'package:app/app/services/firebase_service.dart';

bool isUserAuthenticated() => FirebaseService().currentUser != null;
