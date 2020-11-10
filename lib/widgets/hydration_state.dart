import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:plants_scheduler/pages/myplants/model/plant.dart';

class HydrationStatus extends StatelessWidget {

  final HydrationState hydration;
  final Color color;

  const HydrationStatus({Key key, this.hydration, this.color = Colors.white}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final filledIcon = Icon(
      (MaterialCommunityIcons.water),
      color: color,
    );
    final emptyIcon = Icon(
      MaterialCommunityIcons.water_outline,
      color: color,
    );

    final dryState = <Icon>[];
    for (var i=3; i>0; i--){
      hydration.index < i ? dryState.add(emptyIcon) : dryState.add(filledIcon);
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: dryState,
    );
  }

}