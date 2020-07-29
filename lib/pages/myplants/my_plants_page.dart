import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:plants_scheduler/pages/myplants/model/plant.dart';
import 'package:plants_scheduler/utils/drawer.dart';
import 'package:plants_scheduler/utils/leaf_clippers.dart';

import 'mock.dart';

class MyPlantPage extends StatefulWidget {
  @override
  _MyPlantPageState createState() => _MyPlantPageState();
}

class _MyPlantPageState extends State<MyPlantPage> {
  final _selectedColor = Colors.deepOrange.shade900;
  final _unselectedColor = Colors.grey.shade500;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My Plants",
        ),
        actions: <Widget>[
          IconButton(
            splashColor: Colors.yellow,
            icon: Icon(
              Icons.filter_list,
            ),
            onPressed: () {},
          )
        ],
      ),
      body: _PlantsList(
        plants: getPlants(50),
      ),
      drawer: Row(
        children: <Widget>[
          Expanded(
            flex: 7,
            child: Container(
              color: Colors.white,
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  PlantDrawerHeader(
                    child: Center(
                      child: Column(
                        children: <Widget>[
                          CircleAvatar(
                            backgroundImage: NetworkImage(
                                "https://w7.pngwing.com/pngs/423/362/png-transparent-undertale-flowey-game-toriel-flower-fox-draw-game-food-pin.png"),
                            radius: 40,
                          ),
                          Container(
                            margin: EdgeInsets.only(
                              top: 8,
                            ),
                            child: Text(
                              "Flowey the Flower",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    decoration: ShapeDecoration(
                      color: Colors.green,
                      shape: LeafBottomShapeBorder(),
                    ),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.favorite,
                      color: _selectedColor,
                    ),
                    title: Text(
                      "My Plants",
                      style: TextStyle(
                        color: _selectedColor,
                      ),
                    ),
                  ),
                  ListTile(
                    leading: Icon(
                      MaterialCommunityIcons.book_open_page_variant,
                      color: _unselectedColor,
                    ),
                    title: Text(
                      "Catalogue",
                      style: TextStyle(
                        color: _unselectedColor,
                      ),
                    ),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.event,
                      color: _unselectedColor,
                    ),
                    title: Text(
                      "Schedule",
                      style: TextStyle(
                        color: _unselectedColor,
                      ),
                    ),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.exit_to_app,
                      color: _unselectedColor,
                    ),
                    title: Text(
                      "Logout",
                      style: TextStyle(
                        color: _unselectedColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Spacer(
            flex: 3,
          ),
        ],
      ),
    );
  }
}

class _PlantsList extends StatelessWidget {
  final List<Plant> _plants;

  const _PlantsList({Key key, List<Plant> plants})
      : _plants = plants,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        padding: EdgeInsets.all(
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

  MainAxisAlignment _waterDropsAlignment() {
    if (isLeft) {
      return MainAxisAlignment.start;
    } else {
      return MainAxisAlignment.end;
    }
  }

  CrossAxisAlignment _textAlignment() {
    if (isLeft) {
      return CrossAxisAlignment.end;
    } else {
      return CrossAxisAlignment.start;
    }
  }

  Widget _hydrationStatus() {
    final filledIcon = Icon(
      (MaterialCommunityIcons.water),
      color: Colors.white,
    );
    final emptyIcon = Icon(
      MaterialCommunityIcons.water_outline,
      color: Colors.white,
    );
    switch (plant.hydrationState) {
      case HydrationState.Dry:
        return Row(
          mainAxisAlignment: _waterDropsAlignment(),
          children: <Widget>[
            emptyIcon,
            emptyIcon,
            emptyIcon,
          ],
        );
        break;
      case HydrationState.Low:
        return Row(
          mainAxisAlignment: _waterDropsAlignment(),
          children: <Widget>[
            emptyIcon,
            emptyIcon,
            filledIcon,
          ],
        );
        break;
      case HydrationState.Medium:
        return Row(
          mainAxisAlignment: _waterDropsAlignment(),
          children: <Widget>[
            emptyIcon,
            filledIcon,
            filledIcon,
          ],
        );
        break;
      case HydrationState.High:
        return Row(
          mainAxisAlignment: _waterDropsAlignment(),
          children: <Widget>[
            filledIcon,
            filledIcon,
            filledIcon,
          ],
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
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
                padding: EdgeInsets.symmetric(
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
                child: _hydrationStatus(),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 8.0,
                ),
                constraints: BoxConstraints.expand(
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
    );
  }
}
