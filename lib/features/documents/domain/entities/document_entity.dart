class DocumentEntity {
  final int id;
  final String name;
  final String category; // 'kontrak', 'gambar_kerja', 'rab', 'laporan', 'legal'
  final String projectName;
  final String size;
  final String uploadedBy;

  const DocumentEntity({
    required this.id,
    required this.name,
    required this.category,
    required this.projectName,
    required this.size,
    required this.uploadedBy,
  });
}
