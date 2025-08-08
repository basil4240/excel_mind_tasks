import 'package:excel_mind_tasks/core/errors/exceptions.dart';
import 'package:excel_mind_tasks/data/models/user_model.dart';
import 'package:excel_mind_tasks/data/models/user_persisting_model.dart';
import 'package:excel_mind_tasks/presentation/views/auth/login_view.dart';
import 'package:excel_mind_tasks/presentation/views/main_view.dart';
import 'package:flutter/foundation.dart';
import '../../core/services/dialog_service.dart';
import '../../core/services/navigation_service.dart';
import '../../core/services/storage_service.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/authenticate_user.dart';

class AuthProvider extends ChangeNotifier {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final NavigationService navigationService;
  final DialogService dialogService;
  final StorageService storageService;

  AuthProvider({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.navigationService,
    required this.dialogService,
    required this.storageService,
  }) {
    _checkAuthStatus();
  }

  User? _user;
  UserPersistingModel? _userPersistingModel;
  bool _isLoading = false;
  bool _isAuthenticated = false;

  UserPersistingModel? get userPersistingModel => _userPersistingModel;

  User? get user => _user;

  bool get isLoading => _isLoading;

  bool get isAuthenticated => _isAuthenticated;

  void _checkAuthStatus() {
    _isAuthenticated = storageService.getString('access_token') != null;
    notifyListeners();
  }

  Future<void> updateUser(UserPersistingModel userPersistingModel) async {
    _userPersistingModel = userPersistingModel;

    // save to local storage
    await storageService.saveUser(
      userPersistingModel.email,
      userPersistingModel,
    );
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    _setLoading(true);

    final result = await loginUseCase(email, password);
    result.fold(
      (failure) {
        dialogService.showErrorDialog('Login Failed', failure.message);
      },
      (user) {
        _userPersistingModel = storageService.getUser(_user!.email);
        _user = user;
        _isAuthenticated = true;
        dialogService.showSnackBar('Login successful!');
        navigationService.replace(MainView());
      },
    );

    _setLoading(false);
  }

  Future<void> register(String email, String password, String name) async {
    _setLoading(true);

    final result = await registerUseCase(email, password, name);
    result.fold(
      (failure) {
        dialogService.showErrorDialog('Registration Failed', failure.message);
      },
      (user) {
        _setLoading(false);
        _user = user;
        _userPersistingModel = storageService.getUser(_user!.email);
        _user = user;
        _isAuthenticated = true;
        dialogService.showSnackBar('Registration successful!');
        navigationService.replace(MainView());
      },
    );

    _setLoading(false);
  }

  Future<void> logout() async {
    _user = null;
    _isAuthenticated = false;
    await storageService.clear();
    dialogService.showSnackBar('Logged out successfully');
    navigationService.navigateToPageAndClearStack(LoginView());
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
