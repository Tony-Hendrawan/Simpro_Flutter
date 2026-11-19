class ClientEntity {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String address;
  final String category; // 'Klien', 'Vendor', 'Subkontraktor'
  final String contactPerson;
  final String status; // 'aktif', 'nonaktif'
  final String company;

  const ClientEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.category,
    this.contactPerson = '',
    this.status = 'aktif',
    this.company = '',
  });
}
