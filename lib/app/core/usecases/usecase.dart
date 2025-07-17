import 'package:bhoomi_sakti/app/core/error/app_failures.dart';
import 'package:fpdart/fpdart.dart';
import 'package:equatable/equatable.dart';

/// Base use case interface for synchronous operations
abstract class UseCase<Type, Params> {
  /// Executes the use case
  ///
  /// Returns [Either] a [Failure] or the result of type [Type]
  Either<Failure, Type> call(Params params);
}

/// Base use case interface for asynchronous operations
abstract class FutureUseCase<Type, Params> {
  /// Executes the use case asynchronously
  ///
  /// Returns a [Future] that resolves to [Either] a [Failure] or the result of type [Type]
  Future<Either<Failure, Type>> call(Params params);
}

/// A use case that doesn't take any parameters
class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}
