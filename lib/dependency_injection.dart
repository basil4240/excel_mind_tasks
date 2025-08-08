import 'package:excel_mind_tasks/presentation/providers/project_provider.dart';
import 'package:excel_mind_tasks/presentation/providers/task_provider.dart';
import 'package:excel_mind_tasks/presentation/providers/theme_provider.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import 'core/network/api_client.dart';
import 'core/services/navigation_service.dart';
import 'core/services/dialog_service.dart';
import 'core/services/storage_service.dart';
import 'data/datasources/local/database_helper.dart';
import 'data/datasources/local/project_local_data_source.dart';
import 'data/datasources/local/task_local_data_source.dart';
import 'data/datasources/remote/auth_remote_data_source.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'data/repositories/project_repository_impl.dart';
import 'data/repositories/task_repository_impl.dart';
import 'domain/repositories/auth_repository.dart';
import 'domain/repositories/project_repository.dart';
import 'domain/repositories/task_repository.dart';
import 'domain/usecases/authenticate_user.dart';
import 'domain/usecases/projects/create_project.dart';
import 'domain/usecases/projects/delete_project.dart';
import 'domain/usecases/projects/get_projects.dart';
import 'domain/usecases/projects/search_projects.dart';
import 'domain/usecases/projects/update_project.dart';
import 'domain/usecases/tasks/create_task.dart';
import 'domain/usecases/tasks/delete_task.dart';
import 'domain/usecases/tasks/get_tasks.dart';
import 'domain/usecases/tasks/search_tasks.dart';
import 'domain/usecases/tasks/update_task.dart';
import 'presentation/providers/auth_provider.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  final database = await openDatabase('todo_app.db', version: 1);

  getIt.registerLazySingleton(() => sharedPreferences);
  getIt.registerLazySingleton(() => database);
  getIt.registerLazySingleton(() => Dio());

  // Core
  final dbHelper = DatabaseHelper();
  await dbHelper.seedDatabaseManually();
  // await dbHelper.clearAndReseed();
  getIt.registerLazySingleton(() => dbHelper);
  getIt.registerLazySingleton(() => ApiClient(getIt()));
  getIt.registerLazySingleton(() => NavigationService());
  getIt.registerLazySingleton(() => DialogService());
  getIt.registerLazySingleton(() => StorageService(getIt()));

  // Data sources
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(getIt(), getIt()),
  );
  getIt.registerLazySingleton<ProjectLocalDataSource>(
    () => ProjectLocalDataSourceImpl(getIt()),
  );
  getIt.registerLazySingleton<TaskLocalDataSource>(
    () => TaskLocalDataSourceImpl(getIt()),
  );

  // Repositories
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(getIt(), getIt()),
  );
  getIt.registerLazySingleton<ProjectRepository>(
    () => ProjectRepositoryImpl(getIt()),
  );
  getIt.registerLazySingleton<TaskRepository>(
    () => TaskRepositoryImpl(getIt()),
  );

  // Use cases - Auth
  getIt.registerLazySingleton(() => LoginUseCase(getIt()));
  getIt.registerLazySingleton(() => RegisterUseCase(getIt()));

  // Use cases - Projects
  getIt.registerLazySingleton(() => CreateProjectUseCase(getIt()));
  getIt.registerLazySingleton(() => GetProjectsUseCase(getIt()));
  getIt.registerLazySingleton(() => SearchProjectsUseCase(getIt()));
  getIt.registerLazySingleton(() => UpdateProjectUseCase(getIt()));
  getIt.registerLazySingleton(() => DeleteProjectUseCase(getIt()));

  // Use cases - Tasks
  getIt.registerLazySingleton(() => CreateTaskUseCase(getIt()));
  getIt.registerLazySingleton(() => GetTasksUseCase(getIt()));
  getIt.registerLazySingleton(() => SearchTasksUseCase(getIt()));
  getIt.registerLazySingleton(() => UpdateTaskUseCase(getIt()));
  getIt.registerLazySingleton(() => DeleteTaskUseCase(getIt()));

  // Providers
  getIt.registerLazySingleton<AuthProvider>(
    () => AuthProvider(
      loginUseCase: getIt(),
      registerUseCase: getIt(),
      navigationService: getIt(),
      dialogService: getIt(),
      storageService: getIt(),
    ),
  );
  getIt.registerLazySingleton(() => ThemeProvider());
  getIt.registerFactory(
    () => ProjectProvider(
      createProjectUseCase: getIt(),
      getProjectsUseCase: getIt(),
      searchProjectsUseCase: getIt(),
      updateProjectUseCase: getIt(),
      deleteProjectUseCase: getIt(),
    ),
  );
  getIt.registerFactory(
    () => TaskProvider(
      createTaskUseCase: getIt(),
      getTasksUseCase: getIt(),
      searchTasksUseCase: getIt(),
      updateTaskUseCase: getIt(),
      deleteTaskUseCase: getIt(),
    ),
  );
}
