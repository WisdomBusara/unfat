import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../models/nutrition.dart';
import '../../providers/auth_provider.dart';
import '../../providers/nutrition_provider.dart';
import '../../theme/app_theme.dart';

const _mealTypes = ['breakfast', 'lunch', 'dinner', 'snack'];

class _FoodDraft {
  final nameController = TextEditingController();
  final caloriesController = TextEditingController();
  final proteinController = TextEditingController();
  final carbsController = TextEditingController();
  final fatController = TextEditingController();

  void dispose() {
    nameController.dispose();
    caloriesController.dispose();
    proteinController.dispose();
    carbsController.dispose();
    fatController.dispose();
  }
}

class MealLogScreen extends StatefulWidget {
  const MealLogScreen({Key? key}) : super(key: key);

  @override
  State<MealLogScreen> createState() => _MealLogScreenState();
}

class _MealLogScreenState extends State<MealLogScreen> {
  static const _uuid = Uuid();
  String _mealType = 'breakfast';
  final _foods = <_FoodDraft>[_FoodDraft()];
  bool _isSaving = false;

  @override
  void dispose() {
    for (final f in _foods) {
      f.dispose();
    }
    super.dispose();
  }

  bool get _canSave => _foods.any((f) => f.nameController.text.trim().isNotEmpty);

  Future<void> _save() async {
    final userId = context.read<AuthProvider>().currentUser?.uid ?? '';
    final now = DateTime.now();

    final foods = _foods
        .where((f) => f.nameController.text.trim().isNotEmpty)
        .map((f) => FoodLog(
              food: Food(
                id: _uuid.v4(),
                name: f.nameController.text.trim(),
                servingSize: 100,
                calories: int.tryParse(f.caloriesController.text) ?? 0,
                protein: double.tryParse(f.proteinController.text) ?? 0,
                carbs: double.tryParse(f.carbsController.text) ?? 0,
                fat: double.tryParse(f.fatController.text) ?? 0,
                fiber: 0,
                category: 'other',
              ),
              quantity: 1,
              loggedAt: now,
            ))
        .toList();

    setState(() => _isSaving = true);
    try {
      await context.read<NutritionProvider>().logMeal(MealEntry(
            id: '',
            userId: userId,
            mealType: _mealType,
            foods: foods,
            date: now,
          ));
      if (mounted) Navigator.pop(context);
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _addFood() => setState(() => _foods.add(_FoodDraft()));

  void _removeFood(int index) {
    setState(() {
      _foods[index].dispose();
      _foods.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log meal'),
        actions: [
          TextButton(
            onPressed: (_canSave && !_isSaving) ? _save : null,
            child: _isSaving
                ? const SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Save'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Wrap(
            spacing: 8,
            children: _mealTypes.map((type) {
              final selected = _mealType == type;
              return ChoiceChip(
                label: Text(type[0].toUpperCase() + type.substring(1)),
                selected: selected,
                onSelected: (_) => setState(() => _mealType = type),
                selectedColor: AppTheme.accent.withOpacity(0.2),
                side: BorderSide(color: selected ? AppTheme.accent : Colors.transparent),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          ..._foods.asMap().entries.map((entry) => _buildFoodCard(entry.value, entry.key)),
          OutlinedButton.icon(
            onPressed: _addFood,
            icon: const Icon(Icons.add),
            label: const Text('Add food'),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildFoodCard(_FoodDraft food, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: food.nameController,
                    decoration: const InputDecoration(labelText: 'Food'),
                    onChanged: (_) => setState(() {}),
                  ),
                ),
                if (_foods.length > 1)
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: () => _removeFood(index),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: food.caloriesController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'kcal', isDense: true),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: food.proteinController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(labelText: 'Protein g', isDense: true),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: food.carbsController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(labelText: 'Carbs g', isDense: true),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: food.fatController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(labelText: 'Fat g', isDense: true),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
