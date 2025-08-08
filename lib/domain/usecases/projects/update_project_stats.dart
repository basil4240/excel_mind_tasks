import 'package:dartz/dartz.dart';

import '../../../core/errors/failures.dart';
import '../../repositories/project_repository.dart';

class UpdateProjectStatsUseCase {
  final ProjectRepository repository;

  UpdateProjectStatsUseCase(this.repository);

  Future<Either<Failure, void>> call(int id) async {
    return await repository.updateProjectStats(id);
  }
}