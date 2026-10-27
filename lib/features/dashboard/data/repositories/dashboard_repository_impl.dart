import 'package:fpdart/fpdart.dart';
import '../../domain/entities/dashboard_summary.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../data_sources/dashboard_local_data_source.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardLocalDataSource localDataSource;

  const DashboardRepositoryImpl({
    required this.localDataSource,
  });

  @override
  Future<Either<String, DashboardSummary>> getDashboardSummary() async {
    try {
      final summary = await localDataSource.getDashboardSummary();
      return Right(summary);
    } catch (e) {
      return Left('Gagal memuat data dashboard: ${e.toString()}');
    }
  }
}