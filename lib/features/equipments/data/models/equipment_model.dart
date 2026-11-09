import '../../domain/entities/equipment_entity.dart';

class EquipmentModel extends EquipmentEntity {
  const EquipmentModel({
    required super.id,
    required super.code,
    required super.name,
    required super.status,
    required super.condition,
    required super.dailyCost,
    super.projectName,
  });

  static List<EquipmentModel> get mockEquipments => const [
    EquipmentModel(
      id: 1,
      code: 'EQP-EXC-01',
      name: 'Excavator Komatsu PC200-8',
      status: 'dipinjam',
      condition: 'Prima (Operasional)',
      dailyCost: 1500000,
      projectName: 'Pembangunan Gedung Kantor PT Maju Jaya',
    ),
    EquipmentModel(
      id: 2,
      code: 'EQP-CRN-02',
      name: 'Mobile Crane Tadano 50 Ton',
      status: 'dipinjam',
      condition: 'Baik',
      dailyCost: 3500000,
      projectName: 'Pembangunan Jembatan Sungai Ciliwung',
    ),
    EquipmentModel(
      id: 3,
      code: 'EQP-BKP-03',
      name: 'Backhoe Loader CAT 428F2',
      status: 'tersedia',
      condition: 'Sangat Baik',
      dailyCost: 1200000,
      projectName: null,
    ),
    EquipmentModel(
      id: 4,
      code: 'EQP-VIB-04',
      name: 'Vibratory Roller Sakai SV512',
      status: 'tersedia',
      condition: 'Baik',
      dailyCost: 950000,
      projectName: null,
    ),
    EquipmentModel(
      id: 5,
      code: 'EQP-GEN-05',
      name: 'Genset Silent Perkins 150 kVA',
      status: 'diservis',
      condition: 'Pergantian Oli & Filter',
      dailyCost: 600000,
      projectName: null,
    ),
    EquipmentModel(
      id: 6,
      code: 'EQP-SCF-06',
      name: 'Scaffolding Tubular Set (1000 Frame)',
      status: 'dipinjam',
      condition: 'Lengkap',
      dailyCost: 450000,
      projectName: 'Renovasi Hotel Bintang Lima Nusantara',
    ),
  ];
}
