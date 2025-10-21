import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class SupabaseStorageService {
  final SupabaseClient _supabase = Supabase.instance.client;
  final Uuid _uuid = const Uuid();

  Future<String?> uploadImage({
    required File imageFile,
    required String bucket,
    required String folder,
  }) async {
    try {
      final String fileName = '${_uuid.v4()}.jpg';
      final String filePath = '$folder/$fileName';
      await _supabase.storage
          .from(bucket)
          .upload(
            filePath,
            imageFile,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
          );
      final String publicUrl = _supabase.storage.from(bucket).getPublicUrl(filePath);
      return publicUrl;
    } catch (e) {
      throw Exception('Failed to upload image to Supabase: $e');
    }
  }

  Future<void> deleteImage({required String bucket, required String filePath}) async {
    try {
      await _supabase.storage.from(bucket).remove([filePath]);
    } catch (e) {
      throw Exception('Failed to delete image from Supabase: $e');
    }
  }

  String extractFilePathFromUrl(String url, String bucket) {
    final uri = Uri.parse(url);
    final path = uri.path;
    final bucketPrefix = '/storage/v1/object/public/$bucket/';
    if (path.contains(bucketPrefix)) {
      return path.substring(path.indexOf(bucketPrefix) + bucketPrefix.length);
    }
    return '';
  }
}
