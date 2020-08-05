import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:plants_scheduler/resources/strings.dart';

class Menu {
  final List<MenuItem> items;
  final String selected;

  const Menu({this.items, this.selected});

  factory Menu.appMenu({String selected = MenuTitles.MY_PLANTS,}) {
    return Menu(
      items: [
        MenuItem.myPlants,
        MenuItem.catalogue,
        MenuItem.schedule,
        MenuItem.logout,
      ],
      selected: selected,
    );
  }
}

class MenuItem {
  final String title;
  final IconData icon;

  const MenuItem._(this.title, this.icon);

  static const MenuItem myPlants = MenuItem._(
    MenuTitles.MY_PLANTS,
    Icons.favorite,
  );

  static const MenuItem catalogue = MenuItem._(
    MenuTitles.CATALOGUE,
    MaterialCommunityIcons.book_open_page_variant,
  );

  static const MenuItem schedule = MenuItem._(
    MenuTitles.SCHEDULE,
    Icons.event,
  );

  static const MenuItem logout = MenuItem._(
    MenuTitles.LOGOUT,
    Icons.exit_to_app,
  );
}
