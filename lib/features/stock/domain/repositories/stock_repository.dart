import '../entities/stock.dart';

/// Repository interface for stock operations
abstract class StockRepository {
  /// Get all stock items
  Future<List<Stock>> getStocks();

  /// Get a specific stock item by ID
  Future<Stock?> getStock(String id);

  /// Add a new stock item and return the generated ID
  Future<String> addStock(Stock stock);

  /// Update an existing stock item
  Future<void> updateStock(Stock stock);

  /// Delete a stock item
  Future<void> deleteStock(String id);

  /// Get total inventory value
  Future<double> getTotalInventoryValue();
}
