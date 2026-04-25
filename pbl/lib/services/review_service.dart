import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/review_model.dart';

class ReviewService {
  final _supabase = Supabase.instance.client;

  Future<List<ReviewModel>> getProductReviews(String produkId) async {
    try {
      final data = await _supabase
          .from('review')
          .select()
          .eq('produk_id', produkId)
          .order('tgl_review', ascending: false);

      return (data as List).map((item) => ReviewModel.fromMap(item)).toList();
    } catch (e) {
      print('Error getting reviews: $e');
      return [];
    }
  }

  Future<ReviewModel?> getMyReview(String produkId) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return null;

      final data = await _supabase
          .from('review')
          .select()
          .eq('produk_id', produkId)
          .eq('user_id', userId)
          .single();

      return ReviewModel.fromMap(data);
    } catch (e) {
      print('Error getting my review: $e');
      return null;
    }
  }

  Future<String> createReview(
    String produkId,
    int rating,
    String? komentar,
  ) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) throw Exception('User tidak login');

      final result = await _supabase
          .from('review')
          .insert({
            'user_id': userId,
            'produk_id': produkId,
            'rating': rating,
            'komentar': komentar,
          })
          .select()
          .single();

      return result['review_id'];
    } catch (e) {
      print('Error creating review: $e');
      rethrow;
    }
  }

  Future<void> updateReview(
    String reviewId,
    int rating,
    String? komentar,
  ) async {
    try {
      await _supabase
          .from('review')
          .update({'rating': rating, 'komentar': komentar})
          .eq('review_id', reviewId);
    } catch (e) {
      print('Error updating review: $e');
      rethrow;
    }
  }

  Future<double> getAverageRating(String produkId) async {
    try {
      final result = await _supabase
          .from('review')
          .select('rating')
          .eq('produk_id', produkId);

      if ((result as List).isEmpty) return 0.0;

      final sum = (result).fold<int>(
        0,
        (prev, item) => prev + (item['rating'] as int),
      );
      return sum / result.length;
    } catch (e) {
      print('Error getting average rating: $e');
      return 0.0;
    }
  }
}
