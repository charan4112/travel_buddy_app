import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

/// Provides authentication state and user info throughout the app.
class UserProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  UserModel? _user;

  UserModel? get user => _user;
  bool get isLoggedIn => _user != null;

  /// Initialize and listen to auth state changes.
  void init() {
    _authService.authStateChanges().listen((fbUser) {
      if (fbUser != null) {
        _user = UserModel(
          uid: fbUser.uid,
          email: fbUser.email!,
          displayName: fbUser.displayName,
          photoUrl: fbUser.photoURL,
        );
      } else {
        _user = null;
      }
      notifyListeners();
    });
  }

  /// Sign in and update provider state.
  Future<void> signIn(String email, String password) async {
    final fbUser = await _authService.signIn(email, password);
    if (fbUser != null) {
      _user = UserModel(
        uid: fbUser.uid,
        email: fbUser.email!,
        displayName: fbUser.displayName,
        photoUrl: fbUser.photoURL,
      );
      notifyListeners();
    }
  }

  /// Register and update provider state.
  Future<void> register(String email, String password) async {
    final fbUser = await _authService.register(email, password);
    if (fbUser != null) {
      _user = UserModel(
        uid: fbUser.uid,
        email: fbUser.email!,
        displayName: fbUser.displayName,
        photoUrl: fbUser.photoURL,
      );
      notifyListeners();
    }
  }

  /// Send password reset link.
  Future<void> sendPasswordReset(String email) async {
    await _authService.sendPasswordReset(email);
  }

  /// Sign out and clear user data.
  Future<void> signOut() async {
    await _authService.signOut();
    _user = null;
    notifyListeners();
  }
}
