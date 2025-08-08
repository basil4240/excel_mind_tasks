import 'package:excel_mind_tasks/domain/usecases/tasks/create_task.dart';
import 'package:excel_mind_tasks/domain/usecases/tasks/delete_task.dart';
import 'package:excel_mind_tasks/domain/usecases/tasks/get_tasks.dart';
import 'package:excel_mind_tasks/domain/usecases/tasks/search_tasks.dart';
import 'package:excel_mind_tasks/domain/usecases/tasks/update_task.dart';
import 'package:flutter/foundation.dart';
import '../../core/utils/paginated_result.dart';
import '../../domain/entities/task.dart';

class TaskProvider with ChangeNotifier {
  final CreateTaskUseCase _createTaskUseCase;
  final GetTasksUseCase _getTasksUseCase;
  final SearchTasksUseCase _searchTasksUseCase;
  final UpdateTaskUseCase _updateTaskUseCase;
  final DeleteTaskUseCase _deleteTaskUseCase;

  TaskProvider({
    required CreateTaskUseCase createTaskUseCase,
    required GetTasksUseCase getTasksUseCase,
    required SearchTasksUseCase searchTasksUseCase,
    required UpdateTaskUseCase updateTaskUseCase,
    required DeleteTaskUseCase deleteTaskUseCase,
  }) : _createTaskUseCase = createTaskUseCase,
       _getTasksUseCase = getTasksUseCase,
       _searchTasksUseCase = searchTasksUseCase,
       _updateTaskUseCase = updateTaskUseCase,
       _deleteTaskUseCase = deleteTaskUseCase;

  PaginatedResult<Task>? _tasks;
  bool _isLoading = false;
  String? _errorMessage;
  String _searchQuery = '';
  int _currentPage = 1;
  final int _pageSize = 10;

  PaginatedResult<Task>? get tasks => _tasks;

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  String get searchQuery => _searchQuery;

  bool get hasMore => _tasks?.hasMore ?? false;

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  Future<void> loadTasks({bool refresh = false}) async {

    if (refresh) {
      _currentPage = 1;
      _tasks = null;
    }

    _setLoading(true);
    _setError(null);

    final result =
        _searchQuery.isEmpty
            ? await _getTasksUseCase(page: _currentPage, pageSize: _pageSize)
            : await _searchTasksUseCase(
              _searchQuery,
              page: _currentPage,
              pageSize: _pageSize,
            );

    result.fold((failure) => _setError(failure.message), (tasks) {
      if (_currentPage == 1) {
        _tasks = tasks;
      } else {
        _tasks = PaginatedResult<Task>(
          items: [...(_tasks?.items ?? []), ...tasks.items],
          page: tasks.page,
          pageSize: tasks.pageSize,
          totalCount: tasks.totalCount,
        );
      }
      _currentPage++;
    });

    _setLoading(false);
  }

  Future<void> searchTasks(String query) async {
    _searchQuery = query;
    _currentPage = 1;
    _tasks = null;
    await loadTasks();
  }

  Future<void> loadMore() async {
    if (!hasMore || _isLoading) return;
    await loadTasks();
  }

  Future<bool> createTask(Task task) async {
    _setLoading(true);
    _setError(null);

    final result = await _createTaskUseCase(task);

    _setLoading(false);

    return result.fold(
      (failure) {
        _setError(failure.message);
        return false;
      },
      (createdTask) {
        if (_tasks != null) {
          _tasks = PaginatedResult<Task>(
            items: [createdTask, ..._tasks!.items],
            page: _tasks!.page,
            pageSize: _tasks!.pageSize,
            totalCount: _tasks!.totalCount + 1,
          );
          notifyListeners();
        }
        return true;
      },
    );
  }

  Future<bool> updateTask(Task task) async {
    _setLoading(true);
    _setError(null);

    final result = await _updateTaskUseCase(task);

    _setLoading(false);

    return result.fold(
      (failure) {
        _setError(failure.message);
        return false;
      },
      (updatedTask) {
        if (_tasks != null) {
          final updatedItems =
              _tasks!.items
                  .map((t) => t.id == updatedTask.id ? updatedTask : t)
                  .toList();

          _tasks = PaginatedResult<Task>(
            items: updatedItems,
            page: _tasks!.page,
            pageSize: _tasks!.pageSize,
            totalCount: _tasks!.totalCount,
          );
          notifyListeners();
        }
        return true;
      },
    );
  }

  Future<bool> deleteTask(int id) async {
    _setLoading(true);
    _setError(null);

    final result = await _deleteTaskUseCase(id);

    _setLoading(false);

    return result.fold(
      (failure) {
        _setError(failure.message);
        return false;
      },
      (_) {
        if (_tasks != null) {
          final filteredItems = _tasks!.items.where((t) => t.id != id).toList();

          _tasks = PaginatedResult<Task>(
            items: filteredItems,
            page: _tasks!.page,
            pageSize: _tasks!.pageSize,
            totalCount: _tasks!.totalCount - 1,
          );
          notifyListeners();
        }
        return true;
      },
    );
  }

  void clearError() {
    _setError(null);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

}
