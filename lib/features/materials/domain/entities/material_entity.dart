class MaterialEntity {
  final int id;
  final String name;
  final int stock;
  final int minimumStock;
  final double pricePerUnit;
  final String unit;
  final String? specification;
  final String? supplier;
  final double? rentalPricePerUnit;
  final double? discountPercent;
  final double? discountAmount;

  const MaterialEntity({
    required this.id,
    required this.name,
    required this.stock,
    required this.minimumStock,
    required this.pricePerUnit,
    required this.unit,
    this.specification,
    this.supplier,
    this.rentalPricePerUnit,
    this.discountPercent,
    this.discountAmount,
  });

  bool get isCritical => stock <= minimumStock;

  bool get hasActiveDiscount =>
      (discountPercent != null && discountPercent! > 0) ||
      (discountAmount != null && discountAmount! > 0);

  double get effectivePrice {
    if (!hasActiveDiscount) return pricePerUnit;
    if (discountPercent != null && discountPercent! > 0) {
      return pricePerUnit * (1 - (discountPercent! / 100));
    }
    if (discountAmount != null && discountAmount! > 0) {
      final res = pricePerUnit - discountAmount!;
      return res < 0 ? 0 : res;
    }
    return pricePerUnit;
  }
}
