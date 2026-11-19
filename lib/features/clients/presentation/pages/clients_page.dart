import 'package:flutter/material.dart';
import '../../data/models/client_model.dart';
import '../../domain/entities/client_entity.dart';
import '../../../../core/widgets/summary_widgets.dart';

class ClientsPage extends StatefulWidget {
  const ClientsPage({super.key});

  static const String routeName = '/clients';

  @override
  State<ClientsPage> createState() => _ClientsPageState();
}

class _ClientInfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _ClientInfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 14, color: const Color(0xFF94A3B8)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
          ),
        ),
      ],
    );
  }
}

class _ClientField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final TextInputType keyboardType;

  const _ClientField({
    required this.label,
    required this.hint,
    required this.controller,
    required this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Color(0xFF475569),
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ],
    );
  }
}

class _ClientsPageState extends State<ClientsPage> {
  final List<ClientEntity> _clients = List.from(ClientModel.mockClients);
  String _selectedCategory = 'Semua Kategori';
  String _searchQuery = '';

  List<ClientEntity> get _filteredClients {
    return _clients.where((c) {
      final matchesCat =
          _selectedCategory == 'Semua Kategori' ||
          c.category == _selectedCategory;
      final query = _searchQuery.toLowerCase();
      final matchesSearch =
          query.isEmpty ||
          c.name.toLowerCase().contains(query) ||
          c.email.toLowerCase().contains(query) ||
          c.address.toLowerCase().contains(query);
      return matchesCat && matchesSearch;
    }).toList();
  }

