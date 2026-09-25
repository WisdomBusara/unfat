import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../../models/progress_photo.dart';
import '../../theme/app_theme.dart';
import '../../widgets/kaza_loader.dart';

class PhotoDetailScreen extends StatelessWidget {
  final ProgressPhoto photo;

  const PhotoDetailScreen({Key? key, required this.photo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final analyzing = photo.aiAnalysis == null;

    return Scaffold(
      appBar: AppBar(
        title: Text(DateFormat('MMMM d, yyyy').format(photo.date)),
      ),
      body: ListView(
        children: [
          AspectRatio(
            aspectRatio: 3 / 4,
            child: CachedNetworkImage(
              imageUrl: photo.photoUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(color: Theme.of(context).cardTheme.color),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Chip(label: Text(photo.angle)),
                    if (photo.weight != null) ...[
                      const SizedBox(width: 8),
                      Chip(label: Text('${photo.weight} kg')),
                    ],
                  ],
                ),
                if (photo.notes.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(photo.notes, style: Theme.of(context).textTheme.bodyMedium),
                ],
                const SizedBox(height: 20),
                Row(
                  children: [
                    Icon(Icons.auto_awesome, color: AppTheme.accent, size: 20),
                    const SizedBox(width: 8),
                    Text('AI feedback', style: Theme.of(context).textTheme.headlineSmall),
                  ],
                ),
                const SizedBox(height: 10),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: analyzing
                        ? Row(
                            children: [
                              const KazaLoader(size: 16),
                              const SizedBox(width: 12),
                              Text('Analyzing...', style: Theme.of(context).textTheme.bodyMedium),
                            ],
                          )
                        : Text(photo.getAIAdvice(), style: Theme.of(context).textTheme.bodyLarge),
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
