import 'package:flutter/material.dart';
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
  String _selectedCategory = 'Semua Kategori';

  List<DocumentEntity> get _filteredDocuments {
    if (_selectedCategory == 'Semua Kategori') return _documents;
    return _documents.where((d) => d.category.toLowerCase() == _selectedCategory.toLowerCase()).toList();
  }

  void _showUploadDialog() {
    final nameController = TextEditingController();
    final projectController = TextEditingController(text: 'Pembangunan Gedung Kantor PT Maju Jaya');
    String cat = 'kontrak';

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
                  const Text('Unggah Berkas Dokumen', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                  IconButton(icon: const Icon(Icons.close_rounded), onPressed: () => Navigator.pop(ctx)),
                ],
              ),
              const SizedBox(height: 12),
              const Text('Kategori Dokumen', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF475569))),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                initialValue: cat,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
                items: const [
                  DropdownMenuItem(value: 'kontrak', child: Text('Kontrak Kerja (SPK)', style: TextStyle(fontSize: 13))),
                  DropdownMenuItem(value: 'gambar_kerja', child: Text('Gambar Kerja (DED)', style: TextStyle(fontSize: 13))),
                  DropdownMenuItem(value: 'rab', child: Text('RAB & Estimasi', style: TextStyle(fontSize: 13))),
                  DropdownMenuItem(value: 'laporan', child: Text('Laporan Proyek', style: TextStyle(fontSize: 13))),
                  DropdownMenuItem(value: 'legal', child: Text('Legalitas & Izin', style: TextStyle(fontSize: 13))),
                ],
                onChanged: (val) {
                  if (val != null) cat = val;
                },
              ),
              const SizedBox(height: 12),
              const Text('Nama Berkas', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF475569))),
              const SizedBox(height: 6),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: 'Contoh: SPK_Final_Pekerjaan.pdf',
                  hintStyle: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(height: 12),
              const Text('Nama Proyek Terkait', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF475569))),
              const SizedBox(height: 6),
              TextField(
                controller: projectController,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
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
                        content: Text('Dokumen berhasil diunggah ke repositori!'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  icon: const Icon(Icons.cloud_upload_rounded, size: 18),
                  label: const Text('UNGGAH SEKARANG', style: TextStyle(fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1D4ED8),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF0F172A), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Dokumen Proyek',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: const Color(0xFFE2E8F0), height: 1),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.upload_file_rounded, color: Color(0xFF1D4ED8)),
            tooltip: 'Unggah Dokumen',
            onPressed: _showUploadDialog,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Filter Categories Bar
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: ['Semua Kategori', 'Kontrak', 'Gambar_Kerja', 'RAB', 'Laporan'].map((cat) {
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
                        backgroundColor: const Color(0xFFF1F5F9),
                        onSelected: (_) => setState(() => _selectedCategory = cat),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const Divider(height: 1, color: Color(0xFFE2E8F0)),

            // Documents List
            Expanded(
              child: list.isEmpty
                  ? const Center(child: Text('Tidak ada dokumen yang ditemukan.', style: TextStyle(color: Color(0xFF94A3B8))))
                  : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: list.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final d = list[index];
                        final isPdf = d.name.endsWith('.pdf');
                        final isXlsx = d.name.endsWith('.xlsx');
                        final icon = isPdf
                            ? Icons.picture_as_pdf_rounded
                            : (isXlsx ? Icons.table_chart_rounded : Icons.insert_drive_file_rounded);
                        final iconColor = isPdf
                            ? const Color(0xFFE11D48)
                            : (isXlsx ? const Color(0xFF059669) : const Color(0xFF1D4ED8));
                        final iconBg = isPdf
                            ? const Color(0xFFFFF1F2)
                            : (isXlsx ? const Color(0xFFECFDF5) : const Color(0xFFEFF6FF));

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
                                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 3),
                                    Text(d.projectName, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                                    const SizedBox(height: 4),
                                    Text('${d.category.toUpperCase()} · ${d.size} · Oleh ${d.uploadedBy}', style: const TextStyle(fontSize: 10, color: Color(0xFF94A3B8))),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.download_rounded, color: Color(0xFF1D4ED8), size: 20),
                                tooltip: 'Unduh Berkas',
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Mengunduh berkas ${d.name}...'),
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                },
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
