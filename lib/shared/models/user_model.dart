import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String userId;
  final String phoneNumber;
  final String firebaseUid;
  final String? farmerId;
  final bool profileCompleted;
  final DateTime createdAt;
  final DateTime updatedAt;

  const User({
    required this.userId,
    required this.phoneNumber,
    required this.firebaseUid,
    this.farmerId,
    required this.profileCompleted,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['user_id'] as String,
      phoneNumber: json['phone_number'] as String,
      firebaseUid: json['firebase_uid'] as String,
      farmerId: json['farmer_id'] as String?,
      profileCompleted: json['profile_completed'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'phone_number': phoneNumber,
      'firebase_uid': firebaseUid,
      'farmer_id': farmerId,
      'profile_completed': profileCompleted,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  User copyWith({
    String? userId,
    String? phoneNumber,
    String? firebaseUid,
    String? farmerId,
    bool? profileCompleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      userId: userId ?? this.userId,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      firebaseUid: firebaseUid ?? this.firebaseUid,
      farmerId: farmerId ?? this.farmerId,
      profileCompleted: profileCompleted ?? this.profileCompleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    userId,
    phoneNumber,
    firebaseUid,
    farmerId,
    profileCompleted,
    createdAt,
    updatedAt,
  ];
}
