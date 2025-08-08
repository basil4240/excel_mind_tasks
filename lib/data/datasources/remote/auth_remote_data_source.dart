import 'package:excel_mind_tasks/core/errors/exceptions.dart';
import 'package:excel_mind_tasks/core/services/storage_service.dart';
import 'package:excel_mind_tasks/data/models/user_persisting_model.dart';

import '../../../core/network/api_client.dart';
import '../../../core/utils/helpers.dart';
import '../../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);

  Future<UserModel> register(String email, String password, String name);

  Future<void> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient;
  final StorageService storageService;

  AuthRemoteDataSourceImpl(this.apiClient, this.storageService);

  @override
  Future<UserModel> login(String email, String password) async {
    /// This is the actual api call
    // final response = await apiClient.post('/auth/login', data: {
    //   'email': email,
    //   'password': password,
    // });

    // Simulating API request by getting data from local storage
    await Future.delayed(const Duration(seconds: 3));
    var data = storageService.getUser(email);

    if (data == null || data.password != password) {
      throw NotFoundException('User Not found');
    }

    return data.toUserModel();
  }

  @override
  Future<UserModel> register(String email, String password, String name) async {
    /// This is the actual api call
    // final response = await apiClient.post('/auth/register', data: {
    //   'email': email,
    //   'password': password,
    //   'name': name,
    // });

    // Simulating API request by storing data from local storage
    await Future.delayed(const Duration(seconds: 3));

    // check if user exists and throw exception if exists
    var data = storageService.getUser(email);
    if(data != null) {
      throw BadRequestException('User already exists');
    }

    var userPersistingModel = UserPersistingModel(
      id: generateUserId,
      email: email,
      name: name,
      password: password,
      phone: '',
      bio: '',
      isDark: false
    );

    await storageService.saveUser(email, userPersistingModel);

    return userPersistingModel.toUserModel();
  }

  @override
  Future<void> logout() async {
    await apiClient.post('/auth/logout');
  }
}
