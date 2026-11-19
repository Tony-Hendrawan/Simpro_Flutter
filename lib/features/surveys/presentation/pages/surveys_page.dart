import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/survey_entity.dart';
import '../../../projects/data/models/project_model.dart';
import '../../../../core/widgets/summary_widgets.dart';

class SurveysPage extends StatefulWidget {
  const SurveysPage({super.key});

  static const String routeName = '/surveys';

  @override
  State<SurveysPage> createState() => _SurveysPageState();
}

class _SurveysPageState extends State<SurveysPage> {
  final List<SurveyEntity> _surveys = [];
  String _selectedStatus = 'Semua Status';

  List<SurveyEntity> get _filteredSurveys {
    if (_selectedStatus == 'Semua Status') return _surveys;
    return _surveys
        .where((survey) => survey.status == _selectedStatus.toLowerCase())
        .toList();
  }

  String _statusLabel(String status) => switch (status) {
    'pending' => 'Pending (Diajukan)',
    'review' => 'Review (Sedang Ditinjau)',
    'approved' => 'Approved (Disetujui)',
    'rejected' => 'Rejected (Ditolak)',
    _ => status,
  };

  Future<void> _showAddSurveyDialog() async {
    final result = await showDialog<SurveyEntity>(
      context: context,
      barrierColor: const Color(0x730F172A),
      builder: (_) => const _SurveyWizardDialog(),
    );

    if (result == null || !mounted) return;
    setState(() => _surveys.insert(0, result));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Laporan survei lokasi berhasil dibuat.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final list = _filteredSurveys;
    final pending = _surveys.where((s) => s.status == 'pending').length;
    final review = _surveys.where((s) => s.status == 'review').length;
    final approved = _surveys.where((s) => s.status == 'approved').length;
    final rejected = _surveys.where((s) => s.status == 'rejected').length;

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
          'Survei Lokasi',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.add_location_alt_rounded,
              color: Color(0xFF1D4ED8),
            ),
            tooltip: 'Tambah laporan survei',
            onPressed: _showAddSurveyDialog,
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
              LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth >= 700) {
                    return _desktopStats(
                      total: _surveys.length,
                      pending: pending,
                      review: review,
                      approved: approved,
                      rejected: rejected,
                    );
                  }
                  return _summaryCard(
                    total: _surveys.length,
                    pending: pending,
                    review: review,
                    approved: approved,
                    rejected: rejected,
                  );
                },
              ),
              const SizedBox(height: 16),
              AppFilterDropdown<String>(
                value: _selectedStatus,
                entries: const [
                  DropdownMenuEntry(
                    value: 'Semua Status',
                    label: 'Semua Status',
                  ),
                  DropdownMenuEntry(value: 'Pending', label: 'Pengajuan'),
                  DropdownMenuEntry(value: 'Review', label: 'Ditinjau'),
                  DropdownMenuEntry(value: 'Approved', label: 'Disetujui'),
                  DropdownMenuEntry(value: 'Rejected', label: 'Perlu Revisi'),
                ],
                onSelected: (value) =>
                    setState(() => _selectedStatus = value ?? 'Semua Status'),
              ),
              const SizedBox(height: 14),
              if (list.isEmpty)
                const AppEmptyStateCard(
                  icon: Icons.map_outlined,
                  title: 'Belum Ada Laporan Survei',
                  message:
                      'Klik tombol tambah untuk membuat laporan survei lokasi.',
                )
              else
                ...list.map(_surveyCard),
            ],
          ),
        ),
      ),
    );
  }

  Widget _summaryCard({
    required int total,
    required int pending,
    required int review,
    required int approved,
    required int rejected,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
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
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.assignment_outlined,
                  size: 20,
                  color: Color(0xFF1D4ED8),
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'Total Laporan',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF64748B),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                '$total',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1D4ED8),
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1, color: Color(0xFFE2E8F0)),
          ),
          Row(
            children: [
              Expanded(
                child: AppStatusMetricBox(
                  label: 'Pengajuan',
                  value: pending,
                  indicatorColor: const Color(0xFFF59E0B),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: AppStatusMetricBox(
                  label: 'Ditinjau',
                  value: review,
                  indicatorColor: const Color(0xFF2563EB),
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
                  value: rejected,
                  indicatorColor: const Color(0xFFE11D48),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _desktopStats({
    required int total,
    required int pending,
    required int review,
    required int approved,
    required int rejected,
  }) => Row(
    children: [
      Expanded(
        child: AppMetricCard(
          title: 'Total Laporan',
          value: '$total',
          accentColor: const Color(0xFF1D4ED8),
        ),
      ),
      const SizedBox(width: 8),
      Expanded(
        child: AppMetricCard(
          title: 'Pengajuan Baru',
          value: '$pending',
          accentColor: const Color(0xFFF59E0B),
        ),
      ),
      const SizedBox(width: 8),
      Expanded(
        child: AppMetricCard(
          title: 'Dalam Peninjauan',
          value: '$review',
          accentColor: const Color(0xFF2563EB),
        ),
      ),
      const SizedBox(width: 8),
      Expanded(
        child: AppMetricCard(
          title: 'Disetujui',
          value: '$approved',
          accentColor: const Color(0xFF059669),
        ),
      ),
      const SizedBox(width: 8),
      Expanded(
        child: AppMetricCard(
          title: 'Perlu Revisi',
          value: '$rejected',
          accentColor: const Color(0xFFE11D48),
        ),
      ),
    ],
  );

  Widget _surveyCard(SurveyEntity survey) => Container(
    margin: const EdgeInsets.only(bottom: 12),
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
              survey.surveyCode,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Color(0xFF94A3B8),
              ),
            ),
            Text(
              _statusLabel(survey.status),
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Color(0xFFD97706),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          survey.projectName,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          '${survey.surveyorName} · ${survey.surveyDate}',
          style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
        ),
      ],
    ),
  );
}

