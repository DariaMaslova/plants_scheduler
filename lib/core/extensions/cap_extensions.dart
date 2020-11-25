extension CapExtension on String {
  String get allInCaps => this.toUpperCase();
  String get capitalizeFirstOfEach => this.capitalizeBy(" ").capitalizeBy("-");

  String get capitalize {
    if(this.length <= 1) {
      return this.toUpperCase();
    }
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }

  String capitalizeBy(String delimeter) {
    return this.split(delimeter).map((str) => str.capitalize).join(delimeter);
  }
}