import 'package:get_it/get_it.dart';
import 'package:aoun_client/feature/main/statement/data/data_source/statement_data_source.dart';
import 'package:aoun_client/feature/main/statement/presentation/bloc/get_contract_products_cubit.dart';
import 'package:aoun_client/feature/main/statement/presentation/bloc/get_statement_cubit.dart';

class StatementServiceLocator {
  static Future<void> execute({required GetIt getIt}) async {
    getIt.registerLazySingleton<StatementDataSource>(
      () => StatementDataSourceImpl(getIt()),
    );
    getIt.registerFactory<GetContractProductsCubit>(
      () => GetContractProductsCubit(getIt()),
    );
    getIt.registerFactory<GetStatementCubit>(() => GetStatementCubit(getIt()));
  }
}