  void _showAddClientModal({ClientEntity? existing, int? index}) {
    final nameController = TextEditingController(text: existing?.name);
    final companyController = TextEditingController(text: existing?.company);
    final emailController = TextEditingController(text: existing?.email);
    final phoneController = TextEditingController(text: existing?.phone);
    final addressController = TextEditingController(text: existing?.address);
    String category = existing?.category ?? 'Klien';
    String status = existing?.status ?? 'aktif';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Padding(
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
                    Text(
                      existing == null
                          ? 'Tambah Mitra / Klien Baru'
                          : 'Ubah Mitra / Klien',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  'Daftarkan kontak mitra, pemilik proyek, atau vendor baru.',
                  style: TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                ),
                const SizedBox(height: 14),
                const Text(
                  'Kategori Kemitraan *',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF475569),
                  ),
                ),
                const SizedBox(height: 6),
                DropdownButtonFormField<String>(
                  initialValue: category,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  items: ['Klien', 'Vendor', 'Subkontraktor'].map((cat) {
                    return DropdownMenuItem(
                      value: cat,
                      child: Text(switch (cat) {
                        'Klien' => 'Klien (Pemilik Proyek)',
                        'Vendor' => 'Vendor (Supplier / Toko Material & Alat)',
                        _ => 'Subkontraktor (Mitra Pelaksana)',
                      }, style: const TextStyle(fontSize: 13)),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) setModalState(() => category = val);
                  },
                ),
                const SizedBox(height: 12),
                const Text(
                  'Nama Kontak / Penanggung Jawab *',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF475569),
                  ),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: 'Contoh: Budi Santoso',
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Nama Perusahaan / Instansi (Opsional)',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF475569),
                  ),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: companyController,
                  decoration: InputDecoration(
                    hintText: 'Contoh: PT Pembangunan Jaya Utama',
                    hintStyle: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF94A3B8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _ClientField(
                        label: 'No. Telepon / WhatsApp *',
                        hint: '081234567890',
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _ClientField(
                        label: 'Alamat Email (Opsional)',
                        hint: 'budi@perusahaan.com',
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  'Alamat Kantor / Domisili',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF475569),
                  ),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: addressController,
                  maxLines: 2,
                  decoration: InputDecoration(
                    hintText: 'Tuliskan alamat lengkap...',
                    hintStyle: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF94A3B8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('Batal'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.check, size: 16),
                      label: Text(
                        existing == null ? 'Simpan Data' : 'Simpan Perubahan',
                      ),
                      onPressed: () {
                        if (nameController.text.trim().isEmpty ||
                            phoneController.text.trim().isEmpty) {
                          return;
                        }
                        setState(() {
                          final updated = ClientEntity(
                            id:
                                existing?.id ??
                                DateTime.now().millisecondsSinceEpoch,
                            name: nameController.text.trim(),
                            email: emailController.text.trim(),
                            phone: phoneController.text.trim(),
                            address: addressController.text.trim(),
                            category: category,
                            contactPerson: nameController.text.trim(),
                            status: status,
                            company: companyController.text.trim(),
                          );
                          if (existing == null) {
                            _clients.insert(0, updated);
                          } else {
                            _clients[index!] = updated;
                          }
                        });
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              existing == null
                                  ? 'Data mitra/klien berhasil ditambahkan.'
                                  : 'Data mitra/klien berhasil diperbarui.',
                            ),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1D4ED8),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final list = _filteredClients;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Color(0xFF0F172A),
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Klien & Vendor',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: const Color(0xFFE2E8F0), height: 1),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.person_add_alt_1_rounded,
              color: Color(0xFF1D4ED8),
            ),
            tooltip: 'Tambah Mitra',
            onPressed: _showAddClientModal,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Header Search & Filter Bar
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    onChanged: (val) => setState(() => _searchQuery = val),
                    decoration: InputDecoration(
                      hintText: 'Cari nama, perusahaan, atau email...',
                      hintStyle: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF94A3B8),
                      ),
                      prefixIcon: const Icon(
                        Icons.search_rounded,
                        size: 20,
                        color: Color(0xFF94A3B8),
                      ),
                      filled: true,
                      fillColor: const Color(0xFFF1F5F9),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  AppFilterDropdown<String>(
                    value: _selectedCategory,
                    entries: const [
                      DropdownMenuEntry(
                        value: 'Semua Kategori',
                        label: 'Semua Kategori',
                      ),
                      DropdownMenuEntry(value: 'Klien', label: 'Klien'),
                      DropdownMenuEntry(value: 'Vendor', label: 'Vendor'),
                      DropdownMenuEntry(
                        value: 'Subkontraktor',
                        label: 'Subkontraktor',
                      ),
                    ],
                    onSelected: (value) => setState(
                      () => _selectedCategory = value ?? 'Semua Kategori',
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: Color(0xFFE2E8F0)),

            // Client Cards List
            Expanded(
              child: list.isEmpty
                  ? const Center(
                      child: Text(
                        'Tidak ada mitra atau klien yang sesuai.',
                        style: TextStyle(
                          color: Color(0xFF94A3B8),
                          fontSize: 13,
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: list.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final c = list[index];
                        final isKlien = c.category == 'Klien';
                        final isVendor = c.category == 'Vendor';
                        final badgeColor = isKlien
                            ? const Color(0xFF1D4ED8)
                            : (isVendor
                                  ? const Color(0xFFD97706)
                                  : const Color(0xFF7C3AED));
                        final badgeBg = isKlien
                            ? const Color(0xFFEFF6FF)
                            : (isVendor
                                  ? const Color(0xFFFFFBEB)
                                  : const Color(0xFFF5F3FF));

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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: badgeBg,
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(
                                        color: badgeColor.withValues(
                                          alpha: 0.3,
                                        ),
                                      ),
                                    ),
                                    child: Text(
                                      c.category.toUpperCase(),
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.6,
                                        color: badgeColor,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '#${c.id.toString().padLeft(5, '0')}',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontFamily: 'monospace',
                                      color: Color(0xFF94A3B8),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                c.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0F172A),
                                ),
                              ),
                              const SizedBox(height: 3),
                              Row(
                                children: [
                                  Icon(
                                    c.company.isNotEmpty
                                        ? Icons.business_outlined
                                        : Icons.person_outline,
                                    size: 15,
                                    color: const Color(0xFF94A3B8),
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      c.company.isNotEmpty
                                          ? c.company
                                          : 'Kontak Perorangan',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF94A3B8),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 14),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF8FAFC),
                                  border: Border.all(
                                    color: const Color(0xFFF1F5F9),
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  children: [
                                    _ClientInfoRow(
                                      icon: Icons.email_outlined,
                                      text: c.email.isNotEmpty
                                          ? c.email
                                          : 'Tidak ada email',
                                    ),
                                    const SizedBox(height: 8),
                                    _ClientInfoRow(
                                      icon: Icons.phone,
                                      text: c.phone.isNotEmpty
                                          ? c.phone
                                          : 'Tidak ada nomor telepon',
                                    ),
                                    const SizedBox(height: 8),
                                    _ClientInfoRow(
                                      icon: Icons.map_outlined,
                                      text: c.address.isNotEmpty
                                          ? c.address
                                          : 'Alamat belum diisi',
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 14),
                              const Divider(
                                height: 1,
                                color: Color(0xFFF1F5F9),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'CL-AG${c.id.toString().padLeft(5, '0')}',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontFamily: 'monospace',
                                      color: Color(0xFF94A3B8),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      OutlinedButton.icon(
                                        onPressed: () => _showAddClientModal(
                                          existing: c,
                                          index: _clients.indexOf(c),
                                        ),
                                        icon: const Icon(
                                          Icons.edit_outlined,
                                          size: 14,
                                        ),
                                        label: const Text('Ubah'),
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor: const Color(
                                            0xFF475569,
                                          ),
                                          side: const BorderSide(
                                            color: Color(0xFFE2E8F0),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 8,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      IconButton(
                                        onPressed: () =>
                                            setState(() => _clients.remove(c)),
                                        icon: const Icon(
                                          Icons.delete_outline,
                                          size: 17,
                                        ),
                                        color: const Color(0xFFE11D48),
                                        style: IconButton.styleFrom(
                                          backgroundColor: const Color(
                                            0xFFFFF1F2,
                                          ),
                                          side: const BorderSide(
                                            color: Color(0xFFFECDD3),
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              6,
                                            ),
                                          ),
                                        ),
                                        tooltip: 'Hapus Data',
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
