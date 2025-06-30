import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/stock.dart';
import '../repositories/stock_repository.dart';

/// Use case to update an existing stock item
class UpdateStock {
  final StockRepository repository;

  UpdateStock(this.repository);

  /// Execute the use case
  Future<Either<Failure, void>> call(Stock stock) async {
    try {
      await repository.updateStock(stock);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
