// originally copied from https://github.com/MichaelGuldborg/FlutterNestedNavigation

import 'dart:async';
import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:plants_scheduler/pages/common/models/menu.dart';
import 'package:plants_scheduler/pages/myplants/my_plants_page.dart';
import 'package:plants_scheduler/pages/stub/stub_page.dart';
import 'package:plants_scheduler/resources/strings.dart';
import 'package:plants_scheduler/routes.dart';
import 'package:plants_scheduler/widgets/drawer.dart';

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

  final navKey = GlobalKey<NavigatorState>();
  MenuNavigator _menuNavigator;

  final String initialRoute = MenuRoutes.myPlants;
  String currentRoute = MenuRoutes.myPlants;

  get isInitialRoute => currentRoute == initialRoute;

  get isSearchEnabled => currentRoute == MenuRoutes.catalogue;

  get routeTitle => routeTitles[currentRoute] ?? MenuTitles.MY_PLANTS;

  final routeTitles = <String, String>{
    MenuRoutes.myPlants: MenuTitles.MY_PLANTS,
    MenuRoutes.schedule: MenuTitles.SCHEDULE,
    MenuRoutes.catalogue: MenuTitles.CATALOGUE,
    MenuRoutes.logout: MenuTitles.LOGOUT,
  };

  Widget _createRegularAppBar() {
    return AppBar(
      backgroundColor: Colors.green,
      elevation: 0,
      title: Text(routeTitle),
    );
  }

  Widget _createSearchingAppBar() {
    return AppBar(
      backgroundColor: Colors.green,
      elevation: 0,
      title: TextField(
        decoration: InputDecoration(
            hintText: HomeStrings.HINT_SEARCH,
            border: InputBorder.none,
            hintStyle: TextStyle(
              color: Colors.white60,
            )),
        style: TextStyle(color: Colors.white),
      ),
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
              : _createRegularAppBar(),
          body: Navigator(
            key: navKey,
            initialRoute: MenuRoutes.myPlants,
            onGenerateRoute: _menuNavigator.onGenerateRoute,
          ),
          drawer: PlantsDrawer(
            menu: Menu.appMenu(
              selected: routeTitle,
            ),
            user: getUser(),
            onOpen: (item) {
              if (item.route != currentRoute) {
                _menuNavigator.pushNamed(
                  item.route,
                  arguments: item.title,
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
      default:
        String title = settings.arguments is String
            ? settings.arguments
            : StubStrings.UNKNOWN_PAGE;
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
