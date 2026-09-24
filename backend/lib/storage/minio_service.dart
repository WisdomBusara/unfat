import 'dart:typed_data';
import 'package:minio/minio.dart';
import 'package:uuid/uuid.dart';
import '../env.dart';

class MinioService {
  static const _uuid = Uuid();
  static Minio? _client;

  static Minio get client {
    _client ??= Minio(
      endPoint: Env.minioEndpoint,
      port: Env.minioPort,
      accessKey: Env.minioAccessKey,
      secretKey: Env.minioSecretKey,
      useSSL: Env.minioUseSsl,
    );
    return _client!;
  }

  static bool _bucketChecked = false;

  static Future<void> ensureBucket() async {
    if (_bucketChecked) return;
    final exists = await client.bucketExists(Env.minioBucket);
    if (!exists) {
      await client.makeBucket(Env.minioBucket);
    }
    _bucketChecked = true;
  }

  /// Uploads photo bytes under `progress_photos/<userId>/<uuid>.<ext>` and
  /// returns (objectKey, publicUrl).
  static Future<({String objectKey, String publicUrl})> uploadPhoto({
    required String userId,
    required Uint8List bytes,
    required String contentType,
  }) async {
    await ensureBucket();
    final ext = contentType == 'image/png' ? 'png' : 'jpg';
    final objectKey = 'progress_photos/$userId/${_uuid.v4()}.$ext';

    await client.putObject(
      Env.minioBucket,
      objectKey,
      Stream.value(bytes),
      size: bytes.length,
      metadata: {'Content-Type': contentType},
    );

    final publicUrl = '${Env.minioPublicUrl}/${Env.minioBucket}/$objectKey';
    return (objectKey: objectKey, publicUrl: publicUrl);
  }

  static Future<void> deletePhoto(String objectKey) async {
    await client.removeObject(Env.minioBucket, objectKey);
  }
}
