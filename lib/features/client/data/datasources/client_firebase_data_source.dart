import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/services/firebase_service.dart';
import '../models/client_model.dart';

/// Firebase data source for client operations
class ClientFirebaseDataSource {
  final FirebaseFirestore _firestore = FirebaseService.firestore;
  final String _collection = 'clients';

  /// Get all clients from Firebase
  Future<List<ClientModel>> getClients() async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection(_collection)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map(
            (doc) => ClientModel.fromJson({
              'id': doc.id,
              ...doc.data() as Map<String, dynamic>,
            }),
          )
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch clients: $e');
    }
  }

  /// Get a specific client by ID
  Future<ClientModel?> getClient(String id) async {
    try {
      final DocumentSnapshot doc = await _firestore
          .collection(_collection)
          .doc(id)
          .get();

      if (doc.exists) {
        return ClientModel.fromJson({
          'id': doc.id,
          ...doc.data() as Map<String, dynamic>,
        });
      }
      return null;
    } catch (e) {
      throw Exception('Failed to fetch client: $e');
    }
  }

  /// Add a new client to Firebase and return the generated ID
  Future<String> addClient(ClientModel client) async {
    try {
      // Remove the id from the data since Firestore will generate it
      final data = client.toJson();
      data.remove('id');

      final docRef = await _firestore.collection(_collection).add(data);
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to add client: $e');
    }
  }

  /// Update an existing client in Firebase
  Future<void> updateClient(ClientModel client) async {
    try {
      final data = client.toJson();
      data.remove('id'); // Remove id from update data

      await _firestore.collection(_collection).doc(client.id).update(data);
    } catch (e) {
      throw Exception('Failed to update client: $e');
    }
  }

  /// Delete a client from Firebase
  Future<void> deleteClient(String clientId) async {
    try {
      await _firestore.collection(_collection).doc(clientId).delete();
    } catch (e) {
      throw Exception('Failed to delete client: $e');
    }
  }

  /// Search clients by name or mobile number
  Future<List<ClientModel>> searchClients(String query) async {
    try {
      if (query.trim().isEmpty) {
        return await getClients();
      }

      final QuerySnapshot snapshot = await _firestore
          .collection(_collection)
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThan: '$query\uf8ff')
          .get();

      final mobileSnapshot = await _firestore
          .collection(_collection)
          .where('mobileNumber', isGreaterThanOrEqualTo: query)
          .where('mobileNumber', isLessThan: '$query\uf8ff')
          .get();

      final Set<String> seenIds = {};
      final List<ClientModel> results = [];

      // Add name matches
      for (final doc in snapshot.docs) {
        if (!seenIds.contains(doc.id)) {
          seenIds.add(doc.id);
          results.add(
            ClientModel.fromJson({
              'id': doc.id,
              ...doc.data() as Map<String, dynamic>,
            }),
          );
        }
      }

      // Add mobile number matches
      for (final doc in mobileSnapshot.docs) {
        if (!seenIds.contains(doc.id)) {
          seenIds.add(doc.id);
          results.add(ClientModel.fromJson({'id': doc.id, ...doc.data()}));
        }
      }

      return results;
    } catch (e) {
      throw Exception('Failed to search clients: $e');
    }
  }
}
