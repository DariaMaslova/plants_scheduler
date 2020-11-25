import 'dart:collection';

import 'package:plants_scheduler/api/model/filter.dart';

class FilterParams {
  final String query;
  final HashMap<String, FilterAttribute> attributes;

  const FilterParams({this.query, this.attributes,});

  factory FilterParams.initial() {
    return FilterParams(query: "", attributes: HashMap<String, FilterAttribute>());
  }

  FilterParams copy({String query, attributes,}) {
    return FilterParams(
      query: query ?? this.query,
      attributes: attributes ?? this.attributes,
    );
  }

  FilterParams withQuery(String query) {
    return this.copy(query: query);
  }

  FilterParams withAttribute(String key, FilterAttribute attribute) {
    return this.copy(
      attributes: HashMap<String, FilterAttribute>.from(attributes)
          ..update(key, (value) => attribute, ifAbsent: () => attribute)
    );
  }

  FilterParams withoutAttribute(String key) {
    return this.copy(
        attributes: HashMap<String, FilterAttribute>.from(attributes)
          ..remove(key)
    );
  }
}