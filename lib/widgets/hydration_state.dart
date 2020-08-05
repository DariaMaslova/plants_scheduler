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
    switch (hydration) {
      case HydrationState.Dry:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            emptyIcon,
            emptyIcon,
            emptyIcon,
          ],
        );
        break;
      case HydrationState.Low:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            emptyIcon,
            emptyIcon,
            filledIcon,
          ],
        );
        break;
      case HydrationState.Medium:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            emptyIcon,
            filledIcon,
            filledIcon,
          ],
        );
        break;
      case HydrationState.High:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            filledIcon,
            filledIcon,
            filledIcon,
          ],
        );
        break;
    }
  }

}