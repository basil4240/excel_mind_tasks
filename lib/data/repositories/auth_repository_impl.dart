import 'package:dartz/dartz.dart';
import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../core/services/storage_service.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/remote/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final StorageService storageService;

  AuthRepositoryImpl(this.remoteDataSource, this.storageService);

  @override
  Future<Either<Failure, User>> login(String email, String password) async {
    try {

      final user = await remoteDataSource.login(email, password);

      /// Save user tokens to local storage
      await storageService.saveString('access_token', user.id);
      await storageService.saveString('refresh_token', user.id);

      return Right(user);
    } on BadRequestException catch (e) {
      return Left(ValidationFailure(e.message));
    } on UnauthorizedException catch (e) {
      return Left(ValidationFailure('Invalid credentials'));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on NotFoundException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await remoteDataSource.logout();

      // clear local storage
      await storageService.remove('access_token');
      await storageService.remove('refresh_token');
      return Right(null);
    } catch (e) {
      return Left(ServerFailure('Logout failed'));
    }
  }

  @override
  Future<Either<Failure, User>> register(String email, String password, String name) async {
    try {

      final user = await remoteDataSource.register(email, password, name);

      /// Save user tokens to local storage
      await storageService.saveString('access_token', user.id);
      await storageService.saveString('refresh_token', user.id);

      return Right(user);
    } on BadRequestException catch (e) {
      return Left(ValidationFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on NotFoundException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred'));
    }
  }

}
