import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:quiz_app_flutter/base/network/models/base_data.dart';
import 'package:quiz_app_flutter/common/constants/endpoint_constants.dart';
import 'package:quiz_app_flutter/features/data/model/user_model/user_model.dart';
import 'package:quiz_app_flutter/features/data/response/login_response/login_response.dart';
import 'package:retrofit/http.dart';

part 'auth_service.g.dart';

@RestApi()
@Injectable()
abstract class AuthService {
  @factoryMethod
  factory AuthService(@Named('authDio') Dio dio) = _AuthService;

  @POST(EndpointConstants.login)
  @MultiPart()
  Future<BaseData<LoginResponse>> login({
    @Body() required FormData loginRequest,
  });

  @POST(EndpointConstants.register)
  @MultiPart()
  Future<void> register({
    @Body() required FormData request,
  });

  @GET(EndpointConstants.getUserInfo)
  Future<BaseData<UserModel>> getUserInfo();

  @POST(EndpointConstants.logout)
  Future<void> logout();
}
