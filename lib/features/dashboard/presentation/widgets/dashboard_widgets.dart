import 'package:flutter/material.dart';
import '../../../settings/presentation/pages/system_settings_page.dart';

// ── Menu Grid (ikon + label, 4 kolom, langsung di beranda) ──
// Item dan jumlahnya sama persis dengan slide drawer (14 item).
// Awalnya ditampilkan 7 item, posisi ke-8 adalah "Tampilkan Semua"
// yang saat ditekan menampilkan semua menu + tombol "Sembunyikan".
class DashboardQuickActions extends StatefulWidget {
  final ValueChanged<int>? onSelectTab;

  const DashboardQuickActions({super.key, this.onSelectTab});

  @override
  State<DashboardQuickActions> createState() => _DashboardQuickActionsState();
}

class _DashboardQuickActionsState extends State<DashboardQuickActions> {
  bool _showAll = false;

  static const List<_MenuItem> _allItems = [
    _MenuItem(title: 'Klien & Vendor', icon: Icons.people_alt_outlined),
    _MenuItem(title: 'Survei Lokasi', icon: Icons.pin_drop_outlined),
    _MenuItem(title: 'Validasi Survei', icon: Icons.fact_check_outlined),
    _MenuItem(title: 'Daftar Proyek', icon: Icons.format_list_bulleted_rounded),
    _MenuItem(title: 'Laporan Pengerjaan Proyek', icon: Icons.description_outlined),
    _MenuItem(title: 'Logistik & Material', icon: Icons.inventory_2_outlined),
    _MenuItem(title: 'Pengajuan Material', icon: Icons.shopping_bag_outlined),
    _MenuItem(title: 'Alat Berat & Aset', icon: Icons.local_shipping_outlined),
    _MenuItem(title: 'Keuangan Proyek', icon: Icons.account_balance_wallet_outlined),
    _MenuItem(title: 'Dokumen Proyek', icon: Icons.folder_outlined),
    _MenuItem(title: 'Generate Laporan', icon: Icons.print_outlined),
    _MenuItem(title: 'Kelola User', icon: Icons.manage_accounts_outlined),
    _MenuItem(title: 'Pengaturan Sistem', icon: Icons.settings_outlined),
  ];

  List<_MenuItem> get _visibleItems {
    if (_showAll) {
      // 14 item drawer + 1 tombol "Sembunyikan" di posisi terakhir
      return [
        ..._allItems,
        const _MenuItem(title: 'Sembunyikan', icon: Icons.expand_less_rounded),
      ];
    }
    // 7 item pertama + 1 tombol "Tampilkan Semua"
    return [
      ..._allItems.sublist(0, 7),
      const _MenuItem(title: 'Tampilkan Semua', icon: Icons.expand_more_rounded),
    ];
  }

  void _onTap(_MenuItem item, BuildContext context) {
    if (item.title == 'Tampilkan Semua') {
      setState(() => _showAll = true);
      return;
    }
    if (item.title == 'Sembunyikan') {
      setState(() => _showAll = false);
      return;
    }
    if (item.title == 'Pengaturan Sistem') {
      Navigator.pushNamed(context, SystemSettingsPage.routeName);
      return;
    }
    if (item.title == 'Generate Laporan') {
      widget.onSelectTab?.call(1); // Tab Statistik
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Menu ${item.title} sedang dalam pengembangan'),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = _visibleItems;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Daftar Menu Layanan',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: items.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.78,
          ),
          itemBuilder: (context, index) {
            final item = items[index];
            return InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => _onTap(item, context),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      item.icon,
                      size: 28,
                      color: const Color(0xFF1D4ED8),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item.title,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _MenuItem {
  final String title;
  final IconData icon;
  const _MenuItem({required this.title, required this.icon});
}

// ── Metrics Summary Grid ──
class DashboardMetricsGrid extends StatelessWidget {
  const DashboardMetricsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    const metrics = [
      (title: 'PROYEK AKTIF', value: '5', isCur: false),
      (title: 'PROYEK SELESAI', value: '1', isCur: false),
      (title: 'TOTAL RAB', value: 'Rp 132.000.000.000', isCur: true),
      (title: 'REALISASI BIAYA', value: 'Rp 48.000.000.000', isCur: true),
    ];

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: metrics.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.6,
      ),
      itemBuilder: (context, index) {
        final item = metrics[index];
        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                item.title,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                  color: Color(0xFF64748B),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                item.value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: item.isCur ? 14 : 22,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF0F172A),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
