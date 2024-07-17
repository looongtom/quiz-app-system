import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:quiz_app_flutter/base/network/models/base_data.dart';
import 'package:quiz_app_flutter/common/constants/endpoint_constants.dart';
import 'package:quiz_app_flutter/features/data/request/get_questions_by_quiz_request/get_questions_by_quiz_request.dart';
import 'package:quiz_app_flutter/features/data/response/get_questions_by_quiz_response/get_questions_by_quiz_response.dart';
import 'package:retrofit/http.dart';

part 'quiz_service.g.dart';

@RestApi()
@Injectable()
abstract class QuizService {
  @factoryMethod
  factory QuizService(Dio dio) = _QuizService;

  @GET(EndpointConstants.getQuestionsByQuiz)
  Future<BaseData<GetQuestionsByQuizResponse>> getQuestionsByQuiz({
    @Queries() required GetQuestionsByQuizRequest request,
  });
}
