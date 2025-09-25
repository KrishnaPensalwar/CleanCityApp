class User {
  final String uid;
  final String fullName;
  final String email;
  final String mobileNumber;
  final String role;
  final int rewardPoints;
  final DateTime registeredAt;
  final bool isActive;

  User({
    required this.uid,
    required this.fullName,
    required this.email,
    required this.mobileNumber,
    required this.role,
    required this.rewardPoints,
    required this.registeredAt,
    required this.isActive,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      uid: json['uid'] ?? '',  // default empty string if null
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      mobileNumber: json['mobileNumber'] ?? '',
      role: json['role'] ?? '',
      rewardPoints: json['rewardPoints'] ?? 0,
      registeredAt: json['registeredAt'] != null
          ? DateTime.tryParse(json['registeredAt']) ?? DateTime.now()
          : DateTime.now(),
      isActive: json['isActive'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'fullName': fullName,
      'email': email,
      'mobileNumber': mobileNumber,
      'role': role,
      'rewardPoints': rewardPoints,
      'registeredAt': registeredAt.toIso8601String(),
      'isActive': isActive,
    };
  }
}
