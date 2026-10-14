import 'package:equatable/equatable.dart';

class LoginEvent extends Equatable {
  final String phoneNumber;
  final String password;
  final bool rememberMe;
  final String deviceId;
  final String deviceInfo;
  final String deviceToken;

  const LoginEvent({
    required this.phoneNumber,
    required this.password,
    required this.rememberMe,
    required this.deviceId,
    required this.deviceInfo,
    required this.deviceToken,
  });

  @override
  List<Object?> get props => [
        phoneNumber,
        password,
        rememberMe,
        deviceId,
        deviceInfo,
        deviceToken,
      ];
}
