import 'package:dio/dio.dart';
import 'package:plants_scheduler/api/base_params.dart';
import 'package:plants_scheduler/api/model/species.dart';
import 'package:plants_scheduler/core/result.dart';

class SpeciesService {
  static const PATH_SEARCH = "${BaseParams.API_VERSION}/species/search";
  static const PATH_SPECIES = "${BaseParams.API_VERSION}/species";
  static const PARAM_QUERY = "q";
  static const PARAM_TOKEN = "token";
  static const RESPONSE_OK = 200;

  final Dio dio;

  SpeciesService() : dio = Dio(BaseOptions(baseUrl: BaseParams.BASE_URL));

  Future<Result<SpeciesResponse>> searchSpecies(
    String query
  ) async {
    try {
      Response response = await (query == null || query.isEmpty
          ? dio.get(
              PATH_SPECIES,
              queryParameters: {PARAM_TOKEN: BaseParams.API_TOKEN}
            )
          : dio.get(
              PATH_SEARCH,
              queryParameters: {
                PARAM_QUERY: query,
                PARAM_TOKEN: BaseParams.API_TOKEN
              },
            ));

      return Result.success(SpeciesResponse.fromJSON(response.data));
    } on DioError catch (e) {
      return Result.failure(message: e.message);
    }
  }

  Future<Result<SpeciesResponse>> getSpeciesByLink(String pageLink) async {
    try {
      final response = await dio.get(
        pageLink,
        queryParameters: {PARAM_TOKEN: BaseParams.API_TOKEN},
      );
      return Result.success(SpeciesResponse.fromJSON(response.data));
    } on DioError catch (e) {
      return Result.failure(message: e.message);
    }
  }
}