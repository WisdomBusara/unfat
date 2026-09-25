import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../models/workout.dart';
import '../../providers/auth_provider.dart';
import '../../providers/workout_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/kaza_loader.dart';
import 'workout_log_screen.dart';

class WorkoutsScreen extends StatefulWidget {
  const WorkoutsScreen({Key? key}) : super(key: key);

  @override
  State<WorkoutsScreen> createState() => _WorkoutsScreenState();
}

class _WorkoutsScreenState extends State<WorkoutsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.read<AuthProvider>().currentUser != null) {
        context.read<WorkoutProvider>().loadWorkoutHistory();
      }
    });
  }

  Future<void> _openLogger() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const WorkoutLogScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Workouts')),
      floatingActionButton: FloatingActionButton(
        onPressed: _openLogger,
        backgroundColor: AppTheme.accent,
        foregroundColor: AppTheme.onAccent,
        child: const Icon(Icons.add),
      ),
      body: Consumer<WorkoutProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading && provider.workoutHistory.isEmpty) {
            return const Center(child: KazaLoader(size: 32));
          }
          if (provider.workoutHistory.isEmpty) {
            return _buildEmptyState();
          }
          return RefreshIndicator(
            onRefresh: () => context.read<WorkoutProvider>().loadWorkoutHistory(),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildWeekSummary(provider),
                const SizedBox(height: 20),
                ...provider.workoutHistory.map(_buildWorkoutTile),
                const SizedBox(height: 80),
              ],
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
            Icon(Icons.fitness_center, size: 48, color: AppTheme.accent),
            const SizedBox(height: 16),
            Text('No workouts logged yet', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(
              'Tap the + button to log your first session.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeekSummary(WorkoutProvider provider) {
    final count = provider.getWorkoutCount(days: 7);
    final minutes = provider.getTotalDurationMinutes(days: 7);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Last 7 days', style: Theme.of(context).textTheme.bodySmall),
                  const SizedBox(height: 6),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text('$count', style: AppTheme.statNumberStyle(context)),
                      const SizedBox(width: 4),
                      Text(count == 1 ? 'workout' : 'workouts',
                          style: Theme.of(context).textTheme.bodyMedium),
                    ],
                  ),
                ],
              ),
            ),
            Container(width: 1, height: 40, color: Colors.white.withOpacity(0.08)),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Total time', style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(height: 6),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text('$minutes', style: AppTheme.statNumberStyle(context)),
                    const SizedBox(width: 4),
                    Text('min', style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkoutTile(WorkoutSession workout) {
    final typeIcon = switch (workout.workoutType) {
      'cardio' => Icons.directions_run,
      'calisthenics' => Icons.accessibility_new,
      'mobility' => Icons.self_improvement,
      'combat' => Icons.sports_kabaddi,
      _ => Icons.fitness_center,
    };

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: AppTheme.accent.withOpacity(0.15),
              child: Icon(typeIcon, color: AppTheme.accent, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    workout.workoutType[0].toUpperCase() + workout.workoutType.substring(1),
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 16),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${DateFormat('MMM d').format(workout.date)} · ${workout.exercises.length} exercise${workout.exercises.length == 1 ? '' : 's'}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            Text('${workout.durationMinutes} min', style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}
