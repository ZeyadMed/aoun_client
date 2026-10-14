import 'package:dio/dio.dart';
import 'package:aoun_client/core/helpers/helpers.dart';
import 'package:aoun_client/core/http/either.dart';
import 'package:aoun_client/core/http/failure.dart';
import 'package:aoun_client/core/http/http.dart';
import 'package:aoun_client/core/local_storage/local_storage.dart';
import 'package:aoun_client/core/service_locator/service_locator.dart';
import 'package:aoun_client/feature/auth/models/user_model.dart';

import '../models/user_token.dart';

abstract interface class RegisterDataSource {
  Future<Either<Failure, UserToken>> register({
    required String fullname,
    required String email,
    required String phoneNumber,
    required String password,
    required String whatsappNumber,
    required String nationalId,
    required bool rememberMe,
    required String address,
    required String deviceId,
    required String deviceInfo,
    required String deviceToken,
  });
}

class RegisterDataSourceImpl implements RegisterDataSource {
  final GenericDataSource genericDataSource;
  RegisterDataSourceImpl(this.genericDataSource);

  @override
  Future<Either<Failure, UserToken>> register({
    required String fullname,
    required String email,
    required String phoneNumber,
    required String password,
    required String whatsappNumber,
    required String nationalId,
    required bool rememberMe,
    required String address,
    required String deviceId,
    required String deviceInfo,
    required String deviceToken,
  }) async {
    final result = await genericDataSource.postData<UserToken>(
      endpoint: Endpoints.register,
      data: {
        "fullName": fullname,
        "email": email,
        "nationalId": nationalId,
        "address": address,
        "phoneNumber": phoneNumber,
        "whatsappNumber": whatsappNumber,
        "password": password,
        "rememberMe": rememberMe,
        "deviceInfo": deviceInfo,
        "deviceId": deviceId,
        "deviceToken": deviceToken,
      },
      fromJson: (json) => UserToken.fromJson(json as Map<String, dynamic>),
      headers: {"Authorization": null},
      skipAuthRefresh: true,
    );

    return result.fold((fail) => Left(fail), (right) async {
      try {
        await getIt<ITokenCache>().saveAccessToken(right);

        // Also cache the user model so Profile/Edit Profile can use it
        final userModel = UserModel(
          id: right.userId,
          name: fullname,
          email: email,
          phone: phoneNumber,
        );
        await getIt<IUserCache>().cacheUserModel(userModel);

        getIt<Dio>().options.headers.addAll({
          "Authorization": "Bearer ${right.accessToken}",
        });
        logger(getIt<ITokenCache>().getAccessToken());
        return Right(right);
      } catch (e) {
        return Left(CacheFailure(message: e.toString()));
      }
    });
  }
}
