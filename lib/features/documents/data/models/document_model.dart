import '../../domain/entities/document_entity.dart';

class DocumentModel extends DocumentEntity {
  const DocumentModel({
    required super.id,
    required super.name,
    required super.category,
    required super.projectName,
    required super.size,
    required super.uploadedBy,
  });

  static List<DocumentModel> get mockDocuments => const [
    DocumentModel(
      id: 1,
      name: 'Surat_Perjanjian_Kontrak_PT_Maju_Jaya.pdf',
      category: 'kontrak',
      projectName: 'Pembangunan Gedung Kantor PT Maju Jaya',
      size: '4.2 MB',
      uploadedBy: 'Administrasi',
    ),
    DocumentModel(
      id: 2,
      name: 'Gambar_Kerja_DED_Struktur_Gedung.dwg',
      category: 'gambar_kerja',
      projectName: 'Pembangunan Gedung Kantor PT Maju Jaya',
      size: '18.5 MB',
      uploadedBy: 'Konsultan Teknik',
    ),
    DocumentModel(
      id: 3,
      name: 'RAB_Final_Pembangunan_Kantor.xlsx',
      category: 'rab',
      projectName: 'Pembangunan Gedung Kantor PT Maju Jaya',
      size: '1.8 MB',
      uploadedBy: 'Administrasi',
    ),
    DocumentModel(
      id: 4,
      name: 'Laporan_Bulanan_Progres_April.pdf',
      category: 'laporan',
      projectName: 'Pembangunan Gedung Kantor PT Maju Jaya',
      size: '2.1 MB',
      uploadedBy: 'Pengawas Lapangan',
    ),
    DocumentModel(
      id: 5,
      name: 'Kontrak_Renovasi_Hotel_Nusantara.pdf',
      category: 'kontrak',
      projectName: 'Renovasi Hotel Bintang Lima Nusantara',
      size: '3.8 MB',
      uploadedBy: 'Administrasi',
    ),
    DocumentModel(
      id: 6,
      name: 'Spesifikasi_Teknis_Material_Jembatan.pdf',
      category: 'laporan',
      projectName: 'Pembangunan Jembatan Sungai Ciliwung',
      size: '5.6 MB',
      uploadedBy: 'Konsultan Teknik',
    ),
  ];
}
