import '../entities/client.dart';
import '../repositories/client_repository.dart';

/// Use case for adding a new client
class AddClient {
  final ClientRepository repository;

  AddClient(this.repository);

  /// Execute the use case and return the generated client ID
  Future<String> call(Client client) async {
    return await repository.addClient(client);
  }
}
