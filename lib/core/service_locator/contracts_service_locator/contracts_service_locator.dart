import 'package:get_it/get_it.dart';
import 'package:aoun_client/feature/main/contracts/data/data_source/get_contracts_data_source.dart';
import 'package:aoun_client/feature/main/contracts/presentation/bloc/get_contract_installments_cubit.dart';
import 'package:aoun_client/feature/main/contracts/presentation/bloc/get_contracts_cubit.dart';
import 'package:aoun_client/feature/main/contracts/presentation/bloc/get_overdue_installments_cubit.dart';
import 'package:aoun_client/feature/main/contracts/presentation/bloc/get_recent_contracts_cubit.dart';

class ContractsServiceLocator {
  static Future<void> execute({required GetIt getIt}) async {
    getIt.registerLazySingleton<GetContractsDataSource>(
      () => GetContractsDataSourceImpl(getIt()),
    );
    getIt.registerFactory<GetContractsCubit>(() => GetContractsCubit(getIt()));
    getIt.registerFactory<GetRecentContractsCubit>(
      () => GetRecentContractsCubit(getIt()),
    );
    getIt.registerFactory<GetContractInstallmentsCubit>(
      () => GetContractInstallmentsCubit(getIt()),
    );
    getIt.registerFactory<GetOverdueInstallmentsCubit>(
      () => GetOverdueInstallmentsCubit(getIt()),
    );
  }
}
