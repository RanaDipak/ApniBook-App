import '../entities/client.dart';
import '../repositories/client_repository.dart';

/// Use case for updating an existing client
class UpdateClient {
  final ClientRepository repository;

  UpdateClient(this.repository);

  /// Execute the use case
  Future<void> call(Client client) async {
    await repository.updateClient(client);
  }
}
