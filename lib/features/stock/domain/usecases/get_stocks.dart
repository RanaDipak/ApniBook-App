import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/stock.dart';
import '../repositories/stock_repository.dart';

/// Use case to get all stock items
class GetStocks {
  final StockRepository repository;

  GetStocks(this.repository);

  /// Execute the use case
  Future<Either<Failure, List<Stock>>> call() async {
    try {
      final stocks = await repository.getStocks();
      return Right(stocks);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
