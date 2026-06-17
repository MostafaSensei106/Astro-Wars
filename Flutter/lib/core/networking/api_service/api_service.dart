import 'package:astro/core/constants/api_routes.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'api_service.g.dart';

@RestApi(baseUrl: ApiRoutes.apiBaseURL)
abstract class ApiService {
  factory ApiService(Dio dio, {String? baseUrl}) = _ApiService;
}
