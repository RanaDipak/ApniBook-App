import '../entities/client.dart';
import '../repositories/client_repository.dart';

/// Use case for searching clients
class SearchClients {
  final ClientRepository repository;

  SearchClients(this.repository);

  /// Execute the use case
  Future<List<Client>> call(String query) async {
    return await repository.searchClients(query);
  }
}
