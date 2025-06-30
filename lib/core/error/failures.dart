import 'package:dartz/dartz.dart';

/// Base failure class for all errors in the application
abstract class Failure {
  final String message;

  const Failure(this.message);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Failure && other.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}

/// Server-related failures
class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Server error occurred']);
}

/// Cache-related failures
class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Cache error occurred']);
}

/// Network-related failures
class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Network error occurred']);
}

/// Validation failures
class ValidationFailure extends Failure {
  const ValidationFailure([super.message = 'Validation failed']);
}

/// Extension to handle Either<Failure, T> consistently
extension EitherExtensions<L, R> on dynamic {
  R? getRight() {
    if (this is Right) {
      return (this as Right).value;
    }
    return null;
  }

  L? getLeft() {
    if (this is Left) {
      return (this as Left).value;
    }
    return null;
  }
}
