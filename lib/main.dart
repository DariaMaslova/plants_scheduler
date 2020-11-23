// originally copied from https://github.com/MichaelGuldborg/FlutterNestedNavigation

import 'package:flutter/material.dart';
import 'package:plants_scheduler/pages/filter/filter_page.dart';
import 'package:plants_scheduler/pages/home/home_page.dart';
import 'package:plants_scheduler/pages/stub/stub_page.dart';
import 'package:plants_scheduler/resources/strings.dart';
import 'package:plants_scheduler/routes.dart';

void main() {
  runApp(App());
}

class _AppStateProvider extends InheritedWidget {
  final AppState state;

  _AppStateProvider({this.state, child}) : super(child: child);

  @override
  bool updateShouldNotify(_AppStateProvider old) => false;
}

/// For convenience we create a static class and function to get only
/// the app level navigator from the app state
class AppNavigator {
  static NavigatorState of(BuildContext context) {
    return Navigator.of(
      context,
      rootNavigator: true,
    );
  }
}

class App extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AppState();
  }
}

class AppState extends State<App> {
  static AppState of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<_AppStateProvider>())
        .state;
  }

  @override
  Widget build(BuildContext context) {
    return _AppStateProvider(
      state: this,
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.green,
          accentColor: Colors.redAccent,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        onGenerateRoute: _generateRoute,
        initialRoute: AppRoutes.home,
      ),
    );
  }
}

Route<dynamic> _generateRoute(RouteSettings settings) {
  Route route;
  switch (settings.name) {
    case AppRoutes.home:
      route = PageRouteBuilder(
          settings: settings,
          pageBuilder: (context, animation, secondaryAnimation) => HomePage());
      break;
    case AppRoutes.filter:
      route = PageRouteBuilder(
          settings: settings,
          pageBuilder: (context, animation, secondaryAnimation) =>
              FilterPage(filterParams: settings.arguments));
      break;
    default:
      String title = settings.arguments is String
          ? settings.arguments
          : StubStrings.UNKNOWN_PAGE;
      route = PageRouteBuilder(
          settings: settings,
          pageBuilder: (context, animation, secondaryAnimation) =>
              StubPage(title: title));
  }
  return route;
}
