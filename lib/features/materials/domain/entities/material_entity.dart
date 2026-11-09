class MaterialEntity {
  final int id;
  final String name;
  final int stock;
  final int minimumStock;
  final double pricePerUnit;
  final String unit;

  const MaterialEntity({
    required this.id,
    required this.name,
    required this.stock,
    required this.minimumStock,
    required this.pricePerUnit,
    required this.unit,
  });

  bool get isCritical => stock <= minimumStock;
}
