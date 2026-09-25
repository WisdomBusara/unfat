import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/goal.dart';
import '../../providers/auth_provider.dart';
import '../../providers/goal_provider.dart';
import '../../theme/app_theme.dart';

const _goalTypes = [
  ('fat_loss', 'Fat loss', Icons.trending_down),
  ('muscle_gain', 'Muscle gain', Icons.fitness_center),
  ('recomposition', 'Recomposition', Icons.autorenew),
  ('strength', 'Strength', Icons.bolt),
  ('cardio', 'Cardio', Icons.directions_run),
  ('general_health', 'General health', Icons.favorite_border),
];

const _strategyOptions = [
  ('resistance_training', 'Resistance training'),
  ('cardio', 'Cardio'),
  ('nutrition', 'Nutrition'),
  ('sleep', 'Sleep'),
  ('recovery', 'Recovery'),
];

bool _usesWeight(String type) =>
    ['fat_loss', 'muscle_gain', 'recomposition', 'general_health'].contains(type);
bool _usesReps(String type) => type == 'strength';
bool _usesDistance(String type) => type == 'cardio';

class CreateGoalScreen extends StatefulWidget {
  const CreateGoalScreen({Key? key}) : super(key: key);

  @override
  State<CreateGoalScreen> createState() => _CreateGoalScreenState();
}

class _CreateGoalScreenState extends State<CreateGoalScreen> {
  final _titleController = TextEditingController();
  final _targetWeightController = TextEditingController();
  final _targetRepsController = TextEditingController();
  final _targetDistanceController = TextEditingController();
  String _goalType = 'fat_loss';
  String _priority = 'medium';
  DateTime _targetDate = DateTime.now().add(const Duration(days: 60));
  final _strategies = <String>{};
  bool _isSaving = false;

  @override
  void dispose() {
    _titleController.dispose();
    _targetWeightController.dispose();
    _targetRepsController.dispose();
    _targetDistanceController.dispose();
    super.dispose();
  }

  bool get _canSave => _titleController.text.trim().isNotEmpty;

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _targetDate,
      firstDate: DateTime.now().add(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 730)),
    );
    if (picked != null) setState(() => _targetDate = picked);
  }

  Future<void> _save() async {
    final userId = context.read<AuthProvider>().currentUser?.uid ?? '';
    setState(() => _isSaving = true);
    try {
      await context.read<GoalProvider>().createGoal(Goal(
            id: '',
            userId: userId,
            title: _titleController.text.trim(),
            goalType: _goalType,
            targetWeight: _usesWeight(_goalType)
                ? double.tryParse(_targetWeightController.text)
                : null,
            targetReps: _usesReps(_goalType) ? int.tryParse(_targetRepsController.text) : null,
            targetDistance:
                _usesDistance(_goalType) ? double.tryParse(_targetDistanceController.text) : null,
            startDate: DateTime.now(),
            targetDate: _targetDate,
            priority: _priority,
            strategies: _strategies.toList(),
          ));
      if (mounted) Navigator.pop(context);
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final daysOut = _targetDate.difference(DateTime.now()).inDays;

    return Scaffold(
      appBar: AppBar(
        title: const Text('New goal'),
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
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Goal title',
              hintText: 'e.g. Get to 75kg for summer',
            ),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 20),
          Text('Type', style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _goalTypes.map((option) {
              final (value, label, icon) = option;
              final selected = _goalType == value;
              return ChoiceChip(
                avatar: Icon(icon, size: 16, color: selected ? AppTheme.accent : null),
                label: Text(label),
                selected: selected,
                onSelected: (_) => setState(() => _goalType = value),
                selectedColor: AppTheme.accent.withOpacity(0.2),
                side: BorderSide(color: selected ? AppTheme.accent : Colors.transparent),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          if (_usesWeight(_goalType))
            TextField(
              controller: _targetWeightController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'Target weight', suffixText: 'kg'),
            ),
          if (_usesReps(_goalType))
            TextField(
              controller: _targetRepsController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Target reps'),
            ),
          if (_usesDistance(_goalType))
            TextField(
              controller: _targetDistanceController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'Target distance', suffixText: 'km'),
            ),
          const SizedBox(height: 20),
          Text('Target date', style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: _pickDate,
            icon: const Icon(Icons.calendar_today_outlined, size: 18),
            label: Text(
              '${_targetDate.month}/${_targetDate.day}/${_targetDate.year} ($daysOut days)',
            ),
          ),
          const SizedBox(height: 20),
          Text('Priority', style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: ['high', 'medium', 'low'].map((p) {
              final selected = _priority == p;
              return ChoiceChip(
                label: Text(p[0].toUpperCase() + p.substring(1)),
                selected: selected,
                onSelected: (_) => setState(() => _priority = p),
                selectedColor: AppTheme.accent.withOpacity(0.2),
                side: BorderSide(color: selected ? AppTheme.accent : Colors.transparent),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          Text('Strategies (optional)', style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _strategyOptions.map((option) {
              final (value, label) = option;
              final selected = _strategies.contains(value);
              return FilterChip(
                label: Text(label),
                selected: selected,
                onSelected: (isSelected) {
                  setState(() {
                    if (isSelected) {
                      _strategies.add(value);
                    } else {
                      _strategies.remove(value);
                    }
                  });
                },
                selectedColor: AppTheme.accent.withOpacity(0.2),
                checkmarkColor: AppTheme.accent,
                side: BorderSide(color: selected ? AppTheme.accent : Colors.transparent),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
