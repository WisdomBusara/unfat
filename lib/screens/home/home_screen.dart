import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../models/goal.dart';
import '../../providers/auth_provider.dart';
import '../../providers/goal_provider.dart';
import '../../providers/user_provider.dart';
import '../../providers/weight_provider.dart';
import '../../providers/workout_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/gradient_mesh_backdrop.dart';
import '../../widgets/kaza_nav_bar.dart';
import '../../widgets/weight_trend_chart.dart';
import '../goals/create_goal_screen.dart';
import '../goals/goals_screen.dart';
import '../nutrition/meal_log_screen.dart';
import '../nutrition/nutrition_screen.dart';
import '../photos/photos_screen.dart';
import '../profile/profile_screen.dart';
import '../workouts/workout_log_screen.dart';
import '../workouts/workouts_screen.dart';

/// Bottom-nav tab container. Each tab keeps its own state via IndexedStack
/// rather than being rebuilt on every switch.
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedTab = 0;

  final _tabs = const [
    _DashboardTab(),
    WorkoutsScreen(),
    PhotosScreen(),
    NutritionScreen(),
    ProfileScreen(),
  ];

  static const _navItems = [
    KazaNavItem(icon: Icons.home_outlined, activeIcon: Icons.home, label: 'Home'),
    KazaNavItem(
      icon: Icons.fitness_center_outlined,
      activeIcon: Icons.fitness_center,
      label: 'Workouts',
    ),
    KazaNavItem(icon: Icons.camera_alt_outlined, activeIcon: Icons.camera_alt, label: 'Photos'),
    KazaNavItem(icon: Icons.restaurant_outlined, activeIcon: Icons.restaurant, label: 'Nutrition'),
    KazaNavItem(icon: Icons.person_outline, activeIcon: Icons.person, label: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedTab, children: _tabs),
      bottomNavigationBar: KazaNavBar(
        currentIndex: _selectedTab,
        onTap: (index) => setState(() => _selectedTab = index),
        items: _navItems,
      ),
    );
  }
}

class _DashboardTab extends StatefulWidget {
  const _DashboardTab();

  @override
  State<_DashboardTab> createState() => _DashboardTabState();
}