class _SurveyWizardDialog extends StatefulWidget {
  const _SurveyWizardDialog();

  @override
  State<_SurveyWizardDialog> createState() => _SurveyWizardDialogState();
}

class _SurveyWizardDialogState extends State<_SurveyWizardDialog> {
  int _step = 1;
  String? _projectName;
  final _newProjectController = TextEditingController();
  final _areaController = TextEditingController();
  final _elevationController = TextEditingController();
  final _soilController = TextEditingController();
  final _contourController = TextEditingController();
  final _accessController = TextEditingController();
  final List<PlatformFile> _files = [];

  @override
  void dispose() {
    _newProjectController.dispose();
    _areaController.dispose();
    _elevationController.dispose();
    _soilController.dispose();
    _contourController.dispose();
    _accessController.dispose();
    super.dispose();
  }

  void _next() {
    if (_step == 1 &&
        (_projectName == null && _newProjectController.text.trim().isEmpty)) {
      _message('Pilih proyek atau isi nama proyek baru.');
      return;
    }
    if (_step < 3) setState(() => _step++);
  }

  void _message(String message) => ScaffoldMessenger.of(
    context,
  ).showSnackBar(SnackBar(content: Text(message)));

  Future<void> _pickFiles() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf', 'docx'],
    );
    if (result == null) return;
    setState(
      () => _files
        ..clear()
        ..addAll(result.files.take(10)),
    );
  }

  void _submit() {
    final project = _projectName ?? _newProjectController.text.trim();
    Navigator.pop(
      context,
      SurveyEntity(
        id: DateTime.now().millisecondsSinceEpoch,
        surveyCode: 'SRV-${DateTime.now().year}-${DateTime.now().millisecond}',
        projectName: project,
        surveyorName: 'Tim Lapangan',
        surveyDate: 'Hari ini',
        landCondition: _contourController.text.trim(),
        status: 'pending',
        notes: _accessController.text.trim(),
        areaSize: double.tryParse(_areaController.text),
        elevation: double.tryParse(_elevationController.text),
        soilType: _soilController.text.trim(),
        contour: _contourController.text.trim(),
        accessibility: _accessController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      clipBehavior: Clip.antiAlias,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 680, maxHeight: 700),
        child: Column(
          children: [
            _header(),
            _stepper(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                child: _stepContent(),
              ),
            ),
            _footer(),
          ],
        ),
      ),
    );
  }

  Widget _header() => Padding(
    padding: const EdgeInsets.fromLTRB(24, 18, 14, 18),
    child: Row(
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Formulir Laporan Survei Lokasi',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              SizedBox(height: 5),
              Text(
                'Pendataan kondisi geoteknik dan fisik lahan untuk persetujuan manajemen.',
                style: TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.close, color: Color(0xFF94A3B8)),
        ),
      ],
    ),
  );

  Widget _stepper() => Container(
    color: const Color(0xFFF8FAFC),
    padding: const EdgeInsets.symmetric(horizontal: 34, vertical: 12),
    child: Row(
      children: [
        _stepIndicator(1, 'PROYEK'),
        _line(1 < _step),
        _stepIndicator(2, 'FISIK LAHAN'),
        _line(2 < _step),
        _stepIndicator(3, 'LAMPIRAN'),
      ],
    ),
  );

  Widget _line(bool active) => Expanded(
    child: Container(
      height: 3,
      color: active ? const Color(0xFF2563EB) : const Color(0xFFE2E8F0),
    ),
  );

  Widget _stepIndicator(int number, String label) {
    final active = number <= _step;
    return Column(
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: active
              ? const Color(0xFF2563EB)
              : const Color(0xFFF8FAFC),
          child: Text(
            '$number',
            style: TextStyle(
              color: active ? Colors.white : const Color(0xFF94A3B8),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: active ? const Color(0xFF2563EB) : const Color(0xFF94A3B8),
          ),
        ),
      ],
    );
  }

  Widget _stepContent() => switch (_step) {
    1 => _projectStep(),
    2 => _physicalStep(),
    _ => _attachmentStep(),
  };

  Widget _projectStep() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _sectionTitle(
        'TENTUKAN OBJEK PROYEK',
        'Pilih proyek konstruksi yang sedang dilakukan survei lapangan.',
      ),
      _label('Proyek Terdaftar *'),
      DropdownButtonFormField<String>(
        initialValue: _projectName,
        hint: const Text('— Pilih Proyek Terdaftar —'),
        isExpanded: true,
        items: ProjectModel.mockProjects
            .map(
              (project) => DropdownMenuItem(
                value: project.name,
                child: Text(project.name),
              ),
            )
            .toList(),
        onChanged: (value) => setState(() => _projectName = value),
        decoration: _decoration(),
      ),
      const SizedBox(height: 28),
      Row(
        children: [
          const Expanded(child: Divider(color: Color(0xFFE2E8F0))),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 14),
            child: Text('atau', style: TextStyle(color: Color(0xFF94A3B8))),
          ),
          const Expanded(child: Divider(color: Color(0xFFE2E8F0))),
        ],
      ),
      const SizedBox(height: 26),
      _label('Nama Proyek Baru (Jika Belum Terdaftar)'),
      TextField(
        controller: _newProjectController,
        decoration: _decoration(
          hint: 'Ketik nama proyek jika belum terdaftar di sistem',
        ),
      ),
      const SizedBox(height: 8),
      const Text(
        'Proyek baru akan didaftarkan secara otomatis ke dalam sistem.',
        style: TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
      ),
    ],
  );

  Widget _physicalStep() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _sectionTitle(
        'KONDISI FISIK & GEOTEKNIK LAHAN',
        'Lengkapi data pengukuran lahan, kontur tanah, dan elevasi area.',
      ),
      Row(
        children: [
          Expanded(
            child: _field(
              'Luas Area Lahan (Hektar)',
              _areaController,
              'Contoh: 1.5',
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: _field(
              'Elevasi Lahan (mdpl)',
              _elevationController,
              'Contoh: 120',
            ),
          ),
        ],
      ),
      const SizedBox(height: 18),
      _label('Jenis Tanah'),
      TextField(
        controller: _soilController,
        decoration: _decoration(hint: 'Contoh: Tanah Lempung Berpasir'),
      ),
      _chips(_soilController, [
        'Tanah Lempung',
        'Berbatu / Padas',
        'Tanah Pasir',
        'Gambut / Rawa',
      ]),
      const SizedBox(height: 16),
      _label('Kontur Permukaan Lahan'),
      TextField(
        controller: _contourController,
        decoration: _decoration(hint: 'Contoh: Datar Landai'),
      ),
      _chips(_contourController, [
        'Datar Rata',
        'Landai Bergelombang',
        'Miring / Lereng',
        'Terasering',
      ]),
    ],
  );

  Widget _attachmentStep() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _sectionTitle(
        'AKSESIBILITAS & DOKUMENTASI',
        'Catatan jalur akses transportasi dan lampiran foto lokasi.',
      ),
      _label('Catatan Aksesibilitas Jalan & Lokasi'),
      TextField(
        controller: _accessController,
        maxLines: 4,
        decoration: _decoration(
          hint:
              'Contoh: Jalan masuk cor beton lebar 4m, truk tronton dapat masuk, suplai listrik dan air tersedia...',
        ),
      ),
      const SizedBox(height: 22),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: _label('Berkas Foto & Lampiran (Maksimal 10 File)')),
          Text(
            '${_files.length}/10',
            style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
          ),
        ],
      ),
      const SizedBox(height: 8),
      InkWell(
        onTap: _pickFiles,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 24),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            border: Border.all(
              color: const Color(0xFFCBD5E1),
              style: BorderStyle.solid,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              const Icon(
                Icons.cloud_upload_outlined,
                size: 30,
                color: Color(0xFF94A3B8),
              ),
              const SizedBox(height: 8),
              Text(
                _files.isEmpty
                    ? 'Pilih Berkas atau Tarik ke Sini'
                    : '${_files.length} berkas dipilih',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF475569),
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Format: JPG, PNG, PDF, DOCX (Maksimal 10 file)',
                style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
              ),
            ],
          ),
        ),
      ),
    ],
  );

  Widget _sectionTitle(String title, String subtitle) => Padding(
    padding: const EdgeInsets.only(bottom: 22),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFF334155),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
        ),
      ],
    ),
  );

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: Color(0xFF64748B),
      ),
    ),
  );

  Widget _field(String label, TextEditingController controller, String hint) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _label(label),
          TextField(
            controller: controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: _decoration(hint: hint),
          ),
        ],
      );

  Widget _chips(TextEditingController controller, List<String> values) =>
      Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Wrap(
          spacing: 6,
          runSpacing: 6,
          children: values
              .map(
                (value) => ActionChip(
                  label: Text(value, style: const TextStyle(fontSize: 11)),
                  onPressed: () => setState(() => controller.text = value),
                ),
              )
              .toList(),
        ),
      );

  InputDecoration _decoration({String? hint}) => InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(
      fontSize: 12,
      color: Color(0xFF7C8798),
      fontWeight: FontWeight.w600,
    ),
    filled: true,
    fillColor: const Color(0xFFF8FAFC),
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Color(0xFF2563EB)),
    ),
  );

  Widget _footer() => LayoutBuilder(
    builder: (context, constraints) {
      final compact = constraints.maxWidth < 430;
      return Container(
        padding: const EdgeInsets.fromLTRB(18, 12, 18, 14),
        decoration: const BoxDecoration(
          color: Color(0xFFF8FAFC),
          border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
        ),
        child: Row(
          children: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Batal',
                style: TextStyle(
                  color: Color(0xFF64748B),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Spacer(),
            if (_step > 1)
              compact
                  ? IconButton(
                      tooltip: 'Sebelumnya',
                      onPressed: () => setState(() => _step--),
                      icon: const Icon(Icons.arrow_back, size: 18),
                    )
                  : OutlinedButton.icon(
                      onPressed: () => setState(() => _step--),
                      icon: const Icon(Icons.arrow_back, size: 16),
                      label: const Text('Sebelumnya'),
                    ),
            if (_step > 1) SizedBox(width: compact ? 2 : 10),
            ElevatedButton.icon(
              onPressed: _step == 3 ? _submit : _next,
              icon: Icon(
                _step == 3 ? Icons.send_rounded : Icons.arrow_forward,
                size: 17,
              ),
              label: Text(
                compact
                    ? (_step == 3 ? 'Kirim' : 'Lanjut')
                    : (_step == 3 ? 'Kirim Laporan' : 'Selanjutnya'),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: compact ? 12 : 18,
                  vertical: 13,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
