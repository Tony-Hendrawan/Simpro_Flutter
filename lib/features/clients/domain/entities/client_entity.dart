class ClientEntity {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String address;
  final String category; // 'Klien', 'Vendor', 'Subkontraktor'

  const ClientEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.category,
  });
}
