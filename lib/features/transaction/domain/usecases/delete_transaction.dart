import '../repositories/transaction_repository.dart';

/// Use case for deleting a transaction
class DeleteTransaction {
  final TransactionRepository repository;

  DeleteTransaction(this.repository);

  /// Execute the use case
  /// Deletes the transaction with the specified ID
  Future<void> call(String transactionId) async {
    await repository.deleteTransaction(transactionId);
  }
}
