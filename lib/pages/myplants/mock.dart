import 'dart:math';

import 'package:plants_scheduler/pages/common/models/user.dart';

import 'model/plant.dart';

const _plants = [
  "Rubber Tree",
  "Aloe Vera",
  "Anthurium",
  "Succulent",
  "Orchid",
  "Hibiscus"
];
const _images = [
  "https://hips.hearstapps.com/vader-prod.s3.amazonaws.com/1551638026-screen-shot-2019-03-03-at-1-31-58-pm-1551637988.png?crop=0.737xw:0.570xh;0.120xw,0.349xh&resize=768:*",
  "https://hips.hearstapps.com/vader-prod.s3.amazonaws.com/1551638772-screen-shot-2019-03-03-at-1-45-07-pm-1551638729.png?crop=0.835xw:0.716xh;0.0865xw,0.103xh&resize=768:*",
  "https://hgtvhome.sndimg.com/content/dam/images/grdn/fullset/2014/2/13/0/anthurium.jpg.rend.hgtvcom.966.966.suffix/1452657075193.jpeg",
  "https://garden.spoonflower.com/c/4449128/p/f/m/gBtvkgew4Sm4md92U1TgiiiV0o4LrMe-ak-_G7fE2G7eqMcpwSDAsfo2/4449128-succulent-square-by-alidri.jpg",
  "https://cdn2.stylecraze.com/wp-content/uploads/2013/10/1668-Top-25-Beautiful-Orchid-Flowers-is.jpg",
  "https://www.thespruce.com/thmb/7yAUE6GPIRVhGEIGdiBcOQcZPB8=/735x0/trio-of-vibrant-red-hibiscus-flowers-with-bright-yellow-stigma-growing-in-garden-pot-845218812-5abea591119fa80037eef63e.jpg",
];

List<Plant> getPlants(int number) {
  final result = List<Plant>();
  for (var i = 0; i < number; i++ ) {
    result.add(randomPlant());
  }
  return result;
}

Plant randomPlant() {
  final random = Random();
  final plantNum = random.nextInt(_plants.length);
  final hydrationStateNum = random.nextInt(HydrationState.values.length);
  final daysAgo = random.nextInt(14);
  final lastWater = DateTime.now().subtract(Duration(days: daysAgo));
  return Plant(
    name: _plants[plantNum],
    preview: _images[plantNum],
    lastWater: lastWater,
    hydrationState: HydrationState.values[hydrationStateNum]
  );
}