import '../models/dashboard_model.dart';
import '../../domain/entities/dashboard_summary.dart';
import 'dashboard_local_data_source.dart';

class DashboardLocalDataSourceImpl implements DashboardLocalDataSource {
  const DashboardLocalDataSourceImpl();

  @override
  Future<DashboardSummary> getDashboardSummary() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return DashboardModel.fromPlaceholder();
  }
}
