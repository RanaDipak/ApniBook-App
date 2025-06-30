import '../models/client_model.dart';

/// Local data source for client operations
abstract class ClientLocalDataSource {
  /// Get all clients from local storage
  Future<List<ClientModel>> getClients();

  /// Get a specific client by ID
  Future<ClientModel?> getClient(String id);

  /// Add a new client to local storage
  Future<void> addClient(ClientModel client);

  /// Update an existing client
  Future<void> updateClient(ClientModel client);

  /// Delete a client
  Future<void> deleteClient(String id);
}

/// Implementation of local data source using in-memory storage
class ClientLocalDataSourceImpl implements ClientLocalDataSource {
  // In-memory storage for now (will be replaced with SharedPreferences or Hive later)
  static final List<ClientModel> _clients = [];

  @override
  Future<List<ClientModel>> getClients() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_clients);
  }

  @override
  Future<ClientModel?> getClient(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return _clients.firstWhere((client) => client.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> addClient(ClientModel client) async {
    await Future.delayed(const Duration(milliseconds: 400));
    _clients.add(client);
  }

  @override
  Future<void> updateClient(ClientModel client) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final index = _clients.indexWhere((c) => c.id == client.id);
    if (index != -1) {
      _clients[index] = client;
    }
  }

  @override
  Future<void> deleteClient(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _clients.removeWhere((client) => client.id == id);
  }
}
