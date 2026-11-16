import 'package:flutter/material.dart';

import '../features/authentication/data/data_sources/authentication_local_data_source_impl.dart';
import '../features/authentication/data/repositories/authentication_repository_impl.dart';
import '../features/authentication/domain/entities/authentication.dart';

class AppPermissions {
  static const dashboardView = 'dashboard.view';
  static const clientsView = 'clients.view';
  static const projectsView = 'projects.view';
  static const progressView = 'progress.view';
  static const materialsView = 'materials.view';
  static const materialRequestsView = 'material_requests.view';
  static const equipmentsView = 'equipments.view';
  static const financeView = 'finance.view';
  static const documentsView = 'documents.view';
  static const reportsView = 'reports.view';
  static const reportsExport = 'reports.export';
  static const usersView = 'users.view';
  static const siteSurveysView = 'site-surveys.view';
  static const siteSurveysApprove = 'site-surveys.approve';
  static const settingsView = 'settings.view';
}

class AccessControl {
  static const _allPermissions = {
    AppPermissions.dashboardView,
    AppPermissions.clientsView,
    AppPermissions.projectsView,
    AppPermissions.progressView,
    AppPermissions.materialsView,
    AppPermissions.materialRequestsView,
    AppPermissions.equipmentsView,
    AppPermissions.financeView,
    AppPermissions.documentsView,
    AppPermissions.reportsView,
    AppPermissions.reportsExport,
    AppPermissions.usersView,
    AppPermissions.siteSurveysView,
    AppPermissions.siteSurveysApprove,
    AppPermissions.settingsView,
  };

  static const Map<String, Set<String>> rolePermissions = {
    'owner': _allPermissions,
    'admin': _allPermissions,
    'administrasi': {
      AppPermissions.dashboardView,
      AppPermissions.clientsView,
      AppPermissions.projectsView,
      AppPermissions.documentsView,
      AppPermissions.reportsView,
      AppPermissions.reportsExport,
    },
    'konsultan': {
      AppPermissions.dashboardView,
      AppPermissions.projectsView,
      AppPermissions.progressView,
      AppPermissions.documentsView,
      AppPermissions.reportsView,
      AppPermissions.siteSurveysView,
    },
    'pengawas': {
      AppPermissions.dashboardView,
      AppPermissions.projectsView,
      AppPermissions.progressView,
      AppPermissions.materialsView,
      AppPermissions.materialRequestsView,
      AppPermissions.equipmentsView,
      AppPermissions.documentsView,
      AppPermissions.reportsView,
      AppPermissions.siteSurveysView,
    },
    'logistik': {
      AppPermissions.dashboardView,
      AppPermissions.projectsView,
      AppPermissions.materialsView,
      AppPermissions.materialRequestsView,
      AppPermissions.equipmentsView,
      AppPermissions.documentsView,
      AppPermissions.reportsView,
    },
    'marketing': {
      AppPermissions.dashboardView,
      AppPermissions.clientsView,
      AppPermissions.projectsView,
      AppPermissions.documentsView,
      AppPermissions.reportsView,
    },
    'keuangan': {
      AppPermissions.dashboardView,
      AppPermissions.projectsView,
      AppPermissions.materialRequestsView,
      AppPermissions.financeView,
      AppPermissions.documentsView,
      AppPermissions.reportsView,
      AppPermissions.reportsExport,
    },
  };

  static bool can(String? role, String permission) {
    return rolePermissions[role?.toLowerCase()]?.contains(permission) ?? false;
  }

  static Future<Authentication?> currentUser() {
    return const AuthenticationRepositoryImpl(
      localDataSource: AuthenticationLocalDataSourceImpl(),
    ).getCurrentUser();
  }
}

class PermissionGuard extends StatelessWidget {
  final String permission;
  final Widget child;

  const PermissionGuard({
    required this.permission,
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Authentication?>(
      future: AccessControl.currentUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final user = snapshot.data;
        if (user != null && AccessControl.can(user.role, permission)) {
          return child;
        }

        return Scaffold(
          appBar: AppBar(title: const Text('Akses Ditolak')),
          body: const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Text(
                'Anda tidak memiliki izin untuk mengakses fitur ini.',
                textAlign: TextAlign.center,
              ),
            ),
          ),
        );
      },
    );
  }
}
