import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:plants_scheduler/routes.dart';

class Menu {
  List<MenuItem> items;
  String selected;

  Menu({this.items, this.selected});

  Menu.appMenu({
    String selected = MenuIds.MY_PLANTS,
  }) {
    this.items = [
      MenuItem.myPlants,
      MenuItem.catalogue,
      MenuItem.schedule,
      MenuItem.logout,
    ];
    this.selected = selected;
  }
}

class MenuItem {
  final String id;
  final IconData icon;
  final String route;

  const MenuItem._(this.id, this.icon, this.route);

  static const MenuItem myPlants = MenuItem._(
    MenuIds.MY_PLANTS,
    Icons.favorite,
    MenuRoutes.myPlants,
  );

  static const MenuItem catalogue = MenuItem._(
    MenuIds.CATALOGUE,
    MaterialCommunityIcons.book_open_page_variant,
    MenuRoutes.catalogue,
  );

  static const MenuItem schedule = MenuItem._(
    MenuIds.SCHEDULE,
    Icons.event,
    MenuRoutes.schedule,
  );

  static const MenuItem logout = MenuItem._(
    MenuIds.LOGOUT,
    Icons.exit_to_app,
    MenuRoutes.logout,
  );
}

abstract class MenuIds {
  static const MY_PLANTS = "myPlants";
  static const CATALOGUE = "catalogue";
  static const SCHEDULE = "schedule";
  static const LOGOUT = "logout";
}
