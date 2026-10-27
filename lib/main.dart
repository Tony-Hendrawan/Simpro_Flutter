import 'package:flutter/material.dart';
import 'features/authentication/presentation/pages/authentication_page.dart';
import 'features/dashboard/presentation/pages/dashboard_page.dart';
import 'features/profile/presentation/pages/profile_page.dart';
import 'features/settings/presentation/pages/system_settings_page.dart';

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
        ProfilePage.routeName: (_) => const ProfilePage(),
        SystemSettingsPage.routeName: (_) => const SystemSettingsPage(),
      },
    );
  }
}
