import 'package:flutter/material.dart';
import '../../data/models/equipment_model.dart';
import '../../domain/entities/equipment_entity.dart';

class EquipmentsPage extends StatefulWidget {
  const EquipmentsPage({super.key});

  static const String routeName = '/equipments';

  @override
  State<EquipmentsPage> createState() => _EquipmentsPageState();
}

class _EquipmentsPageState extends State<EquipmentsPage> {
  final List<EquipmentEntity> _equipments = List.from(EquipmentModel.mockEquipments);
  String _selectedStatus = 'Semua Status';

  List<EquipmentEntity> get _filteredEquipments {
    if (_selectedStatus == 'Semua Status') return _equipments;
    return _equipments.where((e) => e.status.toLowerCase() == _selectedStatus.toLowerCase()).toList();
  }

  String _formatRp(double val) {
    return 'Rp ${val.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}';
  }

  void _showAddEquipmentModal() {
    final codeController = TextEditingController(text: 'EQP-NEW-0${_equipments.length + 1}');
    final nameController = TextEditingController();
    final conditionController = TextEditingController(text: 'Sangat Baik');
    final costController = TextEditingController(text: '1000000');
    String status = 'tersedia';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Daftarkan Alat / Aset Baru', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                  IconButton(icon: const Icon(Icons.close_rounded), onPressed: () => Navigator.pop(ctx)),
                ],
              ),
              const SizedBox(height: 12),
              const Text('Kode Alat', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF475569))),
              const SizedBox(height: 6),
              TextField(
                controller: codeController,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(height: 12),
              const Text('Nama Alat Berat / Aset', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF475569))),
              const SizedBox(height: 6),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: 'Contoh: Dump Truck Hino 500',
                  hintStyle: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Kondisi Mesin / Fisik', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF475569))),
                        const SizedBox(height: 6),
                        TextField(
                          controller: conditionController,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Tarif Sewa/Hari (Rp)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF475569))),
                        const SizedBox(height: 6),
                        TextField(
                          controller: costController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (nameController.text.trim().isEmpty) return;
                    final cost = double.tryParse(costController.text.trim()) ?? 0;

                    setState(() {
                      _equipments.insert(
                        0,
                        EquipmentEntity(
                          id: DateTime.now().millisecondsSinceEpoch,
                          code: codeController.text.trim(),
                          name: nameController.text.trim(),
                          status: status,
                          condition: conditionController.text.trim(),
                          dailyCost: cost,
                          projectName: null,
                        ),
                      );
                    });
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Alat / Aset baru berhasil didaftarkan!'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1D4ED8),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('SIMPAN ALAT / ASET', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final list = _filteredEquipments;
    final total = _equipments.length;
    final ready = _equipments.where((e) => e.status == 'tersedia').length;
    final active = _equipments.where((e) => e.status == 'dipinjam').length;
    final repair = _equipments.where((e) => e.status == 'diservis').length;

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
          'Alat Berat & Aset',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: const Color(0xFFE2E8F0), height: 1),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline_rounded, color: Color(0xFF1D4ED8)),
            tooltip: 'Tambah Alat',
            onPressed: _showAddEquipmentModal,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Stat Row
              Row(
                children: [
                  Expanded(child: _buildStatCard('Total Aset', '$total', const Color(0xFF0F172A))),
                  const SizedBox(width: 8),
                  Expanded(child: _buildStatCard('Tersedia', '$ready', const Color(0xFF10B981))),
                  const SizedBox(width: 8),
                  Expanded(child: _buildStatCard('Dipinjam', '$active', const Color(0xFF1D4ED8))),
                  const SizedBox(width: 8),
                  Expanded(child: _buildStatCard('Servis', '$repair', const Color(0xFFF59E0B))),
                ],
              ),
              const SizedBox(height: 16),

              // Filter Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: ['Semua Status', 'Tersedia', 'Dipinjam', 'Diservis'].map((st) {
                    final isSel = _selectedStatus.toLowerCase() == st.toLowerCase();
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(st),
                        labelStyle: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: isSel ? Colors.white : const Color(0xFF475569),
                        ),
                        selected: isSel,
                        selectedColor: const Color(0xFF1D4ED8),
                        backgroundColor: Colors.white,
                        onSelected: (_) => setState(() => _selectedStatus = st),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 14),

              // Equipments List
              ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: list.length,
                separatorBuilder: (context, index) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final e = list[index];
                  final isReady = e.status == 'tersedia';
                  final isLoaned = e.status == 'dipinjam';
                  final badgeColor = isReady
                      ? const Color(0xFF059669)
                      : (isLoaned ? const Color(0xFF1D4ED8) : const Color(0xFFD97706));
                  final badgeBg = isReady
                      ? const Color(0xFFECFDF5)
                      : (isLoaned ? const Color(0xFFEFF6FF) : const Color(0xFFFFFBEB));

                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(e.code, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF94A3B8))),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: badgeBg,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                e.status.toUpperCase(),
                                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: badgeColor),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(e.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                        const SizedBox(height: 4),
                        Text('Kondisi: ${e.condition}', style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              e.projectName != null ? 'Lokasi: ${e.projectName}' : 'Lokasi: Pool / Gudang Pusat',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: e.projectName != null ? const Color(0xFF1E293B) : const Color(0xFF94A3B8),
                              ),
                            ),
                            Text(
                              '${_formatRp(e.dailyCost)} / hr',
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1D4ED8)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String val, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          Text(title, style: const TextStyle(fontSize: 10, color: Color(0xFF64748B), fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(val, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }
}
