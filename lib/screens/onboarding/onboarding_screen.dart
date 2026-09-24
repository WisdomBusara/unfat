import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/weight_entry.dart';
import '../../providers/auth_provider.dart';
import '../../providers/user_provider.dart';
import '../../providers/weight_provider.dart';
import '../../services/api_service.dart';
import '../../theme/app_theme.dart';
import '../home/home_screen.dart';

const _goalOptions = [
  ('fat_loss', 'Lose fat', Icons.trending_down),
  ('muscle_gain', 'Build muscle', Icons.fitness_center),
  ('strength', 'Get stronger', Icons.bolt),
  ('recomposition', 'Recomposition', Icons.autorenew),
  ('general_health', 'General health', Icons.favorite_border),
];

const _experienceOptions = [
  ('beginner', 'Beginner', 'New to training, or getting back into it'),
  ('intermediate', 'Intermediate', 'Training consistently for 6+ months'),
  ('advanced', 'Advanced', 'Years of structured training'),
];

const _equipmentOptions = [
  ('none', 'No equipment'),
  ('dumbbells', 'Dumbbells'),
  ('barbell', 'Barbell'),
  ('kettlebells', 'Kettlebells'),
  ('resistance_bands', 'Resistance bands'),
  ('pull_up_bar', 'Pull-up bar'),
  ('full_gym', 'Full gym access'),
];

