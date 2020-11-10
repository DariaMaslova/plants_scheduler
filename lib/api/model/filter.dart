abstract class FilterAttribute {
  final String key;

  FilterAttribute(this.key);

  bool get isEmpty;

  String get queryKey;

  String get queryValue;
}

class BooleanFilterAttribute extends FilterAttribute {
  final bool value;

  BooleanFilterAttribute(
    String key, {
    this.value,
  }) : super(key);

  @override
  bool get isEmpty => value != true;

  @override
  String get queryKey => "filter[$key]";

  @override
  String get queryValue => value.toString();
}

class RangeFilterAttribute extends FilterAttribute {
  /// left value of range; nullable
  final int minValue;

  // right value of range; nullable
  final int maxValue;

  RangeFilterAttribute(
    String key, {
    this.minValue,
    this.maxValue,
  }) : super(key);

  @override
  bool get isEmpty =>
      (minValue == null || minValue <= 0) &&
      (maxValue == null || maxValue <= 0);

  @override
  String get queryKey => "range[$key]";

  @override
  String get queryValue =>
      _missValueIfNotGreaterThenNull(minValue) +
      "," +
      _missValueIfNotGreaterThenNull(maxValue);

  String _missValueIfNotGreaterThenNull(int value) {
    return value != null && value > 0 ? value.toString() : "";
  }
}

class MultiChoiceFilterAttribute extends FilterAttribute {
  final Set<String> values;

  MultiChoiceFilterAttribute(
    String key, {
    this.values,
  }) : super(key);

  @override
  bool get isEmpty => values == null || values.isEmpty;

  @override
  String get queryKey => "filter[$key]";

  @override
  String get queryValue => values.join(",");
}

abstract class FilterAttributeKeys {
  static const FILTER_EDIBLE = "edible";
  static const FILTER_MAX_HEIGHT = "maximum_height_cm";
  static const FILTER_LIGHT = "light";
  static const FILTER_BLOOM_MONTHS = "bloom_months";
// TODO: add precipitation_mm
}
