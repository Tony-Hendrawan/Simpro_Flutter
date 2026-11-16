class DocumentEntity {
  final int id;
  final String name;
  final String category; // 'kontrak', 'gambar_kerja', 'rab', 'laporan', 'legal'
  final String projectName;
  final String size;
  final String uploadedBy;
  final bool isArchived;
  final DateTime? archivedAt;

  const DocumentEntity({
    required this.id,
    required this.name,
    required this.category,
    required this.projectName,
    required this.size,
    required this.uploadedBy,
    this.isArchived = false,
    this.archivedAt,
  });

  DocumentEntity copyWith({
    int? id,
    String? name,
    String? category,
    String? projectName,
    String? size,
    String? uploadedBy,
    bool? isArchived,
    DateTime? archivedAt,
  }) {
    return DocumentEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      projectName: projectName ?? this.projectName,
      size: size ?? this.size,
      uploadedBy: uploadedBy ?? this.uploadedBy,
      isArchived: isArchived ?? this.isArchived,
      archivedAt: archivedAt ?? this.archivedAt,
    );
  }
}
