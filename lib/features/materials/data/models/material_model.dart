import '../../domain/entities/material_entity.dart';

class MaterialModel extends MaterialEntity {
  const MaterialModel({
    required super.id,
    required super.name,
    required super.stock,
    required super.minimumStock,
    required super.pricePerUnit,
    required super.unit,
  });

  static List<MaterialModel> get mockMaterials => const [
    MaterialModel(
      id: 1,
      name: 'Semen Gresik Portland Composite (40kg)',
      stock: 450,
      minimumStock: 100,
      pricePerUnit: 68000,
      unit: 'Sak',
    ),
    MaterialModel(
      id: 2,
      name: 'Besi Beton Ulir D13 mm x 12m (SNI)',
      stock: 850,
      minimumStock: 200,
      pricePerUnit: 115000,
      unit: 'Batang',
    ),
    MaterialModel(
      id: 3,
      name: 'Besi Beton Polos TP24 Dia 10mm x 12m',
      stock: 520,
      minimumStock: 150,
      pricePerUnit: 78000,
      unit: 'Batang',
    ),
    MaterialModel(
      id: 4,
      name: 'Pasir Pasang Super Cilegon',
      stock: 45,
      minimumStock: 15,
      pricePerUnit: 280000,
      unit: 'M3',
    ),
    MaterialModel(
      id: 5,
      name: 'Batu Split Cor 2/3 Clean',
      stock: 30,
      minimumStock: 10,
      pricePerUnit: 295000,
      unit: 'M3',
    ),
    MaterialModel(
      id: 6,
      name: 'Bata Ringan Hebel 7.5cm Standard',
      stock: 120,
      minimumStock: 40,
      pricePerUnit: 620000,
      unit: 'M3',
    ),
    MaterialModel(
      id: 7,
      name: 'Baja Ringan Truss C75.075 SNI',
      stock: 320,
      minimumStock: 100,
      pricePerUnit: 85000,
      unit: 'Batang',
    ),
    MaterialModel(
      id: 8,
      name: 'Cat Tembok Exterior Dulux 20L',
      stock: 8,
      minimumStock: 15,
      pricePerUnit: 1450000,
      unit: 'Galon',
    ),
    MaterialModel(
      id: 9,
      name: 'Pipa PVC Wavin AW 3 inch x 4m',
      stock: 18,
      minimumStock: 25,
      pricePerUnit: 135000,
      unit: 'Batang',
    ),
  ];
}
