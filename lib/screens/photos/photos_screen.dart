import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../../models/progress_photo.dart';
import '../../providers/auth_provider.dart';
import '../../providers/photo_provider.dart';
import '../../services/camera_service.dart';
import '../../theme/app_theme.dart';
import 'photo_compare_screen.dart';
import 'photo_detail_screen.dart';

const _angles = ['front', 'side', 'back'];

class PhotosScreen extends StatefulWidget {
  const PhotosScreen({Key? key}) : super(key: key);

  @override
  State<PhotosScreen> createState() => _PhotosScreenState();
}

class _PhotosScreenState extends State<PhotosScreen> {
  final _cameraService = CameraService();
  String _selectedAngle = 'front';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.read<AuthProvider>().currentUser != null) {
        context.read<PhotoProvider>().loadProgressPhotos();
      }
    });
  }

  Future<void> _captureAndUpload() async {
    final source = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Theme.of(context).cardTheme.color,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: const Text('Take photo'),
              onTap: () => Navigator.pop(context, 'camera'),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Choose from gallery'),
              onTap: () => Navigator.pop(context, 'gallery'),
            ),
          ],
        ),
      ),
    );

    if (source == null) return;

    final path = source == 'camera'
        ? await _cameraService.pickImageFromCamera()
        : await _cameraService.pickImageFromGallery();

    if (path == null || !mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    // Weight isn't prompted for here — could add a quick entry step before
    // upload later, but the photo shouldn't be blocked on it.
    final photo = await context.read<PhotoProvider>().uploadProgressPhoto(
          filePath: path,
          angle: _selectedAngle,
        );

    if (!mounted) return;
    Navigator.pop(context); // close loading dialog

    if (photo != null) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => PhotoDetailScreen(photo: photo)));
    } else {
      final error = context.read<PhotoProvider>().uploadError;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error ?? 'Upload failed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Progress photos'),
        actions: [
          Consumer<PhotoProvider>(
            builder: (context, provider, _) {
              final photos = provider.getPhotosByAngle(_selectedAngle);
              return IconButton(
                icon: const Icon(Icons.compare_arrows),
                tooltip: 'Compare',
                onPressed: photos.length >= 2
                    ? () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PhotoCompareScreen(photos: photos),
                          ),
                        )
                    : null,
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _captureAndUpload,
        backgroundColor: AppTheme.accent,
        foregroundColor: const Color(0xFF06251A),
        child: const Icon(Icons.add_a_photo),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Wrap(
              spacing: 8,
              children: _angles.map((angle) {
                final selected = _selectedAngle == angle;
                return ChoiceChip(
                  label: Text(angle[0].toUpperCase() + angle.substring(1)),
                  selected: selected,
                  onSelected: (_) => setState(() => _selectedAngle = angle),
                  selectedColor: AppTheme.accent.withOpacity(0.2),
                  side: BorderSide(color: selected ? AppTheme.accent : Colors.transparent),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: Consumer<PhotoProvider>(
              builder: (context, provider, _) {
                if (provider.isLoading && provider.getAllPhotos().isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                final photos = provider.getPhotosByAngle(_selectedAngle);
                if (photos.isEmpty) {
                  return _buildEmptyState();
                }
                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: photos.length,
                  itemBuilder: (context, index) => _buildPhotoTile(photos[index]),
                );
              },
            ),
          ),
        ],
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
            Icon(Icons.photo_camera_outlined, size: 48, color: AppTheme.accent),
            const SizedBox(height: 16),
            Text('No $_selectedAngle photos yet', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(
              'Tap the camera button to add your first one.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoTile(ProgressPhoto photo) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => PhotoDetailScreen(photo: photo)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: photo.photoUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(color: Theme.of(context).cardTheme.color),
              errorWidget: (context, url, error) => Container(
                color: Theme.of(context).cardTheme.color,
                child: const Icon(Icons.broken_image_outlined),
              ),
            ),
            Positioned(
              left: 8,
              bottom: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.55),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '${photo.date.month}/${photo.date.day}/${photo.date.year}',
                  style: const TextStyle(color: Colors.white, fontSize: 11),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
