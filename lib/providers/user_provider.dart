import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/firebase_service.dart';

class UserProvider extends ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();
  UserProfile? _userProfile;
  bool _isLoading = false;

  UserProfile? get userProfile => _userProfile;
  bool get isLoading => _isLoading;

  Future<void> loadUserProfile(String uid) async {
    try {
      _isLoading = true;
      notifyListeners();

      _userProfile = await _firebaseService.getUserProfile(uid);
      notifyListeners();
    } catch (e) {
      print('Error loading user profile: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createUserProfile(UserProfile profile) async {
    try {
      await _firebaseService.createUserProfile(profile);
      _userProfile = profile;
      notifyListeners();
    } catch (e) {
      print('Error creating user profile: $e');
    }
  }

  Future<void> updateUserProfile(UserProfile profile) async {
    try {
      await _firebaseService.updateUserProfile(profile);
      _userProfile = profile;
      notifyListeners();
    } catch (e) {
      print('Error updating user profile: $e');
    }
  }
}
