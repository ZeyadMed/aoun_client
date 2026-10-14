import 'package:aoun_client/core/helpers/helpers.dart';
import 'package:aoun_client/core/http/either.dart';
import 'package:aoun_client/core/http/failure.dart';
import 'package:aoun_client/core/http/http.dart';
import 'package:aoun_client/feature/main/home/data/model/dashboard_summary_model.dart';
import 'package:aoun_client/feature/main/home/data/model/recent_payment_model.dart';

abstract interface class DashboardDataSource {
  Future<Either<Failure, DashboardSummaryModel>> getDashboardSummary();
  Future<Either<Failure, List<RecentPaymentModel>>> getRecentPayments();
}

class DashboardDataSourceImpl implements DashboardDataSource {
  final GenericDataSource _genericDataSource;

  const DashboardDataSourceImpl(this._genericDataSource);

  @override
  Future<Either<Failure, DashboardSummaryModel>> getDashboardSummary() {
    return _genericDataSource.fetchResult<DashboardSummaryModel>(
      endpoint: Endpoints.dashboardSummary,
      fromJson: (json) => DashboardSummaryModel.fromJson(json),
    );
  }

  @override
  Future<Either<Failure, List<RecentPaymentModel>>> getRecentPayments() {
    return _genericDataSource.fetchData(
      endpoint: Endpoints.recentPayments,
      fromJson: (json) =>
          RecentPaymentModel.fromJson(json as Map<String, dynamic>),
    );
  }
}
