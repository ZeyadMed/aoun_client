import 'package:aoun_client/core/helpers/helpers.dart';
import 'package:aoun_client/core/http/either.dart';
import 'package:aoun_client/core/http/failure.dart';
import 'package:aoun_client/core/http/http.dart';
import 'package:aoun_client/core/local_storage/local_storage.dart';
import 'package:aoun_client/core/service_locator/service_locator.dart';

abstract interface class LogoutDataSource {
  Future<Either<Failure, void>> logoutAcount();
}

class LogoutDataSourceImpl implements LogoutDataSource {
  final GenericDataSource genericDataSource;

  LogoutDataSourceImpl(this.genericDataSource);

  @override
  Future<Either<Failure, void>> logoutAcount() async {
    final refreshToken =
        getIt<ITokenCache>().getAccessToken()?.refreshToken ?? "";
    final result = await genericDataSource.postData<void>(
      endpoint: Endpoints.logout,
      data: {"refreshToken": refreshToken},
    );

    return result.fold((l) => Left(l), (r) async {
      await getIt<ITokenCache>().clearAccessToken();
      await getIt<IUserCache>().clearUserModel();
      return Right(r);
    });
  }
}
