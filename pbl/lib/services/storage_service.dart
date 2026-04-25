import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path/path.dart' as path;

class StorageService {
  final _supabase = Supabase.instance.client;

  // Upload file produk digital ke bucket 'produk-digital'
  Future<String> uploadProductFile(File file, String produkId) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) throw Exception('User tidak login');

      final fileName =
          '${DateTime.now().millisecondsSinceEpoch}_${path.basename(file.path)}';
      final filePath = 'produk-digital/$userId/$produkId/$fileName';

      await _supabase.storage
          .from('produk-digital')
          .upload(
            filePath,
            file,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
          );

      return filePath;
    } catch (e) {
      print('Error uploading product file: $e');
      rethrow;
    }
  }

  // Upload foto produk ke bucket 'foto-produk'
  Future<String> uploadProductImage(File image, String produkId) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) throw Exception('User tidak login');

      final fileName =
          '${DateTime.now().millisecondsSinceEpoch}_${path.basename(image.path)}';
      final filePath = 'foto-produk/$userId/$produkId/$fileName';

      await _supabase.storage
          .from('foto-produk')
          .upload(
            filePath,
            image,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
          );

      return filePath;
    } catch (e) {
      print('Error uploading product image: $e');
      rethrow;
    }
  }

  // Get public URL untuk foto produk
  String getPublicImageUrl(String filePath) {
    try {
      return _supabase.storage.from('foto-produk').getPublicUrl(filePath);
    } catch (e) {
      print('Error getting public image URL: $e');
      return '';
    }
  }

  // Download file produk digital (hanya untuk pembeli yang sudah bayar)
  Future<void> downloadProductFile(String filePath, String savePath) async {
    try {
      final fileData = await _supabase.storage
          .from('produk-digital')
          .download(filePath);

      final file = File(savePath);
      await file.writeAsBytes(fileData);
    } catch (e) {
      print('Error downloading product file: $e');
      rethrow;
    }
  }

  // Delete file produk digital
  Future<void> deleteProductFile(String filePath) async {
    try {
      await _supabase.storage.from('produk-digital').remove([filePath]);
    } catch (e) {
      print('Error deleting product file: $e');
      rethrow;
    }
  }

  // Delete foto produk
  Future<void> deleteProductImage(String filePath) async {
    try {
      await _supabase.storage.from('foto-produk').remove([filePath]);
    } catch (e) {
      print('Error deleting product image: $e');
      rethrow;
    }
  }

  // List files di folder tertentu
  Future<List<String>> listProductFiles(String produkId) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return [];

      final files = await _supabase.storage
          .from('produk-digital')
          .list(path: 'produk-digital/$userId/$produkId');

      return files.map((f) => f.name).toList();
    } catch (e) {
      print('Error listing product files: $e');
      return [];
    }
  }
}
