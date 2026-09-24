import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/api_service.dart';
import '../services/api_client.dart';
import '../services/token_storage.dart';

class AuthProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  UserProfile? _userProfile;
  bool _isCheckingSession = true;
  bool _isLoading = false;
  String? _errorMessage;

  UserProfile? get userProfile => _userProfile;
  bool get isAuthenticated => _userProfile != null;
  bool get isCheckingSession => _isCheckingSession;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Convenience accessor so existing code that reads `currentUser.uid`
  /// (a hangover from the Firebase version) keeps working.
  UserProfile? get currentUser => _userProfile;

  AuthProvider() {
    _restoreSession();
  }

  Future<void> _restoreSession() async {
    final hasTokens = await TokenStorage.accessToken != null;
    if (hasTokens) {
      try {
        _userProfile = await _apiService.getUserProfile();
      } catch (_) {
        await TokenStorage.clear();
        _userProfile = null;
      }
    }
    _isCheckingSession = false;
    notifyListeners();
  }

  Future<bool> signUp(String email, String password, String name) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      _userProfile = await _apiService.signUp(email, password, name);
      return true;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> signIn(String email, String password) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      _userProfile = await _apiService.signIn(email, password);
      return true;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    await _apiService.signOut();
    _userProfile = null;
    notifyListeners();
  }

  void updateProfile(UserProfile profile) {
    _userProfile = profile;
    notifyListeners();
  }
}
