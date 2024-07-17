import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:injectable/injectable.dart';
import 'package:quiz_app_flutter/base/network/errors/error.dart';
import 'package:quiz_app_flutter/base/network/errors/extension.dart';
import 'package:quiz_app_flutter/features/data/datasource/remote/auth_service/auth_service.dart';
import 'package:quiz_app_flutter/features/data/request/login_request/login_request.dart';
import 'package:quiz_app_flutter/features/data/request/register_request/register_request.dart';
import 'package:quiz_app_flutter/features/data/response/login_response/login_response.dart';
import 'package:quiz_app_flutter/features/domain/entity/user_entity.dart';
import 'package:quiz_app_flutter/features/domain/repository/auth_repository.dart';

@Injectable(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthService _service;

  AuthRepositoryImpl(this._service);

  @override
  Future<Either<BaseError, bool>> register({
    required RegisterRequest request,
  }) async {
    try {
      await _service.register(
        request: FormData.fromMap(request.toJson()),
      );
      return right(true);
    } on DioException catch (e) {
      return left(e.baseError);
    }
  }

  @override
  Future<Either<BaseError, LoginResponse>> signInWithEmailAndPassword({
    required LoginRequest request,
  }) async {
    try {
      final res = await _service.login(
        loginRequest: FormData.fromMap(request.toJson()),
      );
      if (res.data?.token == null) {
        return left(BaseError.httpUnknownError('error_system'.tr()));
      }
      return right(res.data!);
    } on DioException catch (e) {
      return left(e.baseError);
    }
  }

  @override
  Future<Either<BaseError, bool>> signOut() async {
    try {
      await _service.logout();
      return right(true);
    } on DioException catch (e) {
      return left(e.baseError);
    }
  }

  @override
  Future<Either<BaseError, UserEntity>> getUserInfo() async {
    try {
      final res = await _service.getUserInfo();
      if(res.data == null) {
        return left(BaseError.httpUnknownError('error_system'.tr()));
      } else {
        return right(UserEntity.fromModel(res.data!));
      }
    } on DioException catch (e) {
      return left(e.baseError);
    }
  }
}
