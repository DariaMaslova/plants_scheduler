import 'package:plants_scheduler/api/species_service.dart';
import 'package:plants_scheduler/core/result.dart';
import 'package:plants_scheduler/pages/catalogue/model/catalogue.dart';

import 'mapper.dart';

class LoadMore {
  final SpeciesService service;

  LoadMore(this.service);

  Future<Result<CataloguePage>> call(String pageLink) async {
    final responseResult = await service.getSpeciesByLink(pageLink);
    Result<CataloguePage> result = responseResult.map((response) => responseToUIList(response));
    return result;
  }
}