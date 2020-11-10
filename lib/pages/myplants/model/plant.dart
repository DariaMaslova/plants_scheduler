import 'package:intl/intl.dart';

class Plant {

  final _dateFormat = DateFormat('d MMM');
  final String name;
  final String preview;
  final DateTime lastWater;
  final HydrationState hydrationState;

  Plant({this.name, this.preview, this.lastWater, this.hydrationState});

  String getLastWaterString() {
    return "last watered: " + _dateFormat.format(lastWater);
  }

}

enum HydrationState {
  Dry,
  Low,
  Medium,
  High,
}