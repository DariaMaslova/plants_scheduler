import 'package:plants_scheduler/api/model/filter.dart';
import 'package:plants_scheduler/api/species_service.dart';
import 'package:plants_scheduler/core/result.dart';
import 'package:plants_scheduler/pages/catalogue/model/catalogue.dart';
import 'package:plants_scheduler/pages/catalogue/usecase/mapper.dart';

class SearchSpecies {
  final SpeciesService service;

  SearchSpecies(this.service);

  Future<Result<CataloguePage>> call(
    String query,
    List<FilterAttribute> attributes,
  ) async {
    final responseResult = await service.searchSpecies(query, attributes);
    Result<CataloguePage> result =
        responseResult.map((response) => responseToUIList(
              response
            ));
    return result;
  }
}
