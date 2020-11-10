import 'dart:async';
import 'package:plants_scheduler/api/species_service.dart';
import 'package:plants_scheduler/pages/catalogue/model/catalogue.dart';
import 'package:plants_scheduler/pages/catalogue/usecase/load_more.dart';
import 'package:plants_scheduler/pages/catalogue/usecase/search.dart';
import 'package:plants_scheduler/pages/home/home_page.dart';

class CatalogueDataState {
  final String query;
  final List<CataloguePlant> plants;
  final String nextPage;
  final bool isLoading;
  final String errorMessage;

  CatalogueDataState({
    this.query,
    this.plants,
    this.nextPage,
    this.isLoading,
    this.errorMessage,
  });

  factory CatalogueDataState.initial() {
    return CatalogueDataState(
      isLoading: true,
    );
  }

  CatalogueDataState _copy({
    List<CataloguePlant> plants,
    String query,
    String nextPage,
    bool isLoading,
    String errorMessage,
  }) {
    return CatalogueDataState(
      query: query ?? this.query,
      plants: plants ?? this.plants,
      nextPage: nextPage ?? this.nextPage,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  CatalogueDataState _setPage(CataloguePage page) {
    return this._copy(
      plants: List.from(page.plants),
      nextPage: page.nextPage ?? "",
      isLoading: false,
      errorMessage: "",
    );
  }

  CatalogueDataState _addPage(CataloguePage page) {
    return this._copy(
      plants: (this.plants ?? List<CataloguePlant>())..addAll(page.plants),
      nextPage: page.nextPage ?? "",
      isLoading: false,
      errorMessage: "",
    );
  }

  CatalogueDataState _setError(String errorMessage) {
    return this._copy(
      isLoading: false,
      errorMessage: errorMessage ?? "",
    );
  }

  CatalogueDataState _setLoading({bool clearItems = false}) {
    return this._copy(
      plants: clearItems ? List<CataloguePlant>() : null,
      isLoading: true,
    );
  }

  bool canLoadMore() {
    return !isLoading && nextPage != null && nextPage.isNotEmpty;
  }
}

class CatalogueViewModel {
  StreamController<CatalogueDataState> _streamController;

  CatalogueDataState _state;

  final SpeciesService _speciesService = SpeciesService();
  SearchSpecies _searchSpecies;
  LoadMore _loadMore;

  FilterController _filterController;

  CatalogueViewModel() {
    this._searchSpecies = SearchSpecies(_speciesService);
    this._loadMore = LoadMore(_speciesService);
  }

  Stream<CatalogueDataState> get stream => _streamController.stream;

  init() {
    _streamController = StreamController();
    _setState(CatalogueDataState.initial());
  }

  Future<void> search(
      String query) async {
    _setState(_state._copy(
        isLoading: true,
        plants: [],
        query: query,));
    final result = await _searchSpecies.call(query);
    result
      ..onSuccess((page) => _setState(_state._setPage(page)))
      ..onError((code, message) => _setState(_state._setError(message)));
  }

  Future<void> loadMore() async {
    if (_state.nextPage != null && _state.nextPage.isNotEmpty) {
      _setState(_state._setLoading());
      final result = await _loadMore.call(_state.nextPage);
      result
        ..onSuccess((page) => _setState(_state._addPage(page)))
        ..onError((code, message) => _setState(_state._setError(message)));
    }
  }

  subscribeFilter(FilterController filterController) {
    if (_state == null) {
      return; // not initialized
    }
    _filterController?.unsubscribe();
    _filterController = filterController;
    _filterController.subscribe((filter) {
      if (filter.query != _state.query )
        search(
          filter.query
        );
    });
  }

  close() {
    _filterController.unsubscribe();
    _filterController = null;
    _streamController.close();
    _streamController = null;
  }

  _setState(CatalogueDataState state) {
    this._state = state;
    this._streamController?.add(state);
  }
}
