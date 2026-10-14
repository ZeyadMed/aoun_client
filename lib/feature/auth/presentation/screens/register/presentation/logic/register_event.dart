import 'package:equatable/equatable.dart';

class RegisterEvent extends Equatable {
    final String fullname;
    final String email;
    final String phoneNumber;
    final String password;
    final String whatsappNumber;
    final String nationalId;
    final bool rememberMe;
    final String address;
    final String deviceId;
    final String deviceInfo;
    final String deviceToken;
  const  RegisterEvent({
    required this.fullname,
    required this.email,
    required this.phoneNumber,
    required this.password,
    required this.whatsappNumber,
    required this.nationalId,
    required this.rememberMe,
    required this.address,
    required this.deviceId,
    required this.deviceInfo,
    required this.deviceToken,
  });

  @override
  List<Object?> get props => [
        fullname,
        email,
        phoneNumber,
        password,
        whatsappNumber,
        nationalId,
        rememberMe,
        address,
        deviceId,
        deviceInfo,
        deviceToken,
      ];
}