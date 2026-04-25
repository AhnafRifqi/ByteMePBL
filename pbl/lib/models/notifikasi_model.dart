class NotifikasiModel {
  final String id;
  final String userId;
  final String? sanksiId;
  final String? reviewId;
  final String catatan;
  final String status; // belum_dibaca, dibaca
  final DateTime createdAt;

  NotifikasiModel({
    required this.id,
    required this.userId,
    this.sanksiId,
    this.reviewId,
    required this.catatan,
    required this.status,
    required this.createdAt,
  });

  factory NotifikasiModel.fromMap(Map<String, dynamic> map) {
    return NotifikasiModel(
      id: map['notif_id'],
      userId: map['user_id'],
      sanksiId: map['sanksi_id'],
      reviewId: map['review_id'],
      catatan: map['catatan'] ?? '',
      status: map['status'] ?? 'belum_dibaca',
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'notif_id': id,
      'user_id': userId,
      'sanksi_id': sanksiId,
      'review_id': reviewId,
      'catatan': catatan,
      'status': status,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