/// One question per screen, minimal typing, ends by showing a real AI
/// workout recommendation before landing in the app — Fitbod's onboarding
/// pattern rather than a marketing carousel.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageController = PageController();
  final _apiService = ApiService();
  int _step = 0;
  static const _totalSteps = 5;

  String? _goal;
  String? _experience;
  final _equipment = <String>{};

  final _ageController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _targetWeightController = TextEditingController();

  bool _isSubmitting = false;
  String? _submitError;
  String? _workoutPreview;

  @override
  void dispose() {
    _pageController.dispose();
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _targetWeightController.dispose();
    super.dispose();
  }

  bool get _canAdvance {
    switch (_step) {
      case 0:
        return _goal != null;
      case 1:
        return _experience != null;
      case 2:
        return _ageController.text.isNotEmpty &&
            _heightController.text.isNotEmpty &&
            _weightController.text.isNotEmpty;
      case 3:
        return _equipment.isNotEmpty;
      default:
        return true;
    }
  }

  void _next() {
    if (_step == 3) {
      _submitAndPreview();
      return;
    }
    if (_step < _totalSteps - 1) {
      setState(() => _step++);
      _pageController.nextPage(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    }
  }

  void _back() {
    if (_step > 0) {
      setState(() => _step--);
      _pageController.previousPage(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _submitAndPreview() async {
    setState(() {
      _isSubmitting = true;
      _submitError = null;
    });

    try {
      final auth = context.read<AuthProvider>();
      final current = auth.currentUser!;

      final updated = current.copyWith(
        age: int.parse(_ageController.text),
        height: double.parse(_heightController.text),
        targetWeight: _targetWeightController.text.isNotEmpty
            ? double.parse(_targetWeightController.text)
            : double.parse(_weightController.text),
        trainingExperience: _experience,
        goals: [_goal!],
        availableEquipment: _equipment.toList(),
      );

      await context.read<UserProvider>().updateUserProfile(updated);
      auth.updateProfile(updated);

      await context.read<WeightProvider>().addWeightEntry(WeightEntry(
            id: '',
            userId: current.uid,
            weight: double.parse(_weightController.text),
            date: DateTime.now(),
          ));

      final recommendation = await _apiService.getWorkoutRecommendation(_goal!);

      setState(() {
        _workoutPreview = recommendation;
        _step = 4;
      });
      _pageController.nextPage(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    } on ApiException catch (e) {
      setState(() => _submitError = e.message);
    } catch (e) {
      setState(() => _submitError = 'Something went wrong. Please try again.');
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildProgressBar(),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildGoalStep(),
                  _buildExperienceStep(),
                  _buildBasicsStep(),
                  _buildEquipmentStep(),
                  _buildPreviewStep(),
                ],
              ),
            ),
            if (_step < 4) _buildNavButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
      child: Row(
        children: List.generate(_totalSteps, (i) {
          final active = i <= _step;
          return Expanded(
            child: Container(
              height: 4,
              margin: EdgeInsets.only(right: i == _totalSteps - 1 ? 0 : 6),
              decoration: BoxDecoration(
                color: active
                    ? AppTheme.accent
                    : Theme.of(context).brightness == Brightness.dark
                        ? Colors.white.withOpacity(0.12)
                        : Colors.black.withOpacity(0.08),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildNavButtons() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
      child: Row(
        children: [
          if (_step > 0)
            TextButton(onPressed: _isSubmitting ? null : _back, child: const Text('Back')),
          const Spacer(),
          ElevatedButton(
            onPressed: (_canAdvance && !_isSubmitting) ? _next : null,
            child: _isSubmitting
                ? const SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : Text(_step == 3 ? 'Finish' : 'Next'),
          ),
        ],
      ),
    );
  }

  Widget _stepScaffold({required String question, required Widget child, String? error}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          Text(question, style: Theme.of(context).textTheme.displayLarge),
          if (error != null) ...[
            const SizedBox(height: 8),
            Text(error, style: TextStyle(color: Theme.of(context).colorScheme.error)),
          ],
          const SizedBox(height: 28),
          Expanded(child: SingleChildScrollView(child: child)),
        ],
      ),
    );
  }

  Widget _buildGoalStep() {
    return _stepScaffold(
      question: "What's your main goal?",
      child: Column(
        children: _goalOptions.map((option) {
          final (value, label, icon) = option;
          final selected = _goal == value;
          return _SelectCard(
            label: label,
            icon: icon,
            selected: selected,
            onTap: () => setState(() => _goal = value),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildExperienceStep() {
    return _stepScaffold(
      question: "What's your training experience?",
      child: Column(
        children: _experienceOptions.map((option) {
          final (value, label, subtitle) = option;
          final selected = _experience == value;
          return _SelectCard(
            label: label,
            subtitle: subtitle,
            selected: selected,
            onTap: () => setState(() => _experience = value),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildBasicsStep() {
    return _stepScaffold(
      question: 'A few basics',
      error: _submitError,
      child: Column(
        children: [
          _NumberField(controller: _ageController, label: 'Age', suffix: 'years'),
          const SizedBox(height: 16),
          _NumberField(controller: _heightController, label: 'Height', suffix: 'cm'),
          const SizedBox(height: 16),
          _NumberField(controller: _weightController, label: 'Current weight', suffix: 'kg'),
          const SizedBox(height: 16),
          _NumberField(
            controller: _targetWeightController,
            label: 'Target weight (optional)',
            suffix: 'kg',
          ),
        ],
      ),
    );
  }

  Widget _buildEquipmentStep() {
    return _stepScaffold(
      question: 'What equipment do you have?',
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: _equipmentOptions.map((option) {
          final (value, label) = option;
          final selected = _equipment.contains(value);
          return FilterChip(
            label: Text(label),
            selected: selected,
            onSelected: (isSelected) {
              setState(() {
                if (isSelected) {
                  _equipment.add(value);
                } else {
                  _equipment.remove(value);
                }
              });
            },
            selectedColor: AppTheme.accent.withOpacity(0.2),
            checkmarkColor: AppTheme.accent,
            side: BorderSide(
              color: selected ? AppTheme.accent : Colors.transparent,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPreviewStep() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.auto_awesome, color: AppTheme.accent),
              const SizedBox(width: 8),
              Text('Your first workout', style: Theme.of(context).textTheme.displayLarge),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Generated for your goal, experience and equipment.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Text(
                    _workoutPreview ?? 'Loading...',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const HomeScreen()),
                );
              },
              child: const Text("Let's go"),
            ),
          ),
        ],
      ),
    );
  }
}

class _SelectCard extends StatelessWidget {
  final String label;
  final String? subtitle;
  final IconData? icon;
  final bool selected;
  final VoidCallback onTap;

  const _SelectCard({
    required this.label,
    required this.selected,
    required this.onTap,
    this.subtitle,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardTheme.color,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: selected ? AppTheme.accent : Colors.transparent,
                width: 2,
              ),
            ),
            child: Row(
              children: [
                if (icon != null) ...[
                  Icon(icon, color: selected ? AppTheme.accent : null),
                  const SizedBox(width: 14),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(label, style: Theme.of(context).textTheme.headlineSmall),
                      if (subtitle != null) ...[
                        const SizedBox(height: 2),
                        Text(subtitle!, style: Theme.of(context).textTheme.bodyMedium),
                      ],
                    ],
                  ),
                ),
                if (selected) Icon(Icons.check_circle, color: AppTheme.accent),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NumberField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String suffix;

  const _NumberField({required this.controller, required this.label, required this.suffix});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(labelText: label, suffixText: suffix),
    );
  }
}
