import 'package:flutter/material.dart';
import '../../../settings/presentation/pages/system_settings_page.dart';

class DashboardDrawer extends StatelessWidget {
  const DashboardDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final menuItems = [
      _DrawerItemData(title: 'Dashboard', icon: Icons.dashboard_rounded, isSelected: true),
      _DrawerItemData(title: 'Klien & Vendor', icon: Icons.people_alt_outlined),
      _DrawerItemData(title: 'Survei Lokasi', icon: Icons.pin_drop_outlined),
      _DrawerItemData(title: 'Validasi Survei', icon: Icons.fact_check_outlined),
      _DrawerItemData(title: 'Daftar Proyek', icon: Icons.format_list_bulleted_rounded),
      _DrawerItemData(title: 'Laporan Pengerjaan Proyek', icon: Icons.description_outlined),
      _DrawerItemData(title: 'Logistik & Material', icon: Icons.inventory_2_outlined),
      _DrawerItemData(title: 'Pengajuan Material', icon: Icons.shopping_bag_outlined),
      _DrawerItemData(title: 'Alat Berat & Aset', icon: Icons.local_shipping_outlined),
      _DrawerItemData(title: 'Keuangan Proyek', icon: Icons.account_balance_wallet_outlined),
      _DrawerItemData(title: 'Dokumen Proyek', icon: Icons.folder_outlined),
      _DrawerItemData(title: 'Generate Laporan', icon: Icons.print_outlined),
      _DrawerItemData(title: 'Kelola User', icon: Icons.manage_accounts_outlined),
      _DrawerItemData(title: 'Pengaturan Sistem', icon: Icons.settings_outlined),
    ];

    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            // Header: SIMPRO branding
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1D4ED8).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Image.asset(
                      'assets/images/icon.png',
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stack) => const Icon(
                        Icons.business,
                        color: Color(0xFF1D4ED8),
                        size: 24,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'SIMPRO',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      Text(
                        'PT METAMAS GRAHA',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: Color(0xFFF1F5F9)),

            // Menus List
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                itemCount: menuItems.length,
                separatorBuilder: (context, index) => const SizedBox(height: 4),
                itemBuilder: (context, index) {
                  final item = menuItems[index];
                  return _DrawerTile(
                    item: item,
                    onTap: () {
                      if (item.title == 'Pengaturan Sistem') {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, SystemSettingsPage.routeName);
                      } else if (item.isSelected) {
                        Navigator.pop(context);
                      }
                      // Menu lainnya yang belum dibuat tidak bereaksi (tidak ngaruh)
                    },
                  );
                },
              ),
            ),

            const Divider(height: 1, color: Color(0xFFF1F5F9)),

            // Bottom Log Out item (belum difungsikan)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: ListTile(
                dense: true,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                leading: const Icon(
                  Icons.logout_rounded,
                  color: Color(0xFF64748B),
                  size: 20,
                ),
                title: const Text(
                  'Log Out',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF334155),
                  ),
                ),
                onTap: null, // Jangan difungsikan dulu
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerItemData {
  final String title;
  final IconData icon;
  final bool isSelected;

  _DrawerItemData({
    required this.title,
    required this.icon,
    this.isSelected = false,
  });
}

class _DrawerTile extends StatelessWidget {
  final _DrawerItemData item;
  final VoidCallback onTap;

  const _DrawerTile({
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (item.isSelected) {
      return Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1D4ED8),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF1D4ED8).withOpacity(0.25),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ListTile(
          dense: true,
          leading: Icon(item.icon, color: Colors.white, size: 20),
          title: Text(
            item.title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          onTap: onTap,
        ),
      );
    }

    return ListTile(
      dense: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      leading: Icon(item.icon, color: const Color(0xFF64748B), size: 20),
      title: Text(
        item.title,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: Color(0xFF334155),
        ),
      ),
      onTap: onTap,
    );
  }
}
