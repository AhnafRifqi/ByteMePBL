import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

class StorageService {
  final _supabase = Supabase.instance.client;

  Future<String?> uploadFile(File file, String bucket, String fileName) async {
    final userId = _supabase.auth.currentUser!.id;
    final path = '$userId/$fileName';
    
    await _supabase.storage.from(bucket).upload(path, file);
    return path;
  }

  Future<String> getDownloadUrl(String path) async {
    return await _supabase.storage.from('produk-digital').createSignedUrl(path, 60);
  }
}