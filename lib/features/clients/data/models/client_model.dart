import '../../domain/entities/client_entity.dart';

class ClientModel extends ClientEntity {
  const ClientModel({
    required super.id,
    required super.name,
    required super.email,
    required super.phone,
    required super.address,
    required super.category,
  });

  factory ClientModel.fromJson(Map<String, dynamic> json) {
    return ClientModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      address: json['address'] as String? ?? '',
      category: json['category'] as String? ?? 'Klien',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'category': category,
    };
  }

  static List<ClientModel> get mockClients => const [
    ClientModel(
      id: 1,
      name: 'PT Maju Jaya Sentosa',
      email: 'contact@majujaya.co.id',
      phone: '021-12345678',
      address: 'Gedung Wisma Mulia Lt. 12, Jakarta Selatan',
      category: 'Klien',
    ),
    ClientModel(
      id: 2,
      name: 'PT Nusantara Hospitality',
      email: 'corp@nusantarahotel.com',
      phone: '0361-987654',
      address: 'Kawasan Wisata Nusa Dua Lot 4, Bali',
      category: 'Klien',
    ),
    ClientModel(
      id: 3,
      name: 'PT Semen Gresik Tbk',
      email: 'distribusi@semengresik.com',
      phone: '031-7654321',
      address: 'Jl. Veteran No. 1, Gresik',
      category: 'Vendor',
    ),
    ClientModel(
      id: 4,
      name: 'PT Krakatau Steel Cilegon',
      email: 'sales@krakatausteel.com',
      phone: '0254-392111',
      address: 'Kawasan Industri Krakatau Kav E-2, Cilegon',
      category: 'Vendor',
    ),
    ClientModel(
      id: 5,
      name: 'CV Beton Karya Utama',
      email: 'tender@betonkarya.id',
      phone: '021-8899776',
      address: 'Jl. Raya Narogong Km 14, Bekasi',
      category: 'Subkontraktor',
    ),
    ClientModel(
      id: 6,
      name: 'PT Mitra Crane Nusantara',
      email: 'rental@mitracrane.com',
      phone: '021-5544332',
      address: 'Jl. Daan Mogot Km 19, Tangerang',
      category: 'Vendor',
    ),
  ];
}
