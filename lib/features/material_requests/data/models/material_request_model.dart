import '../../domain/entities/material_request_entity.dart';

class MaterialRequestModel extends MaterialRequestEntity {
  const MaterialRequestModel({
    required super.id,
    required super.requestCode,
    required super.projectName,
    required super.materialName,
    required super.quantity,
    required super.unit,
    required super.estimatedCost,
    required super.status,
    required super.requestedBy,
    required super.date,
  });

  static List<MaterialRequestModel> get mockRequests => const [
    MaterialRequestModel(
      id: 1,
      requestCode: 'REQ-2026-001',
      projectName: 'Pembangunan Gedung Kantor PT Maju Jaya',
      materialName: 'Semen Gresik Portland Composite (40kg)',
      quantity: 200,
      unit: 'Sak',
      estimatedCost: 13600000,
      status: 'pending',
      requestedBy: 'Andi Wijaya, ST (Pengawas Lapangan)',
      date: '02 Nov 2026',
    ),
    MaterialRequestModel(
      id: 2,
      requestCode: 'REQ-2026-002',
      projectName: 'Pembangunan Jembatan Sungai Ciliwung',
      materialName: 'Besi Beton Ulir D13 mm x 12m (SNI)',
      quantity: 500,
      unit: 'Batang',
      estimatedCost: 57500000,
      status: 'approved',
      requestedBy: 'Agus Setiawan (Staf Logistik)',
      date: '30 Okt 2026',
    ),
    MaterialRequestModel(
      id: 3,
      requestCode: 'REQ-2026-003',
      projectName: 'Perumahan Green Valley Residence',
      materialName: 'Bata Ringan Hebel 7.5cm Standard',
      quantity: 40,
      unit: 'M3',
      estimatedCost: 24800000,
      status: 'delivered',
      requestedBy: 'Andi Wijaya, ST (Pengawas Lapangan)',
      date: '24 Okt 2026',
    ),
    MaterialRequestModel(
      id: 4,
      requestCode: 'REQ-2026-004',
      projectName: 'Renovasi Hotel Bintang Lima Nusantara',
      materialName: 'Cat Tembok Exterior Dulux 20L',
      quantity: 12,
      unit: 'Galon',
      estimatedCost: 17400000,
      status: 'rejected',
      requestedBy: 'Ir. H. Hendra Wijaya (Owner)',
      date: '18 Okt 2026',
    ),
  ];
}
