import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/nutrition.dart';
import '../../providers/auth_provider.dart';
import '../../providers/nutrition_provider.dart';
import '../../services/api_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/kaza_loader.dart';
import 'meal_log_screen.dart';

class NutritionScreen extends StatefulWidget {
  const NutritionScreen({Key? key}) : super(key: key);

  @override
  State<NutritionScreen> createState() => _NutritionScreenState();
}

class _NutritionScreenState extends State<NutritionScreen> {
  final _apiService = ApiService();
  bool _isAnalyzing = false;
  String? _analysis;
  String? _analysisError;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.read<AuthProvider>().currentUser != null) {
        context.read<NutritionProvider>().loadDailyNutrition(DateTime.now());
      }
    });
  }

  Future<void> _openLogger() async {
    await Navigator.push(context, MaterialPageRoute(builder: (_) => const MealLogScreen()));
    if (mounted) {
      context.read<NutritionProvider>().loadDailyNutrition(DateTime.now());
    }
  }

  Future<void> _analyze() async {
    setState(() {
      _isAnalyzing = true;
      _analysisError = null;
    });
    try {
      final result = await _apiService.getNutritionAnalysis();
      setState(() => _analysis = result);
    } on ApiException catch (e) {
      setState(() => _analysisError = e.message);
    } finally {
      if (mounted) setState(() => _isAnalyzing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nutrition')),
      floatingActionButton: FloatingActionButton(
        onPressed: _openLogger,
        backgroundColor: AppTheme.accent,
        foregroundColor: AppTheme.onAccent,
        child: const Icon(Icons.add),
      ),
      body: Consumer<NutritionProvider>(
        builder: (context, provider, _) {
          final today = provider.getTodayNutrition();

          return RefreshIndicator(
            onRefresh: () => context.read<NutritionProvider>().loadDailyNutrition(DateTime.now()),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildMacroSummary(today),
                const SizedBox(height: 20),
                _buildAnalyzeSection(),
                const SizedBox(height: 20),
                if (today.meals.isEmpty)
                  _buildEmptyState()
                else ...[
                  Text('Today\'s meals', style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 12),
                  ...today.meals.map(_buildMealTile),
                ],
                const SizedBox(height: 80),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.restaurant_outlined, size: 40, color: AppTheme.accent),
            const SizedBox(height: 12),
            Text('No meals logged today', style: Theme.of(context).textTheme.bodyLarge),
          ],
        ),
      ),
    );
  }

  Widget _buildMacroSummary(DailyNutrition today) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text('${today.totalCalories()}', style: AppTheme.statNumberStyle(context)),
                const SizedBox(width: 4),
                Text('/ ${today.calorieTarget} kcal', style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: (today.calorieProgressPercent() / 100).clamp(0, 1).toDouble(),
                minHeight: 6,
                backgroundColor: Colors.white.withOpacity(0.08),
                valueColor: AlwaysStoppedAnimation(AppTheme.accent),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _macroChip('Protein', today.totalProtein(), today.proteinTarget),
                const SizedBox(width: 10),
                _macroChip('Carbs', today.totalCarbs(), today.carbTarget),
                const SizedBox(width: 10),
                _macroChip('Fat', today.totalFat(), today.fatTarget),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _macroChip(String label, double value, double? target) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 2),
          Text(
            '${value.toStringAsFixed(0)}${target != null ? ' / ${target.toStringAsFixed(0)}g' : 'g'}',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyzeSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.auto_awesome, color: AppTheme.accent, size: 20),
                const SizedBox(width: 8),
                Text('AI nutrition check-in', style: Theme.of(context).textTheme.headlineSmall),
              ],
            ),
            const SizedBox(height: 10),
            if (_analysis != null)
              Text(_analysis!, style: Theme.of(context).textTheme.bodyMedium)
            else if (_analysisError != null)
              Text(_analysisError!, style: TextStyle(color: Theme.of(context).colorScheme.error))
            else
              Text(
                'Get evidence-based feedback on what you\'ve logged today.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: _isAnalyzing ? null : _analyze,
                child: _isAnalyzing
                    ? const KazaLoader(size: 18)
                    : Text(_analysis == null ? 'Analyze today' : 'Re-analyze'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMealTile(MealEntry meal) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  meal.mealType[0].toUpperCase() + meal.mealType.substring(1),
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 16),
                ),
                Text('${meal.totalCalories()} kcal', style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              meal.foods.map((f) => f.food.name).join(', '),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
