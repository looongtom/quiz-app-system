import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:injectable/injectable.dart';
import 'package:quiz_app_flutter/base/network/errors/error.dart';
import 'package:quiz_app_flutter/base/network/errors/extension.dart';
import 'package:quiz_app_flutter/features/data/datasource/remote/score_service/score_service.dart';
import 'package:quiz_app_flutter/features/data/request/insert_score_request/insert_score_request.dart';
import 'package:quiz_app_flutter/features/domain/entity/score_entity.dart';
import 'package:quiz_app_flutter/features/domain/repository/score_repository.dart';

@Injectable(as: ScoreRepository)
class ScoreRepositoryImpl implements ScoreRepository {
  final ScoreService _service;

  ScoreRepositoryImpl(this._service);

  @override
  Future<Either<BaseError, List<ScoreEntity>>> getScoreByQuiz({
    required int quizId,
  }) async {
    try {
      final result = await _service.getScoreByQuiz(quizId: quizId);
      if (result.data == null) {
        return left(BaseError.httpUnknownError('error_system'.tr()));
      }
      return right(result.data!.map((e) => ScoreEntity.fromModel(e)).toList());
    } on DioException catch (e) {
      return left(e.baseError);
    }
  }

  @override
  Future<Either<BaseError, List<ScoreEntity>>> getScoreByUser({
    required int userId,
  }) async {
    try {
      final result = await _service.getScoreByUser(userId: userId);
      if (result.data == null) {
        return left(BaseError.httpUnknownError('error_system'.tr()));
      }
      return right(result.data!.map((e) => ScoreEntity.fromModel(e)).toList());
    } on DioException catch (e) {
      return left(e.baseError);
    }
  }

  @override
  Future<Either<BaseError, bool>> insertScore({
    required InsertScoreRequest request,
  }) async {
    try {
      await _service.insertScore(request: request);
      return right(true);
    } on DioException catch (e) {
      return left(e.baseError);
    }
  }
}
