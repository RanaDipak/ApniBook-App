import '../../domain/entities/client.dart';
import '../../domain/repositories/client_repository.dart';
import '../datasources/client_firebase_data_source.dart';
import '../models/client_model.dart';

/// Implementation of ClientRepository
class ClientRepositoryImpl implements ClientRepository {
  final ClientFirebaseDataSource firebaseDataSource;

  ClientRepositoryImpl({required this.firebaseDataSource});

  @override
  Future<List<Client>> getClients() async {
    try {
      final clientModels = await firebaseDataSource.getClients();
      return clientModels.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to get clients: $e');
    }
  }

  @override
  Future<Client?> getClient(String id) async {
    try {
      final clientModel = await firebaseDataSource.getClient(id);
      return clientModel?.toEntity();
    } catch (e) {
      throw Exception('Failed to get client: $e');
    }
  }

  @override
  Future<String> addClient(Client client) async {
    try {
      final clientModel = ClientModel.fromEntity(client);
      return await firebaseDataSource.addClient(clientModel);
    } catch (e) {
      throw Exception('Failed to add client: $e');
    }
  }

  @override
  Future<void> updateClient(Client client) async {
    try {
      final clientModel = ClientModel.fromEntity(client);
      await firebaseDataSource.updateClient(clientModel);
    } catch (e) {
      throw Exception('Failed to update client: $e');
    }
  }

  @override
  Future<void> deleteClient(String id) async {
    try {
      await firebaseDataSource.deleteClient(id);
    } catch (e) {
      throw Exception('Failed to delete client: $e');
    }
  }

  @override
  /// Search clients by name or mobile number
  Future<List<Client>> searchClients(String query) async {
    try {
      final clientModels = await firebaseDataSource.searchClients(query);
      return clientModels.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to search clients: $e');
    }
  }
}
