import 'package:flutter/material.dart';
import '../../domain/entities/survey_entity.dart';
import 'surveys_page.dart';
import '../../../../core/widgets/summary_widgets.dart';

class SurveyApprovalsPage extends StatefulWidget {
  const SurveyApprovalsPage({super.key});

  static const String routeName = '/survey-approvals';

  @override
  State<SurveyApprovalsPage> createState() => _SurveyApprovalsPageState();
}

class _SurveyApprovalsPageState extends State<SurveyApprovalsPage> {
  final List<SurveyEntity> _surveys = [];
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'Semua Status';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<SurveyEntity> get _filteredSurveys {
    final search = _searchController.text.trim().toLowerCase();
    return _surveys.where((survey) {
      final matchesFilter =
          _selectedFilter == 'Semua Status' ||
          (_selectedFilter == 'Menunggu' &&
              (survey.status == 'pending' || survey.status == 'review')) ||
          (_selectedFilter == 'Disetujui' && survey.status == 'approved') ||
          (_selectedFilter == 'Perlu Revisi' && survey.status == 'rejected');
      final matchesSearch =
          search.isEmpty ||
          survey.projectName.toLowerCase().contains(search) ||
          survey.surveyorName.toLowerCase().contains(search);
      return matchesFilter && matchesSearch;
    }).toList();
  }

  void _updateStatus(SurveyEntity survey, String status) {
    final index = _surveys.indexWhere((item) => item.id == survey.id);
    if (index == -1) return;
    setState(() {
      _surveys[index] = SurveyEntity(
        id: survey.id,
        surveyCode: survey.surveyCode,
        projectName: survey.projectName,
        surveyorName: survey.surveyorName,
        surveyDate: survey.surveyDate,
        landCondition: survey.landCondition,
        status: status,
        notes: survey.notes,
        areaSize: survey.areaSize,
        elevation: survey.elevation,
        soilType: survey.soilType,
        contour: survey.contour,
        accessibility: survey.accessibility,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final waiting = _surveys
        .where(
          (survey) => survey.status == 'pending' || survey.status == 'review',
        )
        .length;
    final approved = _surveys
        .where((survey) => survey.status == 'approved')
        .length;
    final revision = _surveys
        .where((survey) => survey.status == 'rejected')
        .length;
    final surveys = _filteredSurveys;

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
          'Persetujuan Survei Lokasi',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A),
          ),
        ),
        actions: [
          TextButton.icon(
            onPressed: () =>
                Navigator.pushNamed(context, SurveysPage.routeName),
            icon: const Icon(Icons.list_alt_rounded, size: 16),
            label: const Text('Survei'),
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF1D4ED8),
              textStyle: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: const Color(0xFFE2E8F0), height: 1),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              _summary(
                waiting: waiting,
                approved: approved,
                revision: revision,
                total: _surveys.length,
              ),
              const SizedBox(height: 14),
              _filters(),
              const SizedBox(height: 14),
              if (surveys.isEmpty)
                const AppEmptyStateCard(
                  icon: Icons.assignment_outlined,
                  title: 'Tidak Ada Laporan yang Perlu Ditinjau',
                  message:
                      'Saat ini belum ada pengajuan survei lokasi yang membutuhkan persetujuan.',
                )
              else
                ...surveys.map(_surveyCard),
            ],
          ),
        ),
      ),
    );
  }

  Widget _summary({
    required int waiting,
    required int approved,
    required int revision,
    required int total,
  }) => Container(
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
                'Total Laporan',
                style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
              ),
            ),
            Text(
              '$total',
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
                label: 'Menunggu',
                value: waiting,
                indicatorColor: const Color(0xFFF59E0B),
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: AppStatusMetricBox(
                label: 'Disetujui',
                value: approved,
                indicatorColor: const Color(0xFF059669),
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: AppStatusMetricBox(
                label: 'Perlu Revisi',
                value: revision,
                indicatorColor: const Color(0xFFE11D48),
              ),
            ),
          ],
        ),
      ],
    ),
  );

  Widget _filters() => Container(
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: const Color(0xFFE2E8F0)),
    ),
    child: Column(
      children: [
        TextField(
          controller: _searchController,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            hintText: 'Cari nama proyek atau pengawas...',
            hintStyle: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
            prefixIcon: const Icon(
              Icons.search,
              size: 17,
              color: Color(0xFF94A3B8),
            ),
            filled: true,
            fillColor: const Color(0xFFF8FAFC),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 10,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
          ),
        ),
        const SizedBox(height: 8),
        AppFilterDropdown<String>(
          value: _selectedFilter,
          entries: const [
            DropdownMenuEntry(value: 'Menunggu', label: 'Menunggu'),
            DropdownMenuEntry(value: 'Disetujui', label: 'Disetujui'),
            DropdownMenuEntry(value: 'Perlu Revisi', label: 'Perlu Revisi'),
            DropdownMenuEntry(value: 'Semua Status', label: 'Semua Status'),
          ],
          onSelected: (value) =>
              setState(() => _selectedFilter = value ?? 'Semua Status'),
        ),
      ],
    ),
  );

  Widget _surveyCard(SurveyEntity survey) => Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: const Color(0xFFE2E8F0)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          survey.surveyCode,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: Color(0xFF94A3B8),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          survey.projectName,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${survey.surveyorName} · ${survey.surveyDate}',
          style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => _updateStatus(survey, 'rejected'),
                child: const Text('Perlu Revisi'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ElevatedButton(
                onPressed: () => _updateStatus(survey, 'approved'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF059669),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Setujui'),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
