import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:hr_attendance_tracker/providers/profile_provider.dart';
import 'package:hr_attendance_tracker/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  User? _user;
  String? _errorMessage;
  bool _isLoading = false;
  bool _isInitialized = false;

  User? get user => _user;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  bool get isInitialized => _isInitialized;

  AuthProvider() {
    _initializeAuthState();
  }

  void _initializeAuthState() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      _user = user;
      _isInitialized = true;

      if (user != null) {
        await saveUserUID(user.uid);
      } else {
        await clearAllPreferences();
      }

      notifyListeners();
    });
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<bool> signInWithEmail(
    String email,
    String password,
    ProfileProvider profileProvider,
  ) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      final user = await _authService.signInWithEmail(email, password);

      if (user != null) {
        await saveUserUID(user.uid);
        await profileProvider.loadProfile(user.uid);
        print("User signed in: ${user.uid}");
        return true;
      }
      return false;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> registerWithEmail(
    String email,
    String password,
    ProfileProvider profileProvider,
  ) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      final user = await _authService.registerWithEmail(email, password);

      if (user != null) {
        await signOut();
        print("User registered successfully: ${user.uid}");
        return true;
      }
      return false;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> signInWithGoogle(ProfileProvider profileProvider) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      final user = await _authService.signInWithGoogle();

      if (user != null) {
        await saveUserUID(user.uid);
        await profileProvider.loadProfile(user.uid);
        print("User signed in with Google: ${user.uid}");
        return true;
      }
      return false;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signOut() async {
    try {
      await _authService.signOut();
      notifyListeners();
    } catch (e) {
      _errorMessage = "Failed to sign out: $e";
      notifyListeners();
    }
  }

  Future<void> saveUserUID(String uid) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('uid', uid);
    } catch (e) {
      print('Failed to save user UID: $e');
    }
  }

  Future<String?> loadUserUID() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('uid');
    } catch (e) {
      print('Failed to get user UID: $e');
      return null;
    }
  }

  Future<void> clearAllPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
    } catch (e) {
      print('Failed to clear preferences: $e');
    }
  }
}
