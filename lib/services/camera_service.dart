import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';

class CameraService {
  static final CameraService _instance = CameraService._internal();
  late List<CameraDescription> cameras;
  CameraController? controller;

  factory CameraService() {
    return _instance;
  }

  CameraService._internal();

  Future<void> initialize() async {
    cameras = await availableCameras();
  }

  Future<void> initializeCamera({bool useFrontCamera = false}) async {
    final cameraIndex = useFrontCamera
        ? cameras.indexWhere((c) => c.lensDirection == CameraLensDirection.front)
        : cameras.indexWhere((c) => c.lensDirection == CameraLensDirection.back);

    if (cameraIndex == -1) {
      throw Exception('No suitable camera found');
    }

    controller = CameraController(
      cameras[cameraIndex],
      ResolutionPreset.high,
    );

    await controller!.initialize();
  }

  Future<String?> takePicture() async {
    if (controller == null || !controller!.value.isInitialized) {
      return null;
    }

    try {
      final image = await controller!.takePicture();
      return image.path;
    } catch (e) {
      print('Error taking picture: $e');
      return null;
    }
  }

  Future<String?> pickImageFromGallery() async {
    try {
      final picker = ImagePicker();
      final image = await picker.pickImage(source: ImageSource.gallery);
      return image?.path;
    } catch (e) {
      print('Error picking image: $e');
      return null;
    }
  }

  Future<String?> pickImageFromCamera() async {
    try {
      final picker = ImagePicker();
      final image = await picker.pickImage(source: ImageSource.camera);
      return image?.path;
    } catch (e) {
      print('Error picking image from camera: $e');
      return null;
    }
  }

  void dispose() {
    controller?.dispose();
  }
}
