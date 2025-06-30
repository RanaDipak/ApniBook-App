import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/services/firebase_service.dart';
import '../models/stock_model.dart';

/// Firebase data source for stock operations
class StockFirebaseDataSource {
  final FirebaseFirestore _firestore = FirebaseService.firestore;
  final String _collection = 'stocks';

  /// Get all stocks from Firebase
  Future<List<StockModel>> getStocks() async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection(_collection)
          .get();
      return snapshot.docs
          .map(
            (doc) => StockModel.fromJson({
              'id': doc.id,
              ...doc.data() as Map<String, dynamic>,
            }),
          )
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch stocks: $e');
    }
  }

  /// Add a new stock to Firebase and return the generated ID
  Future<String> addStock(StockModel stock) async {
    try {
      // Remove the id from the data since Firestore will generate it
      final data = stock.toJson();
      data.remove('id');
      final docRef = await _firestore.collection(_collection).add(data);
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to add stock: $e');
    }
  }

  /// Update an existing stock in Firebase
  Future<void> updateStock(StockModel stock) async {
    try {
      final data = stock.toJson();
      data.remove('id'); // Remove id from update data
      await _firestore.collection(_collection).doc(stock.id).update(data);
    } catch (e) {
      throw Exception('Failed to update stock: $e');
    }
  }

  /// Delete a stock from Firebase
  Future<void> deleteStock(String stockId) async {
    try {
      await _firestore.collection(_collection).doc(stockId).delete();
    } catch (e) {
      throw Exception('Failed to delete stock: $e');
    }
  }
}
