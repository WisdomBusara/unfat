import 'package:flutter/material.dart';
import '../models/progress_photo.dart';
import '../services/api_service.dart';

class PhotoProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  Map<String, List<ProgressPhoto>> _photosByAngle = {
    'front': [],
    'side': [],
    'back': [],
  };
  bool _isLoading = false;
  bool _isUploading = false;
  String? _uploadError;

  Map<String, List<ProgressPhoto>> get photosByAngle => _photosByAngle;
  bool get isLoading => _isLoading;
  bool get isUploading => _isUploading;
  String? get uploadError => _uploadError;

  Future<void> loadProgressPhotos() async {
    try {
      _isLoading = true;
      notifyListeners();

      final all = await _apiService.getProgressPhotos();
      _photosByAngle = {
        'front': all.where((p) => p.angle == 'front').toList(),
        'side': all.where((p) => p.angle == 'side').toList(),
        'back': all.where((p) => p.angle == 'back').toList(),
      };
      notifyListeners();
    } catch (e) {
      print('Error loading progress photos: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Uploads the photo; the backend stores it in MinIO and runs Claude
  /// vision analysis before returning, so this resolves with the finished
  /// AI feedback already attached.
  Future<ProgressPhoto?> uploadProgressPhoto({
    required String filePath,
    required String angle,
    double? weight,
    String? notes,
  }) async {
    try {
      _isUploading = true;
      _uploadError = null;
      notifyListeners();

      final photo = await _apiService.uploadProgressPhoto(
        filePath: filePath,
        angle: angle,
        weight: weight,
        notes: notes,
      );

      _photosByAngle[angle]?.insert(0, photo);
      notifyListeners();
      return photo;
    } catch (e) {
      _uploadError = e.toString();
      print('Error uploading photo: $e');
      notifyListeners();
      return null;
    } finally {
      _isUploading = false;
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
