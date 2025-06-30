import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/stock.dart';
import '../../domain/usecases/add_stock.dart' as add_stock_usecase;
import '../../domain/usecases/delete_stock.dart' as delete_stock_usecase;
import '../../domain/usecases/get_stocks.dart';
import '../../domain/usecases/get_total_inventory_value.dart';
import '../../domain/usecases/update_stock.dart' as update_stock_usecase;
import 'stock_event.dart';
import 'stock_state.dart';

/// Bloc for managing stock state
class StockBloc extends Bloc<StockEvent, StockState> {
  final GetStocks getStocks;
  final add_stock_usecase.AddStock addStock;
  final update_stock_usecase.UpdateStock updateStock;
  final delete_stock_usecase.DeleteStock deleteStock;
  final GetTotalInventoryValue getTotalInventoryValue;

  StockBloc({
    required this.getStocks,
    required this.addStock,
    required this.updateStock,
    required this.deleteStock,
    required this.getTotalInventoryValue,
  }) : super(const StockInitial()) {
    on<LoadStocks>(_onLoadStocks);
    on<AddStock>(_onAddStock);
    on<UpdateStock>(_onUpdateStock);
    on<DeleteStock>(_onDeleteStock);
    on<RefreshStocks>(_onRefreshStocks);
  }

  /// Handle LoadStocks event
  Future<void> _onLoadStocks(LoadStocks event, Emitter<StockState> emit) async {
    emit(const StockLoading());

    final result = await getStocks();
    await result.fold(
      (failure) async {
        emit(StockError(message: failure.message));
      },
      (stocks) async {
        final totalValue = await getTotalInventoryValue();
        totalValue.fold(
          (failure) => emit(StockError(message: failure.message)),
          (value) =>
              emit(StockLoaded(stocks: stocks, totalInventoryValue: value)),
        );
      },
    );
  }

  /// Handle AddStock event
  Future<void> _onAddStock(AddStock event, Emitter<StockState> emit) async {
    final stock = Stock(
      id: '', // Firebase will generate the ID
      productName: event.productName,
      quantity: event.quantity,
      pricePerUnit: event.pricePerUnit,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final result = await addStock(stock);
    result.fold((failure) => emit(StockError(message: failure.message)), (id) {
      emit(const StockSuccess(message: 'Stock added successfully'));
      add(const LoadStocks());
    });
  }

  /// Handle UpdateStock event
  Future<void> _onUpdateStock(
    UpdateStock event,
    Emitter<StockState> emit,
  ) async {
    final stock = Stock(
      id: event.id,
      productName: event.productName,
      quantity: event.quantity,
      pricePerUnit: event.pricePerUnit,
      createdAt: DateTime.now(), // This should be preserved from original
      updatedAt: DateTime.now(),
    );

    final result = await updateStock(stock);
    result.fold((failure) => emit(StockError(message: failure.message)), (_) {
      emit(const StockSuccess(message: 'Stock updated successfully'));
      add(const LoadStocks());
    });
  }

  /// Handle DeleteStock event
  Future<void> _onDeleteStock(
    DeleteStock event,
    Emitter<StockState> emit,
  ) async {
    final result = await deleteStock(event.id);
    result.fold((failure) => emit(StockError(message: failure.message)), (_) {
      emit(const StockSuccess(message: 'Stock deleted successfully'));
      add(const LoadStocks());
    });
  }

  /// Handle RefreshStocks event
  Future<void> _onRefreshStocks(
    RefreshStocks event,
    Emitter<StockState> emit,
  ) async {
    add(const LoadStocks());
  }
}
