// Tabelul "drivers" - soferii unui Carrier.
class Driver {
  final int id;
  final int carrierId;        // id-ul User-ului cu rol CARRIER
  final String name;
  final String? phone;
  final String? licenseNumber;

  Driver({
    required this.id,
    required this.carrierId,
    required this.name,
    this.phone,
    this.licenseNumber,
  });

  factory Driver.fromMap(Map<String, dynamic> map) {
    return Driver(
      id: map['id'],
      carrierId: map['carrier_id'],
      name: map['name'],
      phone: map['phone'],
      licenseNumber: map['license_number'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'carrier_id': carrierId,
      'name': name,
      'phone': phone,
      'license_number': licenseNumber,
    };
  }
}
