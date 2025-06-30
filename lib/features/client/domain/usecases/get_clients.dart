import '../entities/client.dart';
import '../repositories/client_repository.dart';

/// Use case for getting all clients
class GetClients {
  final ClientRepository repository;

  GetClients(this.repository);

  /// Execute the use case
  Future<List<Client>> call() async {
    return await repository.getClients();
  }
}
