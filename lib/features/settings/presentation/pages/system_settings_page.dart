import 'package:flutter/material.dart';

import '../widgets/company_profile_card.dart';
import '../widgets/settings_widgets.dart';

class SystemSettingsPage extends StatefulWidget {
  const SystemSettingsPage({super.key});

  static const String routeName = '/settings';

  @override
  State<SystemSettingsPage> createState() => _SystemSettingsPageState();
}

class _SystemSettingsPageState extends State<SystemSettingsPage> {
  String _companyName = 'CV Arthamas Graha';
  String _address = 'Jl. Jenderal Sudirman No. 12, Jakarta Selatan';
  String _phone = '021-5551234';
  String _email = 'info@arthamasgraha.com';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF0F172A), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Pengaturan Sistem',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: const Color(0xFFE2E8F0),
            height: 1,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SettingsHeader(),
              const SizedBox(height: 20),
              CompanyProfileCard(
                onChanged: (name, address, phone, email) {
                  setState(() {
                    _companyName = name;
                    _address = address;
                    _phone = phone;
                    _email = email;
                  });
                },
              ),
              const SizedBox(height: 20),
              LetterheadPreviewCard(
                companyName: _companyName,
                address: _address,
                phone: _phone,
                email: _email,
              ),
              const SizedBox(height: 20),
              const RelatedModulesCard(),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
