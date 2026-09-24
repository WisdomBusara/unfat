import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/user.dart';
import '../models/weight_entry.dart';
import '../models/workout.dart';
import '../models/goal.dart';
import '../models/nutrition.dart';
import '../models/progress_photo.dart';

class FirebaseService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseStorage _storage = FirebaseStorage.instance;

  // Auth
  Future<UserCredential?> signUp(String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      print('Sign up error: ${e.message}');
      return null;
    }
  }

  Future<UserCredential?> signIn(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      print('Sign in error: ${e.message}');
      return null;
    }
  }

  Future<void> signOut() => _auth.signOut();

  User? get currentUser => _auth.currentUser;

  // User Profile
  Future<void> createUserProfile(UserProfile profile) async {
    await _firestore.collection('users').doc(profile.uid).set(profile.toFirestore());
  }

  Future<UserProfile?> getUserProfile(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      return doc.exists ? UserProfile.fromFirestore(doc) : null;
    } catch (e) {
      print('Error fetching user profile: $e');
      return null;
    }
  }

  Future<void> updateUserProfile(UserProfile profile) async {
    await _firestore
        .collection('users')
        .doc(profile.uid)
        .update({'updatedAt': Timestamp.now(), ...profile.toFirestore()});
  }

  // Weight Tracking
  Future<void> addWeightEntry(WeightEntry entry) async {
    await _firestore
        .collection('users')
        .doc(entry.userId)
        .collection('weight')
        .doc(entry.id)
        .set(entry.toFirestore());
  }

  Future<List<WeightEntry>> getWeightHistory(String userId, {int days = 90}) async {
    final startDate = DateTime.now().subtract(Duration(days: days));
    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('weight')
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
        .orderBy('date', descending: true)
        .get();

    return snapshot.docs.map((doc) => WeightEntry.fromFirestore(doc)).toList();
  }

  Future<WeightEntry?> getLatestWeight(String userId) async {
    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('weight')
        .orderBy('date', descending: true)
        .limit(1)
        .get();

    return snapshot.docs.isEmpty ? null : WeightEntry.fromFirestore(snapshot.docs.first);
  }

  // Workouts
  Future<void> logWorkout(WorkoutSession workout) async {
    await _firestore
        .collection('users')
        .doc(workout.userId)
        .collection('workouts')
        .doc(workout.id)
        .set(workout.toFirestore());
  }

  Future<List<WorkoutSession>> getWorkoutHistory(String userId, {int days = 90}) async {
    final startDate = DateTime.now().subtract(Duration(days: days));
    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('workouts')
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
        .orderBy('date', descending: true)
        .get();

    return snapshot.docs.map((doc) => WorkoutSession.fromFirestore(doc)).toList();
  }

  // Goals
  Future<void> createGoal(Goal goal) async {
    await _firestore
        .collection('users')
        .doc(goal.userId)
        .collection('goals')
        .doc(goal.id)
        .set(goal.toFirestore());
  }

  Future<List<Goal>> getActiveGoals(String userId) async {
    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('goals')
        .where('completed', isEqualTo: false)
        .orderBy('targetDate')
        .get();

    return snapshot.docs.map((doc) => Goal.fromFirestore(doc)).toList();
  }

  Future<void> updateGoal(Goal goal) async {
    await _firestore
        .collection('users')
        .doc(goal.userId)
        .collection('goals')
        .doc(goal.id)
        .update(goal.toFirestore());
  }

  // Nutrition
  Future<void> logMeal(MealEntry meal) async {
    await _firestore
        .collection('users')
        .doc(meal.userId)
        .collection('meals')
        .doc(meal.id)
        .set(meal.toFirestore());
  }

  Future<List<MealEntry>> getDailyMeals(String userId, DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(Duration(days: 1));

    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('meals')
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
        .where('date', isLessThan: Timestamp.fromDate(endOfDay))
        .get();

    return snapshot.docs.map((doc) => MealEntry.fromFirestore(doc)).toList();
  }

  // Progress Photos
  Future<String> uploadProgressPhoto(String userId, String filePath) async {
    try {
      final fileName = '${userId}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final ref = _storage.ref('progress_photos').child(userId).child(fileName);
      await ref.putFile(File(filePath));
      return await ref.getDownloadURL();
    } catch (e) {
      print('Error uploading photo: $e');
      rethrow;
    }
  }

  Future<void> saveProgressPhoto(ProgressPhoto photo) async {
    await _firestore
        .collection('users')
        .doc(photo.userId)
        .collection('progress_photos')
        .doc(photo.id)
        .set(photo.toFirestore());
  }

  Future<List<ProgressPhoto>> getProgressPhotos(String userId, {String? angle}) async {
    var query = _firestore
        .collection('users')
        .doc(userId)
        .collection('progress_photos')
        .orderBy('date', descending: true);

    if (angle != null) {
      query = query.where('angle', isEqualTo: angle);
    }

    final snapshot = await query.get();
    return snapshot.docs.map((doc) => ProgressPhoto.fromFirestore(doc)).toList();
  }

  Future<void> updatePhotoAnalysis(String userId, String photoId, Map<String, dynamic> analysis) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('progress_photos')
        .doc(photoId)
        .update({'aiAnalysis': analysis});
  }
}
