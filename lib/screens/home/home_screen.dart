import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/user_provider.dart';
import '../../providers/weight_provider.dart';
import '../../providers/workout_provider.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedTab = 0;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    final auth = context.read<AuthProvider>();
    final user = auth.currentUser;

    if (user != null) {
      context.read<UserProvider>().loadUserProfile(user.uid);
      context.read<WeightProvider>().loadWeightHistory(user.uid);
      context.read<WorkoutProvider>().loadWorkoutHistory(user.uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kaza'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthProvider>().signOut();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildGreeting(),
            const SizedBox(height: 24),
            _buildQuickStats(),
            const SizedBox(height: 24),
            _buildActionButtons(),
            const SizedBox(height: 24),
            _buildRecentWeights(),
            const SizedBox(height: 24),
            _buildRecentWorkouts(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedTab,
        onTap: (index) {
          setState(() => _selectedTab = index);
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.fitness_center), label: 'Workouts'),
          BottomNavigationBarItem(icon: Icon(Icons.camera_alt), label: 'Photos'),
          BottomNavigationBarItem(icon: Icon(Icons.restaurant), label: 'Nutrition'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildGreeting() {
    return Consumer<UserProvider>(
      builder: (context, userProvider, _) {
        final user = userProvider.userProfile;
        final greeting = 'Welcome back, ${user?.name ?? 'User'}!';
        final date = DateFormat('EEEE, MMM d').format(DateTime.now());

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(greeting, style: Theme.of(context).textTheme.headlineSmall),
            Text(date, style: Theme.of(context).textTheme.bodyMedium),
          ],
        );
      },
    );
  }

  Widget _buildQuickStats() {
    return Consumer2<WeightProvider, WorkoutProvider>(
      builder: (context, weightProvider, workoutProvider, _) {
        final latestWeight = weightProvider.latestWeight;
        final workoutCount = workoutProvider.getWorkoutCount(days: 7);
        final weightChange = weightProvider.getWeightChange(days: 7);

        return Row(
          children: [
            Expanded(
              child: _StatCard(
                title: 'Current Weight',
                value: latestWeight != null
                    ? '${latestWeight.weight.toStringAsFixed(1)} kg'
                    : 'N/A',
                icon: Icons.scale,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _StatCard(
                title: 'This Week',
                value: '$workoutCount workouts',
                subtitle: weightChange != null
                    ? '${weightChange.toStringAsFixed(1)} kg change'
                    : 'No change',
                icon: Icons.trending_down,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildActionButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Quick Actions', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _ActionButton(
                icon: Icons.add_a_photo,
                label: 'Take Photo',
                onTap: () {},
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _ActionButton(
                icon: Icons.fitness_center,
                label: 'Log Workout',
                onTap: () {},
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _ActionButton(
                icon: Icons.restaurant,
                label: 'Log Meal',
                onTap: () {},
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRecentWeights() {
    return Consumer<WeightProvider>(
      builder: (context, weightProvider, _) {
        final weights = weightProvider.weightHistory.take(5).toList();

        if (weights.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Recent Weights', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 12),
            ...weights.map((w) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(DateFormat('MMM d, yyyy').format(w.date)),
                  Text('${w.weight} kg',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            )),
          ],
        );
      },
    );
  }

  Widget _buildRecentWorkouts() {
    return Consumer<WorkoutProvider>(
      builder: (context, workoutProvider, _) {
        final workouts = workoutProvider.workoutHistory.take(5).toList();

        if (workouts.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Recent Workouts', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 12),
            ...workouts.map((w) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(w.workoutType, style: const TextStyle(fontWeight: FontWeight.w600)),
                      Text(DateFormat('MMM d').format(w.date),
                          style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                  Text('${w.durationMinutes} min'),
                ],
              ),
            )),
          ],
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;
  final IconData icon;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 24, color: Theme.of(context).primaryColor),
            const SizedBox(height: 8),
            Text(title, style: Theme.of(context).textTheme.bodySmall),
            Text(value, style: Theme.of(context).textTheme.headlineSmall),
            if (subtitle != null) ...[
              const SizedBox(height: 4),
              Text(subtitle!, style: Theme.of(context).textTheme.bodySmall),
            ],
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Icon(icon, color: Theme.of(context).primaryColor),
              const SizedBox(height: 4),
              Text(label, style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}
