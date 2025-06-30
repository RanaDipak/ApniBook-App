import '../entities/client.dart';

/// Repository interface for client operations
abstract class ClientRepository {
  /// Get all clients
  Future<List<Client>> getClients();

  /// Get a specific client by ID
  Future<Client?> getClient(String id);

  /// Add a new client and return the generated ID
  Future<String> addClient(Client client);

  /// Update an existing client
  Future<void> updateClient(Client client);

  /// Delete a client
  Future<void> deleteClient(String id);

  /// Search clients by name or mobile number
  Future<List<Client>> searchClients(String query);
}
