import 'package:dio/dio.dart' hide Headers;
import 'package:injectable/injectable.dart';
import 'package:quiz_app_flutter/base/network/models/base_data.dart';
import 'package:quiz_app_flutter/common/constants/endpoint_constants.dart';
import 'package:quiz_app_flutter/features/data/model/score_model/score_model.dart';
import 'package:quiz_app_flutter/features/data/request/insert_score_request/insert_score_request.dart';
import 'package:retrofit/http.dart';

part 'score_service.g.dart';

@RestApi()
@Injectable()
abstract class ScoreService {
  @factoryMethod
  factory ScoreService(Dio dio) = _ScoreService;

  @POST(EndpointConstants.insertScore)
  @Headers({'Content-Type': 'application/json'})
  Future<BaseData> insertScore({
    @Body() required InsertScoreRequest request,
  });

  @GET(EndpointConstants.getScoreByQuiz)
  Future<BaseData<List<ScoreModel>>> getScoreByQuiz({
    @Query('quizId') required int quizId,
  });

  @GET(EndpointConstants.getScoreByUser)
  Future<BaseData<List<ScoreModel>>> getScoreByUser({
    @Query('userId') required int userId,
  });
}
