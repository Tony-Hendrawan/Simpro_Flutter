class MaterialRequestEntity {
  final int id;
  final String requestCode;
  final String projectName;
  final String materialName;
  final int quantity;
  final String unit;
  final double estimatedCost;
  final String status; // 'pending', 'approved', 'delivered', 'rejected'
  final String requestedBy;
  final String date;
  final String? approvedBy;
  final String? notes;

  const MaterialRequestEntity({
    required this.id,
    required this.requestCode,
    required this.projectName,
    required this.materialName,
    required this.quantity,
    required this.unit,
    required this.estimatedCost,
    required this.status,
    required this.requestedBy,
    required this.date,
    this.approvedBy,
    this.notes,
  });
}
