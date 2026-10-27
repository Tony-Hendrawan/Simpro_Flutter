import 'package:fpdart/fpdart.dart';
import '../entities/dashboard_summary.dart';
import '../repositories/dashboard_repository.dart';

class GetDashboardUseCase {
  final DashboardRepository repository;

  const GetDashboardUseCase(this.repository);

  Future<Either<String, DashboardSummary>> call() async {
    return repository.getDashboardSummary();
  }
}