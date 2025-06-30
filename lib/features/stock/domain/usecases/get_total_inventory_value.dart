import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../repositories/stock_repository.dart';

/// Use case to get total inventory value
class GetTotalInventoryValue {
  final StockRepository repository;

  GetTotalInventoryValue(this.repository);

  /// Execute the use case
  Future<Either<Failure, double>> call() async {
    try {
      final totalValue = await repository.getTotalInventoryValue();
      return Right(totalValue);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
