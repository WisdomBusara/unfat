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

  Map<String, dynamic> toJson() {
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

  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      servingSize: (json['servingSize'] ?? json['serving_size'] ?? 100).toDouble(),
      calories: json['calories'] ?? 0,
      protein: (json['protein'] ?? 0).toDouble(),
      carbs: (json['carbs'] ?? 0).toDouble(),
      fat: (json['fat'] ?? 0).toDouble(),
      fiber: (json['fiber'] ?? 0).toDouble(),
      category: json['category'] ?? 'other',
      cuisine: json['cuisine'],
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

  factory MealEntry.fromJson(Map<String, dynamic> json) {
    final foodsList = (json['foods'] as List? ?? [])
        .map((f) => FoodLog.fromJson(f as Map<String, dynamic>))
        .toList();

    return MealEntry(
      id: json['id'] as String,
      userId: json['user_id'] ?? '',
      mealType: json['meal_type'] ?? 'lunch',
      foods: foodsList,
      date: DateTime.parse(json['date'] as String),
      notes: json['notes'] ?? '',
    );
  }

  Map<String, dynamic> toCreateJson() {
    return {
      'mealType': mealType,
      'foods': foods.map((f) => f.toJson()).toList(),
      'date': date.toIso8601String(),
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

  Map<String, dynamic> toJson() {
    return {
      'food': food.toJson(),
      'quantity': quantity,
      'loggedAt': loggedAt.toIso8601String(),
    };
  }

  factory FoodLog.fromJson(Map<String, dynamic> json) {
    return FoodLog(
      food: Food.fromJson(json['food'] as Map<String, dynamic>),
      quantity: (json['quantity'] ?? 1).toDouble(),
      loggedAt: DateTime.parse(json['loggedAt'] as String),
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
