part of '../service_locator.dart';

final GetIt getIt = GetIt.instance;

abstract interface class DI {
  static Future<void> execute() async {
    await AuthServiceLocator.execute(getIt: getIt);
    await SharedServiceLocator.execute(getIt: getIt);
    await HiveServiceLocator.execute(getIt: getIt);
    await ThemeServiceLocator.execute(getIt: getIt);
    await GetProductServiceLocator.excute(getIt: getIt);
    await ContractsServiceLocator.execute(getIt: getIt);
    await HomeServicesLocator.excute(getIt: getIt);
    await StatementServiceLocator.execute(getIt: getIt);
  }
}
