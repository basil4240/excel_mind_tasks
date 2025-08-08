import 'package:flutter/foundation.dart';
import '../../core/utils/paginated_result.dart';
import '../../domain/entities/project.dart';
import '../../domain/usecases/projects/create_project.dart';
import '../../domain/usecases/projects/delete_project.dart';
import '../../domain/usecases/projects/get_projects.dart';
import '../../domain/usecases/projects/search_projects.dart';
import '../../domain/usecases/projects/update_project.dart';

class ProjectProvider with ChangeNotifier {
  final CreateProjectUseCase _createProjectUseCase;
  final GetProjectsUseCase _getProjectsUseCase;
  final SearchProjectsUseCase _searchProjectsUseCase;
  final UpdateProjectUseCase _updateProjectUseCase;
  final DeleteProjectUseCase _deleteProjectUseCase;

  ProjectProvider({
    required CreateProjectUseCase createProjectUseCase,
    required GetProjectsUseCase getProjectsUseCase,
    required SearchProjectsUseCase searchProjectsUseCase,
    required UpdateProjectUseCase updateProjectUseCase,
    required DeleteProjectUseCase deleteProjectUseCase,
  }) : _createProjectUseCase = createProjectUseCase,
       _getProjectsUseCase = getProjectsUseCase,
       _searchProjectsUseCase = searchProjectsUseCase,
       _updateProjectUseCase = updateProjectUseCase,
       _deleteProjectUseCase = deleteProjectUseCase;

  List<Project> _allProjects = <Project>[];

  List<Project> get allProjects => _allProjects;

  PaginatedResult<Project>? _projects;
  bool _isLoading = false;
  String? _errorMessage;
  String _searchQuery = '';
  int _currentPage = 1;
  final int _pageSize = 10;

  PaginatedResult<Project>? get projects => _projects;

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  String get searchQuery => _searchQuery;

  bool get hasMore => _projects?.hasMore ?? false;

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  Future<void> loadProjects({bool refresh = false}) async {
    if (refresh) {
      _currentPage = 1;
      _projects = null;
    }

    _setLoading(true);
    _setError(null);

    final result =
        _searchQuery.isEmpty
            ? await _getProjectsUseCase(page: _currentPage, pageSize: _pageSize)
            : await _searchProjectsUseCase(
              _searchQuery,
              page: _currentPage,
              pageSize: _pageSize,
            );

    result.fold((failure) => _setError(failure.message), (projects) {
      if (_currentPage == 1) {
        _projects = projects;
      } else {
        _projects = PaginatedResult<Project>(
          items: [...(_projects?.items ?? []), ...projects.items],
          page: projects.page,
          pageSize: projects.pageSize,
          totalCount: projects.totalCount,
        );
      }
      _currentPage++;
    });

    _setLoading(false);
  }

  Future<void> loadAllProjects({bool refresh = false}) async {
    if (refresh) {
      _currentPage = 1;
      _allProjects = [];
    }

    _setLoading(true);
    _setError(null);

    final result = await _getProjectsUseCase(page: 1, pageSize: 400);

    result.fold((failure) => _setError(failure.message), (projects) {
      _allProjects = projects.items;
    });

    _setLoading(false);
  }

  Future<void> searchProjects(String query) async {
    _searchQuery = query;
    _currentPage = 1;
    _projects = null;
    await loadProjects();
  }

  Future<void> loadMore() async {
    if (!hasMore || _isLoading) return;
    await loadProjects();
  }

  Future<bool> createProject(Project project) async {
    _setLoading(true);
    _setError(null);

    final result = await _createProjectUseCase(project);

    _setLoading(false);

    return result.fold(
      (failure) {
        _setError(failure.message);
        return false;
      },
      (createdProject) {
        if (_projects != null) {
          _projects = PaginatedResult<Project>(
            items: [createdProject, ..._projects!.items],
            page: _projects!.page,
            pageSize: _projects!.pageSize,
            totalCount: _projects!.totalCount + 1,
          );
          notifyListeners();
        }
        return true;
      },
    );
  }

  Future<bool> updateProject(Project project) async {
    _setLoading(true);
    _setError(null);

    final result = await _updateProjectUseCase(project);

    _setLoading(false);

    return result.fold(
      (failure) {
        _setError(failure.message);
        return false;
      },
      (updatedProject) {
        if (_projects != null) {
          final updatedItems =
              _projects!.items
                  .map((p) => p.id == updatedProject.id ? updatedProject : p)
                  .toList();

          _projects = PaginatedResult<Project>(
            items: updatedItems,
            page: _projects!.page,
            pageSize: _projects!.pageSize,
            totalCount: _projects!.totalCount,
          );
          notifyListeners();
        }
        return true;
      },
    );
  }

  Future<bool> deleteProject(int id) async {
    _setLoading(true);
    _setError(null);

    final result = await _deleteProjectUseCase(id);

    _setLoading(false);

    return result.fold(
      (failure) {
        _setError(failure.message);
        return false;
      },
      (_) {
        if (_projects != null) {
          final filteredItems =
              _projects!.items.where((p) => p.id != id).toList();

          _projects = PaginatedResult<Project>(
            items: filteredItems,
            page: _projects!.page,
            pageSize: _projects!.pageSize,
            totalCount: _projects!.totalCount - 1,
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
}
