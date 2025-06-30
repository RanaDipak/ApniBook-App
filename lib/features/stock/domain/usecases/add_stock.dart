import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/stock.dart';
import '../repositories/stock_repository.dart';

/// Use case to add a new stock item
class AddStock {
  final StockRepository repository;

  AddStock(this.repository);

  /// Execute the use case
  Future<Either<Failure, String>> call(Stock stock) async {
    try {
      final id = await repository.addStock(stock);
      return Right(id);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
