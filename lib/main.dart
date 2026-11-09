import 'package:flutter/material.dart';
import 'features/authentication/presentation/pages/authentication_page.dart';
import 'features/clients/presentation/pages/clients_page.dart';
import 'features/dashboard/presentation/pages/dashboard_page.dart';
import 'features/documents/presentation/pages/documents_page.dart';
import 'features/equipments/presentation/pages/equipments_page.dart';
import 'features/finance/presentation/pages/finance_page.dart';
import 'features/material_requests/presentation/pages/material_requests_page.dart';
import 'features/materials/presentation/pages/materials_page.dart';
import 'features/profile/presentation/pages/profile_page.dart';
import 'features/progress/presentation/pages/progress_report_page.dart';
import 'features/projects/presentation/pages/projects_page.dart';
import 'features/reports/presentation/pages/reports_export_page.dart';
import 'features/reports/presentation/pages/statistics_page.dart';
import 'features/settings/presentation/pages/system_settings_page.dart';
import 'features/surveys/presentation/pages/survey_approvals_page.dart';
import 'features/surveys/presentation/pages/surveys_page.dart';
import 'features/users/presentation/pages/users_management_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SimproApp());
}

class SimproApp extends StatelessWidget {
  const SimproApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SIMPRO',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1D4ED8)),
        fontFamily: 'Inter',
      ),
      initialRoute: AuthenticationPage.routeName,
      routes: {
        AuthenticationPage.routeName: (_) => const AuthenticationPage(),
        DashboardPage.routeName: (_) => const DashboardPage(),
        StatisticsPage.routeName: (_) => const StatisticsPage(),
        ProfilePage.routeName: (_) => const ProfilePage(),
        SystemSettingsPage.routeName: (_) => const SystemSettingsPage(),
        ClientsPage.routeName: (_) => const ClientsPage(),
        SurveysPage.routeName: (_) => const SurveysPage(),
        SurveyApprovalsPage.routeName: (_) => const SurveyApprovalsPage(),
        ProjectsPage.routeName: (_) => const ProjectsPage(),
        ProgressReportPage.routeName: (_) => const ProgressReportPage(),
        MaterialsPage.routeName: (_) => const MaterialsPage(),
        MaterialRequestsPage.routeName: (_) => const MaterialRequestsPage(),
        EquipmentsPage.routeName: (_) => const EquipmentsPage(),
        FinancePage.routeName: (_) => const FinancePage(),
        DocumentsPage.routeName: (_) => const DocumentsPage(),
        ReportsExportPage.routeName: (_) => const ReportsExportPage(),
        UsersManagementPage.routeName: (_) => const UsersManagementPage(),
      },
    );
  }
}
