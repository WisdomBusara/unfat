import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../../models/progress_photo.dart';
import '../../theme/app_theme.dart';

class PhotoCompareScreen extends StatefulWidget {
  final List<ProgressPhoto> photos; // newest first, same angle

  const PhotoCompareScreen({Key? key, required this.photos}) : super(key: key);

  @override
  State<PhotoCompareScreen> createState() => _PhotoCompareScreenState();
}

class _PhotoCompareScreenState extends State<PhotoCompareScreen> {
  late ProgressPhoto _before;
  late ProgressPhoto _after;

  @override
  void initState() {
    super.initState();
    _before = widget.photos.last; // oldest
    _after = widget.photos.first; // newest
  }

  @override
  Widget build(BuildContext context) {
    final weightDelta = (_before.weight != null && _after.weight != null)
        ? _after.weight! - _before.weight!
        : null;

    return Scaffold(
      appBar: AppBar(title: const Text('Compare')),
      body: ListView(
        children: [
          Row(
            children: [
              Expanded(child: _buildColumn(_before, isBefore: true)),
              Container(width: 1, color: Colors.white.withOpacity(0.08)),
              Expanded(child: _buildColumn(_after, isBefore: false)),
            ],
          ),
          if (weightDelta != null)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        weightDelta <= 0 ? Icons.trending_down : Icons.trending_up,
                        color: AppTheme.accent,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${weightDelta >= 0 ? '+' : ''}${weightDelta.toStringAsFixed(1)} kg over ${_after.date.difference(_before.date).inDays} days',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildColumn(ProgressPhoto photo, {required bool isBefore}) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: DropdownButton<ProgressPhoto>(
            value: photo,
            isExpanded: true,
            underline: const SizedBox.shrink(),
            items: widget.photos
                .map((p) => DropdownMenuItem(
                      value: p,
                      child: Text(
                        DateFormat('MMM d, yyyy').format(p.date),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ))
                .toList(),
            onChanged: (value) {
              if (value == null) return;
              setState(() {
                if (isBefore) {
                  _before = value;
                } else {
                  _after = value;
                }
              });
            },
          ),
        ),
        AspectRatio(
          aspectRatio: 3 / 4,
          child: CachedNetworkImage(
            imageUrl: photo.photoUrl,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(color: Theme.of(context).cardTheme.color),
          ),
        ),
        if (photo.weight != null)
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text('${photo.weight} kg', style: Theme.of(context).textTheme.bodyMedium),
          ),
      ],
    );
  }
}
