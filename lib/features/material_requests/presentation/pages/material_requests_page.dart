import 'package:flutter/material.dart';
import '../../data/models/material_request_model.dart';
import '../../domain/entities/material_request_entity.dart';

class MaterialRequestsPage extends StatefulWidget {
  const MaterialRequestsPage({super.key});

  static const String routeName = '/material-requests';

  @override
  State<MaterialRequestsPage> createState() => _MaterialRequestsPageState();
}

class _MaterialRequestsPageState extends State<MaterialRequestsPage> {
  final List<MaterialRequestEntity> _requests = List.from(MaterialRequestModel.mockRequests);
  String _selectedFilter = 'Semua';

  List<MaterialRequestEntity> get _filteredRequests {
    if (_selectedFilter == 'Semua') return _requests;
    return _requests.where((r) => r.status.toLowerCase() == _selectedFilter.toLowerCase()).toList();
  }

  String _formatRp(double val) {
    return 'Rp ${val.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}';
  }

  void _showBatchInputPosModal() {
    final projectController = TextEditingController(text: 'Pembangunan Gedung Kantor PT Maju Jaya');
    final List<Map<String, dynamic>> batchItems = [
      {
        'name': 'Semen Gresik Portland Composite',
        'type': 'Beli',
        'qty': 50,
        'unit': 'Sak',
        'price': 68000.0,
      },
      {
        'name': 'Besi Beton Ulir D13 mm x 12m',
        'type': 'Beli',
        'qty': 20,
        'unit': 'Batang',
        'price': 115000.0,
      },
    ];

    final itemNameController = TextEditingController();
    final itemQtyController = TextEditingController(text: '10');
    final itemPriceController = TextEditingController(text: '50000');
    final itemUnitController = TextEditingController(text: 'Unit');
    String itemType = 'Beli';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          double grandTotal = 0;
          for (final it in batchItems) {
            grandTotal += (it['qty'] as int) * (it['price'] as double);
          }

          return Padding(
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
                      Row(
                        children: const [
                          Icon(Icons.point_of_sale_rounded, color: Color(0xFF1D4ED8), size: 22),
                          SizedBox(width: 8),
                          Text(
                            'Batch Input POS Pengajuan',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                          ),
                        ],
                      ),
                      IconButton(icon: const Icon(Icons.close_rounded), onPressed: () => Navigator.pop(ctx)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Input cepat multi-item material (katalog gudang maupun custom) dalam satu keranjang pengajuan massal.',
                    style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                  ),
                  const SizedBox(height: 14),
                  const Text('Pilih Proyek Penerima', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF475569))),
                  const SizedBox(height: 6),
                  TextField(
                    controller: projectController,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Tambah Item ke Keranjang', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                        const SizedBox(height: 10),
                        TextField(
                          controller: itemNameController,
                          decoration: InputDecoration(
                            hintText: 'Nama material / alat (gudang / custom)',
                            hintStyle: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: DropdownButtonFormField<String>(
                                initialValue: itemType,
                                decoration: InputDecoration(
                                  labelText: 'Pengadaan',
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                items: const [
                                  DropdownMenuItem(value: 'Beli', child: Text('Beli (New)', style: TextStyle(fontSize: 12))),
                                  DropdownMenuItem(value: 'Sewa', child: Text('Sewa (Rent)', style: TextStyle(fontSize: 12))),
                                ],
                                onChanged: (v) => setModalState(() => itemType = v ?? 'Beli'),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              flex: 2,
                              child: TextField(
                                controller: itemQtyController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: 'Jumlah',
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              flex: 2,
                              child: TextField(
                                controller: itemUnitController,
                                decoration: InputDecoration(
                                  labelText: 'Satuan',
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: itemPriceController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: 'Est. Harga Satuan (Rp)',
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton.icon(
                              onPressed: () {
                                if (itemNameController.text.trim().isEmpty) return;
                                final q = int.tryParse(itemQtyController.text.trim()) ?? 1;
                                final p = double.tryParse(itemPriceController.text.trim()) ?? 0;
                                setModalState(() {
                                  batchItems.add({
                                    'name': itemNameController.text.trim(),
                                    'type': itemType,
                                    'qty': q,
                                    'unit': itemUnitController.text.trim().isNotEmpty ? itemUnitController.text.trim() : 'Unit',
                                    'price': p,
                                  });
                                  itemNameController.clear();
                                });
                              },
                              icon: const Icon(Icons.add, size: 16),
                              label: const Text('Tambah'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1D4ED8),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text('Daftar Keranjang Pengajuan', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                  const SizedBox(height: 8),
                  if (batchItems.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Text('Belum ada item dalam keranjang.', style: TextStyle(fontSize: 12, color: Color(0xFF94A3B8))),
                    )
                  else
                    ...batchItems.asMap().entries.map((entry) {
                      final i = entry.key;
                      final it = entry.value;
                      final subtotal = (it['qty'] as int) * (it['price'] as double);
                      return Container(
                        margin: const EdgeInsets.only(bottom: 6),
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: it['type'] == 'Beli' ? const Color(0xFFEFF6FF) : const Color(0xFFFEF3C7),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                it['type'] as String,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: it['type'] == 'Beli' ? const Color(0xFF1D4ED8) : const Color(0xFFB45309),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    it['name'] as String,
                                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                                  ),
                                  Text(
                                    '${it['qty']} ${it['unit']} x ${_formatRp(it['price'] as double)} = ${_formatRp(subtotal)}',
                                    style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline_rounded, size: 18, color: Color(0xFFE11D48)),
                              onPressed: () => setModalState(() => batchItems.removeAt(i)),
                            ),
                          ],
                        ),
                      );
                    }),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total Estimasi Anggaran:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                        Text(_formatRp(grandTotal), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1D4ED8))),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: batchItems.isEmpty
                          ? null
                          : () {
                              for (final it in batchItems) {
                                final cost = (it['qty'] as int) * (it['price'] as double);
                                _requests.insert(
                                  0,
                                  MaterialRequestEntity(
                                    id: DateTime.now().millisecondsSinceEpoch + batchItems.indexOf(it),
                                    requestCode: 'POS-2026-00${_requests.length + 1}',
                                    projectName: projectController.text.trim(),
                                    materialName: '${it['name']} (${it['type']})',
                                    quantity: it['qty'] as int,
                                    unit: it['unit'] as String,
                                    status: 'pending',
                                    requestedBy: 'Pelaksana Lapangan',
                                    date: 'Hari ini',
                                    estimatedCost: cost,
                                  ),
                                );
                              }
                              setState(() {});
                              Navigator.pop(ctx);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Berhasil membuat batch pengajuan ${batchItems.length} material!'),
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
                      child: const Text('SUBMIT BATCH PENGAJUAN POS', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showAddRequestModal() {
    final codeController = TextEditingController(text: 'REQ-2026-00${_requests.length + 1}');
    final projectController = TextEditingController();
    final materialController = TextEditingController();
    final qtyController = TextEditingController();
    final unitController = TextEditingController(text: 'Sak');
    final costController = TextEditingController();

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
                  const Text('Buat Pengajuan Material', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                  IconButton(icon: const Icon(Icons.close_rounded), onPressed: () => Navigator.pop(ctx)),
                ],
              ),
              const SizedBox(height: 12),
              const Text('Kode Pengajuan', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF475569))),
              const SizedBox(height: 6),
              TextField(
                controller: codeController,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(height: 12),
              const Text('Nama Proyek', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF475569))),
              const SizedBox(height: 6),
              TextField(
                controller: projectController,
                decoration: InputDecoration(
                  hintText: 'Pilih / ketik nama proyek',
                  hintStyle: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(height: 12),
              const Text('Material yang Diajukan', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF475569))),
              const SizedBox(height: 6),
              TextField(
                controller: materialController,
                decoration: InputDecoration(
                  hintText: 'Nama material / spesifikasi',
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
                        const Text('Jumlah', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF475569))),
                        const SizedBox(height: 6),
                        TextField(
                          controller: qtyController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: '100',
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
                        const Text('Satuan', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF475569))),
                        const SizedBox(height: 6),
                        TextField(
                          controller: unitController,
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
              const SizedBox(height: 12),
              const Text('Estimasi Anggaran (Rp)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF475569))),
              const SizedBox(height: 6),
              TextField(
                controller: costController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Contoh: 15000000',
                  hintStyle: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (projectController.text.trim().isEmpty || materialController.text.trim().isEmpty) return;
                    final qty = int.tryParse(qtyController.text.trim()) ?? 0;
                    final cost = double.tryParse(costController.text.trim()) ?? 0.0;

                    setState(() {
                      _requests.insert(
                        0,
                        MaterialRequestEntity(
                          id: DateTime.now().millisecondsSinceEpoch,
                          requestCode: codeController.text.trim(),
                          projectName: projectController.text.trim(),
                          materialName: materialController.text.trim(),
                          quantity: qty,
                          unit: unitController.text.trim(),
                          estimatedCost: cost,
                          status: 'pending',
                          requestedBy: 'Pengawas Lapangan',
                          date: 'Hari ini',
                        ),
                      );
                    });
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Pengajuan material berhasil disubmit!'),
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
                  child: const Text('KIRIM PENGAJUAN', style: TextStyle(fontWeight: FontWeight.bold)),
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
    final list = _filteredRequests;
    final pendingCount = _requests.where((r) => r.status == 'pending').length;
    final approvedCount = _requests.where((r) => r.status == 'approved').length;
    final deliveredCount = _requests.where((r) => r.status == 'delivered').length;

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
          'Pengajuan Material',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: const Color(0xFFE2E8F0), height: 1),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.point_of_sale_rounded, color: Color(0xFF1D4ED8)),
            tooltip: 'Batch Input POS',
            onPressed: _showBatchInputPosModal,
          ),
          IconButton(
            icon: const Icon(Icons.add_shopping_cart_rounded, color: Color(0xFF1D4ED8)),
            tooltip: 'Buat Pengajuan',
            onPressed: _showAddRequestModal,
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
              // Summary Row
              Row(
                children: [
                  Expanded(
                    child: _buildMetricCard('Pending', '$pendingCount', const Color(0xFFF59E0B)),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildMetricCard('Disetujui', '$approvedCount', const Color(0xFF3B82F6)),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildMetricCard('Terkirim', '$deliveredCount', const Color(0xFF10B981)),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Filter Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: ['Semua', 'Pending', 'Approved', 'Delivered', 'Rejected'].map((f) {
                    final isSel = _selectedFilter == f;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(f),
                        labelStyle: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: isSel ? Colors.white : const Color(0xFF475569),
                        ),
                        selected: isSel,
                        selectedColor: const Color(0xFF1D4ED8),
                        backgroundColor: Colors.white,
                        onSelected: (_) => setState(() => _selectedFilter = f),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 14),

              // Request Cards
              ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: list.length,
                separatorBuilder: (context, index) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final r = list[index];
                  final isDelivered = r.status == 'delivered';
                  final isApproved = r.status == 'approved';
                  final isPending = r.status == 'pending';
                  final badgeColor = isDelivered
                      ? const Color(0xFF059669)
                      : (isApproved
                          ? const Color(0xFF2563EB)
                          : (isPending ? const Color(0xFFD97706) : const Color(0xFFE11D48)));
                  final badgeBg = isDelivered
                      ? const Color(0xFFECFDF5)
                      : (isApproved
                          ? const Color(0xFFEFF6FF)
                          : (isPending ? const Color(0xFFFFFBEB) : const Color(0xFFFFF1F2)));

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
                            Text(r.requestCode, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF94A3B8))),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: badgeBg,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                r.status.toUpperCase(),
                                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: badgeColor),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(r.materialName, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                        const SizedBox(height: 2),
                        Text('Untuk: ${r.projectName}', style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Volume: ${r.quantity} ${r.unit}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF334155))),
                            Text(_formatRp(r.estimatedCost), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1D4ED8))),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Pemohon: ${r.requestedBy}', style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
                            Text(r.date, style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
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

  Widget _buildMetricCard(String title, String val, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          Text(title, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B), fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(val, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }
}
