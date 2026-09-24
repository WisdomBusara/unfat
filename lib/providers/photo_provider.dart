import 'package:flutter/material.dart';
import '../models/progress_photo.dart';
import '../models/user.dart';
import '../services/firebase_service.dart';
import '../services/claude_api_service.dart';

class PhotoProvider extends ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();
  late ClaudeAPIService _claudeService;

  Map<String, List<ProgressPhoto>> _photosByAngle = {
    'front': [],
    'side': [],
    'back': [],
  };
  bool _isLoading = false;
  String? _uploadError;

  Map<String, List<ProgressPhoto>> get photosByAngle => _photosByAngle;
  bool get isLoading => _isLoading;
  String? get uploadError => _uploadError;

  PhotoProvider(String claudeApiKey) {
    _claudeService = ClaudeAPIService(claudeApiKey);
  }

  Future<void> loadProgressPhotos(String userId) async {
    try {
      _isLoading = true;
      notifyListeners();

      for (final angle in ['front', 'side', 'back']) {
        _photosByAngle[angle] = await _firebaseService.getProgressPhotos(
          userId,
          angle: angle,
        );
      }
      notifyListeners();
    } catch (e) {
      print('Error loading progress photos: $e');
      _uploadError = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> uploadProgressPhoto(
    String userId,
    String filePath,
    String angle,
    UserProfile userProfile, {
    double? weight,
    String? notes,
  }) async {
    try {
      _isLoading = true;
      _uploadError = null;
      notifyListeners();

      // Upload to Firebase Storage
      final photoUrl = await _firebaseService.uploadProgressPhoto(userId, filePath);

      // Create photo entry
      final photo = ProgressPhoto(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: userId,
        photoUrl: photoUrl,
        angle: angle,
        date: DateTime.now(),
        weight: weight,
        notes: notes ?? '',
      );

      // Analyze with Claude
      final previousPhoto = _photosByAngle[angle]?.isNotEmpty ?? false
          ? _photosByAngle[angle]!.first
          : null;

      final analysis = await _claudeService.analyzeProgressPhoto(
        photo,
        userProfile,
        previousPhoto: previousPhoto,
      );

      photo.aiAnalysis?.addAll(analysis);

      // Save to Firestore
      await _firebaseService.saveProgressPhoto(photo);

      // Update local list
      _photosByAngle[angle]?.insert(0, photo);
      notifyListeners();
    } catch (e) {
      _uploadError = e.toString();
      print('Error uploading photo: $e');
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<ProgressPhoto> getPhotosByAngle(String angle) {
    return _photosByAngle[angle] ?? [];
  }

  ProgressPhoto? getLatestPhoto(String angle) {
    final photos = _photosByAngle[angle];
    return photos?.isNotEmpty ?? false ? photos!.first : null;
  }

  List<ProgressPhoto> getAllPhotos() {
    return [
      ..._photosByAngle['front'] ?? [],
      ..._photosByAngle['side'] ?? [],
      ..._photosByAngle['back'] ?? [],
    ]..sort((a, b) => b.date.compareTo(a.date));
  }
}
