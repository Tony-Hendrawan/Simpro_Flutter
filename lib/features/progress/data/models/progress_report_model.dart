import '../../domain/entities/progress_report_entity.dart';

class ProgressReportModel extends ProgressReportEntity {
  const ProgressReportModel({
    required super.id,
    required super.projectName,
    required super.currentProgress,
    required super.addedProgress,
    required super.reportDate,
    required super.reporter,
    required super.description,
  });

  static List<ProgressReportModel> get mockReports => const [
    ProgressReportModel(
      id: 1,
      projectName: 'Pembangunan Gedung Kantor PT Maju Jaya',
      currentProgress: 45.0,
      addedProgress: 5.0,
      reportDate: '01 Nov 2026',
      reporter: 'Andi Wijaya, ST',
      description: 'Penyelesaian pengecoran plat lantai 3 zona timur dan pemasangan scaffolding.',
    ),
    ProgressReportModel(
      id: 2,
      projectName: 'Renovasi Hotel Bintang Lima Nusantara',
      currentProgress: 68.0,
      addedProgress: 3.5,
      reportDate: '28 Okt 2026',
      reporter: 'Ir. Budi Santoso',
      description: 'Finishing plester dinding lobby utama dan instalasi plafon gypsum koridor.',
    ),
    ProgressReportModel(
      id: 3,
      projectName: 'Pembangunan Jembatan Sungai Ciliwung',
      currentProgress: 32.0,
      addedProgress: 4.0,
      reportDate: '25 Okt 2026',
      reporter: 'Andi Wijaya, ST',
      description: 'Pemasangan tiang pancang abutmen sisi utara selesai 100%.',
    ),
    ProgressReportModel(
      id: 4,
      projectName: 'Perumahan Green Valley Residence',
      currentProgress: 55.0,
      addedProgress: 6.0,
      reportDate: '20 Okt 2026',
      reporter: 'Andi Wijaya, ST',
      description: 'Pengerjaan atap baja ringan pada 20 unit rumah blok A sudah terpasang.',
    ),
    ProgressReportModel(
      id: 5,
      projectName: 'Pembangunan Masjid Al-Ikhlas',
      currentProgress: 72.0,
      addedProgress: 2.0,
      reportDate: '15 Okt 2026',
      reporter: 'Andi Wijaya, ST',
      description: 'Pemasangan kubah utama stainless steel selesai dengan aman.',
    ),
  ];
}
