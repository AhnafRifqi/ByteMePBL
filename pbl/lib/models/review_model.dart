class ReviewModel {
  final String id;
  final String userId;
  final String produkId;
  final int rating; // 1-5
  final String? komentar;
  final DateTime tglReview;

  ReviewModel({
    required this.id,
    required this.userId,
    required this.produkId,
    required this.rating,
    this.komentar,
    required this.tglReview,
  });

  factory ReviewModel.fromMap(Map<String, dynamic> map) {
    return ReviewModel(
      id: map['review_id'],
      userId: map['user_id'],
      produkId: map['produk_id'],
      rating: map['rating'] ?? 5,
      komentar: map['komentar'],
      tglReview: DateTime.parse(map['tgl_review']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'review_id': id,
      'user_id': userId,
      'produk_id': produkId,
      'rating': rating,
      'komentar': komentar,
      'tgl_review': tglReview.toIso8601String(),
    };
  }
}
