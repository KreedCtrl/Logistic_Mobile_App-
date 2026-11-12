import 'enums.dart';

// Tabelul "trucks" - echipamentul unui Carrier sau Owner Operator.
class Truck {
  final int id;
  final int ownerId;          // Carrier sau Owner Operator
  final int? driverId;        // null pentru Owner Operator (el e soferul)
  final String unitNumber;
  final String? plateNumber;
  final EquipmentType equipmentType;

  Truck({
    required this.id,
    required this.ownerId,
    this.driverId,
    required this.unitNumber,
    this.plateNumber,
    required this.equipmentType,
  });

  factory Truck.fromMap(Map<String, dynamic> map) {
    return Truck(
      id: map['id'],
      ownerId: map['owner_id'],
      driverId: map['driver_id'],
      unitNumber: map['unit_number'],
      plateNumber: map['plate_number'],
      equipmentType: EquipmentType.fromValue(map['equipment_type']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'owner_id': ownerId,
      'driver_id': driverId,
      'unit_number': unitNumber,
      'plate_number': plateNumber,
      'equipment_type': equipmentType.value,
    };
  }
}
