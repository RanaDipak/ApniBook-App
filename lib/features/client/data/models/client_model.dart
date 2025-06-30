import '../../domain/entities/client.dart';

/// Client data model for data layer operations
class ClientModel extends Client {
  const ClientModel({
    required super.id,
    required super.name,
    required super.mobileNumber,
    required super.businessType,
    required super.createdAt,
    required super.updatedAt,
  });

  /// Create ClientModel from domain entity
  factory ClientModel.fromEntity(Client client) {
    return ClientModel(
      id: client.id,
      name: client.name,
      mobileNumber: client.mobileNumber,
      businessType: client.businessType,
      createdAt: client.createdAt,
      updatedAt: client.updatedAt,
    );
  }

  /// Create ClientModel from JSON
  factory ClientModel.fromJson(Map<String, dynamic> json) {
    return ClientModel(
      id: json['id'] as String,
      name: json['name'] as String,
      mobileNumber: json['mobileNumber'] as String,
      businessType: json['businessType'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'mobileNumber': mobileNumber,
      'businessType': businessType,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// Convert to domain entity
  Client toEntity() {
    return Client(
      id: id,
      name: name,
      mobileNumber: mobileNumber,
      businessType: businessType,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
