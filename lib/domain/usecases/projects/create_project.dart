import 'package:dartz/dartz.dart';

import '../../../core/errors/failures.dart';
import '../../../core/types.dart';
import '../../entities/project.dart';
import '../../repositories/project_repository.dart';

class CreateProjectUseCase {
  final ProjectRepository repository;

  CreateProjectUseCase(this.repository);

  Future<Either<Failure, Project>> call(CreateProjectData createProjectData) async {
    return await repository.createProject(createProjectData );
  }
}
