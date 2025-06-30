import '../../domain/entities/stock.dart';

/// Stock data model for data layer operations
class StockModel extends Stock {
  const StockModel({
    required super.id,
    required super.productName,
    required super.quantity,
    required super.pricePerUnit,
    required super.createdAt,
    required super.updatedAt,
  });

  /// Create StockModel from domain entity
  factory StockModel.fromEntity(Stock stock) {
    return StockModel(
      id: stock.id,
      productName: stock.productName,
      quantity: stock.quantity,
      pricePerUnit: stock.pricePerUnit,
      createdAt: stock.createdAt,
      updatedAt: stock.updatedAt,
    );
  }

  /// Create StockModel from JSON
  factory StockModel.fromJson(Map<String, dynamic> json) {
    return StockModel(
      id: json['id'] as String,
      productName: json['productName'] as String,
      quantity: json['quantity'] as int,
      pricePerUnit: (json['pricePerUnit'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productName': productName,
      'quantity': quantity,
      'pricePerUnit': pricePerUnit,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// Convert to domain entity
  Stock toEntity() {
    return Stock(
      id: id,
      productName: productName,
      quantity: quantity,
      pricePerUnit: pricePerUnit,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
