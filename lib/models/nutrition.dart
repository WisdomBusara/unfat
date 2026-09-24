import 'package:cloud_firestore/cloud_firestore.dart';

class Food {
  final String id;
  final String name;
  final double servingSize; // grams
  final int calories;
  final double protein; // g
  final double carbs; // g
  final double fat; // g
  final double fiber; // g
  final String category; // 'protein', 'carbs', 'fat', 'vegetable', 'fruit', 'grains'
  final String? cuisine; // 'Kenyan', 'Mediterranean', etc.

  Food({
    required this.id,
    required this.name,
    required this.servingSize,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.fiber,
    required this.category,
    this.cuisine,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'servingSize': servingSize,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
      'fiber': fiber,
      'category': category,
      'cuisine': cuisine,
    };
  }

  factory Food.fromMap(Map<String, dynamic> map) {
    return Food(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      servingSize: (map['servingSize'] ?? 100).toDouble(),
      calories: map['calories'] ?? 0,
      protein: (map['protein'] ?? 0).toDouble(),
      carbs: (map['carbs'] ?? 0).toDouble(),
      fat: (map['fat'] ?? 0).toDouble(),
      fiber: (map['fiber'] ?? 0).toDouble(),
      category: map['category'] ?? 'other',
      cuisine: map['cuisine'],
    );
  }
}

class MealEntry {
  final String id;
  final String userId;
  final String mealType; // 'breakfast', 'lunch', 'dinner', 'snack'
  final List<FoodLog> foods;
  final DateTime date;
  final String notes;

  MealEntry({
    required this.id,
    required this.userId,
    required this.mealType,
    required this.foods,
    required this.date,
    this.notes = '',
  });

  int totalCalories() => foods.fold(0, (sum, food) => sum + food.totalCalories().toInt());
  double totalProtein() => foods.fold(0, (sum, food) => sum + food.totalProtein());
  double totalCarbs() => foods.fold(0, (sum, food) => sum + food.totalCarbs());
  double totalFat() => foods.fold(0, (sum, food) => sum + food.totalFat());

  factory MealEntry.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final foodsList = (data['foods'] as List?)?.map((f) => FoodLog.fromMap(f as Map<String, dynamic>)).toList() ?? [];

    return MealEntry(
      id: doc.id,
      userId: data['userId'] ?? '',
      mealType: data['mealType'] ?? 'lunch',
      foods: foodsList,
      date: (data['date'] as Timestamp).toDate(),
      notes: data['notes'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'mealType': mealType,
      'foods': foods.map((f) => f.toMap()).toList(),
      'date': Timestamp.fromDate(date),
      'notes': notes,
    };
  }
}

class FoodLog {
  final Food food;
  final double quantity; // multiplier of serving size
  final DateTime loggedAt;

  FoodLog({
    required this.food,
    required this.quantity,
    required this.loggedAt,
  });

  double totalCalories() => food.calories * quantity;
  double totalProtein() => food.protein * quantity;
  double totalCarbs() => food.carbs * quantity;
  double totalFat() => food.fat * quantity;

  Map<String, dynamic> toMap() {
    return {
      'food': food.toMap(),
      'quantity': quantity,
      'loggedAt': loggedAt.toIso8601String(),
    };
  }

  factory FoodLog.fromMap(Map<String, dynamic> map) {
    return FoodLog(
      food: Food.fromMap(map['food'] as Map<String, dynamic>),
      quantity: (map['quantity'] ?? 1).toDouble(),
      loggedAt: DateTime.parse(map['loggedAt'] as String),
    );
  }
}

class DailyNutrition {
  final DateTime date;
  final List<MealEntry> meals;
  final int? calorieTarget;
  final double? proteinTarget; // g
  final double? carbTarget; // g
  final double? fatTarget; // g

  DailyNutrition({
    required this.date,
    required this.meals,
    this.calorieTarget = 2000,
    this.proteinTarget = 150,
    this.carbTarget = 200,
    this.fatTarget = 65,
  });

  int totalCalories() => meals.fold(0, (sum, meal) => sum + meal.totalCalories());
  double totalProtein() => meals.fold(0, (sum, meal) => sum + meal.totalProtein());
  double totalCarbs() => meals.fold(0, (sum, meal) => sum + meal.totalCarbs());
  double totalFat() => meals.fold(0, (sum, meal) => sum + meal.totalFat());

  int calorieProgressPercent() => ((totalCalories() / (calorieTarget ?? 2000)) * 100).toInt();
  int proteinProgressPercent() => ((totalProtein() / (proteinTarget ?? 150)) * 100).toInt();
}
