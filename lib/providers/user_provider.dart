import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/api_service.dart';

class UserProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  UserProfile? _userProfile;
  bool _isLoading = false;

  UserProfile? get userProfile => _userProfile;
  bool get isLoading => _isLoading;

  void setFromAuth(UserProfile profile) {
    _userProfile = profile;
    notifyListeners();
  }

  Future<void> loadUserProfile() async {
    try {
      _isLoading = true;
      notifyListeners();

      _userProfile = await _apiService.getUserProfile();
      notifyListeners();
    } catch (e) {
      print('Error loading user profile: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateUserProfile(UserProfile profile) async {
    try {
      _userProfile = await _apiService.updateUserProfile(profile);
      notifyListeners();
    } catch (e) {
      print('Error updating user profile: $e');
    }
  }
}
