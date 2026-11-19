class EquipmentEntity {
  final int id;
  final String code;
  final String name;
  final String status; // 'tersedia', 'dipinjam', 'diservis'
  final String condition;
  final double dailyCost;
  final int? currentProjectId;
  final String? projectName;
  final String? projectLocation;

  const EquipmentEntity({
    required this.id,
    required this.code,
    required this.name,
    required this.status,
    required this.condition,
    required this.dailyCost,
    this.currentProjectId,
    this.projectName,
    this.projectLocation,
  });

  EquipmentEntity copyWith({
    int? id,
    String? code,
    String? name,
    String? status,
    String? condition,
    double? dailyCost,
    int? currentProjectId,
    String? projectName,
    String? projectLocation,
    bool clearProject = false,
  }) {
    return EquipmentEntity(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      status: status ?? this.status,
      condition: condition ?? this.condition,
      dailyCost: dailyCost ?? this.dailyCost,
      currentProjectId: clearProject ? null : (currentProjectId ?? this.currentProjectId),
      projectName: clearProject ? null : (projectName ?? this.projectName),
      projectLocation: clearProject ? null : (projectLocation ?? this.projectLocation),
    );
  }
}
