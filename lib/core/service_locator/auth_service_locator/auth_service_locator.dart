part of '../service_locator.dart';

class AuthServiceLocator {
  static Future<void> execute({required GetIt getIt}) async {
    getIt.registerLazySingleton<LoginDataSource>(
      () => LoginDataSourceImpl(getIt()),
    );
    getIt.registerFactory<LoginBloc>(() => LoginBloc(getIt()));

    getIt.registerLazySingleton<RegisterDataSource>(
      () => RegisterDataSourceImpl(getIt()),
    );
    getIt.registerFactory<RegisterBloc>(() => RegisterBloc(getIt()));

    getIt.registerLazySingleton<ForgetPasswordDataSource>(
      () => ForgetPasswordDataSourceImpl(getIt()),
    );
    getIt.registerFactory<ForgetPasswordBloc>(
      () => ForgetPasswordBloc(getIt()),
    );

    getIt.registerLazySingleton<VerifyOtpDataSource>(
      () => VerifyOtpDataSourceImpl(getIt()),
    );
    getIt.registerFactory<VerifyOtpBloc>(() => VerifyOtpBloc(getIt()));

    //logout
    getIt.registerLazySingleton<LogoutDataSource>(
      () => LogoutDataSourceImpl(getIt()),
    );
    getIt.registerFactory<LogoutBloc>(() => LogoutBloc(getIt(),));
    // gprofile
    getIt.registerLazySingleton<GetProfileDataSource>(
      () => GetProfileDataSourceImpl(getIt()),
    );
    getIt.registerFactory<GetProfileCubit>(() => GetProfileCubit(getIt()));
  }
}
