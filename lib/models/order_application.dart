import 'enums.dart';

class OrderApplication {
  final int id;
  final int orderId;
  final int applicantId;
  final int truckId; 
  final double? proposedPrice;
  final String? message;
  final ApplicationStatus status;
  final DateTime createdAt;

  OrderApplication({
    required this.id,
    required this.orderId,
    required this.applicantId,
    required this.truckId,
    this.proposedPrice,
    this.message,
    this.status = ApplicationStatus.pending,
    required this.createdAt,
  });

  factory OrderApplication.fromMap(Map<String, dynamic> map) {
    return OrderApplication(
      id: map['id'],
      orderId: map['order_id'],
      applicantId: map['applicant_id'],
      truckId: map['truck_id'],
      proposedPrice: (map['proposed_price'] as num?)?.toDouble(),
      message: map['message'],
      status: ApplicationStatus.fromValue(map['status']),
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'order_id': orderId,
      'applicant_id': applicantId,
      'truck_id': truckId,
      'proposed_price': proposedPrice,
      'message': message,
      'status': status.value,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
