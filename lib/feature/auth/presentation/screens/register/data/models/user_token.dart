import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
part 'user_token.g.dart';

@HiveType(typeId: 0)
class UserToken extends Equatable {
  @HiveField(0)
  final String accessToken;
  @HiveField(1)
  final String refreshToken;
  @HiveField(2)
  final String userType;
  @HiveField(3)
  final String userId;
  @HiveField(4)
  final String email;
  @HiveField(5)
  final String userName;
  @HiveField(6)
  final DateTime expiresAtUtc;

  const UserToken({
    required this.accessToken,
    required this.refreshToken,
    required this.userType,
    required this.userId,
    required this.email,
    required this.userName,
    required this.expiresAtUtc,
  });

  factory UserToken.fromJson(Map<String, dynamic> json) {
    // If accessToken is at the top level, it means we are receiving only the 'data' part of the response.
    // Otherwise, we look for 'data' key.
    final data = json.containsKey('accessToken') ? json : (json['data'] ?? {});
    return UserToken(
      accessToken: data['accessToken'] ?? "",
      refreshToken: data['refreshToken'] ?? "",
      userType: data['userType'] ?? "",
      userId: data['userId']?.toString() ?? "",
      email: data['email'] ?? "",
      userName: data['userName'] ?? "",
      expiresAtUtc:
          DateTime.tryParse(data['expiresAtUtc'] ?? "") ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "accessToken": accessToken,
      "refreshToken": refreshToken,
      "userType": userType,
      "userId": userId,
      "email": email,
      "userName": userName,
      "expiresAtUtc": expiresAtUtc.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
    accessToken,
    refreshToken,
    userType,
    userId,
    email,
    userName,
    expiresAtUtc,
  ];
}
