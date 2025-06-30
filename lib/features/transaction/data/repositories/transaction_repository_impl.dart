import '../../domain/entities/transaction.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../datasources/transaction_firebase_data_source.dart';
import '../models/transaction_model.dart';

/// Implementation of TransactionRepository
class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionFirebaseDataSource firebaseDataSource;

  TransactionRepositoryImpl({required this.firebaseDataSource});

  @override
  Future<List<Transaction>> getTransactionsForClient(String clientId) async {
    try {
      final transactionModels = await firebaseDataSource
          .getTransactionsForClient(clientId);
      return transactionModels.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to get transactions for client: $e');
    }
  }

  @override
  Future<Transaction?> getTransaction(String id) async {
    try {
      final transactionModel = await firebaseDataSource.getTransaction(id);
      return transactionModel?.toEntity();
    } catch (e) {
      throw Exception('Failed to get transaction: $e');
    }
  }

  @override
  Future<String> addTransaction(Transaction transaction) async {
    try {
      final transactionModel = TransactionModel.fromEntity(transaction);
      return await firebaseDataSource.addTransaction(transactionModel);
    } catch (e) {
      throw Exception('Failed to add transaction: $e');
    }
  }

  @override
  Future<void> updateTransaction(Transaction transaction) async {
    try {
      final transactionModel = TransactionModel.fromEntity(transaction);
      await firebaseDataSource.updateTransaction(transactionModel);
    } catch (e) {
      throw Exception('Failed to update transaction: $e');
    }
  }

  @override
  Future<void> deleteTransaction(String transactionId) async {
    try {
      await firebaseDataSource.deleteTransaction(transactionId);
    } catch (e) {
      throw Exception('Failed to delete transaction: $e');
    }
  }

  @override
  Future<List<Transaction>> getAllTransactions() async {
    try {
      final transactionModels = await firebaseDataSource.getAllTransactions();
      return transactionModels.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to get all transactions: $e');
    }
  }

  @override
  Future<List<Transaction>> getTransactionsByDateRange(
    String clientId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final transactionModels = await firebaseDataSource
          .getTransactionsByDateRange(clientId, startDate, endDate);
      return transactionModels.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to get transactions by date range: $e');
    }
  }
}
