import 'package:flutter/material.dart';
import '../../data/models/project_model.dart';
import '../../../clients/data/models/client_model.dart';
import '../../domain/entities/project_entity.dart';
import '../../../../core/widgets/summary_widgets.dart';

class ProjectsPage extends StatefulWidget {
  const ProjectsPage({super.key});

  static const String routeName = '/projects';

  @override
  State<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
  final List<ProjectEntity> _projects = List.from(ProjectModel.mockProjects);
  final TextEditingController _searchController = TextEditingController();
  String _selectedStatus = 'Semua Status';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<ProjectEntity> get _filteredProjects {
    return _projects.where((p) {
      final matchesStatus =
          _selectedStatus == 'Semua Status' ||
          p.status.toLowerCase() == _selectedStatus.toLowerCase();
      final query = _searchController.text.trim().toLowerCase();
      final matchesSearch =
          query.isEmpty ||
          p.code.toLowerCase().contains(query) ||
          p.name.toLowerCase().contains(query) ||
          p.location.toLowerCase().contains(query) ||
          p.clientName.toLowerCase().contains(query);
      return matchesStatus && matchesSearch;
    }).toList();
  }

  String _formatRp(double val) {
    if (val >= 1000000000) {
      return 'Rp ${(val / 1000000000).toStringAsFixed(1)} M';
    }
    if (val >= 1000000) {
      return 'Rp ${(val / 1000000).toStringAsFixed(0)} Jt';
    }
    return 'Rp ${val.toStringAsFixed(0)}';
  }

