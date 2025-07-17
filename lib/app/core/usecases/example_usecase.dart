import 'package:bhoomi_sakti/app/core/error/app_failures.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

import 'usecase.dart';

/// Example entity
class ExampleEntity extends Equatable {
  final String id;
  final String name;
  final String description;

  const ExampleEntity({
    required this.id,
    required this.name,
    required this.description,
  });

  @override
  List<Object> get props => [id, name, description];
}

/// Example parameters for the use case
class ExampleParams extends Equatable {
  final String id;
  final bool fetchDetails;

  const ExampleParams({required this.id, this.fetchDetails = false});

  @override
  List<Object> get props => [id, fetchDetails];
}

/// Example repository interface
abstract class ExampleRepository {
  Future<ExampleEntity> getExample(String id, {bool fetchDetails = false});
}

/// Example use case
class GetExampleUseCase implements FutureUseCase<ExampleEntity, ExampleParams> {
  final ExampleRepository repository;

  GetExampleUseCase(this.repository);

  @override
  Future<Either<Failure, ExampleEntity>> call(ExampleParams params) async {
    try {
      final example = await repository.getExample(
        params.id,
        fetchDetails: params.fetchDetails,
      );
      return Right(example);
    } on Exception catch (e) {
      return Left(ExceptionFailure.from(e));
    }
  }
}
