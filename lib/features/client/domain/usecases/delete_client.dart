import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../repositories/client_repository.dart';

class DeleteClient {
  final ClientRepository repository;

  DeleteClient(this.repository);

  Future<Either<Failure, Unit>> call(String clientId) async {
    try {
      await repository.deleteClient(clientId);
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure('Failed to delete client: $e'));
    }
  }
}
