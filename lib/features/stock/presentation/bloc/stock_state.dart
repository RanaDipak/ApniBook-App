import 'package:equatable/equatable.dart';

import '../../domain/entities/stock.dart';

/// States for StockBloc
abstract class StockState extends Equatable {
  const StockState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class StockInitial extends StockState {
  const StockInitial();
}

/// Loading state
class StockLoading extends StockState {
  const StockLoading();
}

/// Loaded state with stocks
class StockLoaded extends StockState {
  final List<Stock> stocks;
  final double totalInventoryValue;

  const StockLoaded({
    required this.stocks,
    required this.totalInventoryValue,
  });

  @override
  List<Object?> get props => [stocks, totalInventoryValue];

  /// Create a copy with updated stocks
  StockLoaded copyWith({
    List<Stock>? stocks,
    double? totalInventoryValue,
  }) {
    return StockLoaded(
      stocks: stocks ?? this.stocks,
      totalInventoryValue: totalInventoryValue ?? this.totalInventoryValue,
    );
  }
}

/// Error state
class StockError extends StockState {
  final String message;

  const StockError({required this.message});

  @override
  List<Object?> get props => [message];
}

/// Success state for operations
class StockSuccess extends StockState {
  final String message;

  const StockSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}
