import 'package:flutter/material.dart';
import '../../data/models/survey_model.dart';
import '../../domain/entities/survey_entity.dart';

class SurveysPage extends StatefulWidget {
  const SurveysPage({super.key});

  static const String routeName = '/surveys';

  @override
  State<SurveysPage> createState() => _SurveysPageState();
}

class _SurveysPageState extends State<SurveysPage> {
  final List<SurveyEntity> _surveys = List.from(SurveyModel.mockSurveys);
  String _selectedStatus = 'Semua Status';

  List<SurveyEntity> get _filteredSurveys {
    if (_selectedStatus == 'Semua Status') return _surveys;
    return _surveys.where((s) => s.status == _selectedStatus.toLowerCase()).toList();
  }

  void _showAddSurveyDialog() {
    final codeController = TextEditingController(text: 'SRV-2026-00${_surveys.length + 1}');
    final projectController = TextEditingController();
    final surveyorController = TextEditingController();
    final landController = TextEditingController();
    final notesController = TextEditingController();

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
                    'Buat Laporan Survei Lokasi',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Text('Kode Survei', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF475569))),
              const SizedBox(height: 6),
              TextField(
                controller: codeController,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(height: 12),
              const Text('Nama Proyek Terkait', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF475569))),
              const SizedBox(height: 6),
              TextField(
                controller: projectController,
                decoration: InputDecoration(
                  hintText: 'Contoh: Pembangunan Kantor Baru',
                  hintStyle: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(height: 12),
              const Text('Petugas / Surveyor', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF475569))),
              const SizedBox(height: 6),
              TextField(
                controller: surveyorController,
                decoration: InputDecoration(
                  hintText: 'Nama lengkap surveyor',
                  hintStyle: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(height: 12),
              const Text('Kondisi Lahan & Tanah', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF475569))),
              const SizedBox(height: 6),
              TextField(
                controller: landController,
                decoration: InputDecoration(
                  hintText: 'Misal: Tanah lempung padat, datar',
                  hintStyle: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(height: 12),
              const Text('Catatan & Rekomendasi Teknis', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF475569))),
              const SizedBox(height: 6),
              TextField(
                controller: notesController,
                maxLines: 2,
                decoration: InputDecoration(
                  hintText: 'Catatan penting saat survei lapangan...',
                  hintStyle: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (projectController.text.trim().isEmpty) return;
                    setState(() {
                      _surveys.insert(
                        0,
                        SurveyEntity(
                          id: DateTime.now().millisecondsSinceEpoch,
                          surveyCode: codeController.text.trim(),
                          projectName: projectController.text.trim(),
                          surveyorName: surveyorController.text.trim().isNotEmpty
                              ? surveyorController.text.trim()
                              : 'Andi Wijaya, ST',
                          surveyDate: 'Hari ini',
                          landCondition: landController.text.trim().isNotEmpty
                              ? landController.text.trim()
                              : 'Datar Standar',
                          status: 'pending',
                          notes: notesController.text.trim(),
                        ),
                      );
                    });
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Laporan survei lokasi baru berhasil dibuat!'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1D4ED8),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('SUBMIT LAPORAN SURVEI', style: TextStyle(fontWeight: FontWeight.bold)),
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
    final total = _surveys.length;
    final pending = _surveys.where((s) => s.status == 'pending').length;
    final review = _surveys.where((s) => s.status == 'review').length;
    final approved = _surveys.where((s) => s.status == 'approved').length;
    final list = _filteredSurveys;

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
          'Survei Lokasi',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: const Color(0xFFE2E8F0), height: 1),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_location_alt_rounded, color: Color(0xFF1D4ED8)),
            tooltip: 'Buat Survei',
            onPressed: _showAddSurveyDialog,
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
              // Stat Cards Grid
              Row(
                children: [
                  Expanded(child: _buildStatItem('Total Survei', '$total', const Color(0xFF1D4ED8))),
                  const SizedBox(width: 8),
                  Expanded(child: _buildStatItem('Pending', '$pending', const Color(0xFFF59E0B))),
                  const SizedBox(width: 8),
                  Expanded(child: _buildStatItem('Review', '$review', const Color(0xFF3B82F6))),
                  const SizedBox(width: 8),
                  Expanded(child: _buildStatItem('Disetujui', '$approved', const Color(0xFF10B981))),
                ],
              ),
              const SizedBox(height: 16),

              // Filter Status Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: ['Semua Status', 'Pending', 'Review', 'Approved', 'Rejected'].map((st) {
                    final isSel = _selectedStatus == st;
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

              // Surveys List
              ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: list.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final s = list[index];
                  final isAppr = s.status == 'approved';
                  final isPend = s.status == 'pending';
                  final isRev = s.status == 'review';
                  final badgeColor = isAppr
                      ? const Color(0xFF059669)
                      : (isPend ? const Color(0xFFD97706) : (isRev ? const Color(0xFF2563EB) : const Color(0xFFE11D48)));
                  final badgeBg = isAppr
                      ? const Color(0xFFECFDF5)
                      : (isPend ? const Color(0xFFFFFBEB) : (isRev ? const Color(0xFFEFF6FF) : const Color(0xFFFFF1F2)));

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
                            Text(
                              s.surveyCode,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF94A3B8),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: badgeBg,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: badgeColor.withValues(alpha: 0.3)),
                              ),
                              child: Text(
                                s.status.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: badgeColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          s.projectName,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.person_outline_rounded, size: 14, color: Color(0xFF64748B)),
                            const SizedBox(width: 4),
                            Text(s.surveyorName, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                            const SizedBox(width: 12),
                            const Icon(Icons.calendar_today_outlined, size: 14, color: Color(0xFF64748B)),
                            const SizedBox(width: 4),
                            Text(s.surveyDate, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Kondisi: ${s.landCondition}',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF334155)),
                        ),
                        if (s.notes.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            s.notes,
                            style: const TextStyle(fontSize: 11, color: Color(0xFF64748B), fontStyle: FontStyle.italic),
                          ),
                        ],
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

  Widget _buildStatItem(String title, String val, Color color) {
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
