import '../entities/transaction.dart';
import '../repositories/transaction_repository.dart';

/// Use case for adding a new transaction
class AddTransaction {
  final TransactionRepository repository;

  AddTransaction(this.repository);

  /// Execute the use case
  /// Returns the generated transaction ID
  Future<String> call(Transaction transaction) async {
    return await repository.addTransaction(transaction);
  }
}
