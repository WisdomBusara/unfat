import 'package:flutter/material.dart';

/// Shared dropdown panel for Autocomplete<T> fields across the app
/// (exercise search, food search) — keeps the styling consistent instead
/// of each screen rolling its own options list.
class AutocompleteOptionsList<T extends Object> extends StatelessWidget {
  final Iterable<T> options;
  final AutocompleteOnSelected<T> onSelected;
  final String Function(T) labelBuilder;
  final String Function(T)? subtitleBuilder;

  const AutocompleteOptionsList({
    Key? key,
    required this.options,
    required this.onSelected,
    required this.labelBuilder,
    this.subtitleBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).cardTheme.color,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 240, minWidth: 280),
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 4),
            shrinkWrap: true,
            itemCount: options.length,
            itemBuilder: (context, index) {
              final option = options.elementAt(index);
              return ListTile(
                dense: true,
                title: Text(labelBuilder(option)),
                subtitle: subtitleBuilder != null ? Text(subtitleBuilder!(option)) : null,
                onTap: () => onSelected(option),
              );
            },
          ),
        ),
      ),
    );
  }
}
