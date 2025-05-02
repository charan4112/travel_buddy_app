import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Sign in with email & password
  Future<User?> signIn(String email, String password) async {
    final cred = await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );
    return cred.user;
  }

  /// Register a new user with email & password
  Future<User?> register(String email, String password) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );
    return cred.user;
  }

  /// Send a password reset email
  Future<void> sendPasswordReset(String email) async {
    await _auth.sendPasswordResetEmail(email: email.trim());
  }

  /// Sign out the current user
  Future<void> signOut() async {
    await _auth.signOut();
  }

  /// Returns the currently signed-in user, or null
  User? get currentUser => _auth.currentUser;

  /// Listen to auth state changes
  Stream<User?> authStateChanges() => _auth.authStateChanges();
}
