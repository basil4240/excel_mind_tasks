import 'package:dartz/dartz.dart';
import 'package:excel_mind_tasks/core/types.dart';

import '../../../core/errors/failures.dart';
import '../../entities/project.dart';
import '../../repositories/project_repository.dart';

class UpdateProject {
  final ProjectRepository repository;

  UpdateProject(this.repository);

  Future<Either<Failure, Project>> call(UpdateProjectData updateProjectData) async {
    return await repository.updateProject(updateProjectData);
  }
}