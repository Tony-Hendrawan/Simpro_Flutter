import 'package:fpdart/fpdart.dart';
import '../entities/dashboard_summary.dart';

abstract interface class DashboardRepository {
  Future<Either<String, DashboardSummary>> getDashboardSummary();
}