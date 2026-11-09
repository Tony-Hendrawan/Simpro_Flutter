import '../../domain/entities/survey_entity.dart';

class SurveyModel extends SurveyEntity {
  const SurveyModel({
    required super.id,
    required super.surveyCode,
    required super.projectName,
    required super.surveyorName,
    required super.surveyDate,
    required super.landCondition,
    required super.status,
    required super.notes,
  });

  static List<SurveyModel> get mockSurveys => const [
    SurveyModel(
      id: 1,
      surveyCode: 'SRV-2026-001',
      projectName: 'Pembangunan Gedung Kantor PT Maju Jaya',
      surveyorName: 'Andi Wijaya, ST',
      surveyDate: '12 Jan 2026',
      landCondition: 'Datar & Kering',
      status: 'approved',
      notes: 'Daya dukung tanah baik, akses jalan masuk kontainer 20ft aman.',
    ),
    SurveyModel(
      id: 2,
      surveyCode: 'SRV-2026-002',
      projectName: 'Renovasi Hotel Bintang Lima Nusantara',
      surveyorName: 'Ir. Budi Santoso',
      surveyDate: '18 Feb 2026',
      landCondition: 'Struktur Eksisting Baik',
      status: 'approved',
      notes: 'Pondasi awal kokoh, hanya perlu perkuatan kolom lantai 2.',
    ),
    SurveyModel(
      id: 3,
      surveyCode: 'SRV-2026-003',
      projectName: 'Pembangunan Jembatan Sungai Ciliwung',
      surveyorName: 'Ir. Budi Santoso',
      surveyDate: '01 Mar 2026',
      landCondition: 'Lembek & Rawan Erosi',
      status: 'review',
      notes: 'Diperlukan bore pile kedalaman minimum 18 meter untuk stabilitas.',
    ),
    SurveyModel(
      id: 4,
      surveyCode: 'SRV-2026-004',
      projectName: 'Perumahan Green Valley Residence',
      surveyorName: 'Andi Wijaya, ST',
      surveyDate: '25 Mar 2026',
      landCondition: 'Kontur Bergelombang',
      status: 'pending',
      notes: 'Perlu cut and fill tanah sebelum pembangunan pondasi blok B.',
    ),
    SurveyModel(
      id: 5,
      surveyCode: 'SRV-2026-005',
      projectName: 'Pembangunan Gudang Logistik Cikupa',
      surveyorName: 'Andi Wijaya, ST',
      surveyDate: '10 Apr 2026',
      landCondition: 'Datar Bebas Banjir',
      status: 'pending',
      notes: 'Menunggu review dokumen elevasi tanah dari Dinas PUPR setempat.',
    ),
  ];
}
