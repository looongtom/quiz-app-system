import 'package:dartz/dartz.dart';
import 'package:quiz_app_flutter/base/network/errors/error.dart';
import 'package:quiz_app_flutter/features/data/request/insert_score_request/insert_score_request.dart';
import 'package:quiz_app_flutter/features/domain/entity/score_entity.dart';

abstract class ScoreRepository {
  Future<Either<BaseError, bool>> insertScore({
    required InsertScoreRequest request,
  });
  Future<Either<BaseError, List<ScoreEntity>>> getScoreByQuiz({
    required int quizId,
  });
  Future<Either<BaseError, List<ScoreEntity>>> getScoreByUser({
    required int userId,
  });
}