  Widget _projectInfoRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 16, color: const Color(0xFF94A3B8)),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
        ),
        const Spacer(),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E293B),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _deleteProject(ProjectEntity project) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus proyek?'),
        content: Text('Proyek ${project.code} akan dihapus dari daftar.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFDC2626),
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      setState(() => _projects.removeWhere((item) => item.id == project.id));
    }
  }

  void _showProjectDetailModal(ProjectEntity p) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        final docsList = [
          ('Surat Perjanjian Kontrak (SPK)', true),
          ('Rencana Anggaran Biaya (RAB)', true),
          ('Gambar Kerja / DED Konstruksi', p.completedDocsCount >= 3),
          ('Berita Acara / Laporan Lapangan', p.completedDocsCount >= 4),
          ('Dokumen Legalitas & Izin (AMDAL/PBG)', p.completedDocsCount >= 5),
        ];

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
                    Expanded(
                      child: Text(
                        p.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
                Text(
                  '${p.code} · ${p.location} · Klien: ${p.clientName}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 16),

                // Financial Summary Card
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Nilai Kontrak:',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF64748B),
                            ),
                          ),
                          Text(
                            _formatRp(p.contractValue),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total RAB:',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF64748B),
                            ),
                          ),
                          Text(
                            _formatRp(p.budget),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1D4ED8),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Realisasi Biaya:',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF64748B),
                            ),
                          ),
                          Text(
                            _formatRp(p.spent),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF059669),
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 16, color: Color(0xFFE2E8F0)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Progres Fisik:',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                          Text(
                            '${p.progress.toInt()}%',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1D4ED8),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),

                // Standar Kelengkapan Berkas (v2 Feature)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Standar Kelengkapan Berkas',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: p.completedDocsCount == 5
                            ? const Color(0xFFECFDF5)
                            : const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '${p.completedDocsCount}/5 Terpenuhi',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: p.completedDocsCount == 5
                              ? const Color(0xFF059669)
                              : const Color(0xFF1D4ED8),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                const Text(
                  'Kesesuaian 5 berkas wajib standar proyek sebelum pencairan termin atau audit lapangan.',
                  style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                ),
                const SizedBox(height: 10),

                ...docsList.map((doc) {
                  final isDone = doc.$2;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 6),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isDone
                          ? const Color(0xFFF0FDF4)
                          : const Color(0xFFFFFBEB),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isDone
                            ? const Color(0xFFBBF7D0)
                            : const Color(0xFFFDE68A),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isDone
                              ? Icons.check_circle_rounded
                              : Icons.pending_outlined,
                          size: 16,
                          color: isDone
                              ? const Color(0xFF059669)
                              : const Color(0xFFD97706),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            doc.$1,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isDone
                                  ? const Color(0xFF166534)
                                  : const Color(0xFF92400E),
                            ),
                          ),
                        ),
                        Text(
                          isDone ? 'Lengkap' : 'Belum Ada',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: isDone
                                ? const Color(0xFF059669)
                                : const Color(0xFFD97706),
                          ),
                        ),
                      ],
                    ),
                  );
                }),

                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(ctx),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1D4ED8),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'TUTUP DETAIL',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showAddProjectModal() {
    final codeController = TextEditingController(
      text: 'P00${_projects.length + 1}',
    );
    final nameController = TextEditingController();
    final locationController = TextEditingController();
    final contractController = TextEditingController();
    final budgetController = TextEditingController();
    final managerController = TextEditingController();
    final descriptionController = TextEditingController();
    final startDateController = TextEditingController();
    final endDateController = TextEditingController();

    showDialog<void>(
      context: context,
      builder: (ctx) {
        var step = 1;
        String? clientName;
        String status = 'aktif';

        InputDecoration fieldDecoration({
          String? hintText,
          Widget? suffixIcon,
        }) {
          return InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: const Color(0xFFF8FAFC),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 11,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
          );
        }

        Widget label(String text, {bool required = true}) {
          return RichText(
            text: TextSpan(
              text: text,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF475569),
              ),
              children: required
                  ? const [
                      TextSpan(
                        text: ' *',
                        style: TextStyle(color: Color(0xFFEF4444)),
                      ),
                    ]
                  : null,
            ),
          );
        }

        Widget textField(
          TextEditingController controller, {
          String? hintText,
          TextInputType? keyboardType,
          Widget? suffixIcon,
          int maxLines = 1,
        }) {
          return TextField(
            controller: controller,
            keyboardType: keyboardType,
            maxLines: maxLines,
            decoration: fieldDecoration(
              hintText: hintText,
              suffixIcon: suffixIcon,
            ),
          );
        }

        Widget formField(String title, Widget child, {bool required = true}) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              label(title, required: required),
              const SizedBox(height: 6),
              child,
            ],
          );
        }

        DateTime? parseDate(String value) {
          final parts = value.split('/');
          if (parts.length != 3) return null;
          final day = int.tryParse(parts[0]);
          final month = int.tryParse(parts[1]);
          final year = int.tryParse(parts[2]);
          if (day == null || month == null || year == null) return null;
          return DateTime.tryParse(
            '$year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}',
          );
        }

        Widget durationSummary() {
          final startDate = parseDate(startDateController.text);
          final endDate = parseDate(endDateController.text);
          if (startDate == null ||
              endDate == null ||
              endDate.isBefore(startDate)) {
            return const SizedBox.shrink();
          }
          final duration = endDate.difference(startDate).inDays + 1;
          return Container(
            margin: const EdgeInsets.only(top: 12),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              border: Border.all(color: const Color(0xFFE2E8F0)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.access_time_rounded,
                  size: 16,
                  color: Color(0xFF94A3B8),
                ),
                const SizedBox(width: 6),
                const Expanded(
                  child: Text(
                    'Estimasi Durasi Proyek:',
                    style: TextStyle(fontSize: 11, color: Color(0xFF475569)),
                  ),
                ),
                Text(
                  '$duration Hari Kalender',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ],
            ),
          );
        }

        Widget dateField(
          TextEditingController controller, {
          VoidCallback? onDateSelected,
        }) {
          return TextField(
            controller: controller,
            readOnly: true,
            onTap: () async {
              final pickedDate = await showDatePicker(
                context: ctx,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );
              if (pickedDate != null) {
                final day = pickedDate.day.toString().padLeft(2, '0');
                final month = pickedDate.month.toString().padLeft(2, '0');
                controller.text = '$day/$month/${pickedDate.year}';
                onDateSelected?.call();
              }
            },
            decoration: fieldDecoration(
              hintText: 'dd/mm/yyyy',
              suffixIcon: const Icon(
                Icons.calendar_today_outlined,
                size: 16,
                color: Color(0xFF0F172A),
              ),
            ),
          );
        }

        void saveProject(StateSetter setState) {
          if (nameController.text.trim().isEmpty ||
              locationController.text.trim().isEmpty) {
            return;
          }
          final contractVal =
              double.tryParse(contractController.text.trim()) ?? 0;
          final budgetVal = double.tryParse(budgetController.text.trim()) ?? 0;

          setState(() {});
          this.setState(() {
            _projects.insert(
              0,
              ProjectEntity(
                id: DateTime.now().millisecondsSinceEpoch,
                code: codeController.text.trim(),
                name: nameController.text.trim(),
                location: locationController.text.trim(),
                clientName: clientName ?? 'Belum dipilih',
                contractValue: contractVal,
                budget: budgetVal,
                spent: 0,
                progress: 0,
                status: status,
                manager: managerController.text.trim(),
                description: descriptionController.text.trim(),
                startDate: startDateController.text.trim(),
                endDate: endDateController.text.trim(),
              ),
            );
          });
          Navigator.pop(ctx);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Proyek baru berhasil didaftarkan!'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }

        return StatefulBuilder(
          builder: (context, setState) {
            final isLastStep = step == 3;
            return Dialog(
              insetPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 24,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: 620,
                  maxHeight: MediaQuery.of(ctx).size.height * 0.84,
                ),
                child: SizedBox(
                  height: MediaQuery.of(ctx).size.height * 0.84,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 16, 12, 14),
                        child: Row(
                          children: [
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Pendaftaran Proyek Baru',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF1E293B),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.close,
                                color: Color(0xFF94A3B8),
                              ),
                              onPressed: () => Navigator.pop(ctx),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        color: const Color(0xFFF8FAFC),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        child: Row(
                          children: List.generate(3, (index) {
                            final current = index + 1;
                            final active = current <= step;
                            return Expanded(
                              child: Row(
                                children: [
                                  Column(
                                    children: [
                                      CircleAvatar(
                                        radius: 15,
                                        backgroundColor: active
                                            ? const Color(0xFF2563EB)
                                            : Colors.white,
                                        foregroundColor: active
                                            ? Colors.white
                                            : const Color(0xFF94A3B8),
                                        child: Text(
                                          '$current',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        [
                                          'IDENTITAS',
                                          'ANGGARAN',
                                          'PENGAWASAN',
                                        ][index],
                                        style: TextStyle(
                                          fontSize: 9,
                                          fontWeight: FontWeight.bold,
                                          color: active
                                              ? const Color(0xFF2563EB)
                                              : const Color(0xFF94A3B8),
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (index < 2)
                                    Expanded(
                                      child: Container(
                                        height: 2,
                                        margin: const EdgeInsets.only(
                                          left: 4,
                                          right: 4,
                                          bottom: 20,
                                        ),
                                        color: current < step
                                            ? const Color(0xFF2563EB)
                                            : const Color(0xFFE2E8F0),
                                      ),
                                    ),
                                ],
                              ),
                            );
                          }),
                        ),
                      ),
                      Flexible(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                          child: step == 1
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'IDENTITAS & PEMILIK PROYEK',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF475569),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    const Text(
                                      'Informasi umum mengenai kode proyek, nama, dan lokasi pekerjaan.',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Color(0xFF94A3B8),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    LayoutBuilder(
                                      builder: (context, constraints) {
                                        final fields = [
                                          formField(
                                            'Kode Proyek',
                                            textField(codeController),
                                          ),
                                          formField(
                                            'Nama Proyek',
                                            textField(
                                              nameController,
                                              hintText:
                                                  'Contoh: Pembangunan Ruko Graha',
                                            ),
                                          ),
                                        ];
                                        return constraints.maxWidth < 480
                                            ? Column(
                                                children: [
                                                  fields[0],
                                                  const SizedBox(height: 12),
                                                  fields[1],
                                                ],
                                              )
                                            : Row(
                                                children: [
                                                  Expanded(child: fields[0]),
                                                  const SizedBox(width: 12),
                                                  Expanded(child: fields[1]),
                                                ],
                                              );
                                      },
                                    ),
                                    const SizedBox(height: 12),
                                    LayoutBuilder(
                                      builder: (context, constraints) {
                                        final fields = [
                                          formField(
                                            'Klien / Pemilik Proyek',
                                            DropdownButtonFormField<String>(
                                              initialValue: clientName,
                                              hint: const Text(
                                                '— Pilih Klien Terdaftar —',
                                                style: TextStyle(fontSize: 12),
                                              ),
                                              items: ClientModel.mockClients
                                                  .map(
                                                    (client) =>
                                                        DropdownMenuItem(
                                                          value: client.name,
                                                          child: Text(
                                                            client.name,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                  )
                                                  .toList(),
                                              onChanged: (value) => setState(
                                                () => clientName = value,
                                              ),
                                              decoration: fieldDecoration(),
                                            ),
                                          ),
                                          formField(
                                            'Lokasi Proyek',
                                            textField(
                                              locationController,
                                              hintText:
                                                  'Contoh: BSD, Tangerang Selatan',
                                            ),
                                          ),
                                        ];
                                        return constraints.maxWidth < 480
                                            ? Column(
                                                children: [
                                                  fields[0],
                                                  const SizedBox(height: 12),
                                                  fields[1],
                                                ],
                                              )
                                            : Row(
                                                children: [
                                                  Expanded(child: fields[0]),
                                                  const SizedBox(width: 12),
                                                  Expanded(child: fields[1]),
                                                ],
                                              );
                                      },
                                    ),
                                  ],
                                )
                              : step == 2
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'ANGGARAN & JADWAL PELAKSANAAN',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF475569),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    const Text(
                                      'Penetapan nilai kontrak kerja dan estimasi durasi pekerjaan.',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Color(0xFF94A3B8),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    LayoutBuilder(
                                      builder: (context, constraints) {
                                        final fields = [
                                          formField(
                                            'Nilai Kontrak (Rp)',
                                            textField(
                                              contractController,
                                              hintText: 'Contoh: 12500000000',
                                              keyboardType:
                                                  TextInputType.number,
                                            ),
                                          ),
                                          formField(
                                            'Alokasi Anggaran / RAB (Rp)',
                                            textField(
                                              budgetController,
                                              hintText: 'Contoh: 10000000000',
                                              keyboardType:
                                                  TextInputType.number,
                                            ),
                                          ),
                                        ];
                                        return constraints.maxWidth < 480
                                            ? Column(
                                                children: [
                                                  fields[0],
                                                  const SizedBox(height: 12),
                                                  fields[1],
                                                ],
                                              )
                                            : Row(
                                                children: [
                                                  Expanded(child: fields[0]),
                                                  const SizedBox(width: 12),
                                                  Expanded(child: fields[1]),
                                                ],
                                              );
                                      },
                                    ),
                                    const SizedBox(height: 12),
                                    LayoutBuilder(
                                      builder: (context, constraints) {
                                        final fields = [
                                          formField(
                                            'Tanggal Mulai',
                                            dateField(
                                              startDateController,
                                              onDateSelected: () =>
                                                  setState(() {}),
                                            ),
                                          ),
                                          formField(
                                            'Tanggal Selesai',
                                            dateField(
                                              endDateController,
                                              onDateSelected: () =>
                                                  setState(() {}),
                                            ),
                                          ),
                                        ];
                                        return constraints.maxWidth < 480
                                            ? Column(
                                                children: [
                                                  fields[0],
                                                  const SizedBox(height: 12),
                                                  fields[1],
                                                ],
                                              )
                                            : Row(
                                                children: [
                                                  Expanded(child: fields[0]),
                                                  const SizedBox(width: 12),
                                                  Expanded(child: fields[1]),
                                                ],
                                              );
                                      },
                                    ),
                                    durationSummary(),
                                  ],
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'PENGAWASAN & LINGKUP PEKERJAAN',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF475569),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    const Text(
                                      'Penetapan penanggung jawab teknis dan ruang lingkup proyek.',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Color(0xFF94A3B8),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    LayoutBuilder(
                                      builder: (context, constraints) {
                                        final fields = [
                                          formField(
                                            'Manajer Proyek / Penanggung Jawab',
                                            textField(
                                              managerController,
                                              hintText: 'Nama penanggung jawab',
                                            ),
                                          ),
                                          formField(
                                            'Status Awal Proyek',
                                            DropdownButtonFormField<String>(
                                              initialValue: status,
                                              items: const [
                                                DropdownMenuItem(
                                                  value: 'aktif',
                                                  child: Text('Aktif'),
                                                ),
                                                DropdownMenuItem(
                                                  value: 'tertunda',
                                                  child: Text('Tertunda'),
                                                ),
                                                DropdownMenuItem(
                                                  value: 'selesai',
                                                  child: Text('Selesai'),
                                                ),
                                              ],
                                              onChanged: (value) => setState(
                                                () => status = value ?? status,
                                              ),
                                              decoration: fieldDecoration(),
                                            ),
                                          ),
                                        ];
                                        return constraints.maxWidth < 480
                                            ? Column(
                                                children: [
                                                  fields[0],
                                                  const SizedBox(height: 12),
                                                  fields[1],
                                                ],
                                              )
                                            : Row(
                                                children: [
                                                  Expanded(child: fields[0]),
                                                  const SizedBox(width: 12),
                                                  Expanded(child: fields[1]),
                                                ],
                                              );
                                      },
                                    ),
                                    const SizedBox(height: 12),
                                    formField(
                                      'Deskripsi / Ruang Lingkup Pekerjaan',
                                      textField(
                                        descriptionController,
                                        hintText:
                                            'Tuliskan ruang lingkup proyek',
                                        maxLines: 3,
                                      ),
                                      required: false,
                                    ),
                                  ],
                                ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 12, 20, 14),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerRight,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (step > 1)
                                OutlinedButton.icon(
                                  onPressed: () => setState(() => step--),
                                  icon: const Icon(Icons.arrow_back, size: 16),
                                  label: const Text('Sebelumnya'),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: const Color(0xFF475569),
                                    side: const BorderSide(
                                      color: Color(0xFFE2E8F0),
                                    ),
                                  ),
                                ),
                              const SizedBox(width: 12),
                              FilledButton.icon(
                                onPressed: () {
                                  if (isLastStep) {
                                    saveProject(setState);
                                  } else {
                                    setState(() => step++);
                                  }
                                },
                                icon: Icon(
                                  isLastStep
                                      ? Icons.check
                                      : Icons.arrow_forward,
                                  size: 16,
                                ),
                                label: Text(
                                  isLastStep ? 'Simpan Proyek' : 'Selanjutnya',
                                ),
                                style: FilledButton.styleFrom(
                                  backgroundColor: const Color(0xFF2563EB),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // ignore: unused_element
  void _showAddProjectModalLegacy() {
    final codeController = TextEditingController(
      text: 'P00${_projects.length + 1}',
    );
    final nameController = TextEditingController();
    final locationController = TextEditingController();
    String clientName = ClientModel.mockClients.first.name;
    final contractController = TextEditingController();
    final budgetController = TextEditingController();
    final managerController = TextEditingController(text: 'Andi Wijaya, ST');
    final descriptionController = TextEditingController();
    final startDateController = TextEditingController();
    final endDateController = TextEditingController();
    String status = 'perencanaan';

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
                    'Tambah Proyek Konstruksi',
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
                'Kode Proyek',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF475569),
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: codeController,
                decoration: InputDecoration(
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
                'Nama Proyek',
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
                  hintText: 'Nama lengkap proyek konstruksi',
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
              const Text(
                'Lokasi',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF475569),
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: locationController,
                decoration: InputDecoration(
                  hintText: 'Kota / Wilayah pelaksanaan',
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
              const Text(
                'Client',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF475569),
                ),
              ),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                initialValue: clientName,
                items: ClientModel.mockClients
                    .map(
                      (client) => DropdownMenuItem(
                        value: client.name,
                        child: Text(client.name),
                      ),
                    )
                    .toList(),
                onChanged: (value) => clientName = value ?? clientName,
                decoration: InputDecoration(
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
                'Manager',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF475569),
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: managerController,
                decoration: InputDecoration(
                  hintText: 'Manager proyek',
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
                children: [
                  Expanded(
                    child: TextField(
                      controller: startDateController,
                      decoration: InputDecoration(
                        labelText: 'Tanggal Mulai',
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: endDateController,
                      decoration: InputDecoration(
                        labelText: 'Tanggal Selesai',
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Text(
                'Deskripsi',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF475569),
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: descriptionController,
                maxLines: 2,
                decoration: InputDecoration(
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
              DropdownButtonFormField<String>(
                initialValue: status,
                decoration: InputDecoration(
                  labelText: 'Status',
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'perencanaan',
                    child: Text('Perencanaan'),
                  ),
                  DropdownMenuItem(value: 'aktif', child: Text('Aktif')),
                  DropdownMenuItem(value: 'selesai', child: Text('Selesai')),
                  DropdownMenuItem(value: 'tertunda', child: Text('Tertunda')),
                ],
                onChanged: (value) => status = value ?? status,
              ),
              const SizedBox(height: 12),
              const Text(
                'Nilai Kontrak (Rp)',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF475569),
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: contractController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Contoh: 15000000000',
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
              const Text(
                'Alokasi RAB (Rp)',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF475569),
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: budgetController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Contoh: 12000000000',
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
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (nameController.text.trim().isEmpty) return;
                    final contractVal =
                        double.tryParse(contractController.text.trim()) ?? 0;
                    final budgetVal =
                        double.tryParse(budgetController.text.trim()) ?? 0;

                    setState(() {
                      _projects.insert(
                        0,
                        ProjectEntity(
                          id: DateTime.now().millisecondsSinceEpoch,
                          code: codeController.text.trim(),
                          name: nameController.text.trim(),
                          location: locationController.text.trim(),
                          clientName: clientName,
                          contractValue: contractVal,
                          budget: budgetVal,
                          spent: 0,
                          progress: 0,
                          status: status,
                          manager: managerController.text.trim(),
                          description: descriptionController.text.trim(),
                          startDate: startDateController.text.trim(),
                          endDate: endDateController.text.trim(),
                        ),
                      );
                    });
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Proyek baru berhasil didaftarkan!'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1D4ED8),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'SIMPAN PROYEK BARU',
                    style: TextStyle(fontWeight: FontWeight.bold),
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
    final list = _filteredProjects;

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
          'Daftar Proyek Konstruksi',
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
            icon: const Icon(Icons.add_box_outlined, color: Color(0xFF1D4ED8)),
            tooltip: 'Tambah Proyek Baru',
            onPressed: _showAddProjectModal,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final search = TextField(
                        controller: _searchController,
                        onChanged: (_) => setState(() {}),
                        decoration: InputDecoration(
                          hintText:
                              'Cari kode, nama proyek, lokasi, atau klien...',
                          hintStyle: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF94A3B8),
                          ),
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
                            borderSide: const BorderSide(
                              color: Color(0xFFE2E8F0),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Color(0xFFE2E8F0),
                            ),
                          ),
                        ),
                      );
                      final status = AppFilterDropdown<String>(
                        value: _selectedStatus,
                        entries: const [
                          DropdownMenuEntry(
                            value: 'Semua Status',
                            label: 'Semua Status',
                          ),
                          DropdownMenuEntry(value: 'aktif', label: 'Aktif'),
                          DropdownMenuEntry(value: 'selesai', label: 'Selesai'),
                          DropdownMenuEntry(
                            value: 'tertunda',
                            label: 'Tertunda',
                          ),
                          DropdownMenuEntry(
                            value: 'perencanaan',
                            label: 'Perencanaan',
                          ),
                        ],
                        onSelected: (value) => setState(
                          () => _selectedStatus = value ?? 'Semua Status',
                        ),
                      );
                      if (constraints.maxWidth >= 600) {
                        return Row(
                          children: [
                            Expanded(child: search),
                            const SizedBox(width: 10),
                            SizedBox(width: 150, child: status),
                          ],
                        );
                      }
                      return Column(
                        children: [search, const SizedBox(height: 8), status],
                      );
                    },
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: Color(0xFFE2E8F0)),

            // Projects List
            Expanded(
              child: list.isEmpty
                  ? const Center(
                      child: Text(
                        'Tidak ada proyek pada status ini.',
                        style: TextStyle(color: Color(0xFF94A3B8)),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: list.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final p = list[index];
                        final isDone = p.status == 'selesai';
                        final isPlan = p.status == 'perencanaan';
                        final isDelay = p.status == 'tertunda';
                        final statusBg = isDone
                            ? const Color(0xFFECFDF5)
                            : (isPlan
                                  ? const Color(0xFFF1F5F9)
                                  : (isDelay
                                        ? const Color(0xFFFFFBEB)
                                        : const Color(0xFFEFF6FF)));
                        final statusColor = isDone
                            ? const Color(0xFF059669)
                            : (isPlan
                                  ? const Color(0xFF475569)
                                  : (isDelay
                                        ? const Color(0xFFB45309)
                                        : const Color(0xFF1D4ED8)));
                        final statusLabel = switch (p.status) {
                          'aktif' => 'Aktif',
                          'selesai' => 'Selesai',
                          'tertunda' => 'Tertunda',
                          'perencanaan' => 'Perencanaan',
                          _ => p.status,
                        };

                        return InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () => _showProjectDetailModal(p),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(0xFFE2E8F0),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 7,
                                              vertical: 3,
                                            ),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFF1F5F9),
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              border: Border.all(
                                                color: const Color(0xFFE2E8F0),
                                              ),
                                            ),
                                            child: Text(
                                              p.code,
                                              style: const TextStyle(
                                                fontSize: 9,
                                                fontWeight: FontWeight.w600,
                                                fontFamily: 'monospace',
                                                color: Color(0xFF475569),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            p.name,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF0F172A),
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.location_on,
                                                size: 13,
                                                color: Color(0xFF94A3B8),
                                              ),
                                              const SizedBox(width: 3),
                                              Expanded(
                                                child: Text(
                                                  p.location,
                                                  style: const TextStyle(
                                                    fontSize: 11,
                                                    color: Color(0xFF64748B),
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 3,
                                          ),
                                          decoration: BoxDecoration(
                                            color: statusBg,
                                            borderRadius: BorderRadius.circular(
                                              6,
                                            ),
                                            border: Border.all(
                                              color: statusColor.withValues(
                                                alpha: 0.3,
                                              ),
                                            ),
                                          ),
                                          child: Text(
                                            statusLabel.toUpperCase(),
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              color: statusColor,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Progres Fisik',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Color(0xFF64748B),
                                      ),
                                    ),
                                    Text(
                                      '${p.progress.toInt()}%',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF0F172A),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: LinearProgressIndicator(
                                    value: p.progress / 100,
                                    minHeight: 6,
                                    backgroundColor: const Color(0xFFF1F5F9),
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      p.progress >= 80
                                          ? const Color(0xFF10B981)
                                          : const Color(0xFF1D4ED8),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                _projectInfoRow(
                                  'Pemilik Proyek',
                                  p.clientName,
                                  Icons.business_outlined,
                                ),
                                const SizedBox(height: 8),
                                _projectInfoRow(
                                  'Manajer Proyek',
                                  p.manager,
                                  Icons.person_outline,
                                ),
                                const SizedBox(height: 8),
                                _projectInfoRow(
                                  'Nilai Kontrak',
                                  _formatRp(p.contractValue),
                                  Icons.payments_outlined,
                                ),
                                const SizedBox(height: 8),
                                _projectInfoRow(
                                  'Tanggal Mulai',
                                  p.startDate ?? '-',
                                  Icons.calendar_today_outlined,
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    Expanded(
                                      child: OutlinedButton.icon(
                                        onPressed: () =>
                                            _showProjectDetailModal(p),
                                        icon: const Icon(
                                          Icons.visibility_outlined,
                                          size: 16,
                                        ),
                                        label: const Text('Detail'),
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor: const Color(
                                            0xFF1D4ED8,
                                          ),
                                          side: const BorderSide(
                                            color: Color(0xFFBFDBFE),
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: OutlinedButton.icon(
                                        onPressed: () => _deleteProject(p),
                                        icon: const Icon(
                                          Icons.delete_outline,
                                          size: 16,
                                        ),
                                        label: const Text('Hapus'),
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor: const Color(
                                            0xFFDC2626,
                                          ),
                                          side: const BorderSide(
                                            color: Color(0xFFFECACA),
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                        ),
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
            ),
          ],
        ),
      ),
    );
  }
}
