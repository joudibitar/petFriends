import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      print("User signed in: ${userCredential.user!.uid}");
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> register(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      print("User registered: ${userCredential.user!.uid}");
    } catch (e) {
      print("Error: $e");
    }
  }
}
