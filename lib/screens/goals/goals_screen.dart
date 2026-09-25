import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../models/goal.dart';
import '../../providers/auth_provider.dart';
import '../../providers/goal_provider.dart';
import '../../providers/weight_provider.dart';
import '../../services/api_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/kaza_loader.dart';
import 'create_goal_screen.dart';

const _weightBasedTypes = ['fat_loss', 'muscle_gain', 'recomposition'];

const _goalTypeIcons = {
  'fat_loss': Icons.trending_down,
  'muscle_gain': Icons.fitness_center,
  'recomposition': Icons.autorenew,
  'strength': Icons.bolt,
  'cardio': Icons.directions_run,
  'general_health': Icons.favorite_border,
};

class GoalsScreen extends StatefulWidget {
  const GoalsScreen({Key? key}) : super(key: key);

  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  final _apiService = ApiService();
  String? _strategyLoadingFor;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.read<AuthProvider>().currentUser != null) {
        context.read<GoalProvider>().loadActiveGoals();
      }
    });
  }

  Future<void> _openCreate() async {
    await Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateGoalScreen()));
    if (mounted) context.read<GoalProvider>().loadActiveGoals();
  }

  Future<void> _showAiStrategy(Goal goal) async {
    setState(() => _strategyLoadingFor = goal.id);
    try {
      final daysToTarget = goal.targetDate.difference(DateTime.now()).inDays;
      final strategy = await _apiService.getWeightLossStrategy(
        daysToTarget: daysToTarget > 0 ? daysToTarget : 90,
        targetWeight: goal.targetWeight,
      );
      if (!mounted) return;
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Theme.of(context).cardTheme.color,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        builder: (context) => DraggableScrollableSheet(
          initialChildSize: 0.7,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) => Padding(
            padding: const EdgeInsets.all(20),
            child: ListView(
              controller: scrollController,
              children: [
                Row(
                  children: [
                    Icon(Icons.auto_awesome, color: AppTheme.accent),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(goal.title, style: Theme.of(context).textTheme.headlineSmall),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(strategy, style: Theme.of(context).textTheme.bodyLarge),
              ],
            ),
          ),
        ),
      );
    } on ApiException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
      }
    } finally {
      if (mounted) setState(() => _strategyLoadingFor = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Goals')),
      floatingActionButton: FloatingActionButton(
        onPressed: _openCreate,
        backgroundColor: AppTheme.accent,
        foregroundColor: AppTheme.onAccent,
        child: const Icon(Icons.add),
      ),
      body: Consumer<GoalProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading && provider.activeGoals.isEmpty) {
            return const Center(child: KazaLoader(size: 32));
          }
          if (provider.activeGoals.isEmpty) {
            return _buildEmptyState();
          }
          return RefreshIndicator(
            onRefresh: () => context.read<GoalProvider>().loadActiveGoals(),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: provider.activeGoals.length,
              itemBuilder: (context, index) => _buildGoalCard(provider.activeGoals[index]),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.flag_outlined, size: 48, color: AppTheme.accent),
            const SizedBox(height: 16),
            Text('No active goals', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(
              'Set a goal to track your progress toward it.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalCard(Goal goal) {
    final daysLeft = goal.targetDate.difference(DateTime.now()).inDays;
    final overdue = daysLeft < 0;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(_goalTypeIcons[goal.goalType] ?? Icons.flag_outlined, color: AppTheme.accent),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(goal.title, style: Theme.of(context).textTheme.headlineSmall),
                ),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, size: 20),
                  onSelected: (value) {
                    if (value == 'complete') {
                      context.read<GoalProvider>().completeGoal(goal.id);
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(value: 'complete', child: Text('Mark complete')),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              overdue
                  ? '${-daysLeft} days overdue'
                  : '$daysLeft days left · target ${DateFormat('MMM d, yyyy').format(goal.targetDate)}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: overdue ? Theme.of(context).colorScheme.error : null,
                  ),
            ),
            if (goal.targetWeight != null) ...[
              const SizedBox(height: 12),
              _buildWeightProgress(goal),
              if (_weightBasedTypes.contains(goal.goalType)) ...[
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed:
                        _strategyLoadingFor == goal.id ? null : () => _showAiStrategy(goal),
                    icon: _strategyLoadingFor == goal.id
                        ? const KazaLoader(size: 16)
                        : const Icon(Icons.auto_awesome, size: 16),
                    label: const Text('AI strategy'),
                  ),
                ),
              ],
            ] else if (goal.targetReps != null) ...[
              const SizedBox(height: 8),
              Text('Target: ${goal.targetReps} reps', style: Theme.of(context).textTheme.bodyMedium),
            ] else if (goal.targetDistance != null) ...[
              const SizedBox(height: 8),
              Text('Target: ${goal.targetDistance} km', style: Theme.of(context).textTheme.bodyMedium),
            ],
            if (goal.strategies.isNotEmpty) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: goal.strategies
                    .map((s) => Chip(
                          label: Text(
                            s.replaceAll('_', ' '),
                            style: const TextStyle(fontSize: 11),
                          ),
                          visualDensity: VisualDensity.compact,
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ))
                    .toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildWeightProgress(Goal goal) {
    return Consumer<WeightProvider>(
      builder: (context, weightProvider, _) {
        final current = weightProvider.latestWeight?.weight;
        if (current == null) {
          return Text(
            'Target: ${goal.targetWeight} kg — log a weight entry to see progress',
            style: Theme.of(context).textTheme.bodyMedium,
          );
        }

        // weightHistory is sorted newest-first, so the last entry still
        // at/after the goal's start date is the earliest one in range.
        final eligible =
            weightProvider.weightHistory.where((w) => !w.date.isBefore(goal.startDate)).toList();
        final startValue = eligible.isNotEmpty ? eligible.last.weight : null;
        final progress = goal.progressPercentage(current, startValue: startValue);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${current.toStringAsFixed(1)} kg now',
                    style: Theme.of(context).textTheme.bodyMedium),
                Text('${goal.targetWeight!.toStringAsFixed(1)} kg target',
                    style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress / 100,
                minHeight: 6,
                backgroundColor: Colors.white.withOpacity(0.08),
                valueColor: AlwaysStoppedAnimation(AppTheme.accent),
              ),
            ),
            const SizedBox(height: 4),
            Text('$progress% there', style: Theme.of(context).textTheme.bodySmall),
          ],
        );
      },
    );
  }
}
