import 'package:flutter/material.dart';
import '../../../../core/widgets/summary_widgets.dart';
import '../../data/models/document_model.dart';
import '../../domain/entities/document_entity.dart';

class DocumentsPage extends StatefulWidget {
  const DocumentsPage({super.key});

  static const String routeName = '/documents';

  @override
  State<DocumentsPage> createState() => _DocumentsPageState();
}

class _DocumentsPageState extends State<DocumentsPage> {
  final List<DocumentEntity> _documents = List.from(
    DocumentModel.mockDocuments,
  );
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'Semua Kategori';
  int _activeTab = 0; // 0: Dokumen Aktif, 1: Arsip Dokumen

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<DocumentEntity> get _filteredDocuments {
    final baseList = _documents
        .where((d) => _activeTab == 0 ? !d.isArchived : d.isArchived)
        .toList();
    final q = _searchController.text.trim().toLowerCase();
    return baseList.where((d) {
      final matchesCat = _selectedCategory == 'Semua Kategori' ||
          d.category.toLowerCase() == _selectedCategory.toLowerCase();
      final matchesSearch = q.isEmpty ||
          d.name.toLowerCase().contains(q) ||
          d.projectName.toLowerCase().contains(q);
      return matchesCat && matchesSearch;
    }).toList();
  }

