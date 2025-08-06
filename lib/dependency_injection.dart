// dependency_injection.dart
import 'package:excel_mind_tasks/presentation/providers/theme_provider.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import 'core/network/api_client.dart';
import 'core/services/navigation_service.dart';
import 'core/services/dialog_service.dart';
import 'core/services/storage_service.dart';

// import 'data/datasources/local/todo_local_datasource.dart';
// import 'data/datasources/remote/auth_remote_datasource.dart';
// import 'data/datasources/remote/todo_remote_datasource.dart';
import 'data/datasources/remote/auth_remote_data_source.dart';
import 'data/repositories/auth_repository_impl.dart';
// import 'data/repositories/todo_repository_impl.dart';

import 'domain/repositories/auth_repository.dart';
// import 'domain/repositories/todo_repository.dart';
// import 'domain/usecases/auth/login_usecase.dart';
// import 'domain/usecases/auth/register_usecase.dart';
// import 'domain/usecases/todo/get_todos_usecase.dart';
// import 'domain/usecases/todo/create_todo_usecase.dart';
// import 'domain/usecases/todo/update_todo_usecase.dart';

import 'domain/usecases/authenticate_user.dart';
import 'presentation/providers/auth_provider.dart';
// import 'presentation/providers/todo_provider.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  final database = await openDatabase('todo_database.db', version: 1);

  getIt.registerLazySingleton(() => sharedPreferences);
  getIt.registerLazySingleton(() => database);
  getIt.registerLazySingleton(() => Dio());

  // Core
  getIt.registerLazySingleton(() => ApiClient(getIt()));
  getIt.registerLazySingleton(() => NavigationService());
  getIt.registerLazySingleton(() => DialogService());
  getIt.registerLazySingleton(() => StorageService(getIt()));

  // Data sources
  getIt.registerLazySingleton<AuthRemoteDataSource>(
        () => AuthRemoteDataSourceImpl(getIt(), getIt()),
  );
  // getIt.registerLazySingleton<TodoRemoteDataSource>(
  //       () => TodoRemoteDataSourceImpl(getIt()),
  // );
  // getIt.registerLazySingleton<TodoLocalDataSource>(
  //       () => TodoLocalDataSourceImpl(getIt()),
  // );

  // Repositories
  getIt.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(getIt(), getIt()),
  );
  // getIt.registerLazySingleton<TodoRepository>(
  //       () => TodoRepositoryImpl(getIt(), getIt()),
  // );

  // Use cases
  getIt.registerLazySingleton(() => LoginUseCase(getIt()));
  getIt.registerLazySingleton(() => RegisterUseCase(getIt()));
  // getIt.registerLazySingleton(() => GetTodosUseCase(getIt()));
  // getIt.registerLazySingleton(() => CreateTodoUseCase(getIt()));
  // getIt.registerLazySingleton(() => UpdateTodoUseCase(getIt()));

  // Providers
  getIt.registerLazySingleton<AuthProvider>(() => AuthProvider(
    loginUseCase: getIt(),
    registerUseCase: getIt(),
    navigationService: getIt(),
    dialogService: getIt(),
    storageService: getIt(),
  ));
  // getIt.registerFactory(() => AuthProvider(
  //   // loginUseCase: getIt(),
  //   // registerUseCase: getIt(),
  //   navigationService: getIt(),
  //   dialogService: getIt(),
  //   storageService: getIt(),
  // ));

  // getIt.registerFactory(() => TodoProvider(
  //   getTodosUseCase: getIt(),
  //   createTodoUseCase: getIt(),
  //   updateTodoUseCase: getIt(),
  //   dialogService: getIt(),
  // ));

  getIt.registerLazySingleton(() => ThemeProvider());
  // getIt.registerFactory(() => ThemeProvider());

}