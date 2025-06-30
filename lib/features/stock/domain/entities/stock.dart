/// Stock entity representing a product in inventory
class Stock {
  final String id;
  final String productName;
  final int quantity;
  final double pricePerUnit;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Stock({
    required this.id,
    required this.productName,
    required this.quantity,
    required this.pricePerUnit,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Calculate total value of this stock item
  double get totalValue => quantity * pricePerUnit;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Stock &&
        other.id == id &&
        other.productName == productName &&
        other.quantity == quantity &&
        other.pricePerUnit == pricePerUnit &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return Object.hash(
        id, productName, quantity, pricePerUnit, createdAt, updatedAt);
  }

  /// Create a copy of this stock item with updated fields
  Stock copyWith({
    String? id,
    String? productName,
    int? quantity,
    double? pricePerUnit,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Stock(
      id: id ?? this.id,
      productName: productName ?? this.productName,
      quantity: quantity ?? this.quantity,
      pricePerUnit: pricePerUnit ?? this.pricePerUnit,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
