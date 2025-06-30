import '../entities/transaction.dart';
import '../repositories/transaction_repository.dart';

/// Use case for getting transactions for a specific client
class GetTransactionsForClient {
  final TransactionRepository repository;

  GetTransactionsForClient(this.repository);

  /// Execute the use case
  /// Returns list of transactions for the specified client
  Future<List<Transaction>> call(String clientId) async {
    return await repository.getTransactionsForClient(clientId);
  }
}
