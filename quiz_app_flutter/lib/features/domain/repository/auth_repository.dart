import 'package:dartz/dartz.dart';
import 'package:quiz_app_flutter/base/network/errors/error.dart';
import 'package:quiz_app_flutter/features/data/request/login_request/login_request.dart';
import 'package:quiz_app_flutter/features/data/request/register_request/register_request.dart';
import 'package:quiz_app_flutter/features/data/response/login_response/login_response.dart';
import 'package:quiz_app_flutter/features/domain/entity/user_entity.dart';

abstract class AuthRepository {
  Future<Either<BaseError, LoginResponse>> signInWithEmailAndPassword({
    required LoginRequest request,
  });

  Future<Either<BaseError, bool>> register({
    required RegisterRequest request,
  });

  Future<Either<BaseError, UserEntity>> getUserInfo();

  Future<Either<BaseError, bool>> signOut();
}
