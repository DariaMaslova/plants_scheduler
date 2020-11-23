import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:plants_scheduler/main.dart';
import 'package:plants_scheduler/pages/myplants/model/plant.dart';
import 'package:plants_scheduler/routes.dart';
import 'package:plants_scheduler/widgets/hydration_state.dart';

import 'mock.dart';

class MyPlantPage extends StatefulWidget {
  @override
  _MyPlantPageState createState() => _MyPlantPageState();
}

class _MyPlantPageState extends State<MyPlantPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _PlantsList(
        plants: getPlants(50),
      ),
    );
  }
}

class _PlantsList extends StatelessWidget {
  final List<Plant> _plants;

  _PlantsList({Key key, List<Plant> plants})
      : _plants = plants,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        padding: const EdgeInsets.all(
          16.0,
        ),
        itemCount: _plants.length,
        physics: const BouncingScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
        ),
        itemBuilder: (context, index) => _PlantItem(
              plant: _plants[index],
              isLeft: index % 2 == 0,
            ));
  }
}

class _PlantItem extends StatelessWidget {
  final Plant plant;
  final bool isLeft;
  final _cornerRadius = Radius.circular(24.0);

  _PlantItem({Key key, this.plant, this.isLeft}) : super(key: key);

  BorderRadius _borderRadius() {
    if (isLeft) {
      return BorderRadius.only(
          topLeft: _cornerRadius,
          topRight: _cornerRadius,
          bottomLeft: _cornerRadius);
    } else {
      return BorderRadius.only(
          topLeft: _cornerRadius,
          topRight: _cornerRadius,
          bottomRight: _cornerRadius);
    }
  }

  Alignment _waterDropsAlignment() {
    return isLeft ? Alignment.centerLeft : Alignment.centerRight;
  }

  CrossAxisAlignment _textAlignment() {
    return isLeft ? CrossAxisAlignment.end : CrossAxisAlignment.start;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => AppNavigator.of(context)
          .pushNamed(AppRoutes.plantDetails, arguments: plant),
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(borderRadius: _borderRadius()),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            Container(
              constraints: BoxConstraints.expand(),
              child: Image.network(
                plant.preview,
                fit: BoxFit.cover,
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  alignment: _waterDropsAlignment(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4.0,
                    vertical: 2.0,
                  ),
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                        Colors.transparent,
                        Colors.grey.shade600.withAlpha(50)
                      ])),
                  child: HydrationStatus(
                    hydration: plant.hydrationState,
                    color: Colors.white,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                  ),
                  constraints: const BoxConstraints.expand(
                    height: 48.0,
                  ),
                  color: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: _textAlignment(),
                    children: <Widget>[
                      Text(
                        plant.name,
                        style: TextStyle(
                          color: Colors.grey.shade800,
                          fontSize: 14.0,
                        ),
                      ),
                      Text(
                        plant.getLastWaterString(),
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 10.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
