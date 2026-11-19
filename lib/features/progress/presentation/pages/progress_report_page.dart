import 'package:flutter/material.dart';
import '../../data/models/progress_report_model.dart';
import '../../domain/entities/progress_report_entity.dart';
import '../../../projects/data/models/project_model.dart';
import '../../../../core/widgets/summary_widgets.dart';
import 'progress_history_page.dart';

class ProgressReportPage extends StatefulWidget {
  const ProgressReportPage({super.key});

  static const String routeName = '/progress';

  @override
  State<ProgressReportPage> createState() => _ProgressReportPageState();
}

class _ProgressReportPageState extends State<ProgressReportPage> {
  final List<ProgressReportEntity> _reports = List.from(
    ProgressReportModel.mockReports,
  );

  String _selectedProject = 'Pembangunan Gedung Kantor PT Maju Jaya';
  double _progressValue = 54;
  final _descController = TextEditingController();

  List<ProjectModel> get _projectOptions => ProjectModel.mockProjects;

  double get _selectedProjectProgress => _projectOptions
      .firstWhere(
        (project) => project.name == _selectedProject,
        orElse: () => _projectOptions.first,
      )
      .progress;

  void _submitProgress() {
    final addVal = _progressValue - _selectedProjectProgress;
    if (_descController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Harap masukkan progres penambahan dan deskripsi pekerjaan.',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (_progressValue < _selectedProjectProgress || _progressValue > 100.0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Persentase progres pekerjaan tidak boleh melebihi 100%.',
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Color(0xFFE11D48),
        ),
      );
      return;
    }

    setState(() {
      _reports.insert(
        0,
        ProgressReportEntity(
          id: DateTime.now().millisecondsSinceEpoch,
          projectName: _selectedProject,
          currentProgress: _progressValue,
          addedProgress: addVal,
          reportDate: 'Hari ini',
          reporter: 'Pengawas Lapangan',
          description: _descController.text.trim(),
        ),
      );
      _descController.clear();
      _progressValue = _selectedProjectProgress;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Laporan perkembangan proyek berhasil dicatat!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ignore: unused_element
  Widget _projectProgressCard(ProjectModel project) {
    final isComplete = project.progress >= 100;
    final progressColor = isComplete
        ? const Color(0xFF059669)
        : const Color(0xFF2563EB);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  project.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: isComplete
                      ? const Color(0xFFECFDF5)
                      : const Color(0xFFEFF6FF),
                  border: Border.all(
                    color: isComplete
                        ? const Color(0xFFA7F3D0)
                        : const Color(0xFFBFDBFE),
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '${project.progress.toInt()}%',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: progressColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                project.code,
                style: const TextStyle(fontSize: 9, color: Color(0xFF94A3B8)),
              ),
              Text(
                project.clientName,
                style: const TextStyle(fontSize: 9, color: Color(0xFF94A3B8)),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: project.progress / 100,
              minHeight: 5,
              backgroundColor: const Color(0xFFE2E8F0),
              valueColor: AlwaysStoppedAnimation<Color>(progressColor),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
          'Laporan Pengerjaan Proyek',
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
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Form Input Laporan Progres
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                            Icons.edit_calendar_rounded,
                            color: Color(0xFF1D4ED8),
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'Input Laporan Perkembangan Proyek',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Pilih Proyek',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF475569),
                      ),
                    ),
                    const SizedBox(height: 6),
                    AppFilterDropdown<String>(
                      value: _selectedProject,
                      entries: _projectOptions
                          .map(
                            (project) => DropdownMenuEntry(
                              value: project.name,
                              label: project.name,
                            ),
                          )
                          .toList(),
                      onSelected: (val) {
                        if (val != null) {
                          setState(() {
                            _selectedProject = val;
                            _progressValue = _selectedProjectProgress;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Persentase Capaian Pengerjaan (%)',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF475569),
                          ),
                        ),
                        Text(
                          '${_progressValue.toInt()}%',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1D4ED8),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Slider(
                      value: _progressValue,
                      min: 0,
                      max: 100,
                      divisions: 100,
                      activeColor: const Color(0xFF2563EB),
                      inactiveColor: const Color(0xFFE2E8F0),
                      onChanged: (value) =>
                          setState(() => _progressValue = value),
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '0% (Capaian Saat Ini)',
                          style: TextStyle(
                            fontSize: 10,
                            color: Color(0xFF94A3B8),
                          ),
                        ),
                        Text(
                          '100% (Selesai)',
                          style: TextStyle(
                            fontSize: 10,
                            color: Color(0xFF94A3B8),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Catatan Pekerjaan & Kendala Lapangan',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF475569),
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _descController,
                      maxLines: 2,
                      decoration: InputDecoration(
                        hintText:
                            'Deskripsikan item pekerjaan yang telah diselesaikan atau kendala teknis/cuaca di lapangan...',
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
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 18,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: const Color(0xFFBFDBFE),
                          style: BorderStyle.solid,
                        ),
                      ),
                      child: const Column(
                        children: [
                          Icon(
                            Icons.cloud_upload_outlined,
                            size: 24,
                            color: Color(0xFF2563EB),
                          ),
                          SizedBox(height: 6),
                          Text(
                            'Klik untuk memilih atau seret berkas ke sini',
                            style: TextStyle(
                              fontSize: 11,
                              color: Color(0xFF475569),
                            ),
                          ),
                          SizedBox(height: 3),
                          Text(
                            'Format: JPG, PNG, WEBP • Maksimal 5 foto',
                            style: TextStyle(
                              fontSize: 9,
                              color: Color(0xFF94A3B8),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _submitProgress,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1D4ED8),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'SIMPAN LAPORAN PENGERJAAN',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => Navigator.pushNamed(
                    context,
                    ProgressHistoryPage.routeName,
                  ),
                  icon: const Icon(Icons.history, size: 18),
                  label: const Text('Lihat Ringkasan & Riwayat Progres'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
