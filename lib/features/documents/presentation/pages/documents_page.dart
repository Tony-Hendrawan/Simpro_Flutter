import 'package:flutter/material.dart';

import '../../../../core/access_control.dart';
import '../../../../core/widgets/summary_widgets.dart';
import '../../../authentication/domain/entities/authentication.dart';
import '../../../projects/data/models/project_model.dart';
import '../../data/models/document_model.dart';
import '../../domain/entities/document_entity.dart';

class DocumentsPage extends StatefulWidget {
  const DocumentsPage({super.key});

  static const String routeName = '/documents';

  @override
  State<DocumentsPage> createState() => _DocumentsPageState();
}

class _DocumentsPageState extends State<DocumentsPage> {
  final List<DocumentEntity> _documents = List.from(DocumentModel.mockDocuments);
  final TextEditingController _searchController = TextEditingController();

  String _selectedCategory = 'semua';
  int? _selectedProjectId;
  int _activeTab = 0; // 0: Dokumen Aktif, 1: Arsip Dokumen
  Authentication? _currentUser;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    final user = await AccessControl.currentUser();
    if (mounted) setState(() => _currentUser = user);
  }

  bool get _canDelete {
    final role = _currentUser?.role?.toLowerCase();
    return role == 'owner' || role == 'admin';
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  final List<Map<String, dynamic>> _categoryFilters = const [
    {'key': 'semua', 'label': 'Semua Dokumen', 'icon': Icons.folder_copy_outlined},
    {'key': 'legal', 'label': 'Legalitas & Perizinan', 'icon': Icons.gavel_rounded},
    {'key': 'kontrak', 'label': 'Kontrak Kerja (SPK)', 'icon': Icons.assignment_outlined},
    {'key': 'gambar_kerja', 'label': 'Gambar Kerja (DED)', 'icon': Icons.architecture_rounded},
    {'key': 'rab', 'label': 'RAB & Estimasi', 'icon': Icons.table_chart_outlined},
    {'key': 'laporan', 'label': 'Laporan Proyek', 'icon': Icons.description_outlined},
    {'key': 'lainnya', 'label': 'Dokumen Lainnya', 'icon': Icons.more_horiz_rounded},
  ];

  List<DocumentEntity> get _filteredDocuments {
    final baseList = _documents
        .where((d) => _activeTab == 0 ? !d.isArchived : d.isArchived)
        .toList();
    final q = _searchController.text.trim().toLowerCase();

    return baseList.where((d) {
      final matchesCat = _selectedCategory == 'semua' ||
          d.category.toLowerCase() == _selectedCategory.toLowerCase();
      final matchesProject = _selectedProjectId == null ||
          d.projectId == _selectedProjectId;
      final matchesSearch = q.isEmpty ||
          d.name.toLowerCase().contains(q) ||
          d.projectName.toLowerCase().contains(q) ||
          (d.projectCode ?? '').toLowerCase().contains(q);
      return matchesCat && matchesProject && matchesSearch;
    }).toList();
  }

  String _formatDate(DateTime? dt) {
    if (dt == null) return '16/11/2026';
    final d = dt.day.toString().padLeft(2, '0');
    final m = dt.month.toString().padLeft(2, '0');
    final y = dt.year.toString();
    return '$d/$m/$y';
  }

  Map<String, dynamic> _getFileMeta(String fileName) {
    final lower = fileName.toLowerCase();
    if (lower.endsWith('.xlsx') || lower.endsWith('.xls') || lower.endsWith('.csv')) {
      return {
        'icon': Icons.table_chart_rounded,
        'color': const Color(0xFF059669),
        'bg': const Color(0xFFECFDF5),
      };
    } else if (lower.endsWith('.pdf')) {
      return {
        'icon': Icons.picture_as_pdf_rounded,
        'color': const Color(0xFFE11D48),
        'bg': const Color(0xFFFFF1F2),
      };
    } else if (lower.endsWith('.dwg') || lower.endsWith('.dxf')) {
      return {
        'icon': Icons.architecture_rounded,
        'color': const Color(0xFF0284C7),
        'bg': const Color(0xFFF0F9FF),
      };
    } else if (lower.endsWith('.doc') || lower.endsWith('.docx')) {
      return {
        'icon': Icons.description_rounded,
        'color': const Color(0xFF2563EB),
        'bg': const Color(0xFFEFF6FF),
      };
    } else if (lower.endsWith('.zip') || lower.endsWith('.rar')) {
      return {
        'icon': Icons.folder_zip_rounded,
        'color': const Color(0xFFD97706),
        'bg': const Color(0xFFFFFBEB),
      };
    }
    return {
      'icon': Icons.insert_drive_file_rounded,
      'color': const Color(0xFF64748B),
      'bg': const Color(0xFFF8FAFC),
    };
  }

  Map<String, dynamic> _getCategoryMeta(String cat) {
    switch (cat.toLowerCase()) {
      case 'legal':
      case 'legalitas':
        return {
          'label': 'Legalitas & Perizinan',
          'color': const Color(0xFF4338CA),
          'bg': const Color(0xFFEEF2FF),
          'border': const Color(0xFFC7D2FE),
        };
      case 'kontrak':
        return {
          'label': 'Kontrak Kerja (SPK)',
          'color': const Color(0xFF1D4ED8),
          'bg': const Color(0xFFEFF6FF),
          'border': const Color(0xFFBFDBFE),
        };
      case 'gambar_kerja':
      case 'gambar':
        return {
          'label': 'Gambar Kerja (DED)',
          'color': const Color(0xFF0284C7),
          'bg': const Color(0xFFF0F9FF),
          'border': const Color(0xFFBAE6FD),
        };
      case 'rab':
        return {
          'label': 'RAB & Estimasi',
          'color': const Color(0xFF059669),
          'bg': const Color(0xFFECFDF5),
          'border': const Color(0xFFA7F3D0),
        };
      case 'laporan':
        return {
          'label': 'Laporan Proyek',
          'color': const Color(0xFFE11D48),
          'bg': const Color(0xFFFFF1F2),
          'border': const Color(0xFFFECDD3),
        };
      case 'lainnya':
      default:
        return {
          'label': 'Dokumen Lainnya',
          'color': const Color(0xFF475569),
          'bg': const Color(0xFFF8FAFC),
          'border': const Color(0xFFE2E8F0),
        };
    }
  }

  int _countByCategory(String catKey) {
    final activeDocs = _documents.where((d) => !d.isArchived);
    if (catKey == 'semua') return activeDocs.length;
    return activeDocs.where((d) => d.category.toLowerCase() == catKey.toLowerCase()).length;
  }

  // Modal Unggah Dokumen Proyek (Sesuai Versi Web)
  void _showUploadDialog() {
    final projects = ProjectModel.mockProjects;
    int? selectedProjectId = projects.isNotEmpty ? projects.first.id : 1;
    final nameController = TextEditingController();
    final driveUrlController = TextEditingController();
    String category = 'kontrak';
    String selectedFileName = '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
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
                // Header Modal
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEFF6FF),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.cloud_upload_outlined,
                            size: 20,
                            color: Color(0xFF1D4ED8),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Unggah Dokumen Proyek',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Tambahkan berkas digital ke repositori arsip proyek.',
                              style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                            ),
                          ],
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, color: Color(0xFF64748B), size: 20),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Pilihan Proyek Terkait
                const Text(
                  'Proyek Terkait *',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF334155)),
                ),
                const SizedBox(height: 6),
                DropdownButtonFormField<int>(
                  value: selectedProjectId,
                  isExpanded: true,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  items: projects.map((p) {
                    final code = p.code.startsWith('PR') ? p.code : 'PR0${p.id}';
                    return DropdownMenuItem<int>(
                      value: p.id,
                      child: Text(
                        '$code - ${p.name}',
                        style: const TextStyle(fontSize: 12),
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) setModalState(() => selectedProjectId = val);
                  },
                ),
                const SizedBox(height: 12),

                // Nama Dokumen & Kategori Dokumen (2 Kolom)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Nama Dokumen *',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF334155)),
                          ),
                          const SizedBox(height: 6),
                          TextField(
                            controller: nameController,
                            style: const TextStyle(fontSize: 12),
                            decoration: InputDecoration(
                              hintText: 'Contoh: SPK_Final_Pekerjaan.pdf',
                              hintStyle: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
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
                          const Text(
                            'Kategori Dokumen *',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF334155)),
                          ),
                          const SizedBox(height: 6),
                          DropdownButtonFormField<String>(
                            value: category,
                            isExpanded: true,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            items: const [
                              DropdownMenuItem(value: 'legal', child: Text('Legalitas & Perizinan', style: TextStyle(fontSize: 11))),
                              DropdownMenuItem(value: 'kontrak', child: Text('Kontrak Kerja (SPK)', style: TextStyle(fontSize: 11))),
                              DropdownMenuItem(value: 'gambar_kerja', child: Text('Gambar Kerja (DED)', style: TextStyle(fontSize: 11))),
                              DropdownMenuItem(value: 'rab', child: Text('RAB & Estimasi', style: TextStyle(fontSize: 11))),
                              DropdownMenuItem(value: 'laporan', child: Text('Laporan Proyek', style: TextStyle(fontSize: 11))),
                              DropdownMenuItem(value: 'lainnya', child: Text('Dokumen Lainnya', style: TextStyle(fontSize: 11))),
                            ],
                            onChanged: (val) {
                              if (val != null) setModalState(() => category = val);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Pilih Berkas Dokumen Fisik
                const Text(
                  'Pilih Berkas Dokumen',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF334155)),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Format: PDF, Word, Excel, DWG, ZIP, atau Gambar (Maks. 25 MB)',
                  style: TextStyle(fontSize: 10, color: Color(0xFF94A3B8)),
                ),
                const SizedBox(height: 6),
                InkWell(
                  onTap: () {
                    // Simulasi pemilihan file berkas
                    final suggestedName = nameController.text.trim().isNotEmpty
                        ? nameController.text.trim()
                        : 'Berkas_${category.toUpperCase()}_${DateTime.now().millisecondsSinceEpoch % 1000}.pdf';
                    setModalState(() {
                      selectedFileName = suggestedName;
                      if (nameController.text.trim().isEmpty) {
                        nameController.text = suggestedName;
                      }
                    });
                  },
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: selectedFileName.isNotEmpty ? const Color(0xFF1D4ED8) : const Color(0xFFE2E8F0),
                        style: BorderStyle.solid,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          selectedFileName.isNotEmpty ? Icons.check_circle_rounded : Icons.attach_file_rounded,
                          color: selectedFileName.isNotEmpty ? const Color(0xFF059669) : const Color(0xFF64748B),
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            selectedFileName.isNotEmpty ? selectedFileName : 'Klik untuk memilih berkas dari perangkat...',
                            style: TextStyle(
                              fontSize: 11,
                              color: selectedFileName.isNotEmpty ? const Color(0xFF0F172A) : const Color(0xFF94A3B8),
                              fontWeight: selectedFileName.isNotEmpty ? FontWeight.w600 : FontWeight.normal,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEFF6FF),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: const Color(0xFFBFDBFE)),
                          ),
                          child: const Text(
                            'Pilih File',
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF1D4ED8)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Tautan Google Drive Manual (Opsional)
                const Text(
                  'Atau Tautan Google Drive Manual (Opsional)',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF334155)),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: driveUrlController,
                  style: const TextStyle(fontSize: 12),
                  decoration: InputDecoration(
                    hintText: 'https://drive.google.com/file/d/...',
                    hintStyle: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
                    prefixIcon: const Icon(Icons.link_rounded, size: 18, color: Color(0xFF94A3B8)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 10),

                // Warning Banner
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFBEB),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFFDE68A)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Icon(Icons.warning_amber_rounded, size: 16, color: Color(0xFFD97706)),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Penting: Pastikan setelan akses tautan Google Drive diatur ke "Siapa saja yang memiliki link" agar dapat diunduh tim.',
                          style: TextStyle(fontSize: 10, color: Color(0xFF92400E)),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),

                // Tombol Aksi Modal
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('Batal', style: TextStyle(color: Color(0xFF64748B))),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.cloud_upload_outlined, size: 16),
                      label: const Text('Simpan Dokumen', style: TextStyle(fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1D4ED8),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () {
                        if (nameController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Nama dokumen wajib diisi!'),
                              backgroundColor: Color(0xFFE11D48),
                            ),
                          );
                          return;
                        }

                        final selectedProject = projects.firstWhere(
                          (p) => p.id == selectedProjectId,
                          orElse: () => projects.first,
                        );
                        final pCode = selectedProject.code.startsWith('PR')
                            ? selectedProject.code
                            : 'PR0${selectedProject.id}';

                        final uploaderRole = _currentUser?.role != null
                            ? _currentUser!.role.substring(0, 1).toUpperCase() + _currentUser!.role.substring(1)
                            : 'Administrasi';

                        setState(() {
                          _documents.insert(
                            0,
                            DocumentEntity(
                              id: DateTime.now().millisecondsSinceEpoch,
                              name: nameController.text.trim(),
                              category: category,
                              projectId: selectedProject.id,
                              projectCode: pCode,
                              projectName: selectedProject.name,
                              size: selectedFileName.isNotEmpty ? '3.5 MB' : 'Drive Link',
                              uploadedBy: _currentUser?.name ?? uploaderRole,
                              createdAt: DateTime.now(),
                              googleDriveUrl: driveUrlController.text.trim().isNotEmpty
                                  ? driveUrlController.text.trim()
                                  : null,
                            ),
                          );
                        });

                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Dokumen "${nameController.text.trim()}" berhasil ditambahkan!'),
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: const Color(0xFF059669),
                          ),
                        );
                      },
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

  void _confirmDelete(DocumentEntity doc) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Dokumen?', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        content: Text(
          'Dokumen "${doc.name}" akan dihapus dari repositori digital.',
          style: const TextStyle(fontSize: 13, color: Color(0xFF475569)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal', style: TextStyle(color: Color(0xFF64748B))),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE11D48),
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(ctx);
              setState(() {
                _documents.removeWhere((d) => d.id == doc.id);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Dokumen "${doc.name}" berhasil dihapus.'),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: const Color(0xFFE11D48),
                ),
              );
            },
            child: const Text('Hapus', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _confirmArchive(DocumentEntity doc) {
    final willArchive = !doc.isArchived;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: willArchive ? const Color(0xFFFFFBEB) : const Color(0xFFECFDF5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                willArchive ? Icons.inventory_2_outlined : Icons.unarchive_outlined,
                size: 20,
                color: willArchive ? const Color(0xFFD97706) : const Color(0xFF059669),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                willArchive ? 'Arsipkan Dokumen?' : 'Pulihkan Dokumen?',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
              ),
            ),
          ],
        ),
        content: Text(
          willArchive
              ? 'Pindahkan dokumen "${doc.name}" ke arsip? Dokumen tetap tersimpan aman di repositori.'
              : 'Pulihkan dokumen "${doc.name}" kembali ke daftar Dokumen Aktif?',
          style: const TextStyle(fontSize: 13, color: Color(0xFF475569)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal', style: TextStyle(color: Color(0xFF64748B))),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: willArchive ? const Color(0xFFD97706) : const Color(0xFF059669),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              final idx = _documents.indexWhere((d) => d.id == doc.id);
              if (idx != -1) {
                setState(() {
                  _documents[idx] = doc.copyWith(
                    isArchived: willArchive,
                    archivedAt: willArchive ? DateTime.now() : null,
                  );
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      willArchive
                          ? 'Dokumen "${doc.name}" berhasil dipindahkan ke tab Arsip.'
                          : 'Dokumen "${doc.name}" berhasil dipulihkan ke Dokumen Aktif.',
                    ),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: willArchive ? const Color(0xFFD97706) : const Color(0xFF059669),
                  ),
                );
              }
            },
            child: Text(
              willArchive ? 'Arsipkan' : 'Pulihkan',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  int get _activeFilterCount {
    int count = 0;
    if (_selectedCategory != 'semua') count++;
    if (_selectedProjectId != null) count++;
    return count;
  }

  // Modal Bottom Sheet Filter (Opsi 2: Hemat Ruang)
  void _showFilterModal() {
    String tempCategory = _selectedCategory;
    int? tempProjectId = _selectedProjectId;
    final projects = ProjectModel.mockProjects;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
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
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEFF6FF),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.tune_rounded,
                              size: 18,
                              color: Color(0xFF1D4ED8),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Filter Dokumen',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0F172A),
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Saring berkas berdasarkan kategori dan proyek.',
                                style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                              ),
                            ],
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded, color: Color(0xFF64748B), size: 20),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Proyek Terkait
                  const Text(
                    'Proyek Terkait',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF334155)),
                  ),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<int?>(
                    value: tempProjectId,
                    isExpanded: true,
                    icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 20, color: Color(0xFF64748B)),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFFF8FAFC),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                    ),
                    items: [
                      const DropdownMenuItem<int?>(
                        value: null,
                        child: Text(
                          '-- Semua Proyek --',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF0F172A)),
                        ),
                      ),
                      ...projects.map((p) {
                        final code = p.code.startsWith('PR') ? p.code : 'PR0${p.id}';
                        return DropdownMenuItem<int?>(
                          value: p.id,
                          child: Text(
                            '$code - ${p.name}',
                            style: const TextStyle(fontSize: 12, color: Color(0xFF0F172A)),
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }),
                    ],
                    onChanged: (val) {
                      setModalState(() => tempProjectId = val);
                    },
                  ),
                  const SizedBox(height: 16),

                  // Kategori Dokumen
                  const Text(
                    'Kategori Dokumen',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF334155)),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _categoryFilters.map((cat) {
                      final isSel = tempCategory.toLowerCase() == cat['key'].toString().toLowerCase();
                      final count = _countByCategory(cat['key'].toString());

                      return InkWell(
                        onTap: () {
                          setModalState(() => tempCategory = cat['key'].toString());
                        },
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                          decoration: BoxDecoration(
                            color: isSel ? const Color(0xFF1D4ED8) : const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isSel ? const Color(0xFF1D4ED8) : const Color(0xFFE2E8F0),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                cat['icon'] as IconData,
                                size: 14,
                                color: isSel ? Colors.white : const Color(0xFF64748B),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                cat['label'].toString(),
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: isSel ? FontWeight.bold : FontWeight.w600,
                                  color: isSel ? Colors.white : const Color(0xFF334155),
                                ),
                              ),
                              if (count > 0 || cat['key'] == 'semua') ...[
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                                  decoration: BoxDecoration(
                                    color: isSel ? const Color(0xFF1E3A8A) : const Color(0xFFE2E8F0),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    '$count',
                                    style: TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                      color: isSel ? Colors.white : const Color(0xFF475569),
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            setModalState(() {
                              tempCategory = 'semua';
                              tempProjectId = null;
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF64748B),
                            side: const BorderSide(color: Color(0xFFCBD5E1)),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          child: const Text('Reset Filter', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _selectedCategory = tempCategory;
                              _selectedProjectId = tempProjectId;
                            });
                            Navigator.pop(ctx);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1D4ED8),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          child: const Text('Terapkan Filter', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final list = _filteredDocuments;
    final activeDocs = _documents.where((d) => !d.isArchived).toList();
    final archivedDocs = _documents.where((d) => d.isArchived).toList();

    final totalActive = activeDocs.length;
    final totalArchived = archivedDocs.length;

    // Stat metric calculations (Sesuai 4 kartu web)
    final legalKontrak = activeDocs
        .where((d) => d.category == 'legal' || d.category == 'kontrak')
        .length;
    final gambarDed = activeDocs.where((d) => d.category == 'gambar_kerja').length;
    final rabLaporan = activeDocs
        .where((d) => d.category == 'rab' || d.category == 'laporan')
        .length;

    final projects = ProjectModel.mockProjects;

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
            fontSize: 17,
            fontWeight: FontWeight.w800,
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
              Icons.add_circle_rounded,
              color: Color(0xFF1E3A8A),
              size: 24,
            ),
            tooltip: 'Unggah Dokumen',
            onPressed: _showUploadDialog,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Ringkasan Statistik Repositori (Desain Sama Persis Fitur Survei, Validasi & Alat Berat)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Total Dokumen',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF64748B),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Text(
                          '$totalActive',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Divider(height: 1, color: Color(0xFFE2E8F0)),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: AppStatusMetricBox(
                            label: 'Legal & SPK',
                            value: legalKontrak,
                            indicatorColor: const Color(0xFF6366F1), // indigo
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: AppStatusMetricBox(
                            label: 'Gambar (DED)',
                            value: gambarDed,
                            indicatorColor: const Color(0xFF0284C7), // sky
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: AppStatusMetricBox(
                            label: 'RAB & Laporan',
                            value: rabLaporan,
                            indicatorColor: const Color(0xFF059669), // emerald
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Tab Switcher: Dokumen Aktif vs Arsip Dokumen (Sesuai Web)
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                padding: const EdgeInsets.all(4),
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => setState(() => _activeTab = 0),
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: _activeTab == 0 ? const Color(0xFF1D4ED8) : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.folder_open_rounded,
                                size: 16,
                                color: _activeTab == 0 ? Colors.white : const Color(0xFF64748B),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Dokumen Aktif',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: _activeTab == 0 ? Colors.white : const Color(0xFF64748B),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                                decoration: BoxDecoration(
                                  color: _activeTab == 0
                                      ? Colors.white.withAlpha(64)
                                      : const Color(0xFFE2E8F0),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  '$totalActive',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: _activeTab == 0 ? Colors.white : const Color(0xFF475569),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: InkWell(
                        onTap: () => setState(() => _activeTab = 1),
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: _activeTab == 1 ? const Color(0xFFD97706) : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.inventory_2_outlined,
                                size: 16,
                                color: _activeTab == 1 ? Colors.white : const Color(0xFF64748B),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Arsip Dokumen',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: _activeTab == 1 ? Colors.white : const Color(0xFF64748B),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                                decoration: BoxDecoration(
                                  color: _activeTab == 1
                                      ? Colors.white.withAlpha(64)
                                      : const Color(0xFFE2E8F0),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  '$totalArchived',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: _activeTab == 1 ? Colors.white : const Color(0xFF475569),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Filter & Pencarian (Opsi 2: Search Bar + Tombol Filter Modal Pop-up)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Baris Utama: Search Bar + Tombol Filter
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            onChanged: (_) => setState(() {}),
                            style: const TextStyle(fontSize: 12),
                            decoration: InputDecoration(
                              hintText: 'Cari nama dokumen atau kode proyek...',
                              hintStyle: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
                              prefixIcon: const Icon(Icons.search_rounded, size: 18, color: Color(0xFF94A3B8)),
                              suffixIcon: _searchController.text.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(Icons.clear_rounded, size: 16),
                                      onPressed: () {
                                        _searchController.clear();
                                        setState(() {});
                                      },
                                    )
                                  : null,
                              filled: true,
                              fillColor: const Color(0xFFF8FAFC),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),

                        // Tombol Buka Modal Filter
                        InkWell(
                          onTap: _showFilterModal,
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            height: 40,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: _activeFilterCount > 0 ? const Color(0xFFEFF6FF) : const Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: _activeFilterCount > 0 ? const Color(0xFF1D4ED8) : const Color(0xFFE2E8F0),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.tune_rounded,
                                  size: 17,
                                  color: _activeFilterCount > 0 ? const Color(0xFF1D4ED8) : const Color(0xFF475569),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Filter',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: _activeFilterCount > 0 ? const Color(0xFF1D4ED8) : const Color(0xFF475569),
                                  ),
                                ),
                                if (_activeFilterCount > 0) ...[
                                  const SizedBox(width: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF1D4ED8),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      '$_activeFilterCount',
                                      style: const TextStyle(
                                        fontSize: 9,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        height: 1,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Daftar Berkas Dokumen (List Cards Persis Web)
              if (list.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _activeTab == 0 ? Icons.folder_open_rounded : Icons.inventory_2_outlined,
                        size: 44,
                        color: const Color(0xFFCBD5E1),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _activeTab == 0 ? 'Tidak Ada Dokumen Aktif' : 'Arsip Dokumen Kosong',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF334155),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _activeTab == 0
                            ? 'Tidak ada berkas yang sesuai dengan kriteria penyaringan yang dipilih.'
                            : 'Tidak ada dokumen yang sedang berada di tab arsip.',
                        style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              else
                ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: list.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final d = list[index];
                    final fileMeta = _getFileMeta(d.name);
                    final catMeta = _getCategoryMeta(d.category);

                    return Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header: Ikon File & Badge Kategori
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: fileMeta['bg'] as Color,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  fileMeta['icon'] as IconData,
                                  color: fileMeta['color'] as Color,
                                  size: 19,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  d.name,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF0F172A),
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                                decoration: BoxDecoration(
                                  color: catMeta['bg'] as Color,
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: catMeta['border'] as Color),
                                ),
                                child: Text(
                                  catMeta['label'].toString(),
                                  style: TextStyle(
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.bold,
                                    color: catMeta['color'] as Color,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),

                          // Informasi Proyek Terkait & Kode Proyek
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.folder_rounded, size: 14, color: Color(0xFF94A3B8)),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    d.projectName,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF334155),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (d.projectCode != null) ...[
                                  const SizedBox(width: 6),
                                  Text(
                                    d.projectCode!,
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontFamily: 'monospace',
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF64748B),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),

                          // Footer Kartu: Tanggal, Pengunggah, Ukuran & Tombol Aksi
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(Icons.calendar_today_outlined, size: 11, color: Color(0xFF94A3B8)),
                                        const SizedBox(width: 4),
                                        Text(
                                          _formatDate(d.createdAt),
                                          style: const TextStyle(fontSize: 10.5, color: Color(0xFF64748B)),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          '• ${d.size}',
                                          style: const TextStyle(fontSize: 10, color: Color(0xFF94A3B8)),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    Row(
                                      children: [
                                        const Icon(Icons.person_outline_rounded, size: 11, color: Color(0xFF94A3B8)),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: Text(
                                            d.uploadedBy,
                                            style: const TextStyle(
                                              fontSize: 10.5,
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xFF475569),
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 6),

                              // Tombol Unduh (Sesuai Web)
                              OutlinedButton.icon(
                                icon: const Icon(Icons.download_rounded, size: 14),
                                label: const Text('Unduh', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: const Color(0xFF1D4ED8),
                                  side: const BorderSide(color: Color(0xFFBFDBFE)),
                                  backgroundColor: const Color(0xFFEFF6FF),
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                  visualDensity: VisualDensity.compact,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Mengunduh berkas ${d.name}...'),
                                      behavior: SnackBarBehavior.floating,
                                      backgroundColor: const Color(0xFF1D4ED8),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(width: 4),

                              // Tombol Arsipkan / Pulihkan (Sesuai Web)
                              IconButton(
                                icon: Icon(
                                  d.isArchived ? Icons.unarchive_outlined : Icons.inventory_2_outlined,
                                  size: 17,
                                  color: d.isArchived ? const Color(0xFF059669) : const Color(0xFF94A3B8),
                                ),
                                tooltip: d.isArchived ? 'Pulihkan dari Arsip' : 'Arsipkan Dokumen',
                                visualDensity: VisualDensity.compact,
                                onPressed: () => _confirmArchive(d),
                              ),

                              // Tombol Hapus (Hanya untuk Owner / Admin sesuai Web)
                              if (_canDelete)
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete_outline_rounded,
                                    size: 17,
                                    color: Color(0xFFE11D48),
                                  ),
                                  tooltip: 'Hapus Dokumen',
                                  visualDensity: VisualDensity.compact,
                                  onPressed: () => _confirmDelete(d),
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
