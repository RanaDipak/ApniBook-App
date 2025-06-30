import '../../domain/entities/stock.dart';
import '../../domain/repositories/stock_repository.dart';
import '../datasources/stock_firebase_data_source.dart';
import '../models/stock_model.dart';

/// Implementation of StockRepository
class StockRepositoryImpl implements StockRepository {
  final StockFirebaseDataSource firebaseDataSource;

  StockRepositoryImpl({required this.firebaseDataSource});

  @override
  Future<List<Stock>> getStocks() async {
    try {
      final stockModels = await firebaseDataSource.getStocks();
      return stockModels.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to get stocks: $e');
    }
  }

  @override
  Future<Stock?> getStock(String id) async {
    try {
      final stocks = await getStocks();
      return stocks.where((stock) => stock.id == id).firstOrNull;
    } catch (e) {
      throw Exception('Failed to get stock: $e');
    }
  }

  @override
  Future<String> addStock(Stock stock) async {
    try {
      final stockModel = StockModel.fromEntity(stock);
      return await firebaseDataSource.addStock(stockModel);
    } catch (e) {
      throw Exception('Failed to add stock: $e');
    }
  }

  @override
  Future<void> updateStock(Stock stock) async {
    try {
      final stockModel = StockModel.fromEntity(stock);
      await firebaseDataSource.updateStock(stockModel);
    } catch (e) {
      throw Exception('Failed to update stock: $e');
    }
  }

  @override
  Future<void> deleteStock(String id) async {
    try {
      await firebaseDataSource.deleteStock(id);
    } catch (e) {
      throw Exception('Failed to delete stock: $e');
    }
  }

  @override
  Future<double> getTotalInventoryValue() async {
    try {
      final stocks = await getStocks();
      double totalValue = 0.0;
      for (final stock in stocks) {
        totalValue += stock.totalValue;
      }
      return totalValue;
    } catch (e) {
      throw Exception('Failed to get total inventory value: $e');
    }
  }
}
