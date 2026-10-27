import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/use_cases/get_dashboard_use_case.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final GetDashboardUseCase getDashboardUseCase;

  DashboardBloc({
    required this.getDashboardUseCase,
  }) : super(const DashboardInitial()) {
    on<DashboardLoadRequested>(_onLoadRequested);
  }

  Future<void> _onLoadRequested(
    DashboardLoadRequested event,
    Emitter<DashboardState> emit,
  ) async {
    emit(const DashboardLoading());
    final result = await getDashboardUseCase();
    result.fold(
      (failure) => emit(DashboardFailure(failure)),
      (summary) => emit(DashboardSuccess(summary)),
    );
  }
}