import '../entities/transaction.dart';

abstract class TransactionRepository {
  /// Get all transactions for a specific client
  Future<List<Transaction>> getTransactionsForClient(String clientId);

  /// Get a specific transaction by ID
  Future<Transaction?> getTransaction(String id);

  /// Add a new transaction and return the generated ID
  Future<String> addTransaction(Transaction transaction);

  /// Update an existing transaction
  Future<void> updateTransaction(Transaction transaction);

  /// Delete a transaction
  Future<void> deleteTransaction(String transactionId);

  /// Get all transactions (for admin purposes)
  Future<List<Transaction>> getAllTransactions();

  /// Get transactions within a date range for a client
  Future<List<Transaction>> getTransactionsByDateRange(
    String clientId,
    DateTime startDate,
    DateTime endDate,
  );
}
