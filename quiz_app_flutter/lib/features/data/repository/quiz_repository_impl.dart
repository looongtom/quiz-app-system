import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:injectable/injectable.dart';
import 'package:quiz_app_flutter/base/network/errors/error.dart';
import 'package:quiz_app_flutter/base/network/errors/extension.dart';
import 'package:quiz_app_flutter/features/data/datasource/remote/quiz_service/quiz_service.dart';
import 'package:quiz_app_flutter/features/data/request/get_questions_by_quiz_request/get_questions_by_quiz_request.dart';
import 'package:quiz_app_flutter/features/domain/entity/quiz_entity.dart';
import 'package:quiz_app_flutter/features/domain/repository/quiz_repository.dart';

@Injectable(as: QuizRepository)
class QuizRepositoryImpl implements QuizRepository {
  final QuizService _service;

  QuizRepositoryImpl(this._service);

  @override
  Future<Either<BaseError, QuizEntity>> getQuestionsByQuiz({
    required GetQuestionsByQuizRequest request,
  }) async {
    try {
      final res = await _service.getQuestionsByQuiz(
        request: request,
      );
      if(res.data == null) {
        return left(BaseError.httpUnknownError('error_system'.tr()));
      } else {
        return right(QuizEntity.fromModel(res.data!));
      }
    } on DioException catch(e) {
      return left(e.baseError);
    }
  }
}
