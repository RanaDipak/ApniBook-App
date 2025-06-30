import 'package:equatable/equatable.dart';

/// Events for StockBloc
abstract class StockEvent extends Equatable {
  const StockEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load all stocks
class LoadStocks extends StockEvent {
  const LoadStocks();
}

/// Event to add a new stock
class AddStock extends StockEvent {
  final String productName;
  final int quantity;
  final double pricePerUnit;

  const AddStock({
    required this.productName,
    required this.quantity,
    required this.pricePerUnit,
  });

  @override
  List<Object?> get props => [productName, quantity, pricePerUnit];
}

/// Event to update an existing stock
class UpdateStock extends StockEvent {
  final String id;
  final String productName;
  final int quantity;
  final double pricePerUnit;

  const UpdateStock({
    required this.id,
    required this.productName,
    required this.quantity,
    required this.pricePerUnit,
  });

  @override
  List<Object?> get props => [id, productName, quantity, pricePerUnit];
}

/// Event to delete a stock
class DeleteStock extends StockEvent {
  final String id;

  const DeleteStock({required this.id});

  @override
  List<Object?> get props => [id];
}

/// Event to refresh stocks
class RefreshStocks extends StockEvent {
  const RefreshStocks();
}
