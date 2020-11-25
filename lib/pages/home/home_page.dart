// originally copied from https://github.com/MichaelGuldborg/FlutterNestedNavigation
import 'dart:async';
import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:plants_scheduler/generated/l10n.dart';
import 'package:plants_scheduler/main.dart';
import 'package:plants_scheduler/pages/catalogue/catalogue_page.dart';
import 'package:plants_scheduler/pages/common/models/filter.dart';
import 'package:plants_scheduler/pages/common/models/menu.dart';
import 'package:plants_scheduler/pages/myplants/my_plants_page.dart';
import 'package:plants_scheduler/pages/stub/stub_page.dart';
import 'package:plants_scheduler/routes.dart';
import 'package:plants_scheduler/widgets/drawer.dart';
import 'package:stream_transform/stream_transform.dart';

import 'mock.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  static HomePageState of(BuildContext context) {
    return (context
            .dependOnInheritedWidgetOfExactType<_HomePageStateProvider>())
        .state;
  }

  FilterController _filterController = FilterController();

  final navKey = GlobalKey<NavigatorState>();
  MenuNavigator _menuNavigator;

  final String initialRoute = MenuRoutes.myPlants;
  String currentRoute = MenuRoutes.myPlants;

  get isInitialRoute => currentRoute == initialRoute;

  get isSearchEnabled => currentRoute == MenuRoutes.catalogue;

  get routeId => routeIds[currentRoute] ?? MenuIds.MY_PLANTS;

  final routeIds = <String, String>{
    MenuRoutes.myPlants: MenuIds.MY_PLANTS,
    MenuRoutes.schedule: MenuIds.SCHEDULE,
    MenuRoutes.catalogue: MenuIds.CATALOGUE,
    MenuRoutes.logout: MenuIds.LOGOUT,
  };

  Widget _createRegularAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.green,
      elevation: 0,
      title: Text(S.of(context).menuTitles(routeId)),
    );
  }

  Widget _createSearchingAppBar() {
    return AppBar(
      backgroundColor: Colors.green,
      elevation: 0,
      title: TextField(
        controller: _filterController.queryController,
        decoration: InputDecoration(
            hintText: S.of(context).homeHintSearch,
            border: InputBorder.none,
            hintStyle: TextStyle(
              color: Colors.white60,
            )),
        style: TextStyle(color: Colors.white),
      ),
      actions: [
        GestureDetector(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Icon(MaterialCommunityIcons.filter),
          ),
          onTap: () async {
            final newParams = await AppNavigator.of(context).pushNamed(
              AppRoutes.filter,
              arguments: _filterController._filterParams,
            );
            if (newParams is FilterParams) {
              _filterController._setFilterParams(newParams);
            }
          },
        )
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _menuNavigator = MenuNavigator(
        navKey: navKey,
        initialRoute: initialRoute,
        onGenerateRoute: onGenerateRoute,
        onRouteChange: (String route) {
          setState(() {
            currentRoute = route;
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return _HomePageStateProvider(
      state: this,
      child: WillPopScope(
        onWillPop: _menuNavigator.onBackPressed,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: isSearchEnabled
              ? _createSearchingAppBar()
              : _createRegularAppBar(context),
          body: Navigator(
            key: navKey,
            initialRoute: MenuRoutes.myPlants,
            onGenerateRoute: _menuNavigator.onGenerateRoute,
          ),
          drawer: PlantsDrawer(
            menu: Menu.appMenu(
              selected: routeId,
            ),
            user: getUser(),
            onOpen: (item) {
              if (item.route != currentRoute) {
                _menuNavigator.pushNamed(
                  item.route,
                  arguments: item.id,
                );
              }
            },
          ),
        ),
      ),
    );
    ;
  }

  /// Navigation function (similar to navigateTo(Fragment fragment))
  Widget onGenerateRoute(RouteSettings settings) {
    final String routeName = settings.name;
    Widget page;
    switch (routeName) {
      case MenuRoutes.myPlants:
        page = MyPlantPage();
        break;
      case MenuRoutes.catalogue:
        page = CataloguePage();
        break;
      default:
        String title = settings.arguments is String
            ? settings.arguments
            : null;
        page = StubPage(
          title: title,
          hasActionBar: false,
        );
    }
    return page;
  }

  @override
  void dispose() {
    super.dispose();
    _menuNavigator = null;
  }
}

class _HomePageStateProvider extends InheritedWidget {
  final HomePageState state;

  _HomePageStateProvider({this.state, child}) : super(child: child);

  @override
  bool updateShouldNotify(_HomePageStateProvider old) => false;
}

class MenuNavigator {
  static MenuNavigator of(BuildContext context) {
    return (context
            .dependOnInheritedWidgetOfExactType<_HomePageStateProvider>())
        .state
        ._menuNavigator;
  }

  final GlobalKey<NavigatorState> _navKey;
  final String _initialRoute;
  String _currentRoute;
  final Widget Function(RouteSettings settings) _onGenerateRoute;
  final Function(String route) _onRouteChange;

  final Queue<String> _navigationStack = Queue();
  final Map<String, Object> _arguments = HashMap();
  final Map<String, Widget> _routes = HashMap();

  MenuNavigator(
      {Function(RouteSettings settings) onGenerateRoute,
      Function(String route) onRouteChange,
      GlobalKey<NavigatorState> navKey,
      String initialRoute})
      : _navKey = navKey,
        _initialRoute = initialRoute,
        _currentRoute = initialRoute,
        _onGenerateRoute = onGenerateRoute,
        _onRouteChange = onRouteChange;

  Future<T> pushNamed<T extends Object, TO extends Object>(
    String routeName, {
    TO result,
    Object arguments,
  }) {
    if (routeName != _initialRoute) {
      _navigationStack.add(_currentRoute);
      _navigationStack.remove(routeName);
    } else {
      _navigationStack.clear();
    }
    _currentRoute = routeName;
    _onRouteChange.call(_currentRoute);
    _arguments[_currentRoute] = arguments;
    return this._navKey.currentState.pushReplacementNamed(
          routeName,
          result: result,
          arguments: arguments,
        );
  }

  void pop<T extends Object>([T result]) {
    if (_navigationStack.isNotEmpty) {
      _popFromStack(result: result);
    } else {
      _navKey.currentState.pop(result);
    }
  }

  Future<bool> onBackPressed() async {
    if (_navigationStack.isNotEmpty) {
      await _popFromStack();
      return false;
    } else {
      return true;
    }
  }

  Future<T> _popFromStack<T extends Object, TO extends Object>({TO result}) {
    final routeName = _navigationStack.removeLast();
    _currentRoute = routeName;
    _onRouteChange.call(_currentRoute);
    return this._navKey.currentState.pushReplacementNamed(
          routeName,
          result: result,
          arguments: _arguments[_currentRoute],
        );
  }

  Route onGenerateRoute(RouteSettings settings) {
    final page =
        _routes[settings.name] ?? _onGenerateRoute.call(settings);
    _routes[settings.name] = page;
    return PageRouteBuilder(
        settings: settings,
        pageBuilder: (context, animation, secondaryAnimation) => page);
  }
}

class FilterController {
  static FilterController of(BuildContext context) {
    return (context
            .dependOnInheritedWidgetOfExactType<_HomePageStateProvider>())
        .state
        ._filterController;
  }

  FilterParams _filterParams;

  StreamController<FilterParams> _streamController;

  final TextEditingController queryController = TextEditingController();

  FilterController() {
    init();
  }

  init() {
    _setFilterParams(FilterParams.initial());
    queryController.addListener(() {
      _setFilterParams(_filterParams.withQuery(queryController.text));
    });
  }

  subscribe(Function(FilterParams) listener) {
    unsubscribe();
    _streamController = StreamController();
    _streamController.stream
        .debounce(Duration(milliseconds: 500))
        .listen(listener);
    _streamController.add(_filterParams);
  }

  unsubscribe() {
    _streamController?.close();
    _streamController = null;
  }

  _setFilterParams(FilterParams params) {
    _filterParams = params;
    _streamController?.add(params);
  }

  close() {
    unsubscribe();
  }
}
