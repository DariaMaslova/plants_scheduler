class Plant {
  final String name;
  final String preview;
  final DateTime lastWater;
  final HydrationState hydrationState;

  Plant({this.name, this.preview, this.lastWater, this.hydrationState});
}

enum HydrationState {
  Dry,
  Low,
  Medium,
  High,
}