  void _showUploadDialog() {
    final nameController = TextEditingController();
    final projectController = TextEditingController(
      text: 'Pembangunan Gedung Kantor PT Maju Jaya',
    );
    String cat = 'kontrak';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
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
                  const Text(
                    'Unggah Berkas Dokumen',
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
              const SizedBox(height: 12),
              const Text(
                'Kategori Dokumen',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF475569),
                ),
              ),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                initialValue: cat,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'kontrak',
                    child: Text(
                      'Kontrak Kerja (SPK)',
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'gambar_kerja',
                    child: Text(
                      'Gambar Kerja (DED)',
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'rab',
                    child: Text(
                      'RAB & Estimasi',
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'laporan',
                    child: Text(
                      'Laporan Proyek',
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'legal',
                    child: Text(
                      'Legalitas & Perizinan',
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'lainnya',
                    child: Text(
                      'Dokumen Lainnya',
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                ],
                onChanged: (val) {
                  if (val != null) cat = val;
                },
              ),
              const SizedBox(height: 12),
              const Text(
                'Nama Berkas',
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
                  hintText: 'Contoh: SPK_Final_Pekerjaan.pdf',
                  hintStyle: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF94A3B8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Nama Proyek Terkait',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF475569),
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: projectController,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (nameController.text.trim().isEmpty) return;
                    setState(() {
                      _documents.insert(
                        0,
                        DocumentEntity(
                          id: DateTime.now().millisecondsSinceEpoch,
                          name: nameController.text.trim(),
                          category: cat,
                          projectName: projectController.text.trim(),
                          size: '2.4 MB',
                          uploadedBy: 'Administrasi',
                        ),
                      );
                    });
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Dokumen berhasil diunggah ke repositori!',
                        ),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  icon: const Icon(Icons.cloud_upload_rounded, size: 18),
                  label: const Text(
                    'UNGGAH SEKARANG',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1D4ED8),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
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
    final list = _filteredDocuments;

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
          'Dokumen Proyek',
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
              Icons.upload_file_rounded,
              color: Color(0xFF1D4ED8),
            ),
            tooltip: 'Unggah Dokumen',
            onPressed: _showUploadDialog,
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
              // 4 Stat Metric Cards (Persis Web v3)
              Row(
                children: [
                  Expanded(
                    child: AppMetricCard(
                      title: 'Total Berkas',
                      value: '${_documents.length}',
                      accentColor: const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: AppMetricCard(
                      title: 'Legal & SPK',
                      value: '${_documents.where((d) => d.category.toLowerCase().contains('kontrak') || d.category.toLowerCase().contains('legal')).length}',
                      accentColor: const Color(0xFF4F46E5),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: AppMetricCard(
                      title: 'DED Teknis',
                      value: '${_documents.where((d) => d.category.toLowerCase().contains('gambar')).length}',
                      accentColor: const Color(0xFF0284C7),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: AppMetricCard(
                      title: 'RAB & Lap',
                      value: '${_documents.where((d) => d.category.toLowerCase().contains('rab') || d.category.toLowerCase().contains('laporan')).length}',
                      accentColor: const Color(0xFF059669),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Tab Switcher (Dokumen Aktif vs Arsip Dokumen)
              AppSegmentedTab(
                tabs: [
                  'Dokumen Aktif (${_documents.where((d) => !d.isArchived).length})',
                  'Arsip Dokumen (${_documents.where((d) => d.isArchived).length})',
                ],
                selectedIndex: _activeTab,
                onTabSelected: (idx) => setState(() => _activeTab = idx),
              ),
              const SizedBox(height: 12),

              // Search Bar
              AppSearchBar(
                hintText: 'Cari nama berkas dokumen, nomor SPK, atau proyek...',
                controller: _searchController,
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 10),

              // Filter Categories Bar
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    'Semua Kategori',
                    'Kontrak',
                    'Gambar_Kerja',
                    'RAB',
                    'Laporan',
                    'Legalitas & Perizinan',
                    'Dokumen Lainnya',
                  ].map((cat) {
                    final isSel = _selectedCategory.toLowerCase() == cat.toLowerCase();
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(cat.replaceAll('_', ' ')),
                        labelStyle: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: isSel ? Colors.white : const Color(0xFF475569),
                        ),
                        selected: isSel,
                        selectedColor: const Color(0xFF1D4ED8),
                        backgroundColor: Colors.white,
                        onSelected: (_) => setState(() => _selectedCategory = cat),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 14),

              // Documents List
              if (list.isEmpty)
                AppEmptyStateCard(
                  icon: _activeTab == 0 ? Icons.folder_open_rounded : Icons.archive_outlined,
                  title: _activeTab == 0 ? 'Tidak Ada Dokumen Aktif' : 'Arsip Dokumen Kosong',
                  message: _activeTab == 0
                      ? 'Tidak ditemukan dokumen aktif yang sesuai dengan kriteria filter.'
                      : 'Tidak ada dokumen yang sedang berada di folder arsip.',
                )
              else
                ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: list.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final d = list[index];
                        final isPdf = d.name.endsWith('.pdf');
                        final isXlsx = d.name.endsWith('.xlsx');
                        final icon = isPdf
                            ? Icons.picture_as_pdf_rounded
                            : (isXlsx
                                  ? Icons.table_chart_rounded
                                  : Icons.insert_drive_file_rounded);
                        final iconColor = isPdf
                            ? const Color(0xFFE11D48)
                            : (isXlsx
                                  ? const Color(0xFF059669)
                                  : const Color(0xFF1D4ED8));
                        final iconBg = isPdf
                            ? const Color(0xFFFFF1F2)
                            : (isXlsx
                                  ? const Color(0xFFECFDF5)
                                  : const Color(0xFFEFF6FF));

                        return Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: iconBg,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(icon, color: iconColor, size: 22),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      d.name,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF0F172A),
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      d.projectName,
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: Color(0xFF64748B),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${d.category.toUpperCase()} · ${d.size} · Oleh ${d.uploadedBy}',
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color: Color(0xFF94A3B8),
                                      ),
                                    ),
                                    if (d.isArchived) ...[
                                      const SizedBox(height: 4),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFFEF2F2),
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                        ),
                                        child: const Text(
                                          'Diarsipkan',
                                          style: TextStyle(
                                            fontSize: 9,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFFDC2626),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                              Column(
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.download_rounded,
                                      color: Color(0xFF1D4ED8),
                                      size: 20,
                                    ),
                                    tooltip: 'Unduh Berkas',
                                    onPressed: () {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Mengunduh berkas ${d.name}...',
                                          ),
                                          behavior: SnackBarBehavior.floating,
                                        ),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      d.isArchived
                                          ? Icons.unarchive_rounded
                                          : Icons.archive_outlined,
                                      color: d.isArchived
                                          ? const Color(0xFF059669)
                                          : const Color(0xFF64748B),
                                      size: 18,
                                    ),
                                    tooltip: d.isArchived
                                        ? 'Pulihkan Dokumen'
                                        : 'Arsipkan Dokumen',
                                    onPressed: () {
                                      final targetIdx = _documents.indexWhere(
                                        (doc) => doc.id == d.id,
                                      );
                                      if (targetIdx != -1) {
                                        setState(() {
                                          _documents[targetIdx] = d.copyWith(
                                            isArchived: !d.isArchived,
                                            archivedAt: !d.isArchived
                                                ? DateTime.now()
                                                : null,
                                          );
                                        });
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              !d.isArchived
                                                  ? 'Dokumen berhasil dipindahkan ke tab Arsip.'
                                                  : 'Dokumen berhasil dipulihkan ke Dokumen Aktif.',
                                            ),
                                            behavior: SnackBarBehavior.floating,
                                          ),
                                        );
                                      }
                                    },
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
}
