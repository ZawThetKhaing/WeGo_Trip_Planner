import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;
  Stream<User?> authStateChange() => auth.authStateChanges();
  Stream<User?> userChange() => auth.userChanges();
}
