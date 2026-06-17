import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/constants/api_routes.dart';
import '../models/run_request_model.dart';

part 'game_remote_datasource.g.dart';

@RestApi(baseUrl: ApiRoutes.apiBaseURL)
abstract class GameRemoteDataSource {
  @factoryMethod
  factory GameRemoteDataSource(Dio dio) = _GameRemoteDataSource;

  @POST(ApiRoutes.gameRuns)
  Future<HttpResponse<dynamic>> submitRun(@Body() RunRequestModel request);
}
