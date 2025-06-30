/// Client entity representing a business client
class Client {
  final String id;
  final String name;
  final String mobileNumber;
  final String businessType;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Client({
    required this.id,
    required this.name,
    required this.mobileNumber,
    required this.businessType,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Client &&
        other.id == id &&
        other.name == name &&
        other.mobileNumber == mobileNumber &&
        other.businessType == businessType &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return Object.hash(
        id, name, mobileNumber, businessType, createdAt, updatedAt);
  }

  /// Create a copy of this client with updated fields
  Client copyWith({
    String? id,
    String? name,
    String? mobileNumber,
    String? businessType,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Client(
      id: id ?? this.id,
      name: name ?? this.name,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      businessType: businessType ?? this.businessType,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
