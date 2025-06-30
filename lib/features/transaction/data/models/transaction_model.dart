import '../../domain/entities/transaction.dart';

/// Model class for Transaction data layer
class TransactionModel {
  final String id;
  final String clientId;
  final DateTime dateTime;
  final int received;
  final int paid;
  final String? note;

  TransactionModel({
    required this.id,
    required this.clientId,
    required this.dateTime,
    required this.received,
    required this.paid,
    this.note,
  });

  /// Convert model to entity
  Transaction toEntity() {
    return Transaction(
      id: id,
      clientId: clientId,
      dateTime: dateTime,
      received: received,
      paid: paid,
    );
  }

  /// Create model from entity
  factory TransactionModel.fromEntity(Transaction transaction) {
    return TransactionModel(
      id: transaction.id,
      clientId: transaction.clientId,
      dateTime: transaction.dateTime,
      received: transaction.received,
      paid: transaction.paid,
    );
  }

  /// Convert model to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'clientId': clientId,
      'dateTime': dateTime.toIso8601String(),
      'received': received,
      'paid': paid,
      'note': note,
      'createdAt': DateTime.now().toIso8601String(),
    };
  }

  /// Create model from JSON from Firestore
  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] as String,
      clientId: json['clientId'] as String,
      dateTime: DateTime.parse(json['dateTime'] as String),
      received: json['received'] as int,
      paid: json['paid'] as int,
      note: json['note'] as String?,
    );
  }

  /// Create a copy of the model with updated fields
  TransactionModel copyWith({
    String? id,
    String? clientId,
    DateTime? dateTime,
    int? received,
    int? paid,
    String? note,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      clientId: clientId ?? this.clientId,
      dateTime: dateTime ?? this.dateTime,
      received: received ?? this.received,
      paid: paid ?? this.paid,
      note: note ?? this.note,
    );
  }
}
