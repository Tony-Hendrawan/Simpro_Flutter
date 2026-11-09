class EquipmentEntity {
  final int id;
  final String code;
  final String name;
  final String status; // 'tersedia', 'dipinjam', 'diservis'
  final String condition;
  final double dailyCost;
  final String? projectName;

  const EquipmentEntity({
    required this.id,
    required this.code,
    required this.name,
    required this.status,
    required this.condition,
    required this.dailyCost,
    this.projectName,
  });
}
