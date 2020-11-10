class FilterParams {
  final String query;

  const FilterParams({this.query,});

  factory FilterParams.initial() {
    return FilterParams(query: "",);
  }

  FilterParams copy({String query, attributes,}) {
    return FilterParams(
      query: query ?? this.query,
    );
  }

  FilterParams withQuery(String query) {
    return this.copy(query: query);
  }
}