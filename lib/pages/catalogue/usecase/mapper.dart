import 'package:plants_scheduler/api/model/species.dart';
import 'package:plants_scheduler/pages/catalogue/model/catalogue.dart';

CataloguePage responseToUIList(SpeciesResponse response) {
  return CataloguePage(
      plants: response.data
          .map((e) =>
              CataloguePlant(id: e.id, name: e.name, preview: e.imageUrl))
          .toList(),
      nextPage: response.links.next ?? "");
}
