// import 'package:dartz/dartz.dart';
//
// import 'package:excel_mind_tasks/core/errors/failures.dart';
//
// import 'package:excel_mind_tasks/core/types.dart';
//
// import '../../core/enums/sync_status.dart';
// import '../../domain/entities/project.dart';
// import '../../domain/repositories/project_repository.dart';
// import '../datasources/local/project_local_data_source.dart';
// import '../models/project_model.dart';
//
// class ProjectRepositoryImpl implements ProjectRepository {
//   final ProjectLocalDataSource _localDataSource;
//
//   ProjectRepositoryImpl({
//     required ProjectLocalDataSource localDataSource,
//   }) : _localDataSource = localDataSource;
//
//   @override
//   Future<Either<Failure, Project>> createProject(CreateProjectData createProjectData) async {
//
//     final project = await _localDataSource.createProject(ProjectModel(id: id, name: name, createdAt: createdAt, updatedAt: updatedAt, startedAt: startedAt, endedAt: endedAt));
//
//   }
//
//   // @override
//   // Future<Project> createProject(Project project) async {
//   //   final projectModel = ProjectModel.fromEntity(project);
//   //   return await _localDataSource.createProject(projectModel);
//   // }
//
//   @override
//   Future<void> updateProject(Project project) async {
//     final projectModel = ProjectModel.fromEntity(project.copyWith(
//       syncStatus: SyncStatus.pending,
//     ));
//     await _localDataSource.updateProject(projectModel);
//   }
//
//   @override
//   Future<void> deleteProject(String id) async {
//     // Mark as pending delete instead of immediate deletion
//     final project = await _localDataSource.getProjectById(id);
//     if (project != null) {
//       final updatedProject = ProjectModel.fromEntity(project.copyWith(
//         syncStatus: SyncStatus.deleted,
//       ));
//       await _localDataSource.updateProject(updatedProject);
//     }
//   }
//
//   @override
//   Future<Project?> getProjectById(String id) async {
//     return await _localDataSource.getProjectById(id);
//   }
//
//   @override
//   Future<List<Project>> getProjects({int limit = 20, int offset = 0}) async {
//     final projects = await _localDataSource.getProjects(limit: limit, offset: offset);
//     // Filter out projects marked for deletion
//     return projects.where((p) => p.syncStatus != SyncStatus.pendingDelete).toList();
//   }
//
//   @override
//   Future<List<Project>> searchProjects(String query, {int limit = 20, int offset = 0}) async {
//     final projects = await _localDataSource.searchProjects(query, limit: limit, offset: offset);
//     return projects.where((p) => p.syncStatus != SyncStatus.pendingDelete).toList();
//   }
//
//   @override
//   Future<int> getProjectsCount() async {
//     return await _localDataSource.getProjectsCount();
//   }
//
//   @override
//   Future<int> getSearchProjectsCount(String query) async {
//     return await _localDataSource.getSearchProjectsCount(query);
//   }
//
//
// }