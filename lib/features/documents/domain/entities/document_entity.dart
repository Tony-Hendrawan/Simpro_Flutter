class DocumentEntity {
  final int id;
  final String name;
  final String category; // 'kontrak', 'gambar_kerja', 'rab', 'laporan', 'legal', 'lainnya'
  final String projectName;
  final int? projectId;
  final String? projectCode;
  final String size;
  final String uploadedBy;
  final bool isArchived;
  final DateTime? archivedAt;
  final DateTime? createdAt;
  final String? googleDriveUrl;
  final String? filePath;

  const DocumentEntity({
    required this.id,
    required this.name,
    required this.category,
    required this.projectName,
    this.projectId,
    this.projectCode,
    required this.size,
    required this.uploadedBy,
    this.isArchived = false,
    this.archivedAt,
    this.createdAt,
    this.googleDriveUrl,
    this.filePath,
  });

  DocumentEntity copyWith({
    int? id,
    String? name,
    String? category,
    String? projectName,
    int? projectId,
    String? projectCode,
    String? size,
    String? uploadedBy,
    bool? isArchived,
    DateTime? archivedAt,
    DateTime? createdAt,
    String? googleDriveUrl,
    String? filePath,
  }) {
    return DocumentEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      projectName: projectName ?? this.projectName,
      projectId: projectId ?? this.projectId,
      projectCode: projectCode ?? this.projectCode,
      size: size ?? this.size,
      uploadedBy: uploadedBy ?? this.uploadedBy,
      isArchived: isArchived ?? this.isArchived,
      archivedAt: archivedAt ?? this.archivedAt,
      createdAt: createdAt ?? this.createdAt,
      googleDriveUrl: googleDriveUrl ?? this.googleDriveUrl,
      filePath: filePath ?? this.filePath,
    );
  }
}
