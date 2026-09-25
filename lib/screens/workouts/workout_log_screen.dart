import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../models/workout.dart';
import '../../providers/auth_provider.dart';
import '../../providers/workout_provider.dart';
import '../../services/api_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/autocomplete_options_list.dart';
import '../../widgets/kaza_loader.dart';

const _workoutTypes = ['strength', 'cardio', 'calisthenics', 'mobility', 'combat'];

class _SetDraft {
  final repsController = TextEditingController();
  final weightController = TextEditingController();

  void dispose() {
    repsController.dispose();
    weightController.dispose();
  }
}

class _ExerciseDraft {
  final nameController = TextEditingController();
  final nameFocusNode = FocusNode();
  final sets = <_SetDraft>[_SetDraft()];

  void dispose() {
    nameController.dispose();
    nameFocusNode.dispose();
    for (final s in sets) {
      s.dispose();
    }
  }
}

class WorkoutLogScreen extends StatefulWidget {
  const WorkoutLogScreen({Key? key}) : super(key: key);

  @override
  State<WorkoutLogScreen> createState() => _WorkoutLogScreenState();
}

class _WorkoutLogScreenState extends State<WorkoutLogScreen> {
  static const _uuid = Uuid();
  final _apiService = ApiService();

  String _workoutType = 'strength';
  final _durationController = TextEditingController(text: '45');
  final _notesController = TextEditingController();
  double _rpe = 6;
  final _exercises = <_ExerciseDraft>[_ExerciseDraft()];
  bool _isSaving = false;

  @override
  void dispose() {
    _durationController.dispose();
    _notesController.dispose();
    for (final e in _exercises) {
      e.dispose();
    }
    super.dispose();
  }

  void _addExercise() {
    setState(() => _exercises.add(_ExerciseDraft()));
  }

  void _removeExercise(int index) {
    setState(() {
      _exercises[index].dispose();
      _exercises.removeAt(index);
    });
  }

  void _addSet(_ExerciseDraft exercise) {
    setState(() => exercise.sets.add(_SetDraft()));
  }

  void _removeSet(_ExerciseDraft exercise, int index) {
    if (exercise.sets.length <= 1) return;
    setState(() {
      exercise.sets[index].dispose();
      exercise.sets.removeAt(index);
    });
  }

  bool get _canSave =>
      _exercises.any((e) => e.nameController.text.trim().isNotEmpty) &&
      _durationController.text.isNotEmpty;

  Future<void> _save() async {
    final userId = context.read<AuthProvider>().currentUser?.uid ?? '';
    final validExercises = _exercises.where((e) => e.nameController.text.trim().isNotEmpty).toList();

    final exercises = validExercises
        .map((e) => Exercise(
              id: _uuid.v4(),
              name: e.nameController.text.trim(),
              category: _workoutType,
              targetMuscles: const [],
            ))
        .toList();

    final sets = validExercises.map((e) {
      var setNumber = 0;
      return e.sets
          .where((s) => s.repsController.text.isNotEmpty || s.weightController.text.isNotEmpty)
          .map((s) {
        setNumber++;
        return WorkoutSet(
          setNumber: setNumber,
          reps: int.tryParse(s.repsController.text),
          weight: double.tryParse(s.weightController.text),
        );
      }).toList();
    }).toList();

    setState(() => _isSaving = true);
    try {
      await context.read<WorkoutProvider>().logWorkout(WorkoutSession(
            id: '',
            userId: userId,
            date: DateTime.now(),
            workoutType: _workoutType,
            exercises: exercises,
            sets: sets,
            durationMinutes: int.tryParse(_durationController.text) ?? 0,
            notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
            rpe: _rpe,
          ));
      if (mounted) Navigator.pop(context);
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log workout'),
        actions: [
          TextButton(
            onPressed: (_canSave && !_isSaving) ? _save : null,
            child: _isSaving ? const KazaLoader(size: 18) : const Text('Save'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildTypeSelector(),
          const SizedBox(height: 16),
          ..._exercises.asMap().entries.map(
                (entry) => _buildExerciseCard(entry.value, entry.key),
              ),
          OutlinedButton.icon(
            onPressed: _addExercise,
            icon: const Icon(Icons.add),
            label: const Text('Add exercise'),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _durationController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Duration', suffixText: 'min'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text('Perceived effort (RPE)', style: Theme.of(context).textTheme.bodyMedium),
          Row(
            children: [
              Expanded(
                child: Slider(
                  value: _rpe,
                  min: 1,
                  max: 10,
                  divisions: 9,
                  activeColor: AppTheme.accent,
                  label: _rpe.round().toString(),
                  onChanged: (v) => setState(() => _rpe = v),
                ),
              ),
              SizedBox(width: 28, child: Text(_rpe.round().toString(), textAlign: TextAlign.end)),
            ],
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _notesController,
            decoration: const InputDecoration(labelText: 'Notes (optional)'),
            maxLines: 3,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildTypeSelector() {
    return Wrap(
      spacing: 8,
      children: _workoutTypes.map((type) {
        final selected = _workoutType == type;
        return ChoiceChip(
          label: Text(type[0].toUpperCase() + type.substring(1)),
          selected: selected,
          onSelected: (_) => setState(() => _workoutType = type),
          selectedColor: AppTheme.accent.withOpacity(0.2),
          side: BorderSide(color: selected ? AppTheme.accent : Colors.transparent),
        );
      }).toList(),
    );
  }

  Widget _buildExerciseCard(_ExerciseDraft exercise, int index) {
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
                  child: Autocomplete<Exercise>(
                    textEditingController: exercise.nameController,
                    focusNode: exercise.nameFocusNode,
                    optionsBuilder: (value) async {
                      if (value.text.trim().length < 2) return const Iterable<Exercise>.empty();
                      try {
                        return await _apiService.searchExercises(query: value.text.trim());
                      } catch (_) {
                        return const Iterable<Exercise>.empty();
                      }
                    },
                    displayStringForOption: (e) => e.name,
                    onSelected: (_) => setState(() {}),
                    fieldViewBuilder: (context, controller, focusNode, onSubmitted) {
                      return TextField(
                        controller: controller,
                        focusNode: focusNode,
                        decoration: const InputDecoration(
                          labelText: 'Exercise name',
                          helperText: 'Search the catalog or type your own',
                        ),
                        onChanged: (_) => setState(() {}),
                      );
                    },
                    optionsViewBuilder: (context, onSelected, options) {
                      return AutocompleteOptionsList<Exercise>(
                        options: options,
                        onSelected: onSelected,
                        labelBuilder: (e) => e.name,
                        subtitleBuilder: (e) => e.equipment ?? 'no equipment',
                      );
                    },
                  ),
                ),
                if (_exercises.length > 1)
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: () => _removeExercise(index),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Sets', style: Theme.of(context).textTheme.bodyMedium),
                TextButton.icon(
                  onPressed: () => _addSet(exercise),
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('Add set'),
                ),
              ],
            ),
            ...exercise.sets.asMap().entries.map((entry) {
              final setIndex = entry.key;
              final set = entry.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    SizedBox(width: 28, child: Text('${setIndex + 1}')),
                    Expanded(
                      child: TextField(
                        controller: set.repsController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'Reps', isDense: true),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: set.weightController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(labelText: 'Weight (kg)', isDense: true),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline, size: 20),
                      onPressed: exercise.sets.length > 1 ? () => _removeSet(exercise, setIndex) : null,
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
