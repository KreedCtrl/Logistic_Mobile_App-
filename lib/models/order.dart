import 'enums.dart';

// Tabelul "orders" - comanda postata de un Customer.
class Order {
  final int id;
  final int customerId;

  final String pickupCity;
  final DateTime pickupDate;
  final String deliveryCity;
  final DateTime deliveryDate;

  final EquipmentType equipmentType;
  final double? weight;       // kg
  final String? description;
  final double price;

  final OrderStatus status;

  // se completeaza dupa ce Customer-ul accepta o aplicare
  final int? assignedToId;
  final int? truckId;

  final DateTime createdAt;

  Order({
    required this.id,
    required this.customerId,
    required this.pickupCity,
    required this.pickupDate,
    required this.deliveryCity,
    required this.deliveryDate,
    required this.equipmentType,
    this.weight,
    this.description,
    required this.price,
    this.status = OrderStatus.open,   // valoare implicita, ca DEFAULT 'OPEN' in SQL
    this.assignedToId,
    this.truckId,
    required this.createdAt,
  });

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['id'],
      customerId: map['customer_id'],
      pickupCity: map['pickup_city'],
      pickupDate: DateTime.parse(map['pickup_date']),
      deliveryCity: map['delivery_city'],
      deliveryDate: DateTime.parse(map['delivery_date']),
      equipmentType: EquipmentType.fromValue(map['equipment_type']),
      weight: (map['weight'] as num?)?.toDouble(),
      description: map['description'],
      price: (map['price'] as num).toDouble(),
      status: OrderStatus.fromValue(map['status']),
      assignedToId: map['assigned_to_id'],
      truckId: map['truck_id'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'customer_id': customerId,
      'pickup_city': pickupCity,
      'pickup_date': pickupDate.toIso8601String(),
      'delivery_city': deliveryCity,
      'delivery_date': deliveryDate.toIso8601String(),
      'equipment_type': equipmentType.value,
      'weight': weight,
      'description': description,
      'price': price,
      'status': status.value,
      'assigned_to_id': assignedToId,
      'truck_id': truckId,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
