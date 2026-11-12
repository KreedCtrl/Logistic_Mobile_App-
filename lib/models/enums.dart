// Valorile fixe din baza de date (coloanele cu CHECK).
// Fiecare enum are un "value" = exact textul salvat in baza de date.

enum UserRole {
  customer('CUSTOMER'),
  carrier('CARRIER'),
  ownerOperator('OWNER_OPERATOR');

  const UserRole(this.value);
  final String value;

  static UserRole fromValue(String value) =>
      values.firstWhere((e) => e.value == value);
}

enum EquipmentType {
  dryVan('DRY_VAN'),
  reefer('REEFER'),
  flatbed('FLATBED');

  const EquipmentType(this.value);
  final String value;

  static EquipmentType fromValue(String value) =>
      values.firstWhere((e) => e.value == value);
}

enum OrderStatus {
  open('OPEN'),
  assigned('ASSIGNED'),
  inTransit('IN_TRANSIT'),
  delivered('DELIVERED'),
  cancelled('CANCELLED');

  const OrderStatus(this.value);
  final String value;

  static OrderStatus fromValue(String value) =>
      values.firstWhere((e) => e.value == value);
}

enum ApplicationStatus {
  pending('PENDING'),
  accepted('ACCEPTED'),
  rejected('REJECTED');

  const ApplicationStatus(this.value);
  final String value;

  static ApplicationStatus fromValue(String value) =>
      values.firstWhere((e) => e.value == value);
}
