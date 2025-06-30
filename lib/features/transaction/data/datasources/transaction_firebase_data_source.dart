import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/services/firebase_service.dart';
import '../models/transaction_model.dart';

/// Firebase data source for transaction operations
class TransactionFirebaseDataSource {
  final FirebaseFirestore _firestore = FirebaseService.firestore;
  final String _collection = 'transactions';

  /// Get all transactions for a specific client from Firebase
  Future<List<TransactionModel>> getTransactionsForClient(
    String clientId,
  ) async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection(_collection)
          .where('clientId', isEqualTo: clientId)
          .orderBy('dateTime', descending: true)
          .get();

      return snapshot.docs
          .map(
            (doc) => TransactionModel.fromJson({
              'id': doc.id,
              ...doc.data() as Map<String, dynamic>,
            }),
          )
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch transactions: $e');
    }
  }

  /// Get a specific transaction by ID
  Future<TransactionModel?> getTransaction(String id) async {
    try {
      final DocumentSnapshot doc = await _firestore
          .collection(_collection)
          .doc(id)
          .get();

      if (doc.exists) {
        return TransactionModel.fromJson({
          'id': doc.id,
          ...doc.data() as Map<String, dynamic>,
        });
      }
      return null;
    } catch (e) {
      throw Exception('Failed to fetch transaction: $e');
    }
  }

  /// Add a new transaction to Firebase and return the generated ID
  Future<String> addTransaction(TransactionModel transaction) async {
    try {
      // Remove the id from the data since Firestore will generate it
      final data = transaction.toJson();
      data.remove('id');

      final docRef = await _firestore.collection(_collection).add(data);
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to add transaction: $e');
    }
  }

  /// Update an existing transaction in Firebase
  Future<void> updateTransaction(TransactionModel transaction) async {
    try {
      final data = transaction.toJson();
      data.remove('id'); // Remove id from update data

      await _firestore.collection(_collection).doc(transaction.id).update(data);
    } catch (e) {
      throw Exception('Failed to update transaction: $e');
    }
  }

  /// Delete a transaction from Firebase
  Future<void> deleteTransaction(String transactionId) async {
    try {
      await _firestore.collection(_collection).doc(transactionId).delete();
    } catch (e) {
      throw Exception('Failed to delete transaction: $e');
    }
  }

  /// Get all transactions (for admin purposes)
  Future<List<TransactionModel>> getAllTransactions() async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection(_collection)
          .orderBy('dateTime', descending: true)
          .get();

      return snapshot.docs
          .map(
            (doc) => TransactionModel.fromJson({
              'id': doc.id,
              ...doc.data() as Map<String, dynamic>,
            }),
          )
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch all transactions: $e');
    }
  }

  /// Get transactions within a date range for a client
  Future<List<TransactionModel>> getTransactionsByDateRange(
    String clientId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection(_collection)
          .where('clientId', isEqualTo: clientId)
          .where(
            'dateTime',
            isGreaterThanOrEqualTo: startDate.toIso8601String(),
          )
          .where('dateTime', isLessThanOrEqualTo: endDate.toIso8601String())
          .orderBy('dateTime', descending: true)
          .get();

      return snapshot.docs
          .map(
            (doc) => TransactionModel.fromJson({
              'id': doc.id,
              ...doc.data() as Map<String, dynamic>,
            }),
          )
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch transactions by date range: $e');
    }
  }
}
