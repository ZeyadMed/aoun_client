import 'package:get_it/get_it.dart';
import 'package:aoun_client/feature/main/home/data/data_source/dashboard_data_source.dart';
import 'package:aoun_client/feature/main/home/presentation/bloc/dashboard_summary_cubit.dart';
import 'package:aoun_client/feature/main/home/presentation/bloc/recent_payments_cubit.dart';

class HomeServicesLocator {
  static Future<void> excute({required GetIt getIt}) async {
    // Dashboard Summary
    getIt.registerLazySingleton<DashboardDataSource>(
      () => DashboardDataSourceImpl(getIt()),
    );
    getIt.registerFactory<DashboardSummaryCubit>(
      () => DashboardSummaryCubit(getIt()),
    );
    getIt.registerFactory<RecentPaymentsCubit>(
      () => RecentPaymentsCubit(getIt()),
    );
  }
}
