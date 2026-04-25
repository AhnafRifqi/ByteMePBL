class ProfileModel {
  final String id;
  final String username;
  final String role;
  final DateTime createdAt;

  ProfileModel({
    required this.id,
    required this.username,
    required this.role,
    required this.createdAt,
  });

  factory ProfileModel.fromMap(Map<String, dynamic> map) {
    return ProfileModel(
      id: map['id'],
      username: map['username'],
      role: map['role'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }
}