class _DashboardTabState extends State<_DashboardTab> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadUserData());
  }

  void _loadUserData() {
    final auth = context.read<AuthProvider>();
    if (auth.currentUser == null) return;

    context.read<UserProvider>().setFromAuth(auth.currentUser!);
    context.read<WeightProvider>().loadWeightHistory();
    context.read<WorkoutProvider>().loadWorkoutHistory();
    context.read<GoalProvider>().loadActiveGoals();
  }

  @override
  Widget build(BuildContext context) {
    // No boxed AppBar here — the greeting doubles as the header, with a
    // gradient-mesh backdrop behind it rather than a flat title bar.
    return Scaffold(
      body: Stack(
        children: [
          const Positioned(top: 0, left: 0, right: 0, child: GradientMeshBackdrop()),
          RefreshIndicator(
            onRefresh: () async => _loadUserData(),
            child: SafeArea(
              bottom: false,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildGreeting(),
                    const SizedBox(height: 28),
                    _buildQuickStats(),
                    const SizedBox(height: 28),
                    _buildActionButtons(context),
                    const SizedBox(height: 28),
                    _buildGoalsSection(context),
                    const SizedBox(height: 28),
                    _buildWeightTrend(),
                    const SizedBox(height: 28),
                    _buildRecentWorkouts(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGreeting() {
    return Consumer<UserProvider>(
      builder: (context, userProvider, _) {
        final name = userProvider.userProfile?.name ?? 'there';
        final firstName = name.trim().isEmpty ? 'there' : name.trim().split(' ').first;
        final date = DateFormat('EEEE, MMM d').format(DateTime.now());

        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(date.toUpperCase(), style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        letterSpacing: 0.8,
                      )),
                  const SizedBox(height: 4),
                  Text(
                    'Hey, $firstName',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 28),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              ),
              child: CircleAvatar(
                radius: 24,
                backgroundColor: AppTheme.accent.withOpacity(0.18),
                child: Text(
                  firstName[0].toUpperCase(),
                  style: const TextStyle(
                    color: AppTheme.accent,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // Bento layout: one hero tile carries the primary number, a stacked pair
  // of compact tiles carries the secondary ones — current dashboard pattern
  // rather than a row of equally-weighted cards.
  Widget _buildQuickStats() {
    return Consumer2<WeightProvider, WorkoutProvider>(
      builder: (context, weightProvider, workoutProvider, _) {
        final latestWeight = weightProvider.latestWeight;
        final workoutCount = workoutProvider.getWorkoutCount(days: 7);
        final weightChange = weightProvider.getWeightChange(days: 7);
        final streak = workoutProvider.getStreakDays();

        return SizedBox(
          height: 172,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 3,
                child: _HeroStatCard(
                  title: 'Current weight',
                  value: latestWeight != null ? latestWeight.weight.toStringAsFixed(1) : '—',
                  unit: 'kg',
                  icon: Icons.monitor_weight_outlined,
                  trendLabel: weightChange != null
                      ? '${weightChange >= 0 ? '-' : '+'}${weightChange.abs().toStringAsFixed(1)} kg this week'
                      : null,
                  trendIsGood: (weightChange ?? 0) >= 0,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    Expanded(
                      child: _StatCard(
                        title: 'This week',
                        value: '$workoutCount',
                        unit: workoutCount == 1 ? 'wkt' : 'wkts',
                        icon: Icons.bolt_outlined,
                        compact: true,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: _StatCard(
                        title: 'Streak',
                        value: '$streak',
                        unit: streak == 1 ? 'day' : 'days',
                        icon: Icons.local_fire_department_outlined,
                        compact: true,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Quick actions', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _ActionButton(
                icon: Icons.add_a_photo_outlined,
                label: 'Take photo',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PhotosScreen()),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _ActionButton(
                icon: Icons.fitness_center_outlined,
                label: 'Log workout',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const WorkoutLogScreen()),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _ActionButton(
                icon: Icons.restaurant_outlined,
                label: 'Log meal',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MealLogScreen()),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGoalsSection(BuildContext context) {
    return Consumer<GoalProvider>(
      builder: (context, provider, _) {
        final goal = provider.getPrimaryGoal();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Goals', style: Theme.of(context).textTheme.headlineSmall),
                TextButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const GoalsScreen()),
                  ),
                  child: Text(goal == null ? 'Set a goal' : 'View all'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (goal == null)
              Card(
                child: ListTile(
                  leading: Icon(Icons.flag_outlined, color: AppTheme.accent),
                  title: const Text('No active goal yet'),
                  subtitle: const Text('Set one to track progress toward it'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CreateGoalScreen()),
                  ),
                ),
              )
            else
              _buildGoalPreviewCard(context, goal),
          ],
        );
      },
    );
  }

  Widget _buildGoalPreviewCard(BuildContext context, Goal goal) {
    final daysLeft = goal.targetDate.difference(DateTime.now()).inDays;
    return Card(
      child: ListTile(
        leading: Icon(Icons.flag, color: AppTheme.accent),
        title: Text(goal.title),
        subtitle: Text(daysLeft >= 0 ? '$daysLeft days left' : '${-daysLeft} days overdue'),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const GoalsScreen()),
        ),
      ),
    );
  }

  Widget _buildWeightTrend() {
    return Consumer<WeightProvider>(
      builder: (context, weightProvider, _) {
        if (weightProvider.weightHistory.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Weight trend', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 16, 16, 8),
                child: WeightTrendChart(entries: weightProvider.weightHistory),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildRecentWorkouts() {
    return Consumer<WorkoutProvider>(
      builder: (context, workoutProvider, _) {
        final workouts = workoutProvider.workoutHistory.take(5).toList();

        if (workouts.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Recent workouts', style: Theme.of(context).textTheme.headlineSmall),
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

/// The number is the hero element here, not the label — oversized tabular
/// numerals per the current dashboard-design pattern, with the unit set
/// small and inline rather than folded into one string. [compact] scales
/// the number down for the small tiles stacked beside the hero card.
class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String unit;
  final IconData icon;
  final bool compact;

  const _StatCard({
    required this.title,
    required this.value,
    required this.unit,
    required this.icon,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(compact ? 12 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.bodySmall,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(icon, size: 16, color: AppTheme.accent),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  value,
                  style: compact
                      ? AppTheme.statNumberStyle(context).copyWith(fontSize: 24)
                      : AppTheme.statNumberStyle(context),
                ),
                const SizedBox(width: 4),
                Text(unit, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// The bento grid's primary tile — a frosted [GlassCard] over the gradient
/// mesh backdrop rather than a flat [Card], with a trend chip instead of a
/// plain subtitle line.
class _HeroStatCard extends StatelessWidget {
  final String title;
  final String value;
  final String unit;
  final IconData icon;
  final String? trendLabel;
  final bool trendIsGood;

  const _HeroStatCard({
    required this.title,
    required this.value,
    required this.unit,
    required this.icon,
    this.trendLabel,
    this.trendIsGood = true,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: Theme.of(context).textTheme.bodyMedium),
              Icon(icon, size: 20, color: AppTheme.accent),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(value, style: AppTheme.statNumberStyle(context).copyWith(fontSize: 44)),
              const SizedBox(width: 6),
              Text(unit, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
          if (trendLabel != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: (trendIsGood ? AppTheme.accent : Theme.of(context).colorScheme.error)
                    .withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    trendIsGood ? Icons.trending_down : Icons.trending_up,
                    size: 14,
                    color: trendIsGood ? AppTheme.accent : Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    trendLabel!,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: trendIsGood ? AppTheme.accent : Theme.of(context).colorScheme.error,
                    ),
                  ),
                ],
              ),
            ),
        ],
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
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          decoration: BoxDecoration(
            color: Theme.of(context).cardTheme.color,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white.withOpacity(0.08)
                  : Colors.black.withOpacity(0.08),
            ),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.accent.withOpacity(0.14),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: AppTheme.accent, size: 20),
              ),
              const SizedBox(height: 8),
              Text(label, style: Theme.of(context).textTheme.bodySmall, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}
