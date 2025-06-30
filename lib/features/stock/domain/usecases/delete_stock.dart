import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../repositories/stock_repository.dart';

/// Use case to delete a stock item
class DeleteStock {
  final StockRepository repository;

  DeleteStock(this.repository);

  /// Execute the use case
  Future<Either<Failure, void>> call(String id) async {
    try {
      await repository.deleteStock(id);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
