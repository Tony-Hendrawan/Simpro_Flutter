class SurveyEntity {
  final int id;
  final String surveyCode;
  final String projectName;
  final String surveyorName;
  final String surveyDate;
  final String landCondition; // 'Datar', 'Bergelombang', 'Miring/Berbukit'
  final String status; // 'pending', 'review', 'approved', 'rejected'
  final String notes;
  final double? areaSize; // Satuan: m2
  final double? elevation; // Satuan: m
  final String?
  soilType; // Jenis Tanah: Tanah Lempung/Liat, Tanah Keras/Padas, dll.
  final String? contour; // Kontur: Datar, Bergelombang, Miring/Berbukit
  final String? accessibility; // Akses Jalan Menuju Lokasi

  const SurveyEntity({
    required this.id,
    required this.surveyCode,
    required this.projectName,
    required this.surveyorName,
    required this.surveyDate,
    required this.landCondition,
    required this.status,
    required this.notes,
    this.areaSize,
    this.elevation,
    this.soilType,
    this.contour,
    this.accessibility,
  });
}
