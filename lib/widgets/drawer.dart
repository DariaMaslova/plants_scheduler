import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plants_scheduler/generated/l10n.dart';
import 'package:plants_scheduler/pages/common/models/menu.dart';
import 'package:plants_scheduler/pages/common/models/user.dart';

import 'leaf_clippers.dart';

const double _kDrawerHeaderHeight =
    160.0; // without border from original header

class PlantDrawerHeader extends StatelessWidget {
  const PlantDrawerHeader({
    Key key,
    this.decoration,
    this.margin = const EdgeInsets.only(bottom: 8.0),
    this.padding = const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
    this.duration = const Duration(milliseconds: 250),
    this.curve = Curves.fastOutSlowIn,
    @required this.child,
  }) : super(key: key);

  /// Decoration for the main drawer header [Container]; useful for applying
  /// backgrounds.
  ///
  /// This decoration will extend under the system status bar.
  ///
  /// If this is changed, it will be animated according to [duration] and [curve].
  final Decoration decoration;

  /// The padding by which to inset [child].
  ///
  /// The [DrawerHeader] additionally offsets the child by the height of the
  /// system status bar.
  ///
  /// If the child is null, the padding has no effect.
  final EdgeInsetsGeometry padding;

  /// The margin around the drawer header.
  final EdgeInsetsGeometry margin;

  /// The duration for animations of the [decoration].
  final Duration duration;

  /// The curve for animations of the [decoration].
  final Curve curve;

  /// A widget to be placed inside the drawer header, inset by the [padding].
  ///
  /// This widget will be sized to the size of the header. To position the child
  /// precisely, consider using an [Align] or [Center] widget.
  ///
  /// {@macro flutter.widgets.child}
  final Widget child;

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterial(context));
    assert(debugCheckHasMediaQuery(context));
    final ThemeData theme = Theme.of(context);
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return Container(
      height: statusBarHeight + _kDrawerHeaderHeight,
      margin: margin,
      child: AnimatedContainer(
        padding: padding.add(EdgeInsets.only(top: statusBarHeight)),
        decoration: decoration,
        duration: duration,
        curve: curve,
        child: child == null
            ? null
            : DefaultTextStyle(
                style: theme.textTheme.bodyText1,
                child: MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  child: child,
                ),
              ),
      ),
    );
  }
}

class PlantsDrawer extends StatelessWidget {
  final Menu menu;
  final User user;
  final Function(MenuItem) onOpen;

  const PlantsDrawer({Key key, this.menu, this.user, this.onOpen})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: 1 + menu.items.length,
          itemBuilder: (context, index) {
            if (index == 0) {
              return _userHeader(user);
            } else {
              return _menuTile(
                context,
                menu.items[index - 1],
                isSelected: menu.items[index - 1].id == menu.selected,
                onOpen: onOpen,
              );
            }
          }),
    );
  }
}

Widget _menuTile(
  BuildContext context,
  MenuItem menuItem, {
  bool isSelected = false,
  Function(MenuItem) onOpen,
}) {
  Color color;
  if (isSelected) {
    color = Colors.deepOrange.shade900;
  } else {
    color = Colors.grey.shade500;
  }
  return ListTile(
    leading: Icon(
      menuItem.icon,
      color: color,
    ),
    title: Text(
      S.of(context).menuTitles(menuItem.id),
      style: TextStyle(
        color: color,
      ),
    ),
    onTap: () {
      Navigator.of(context).pop();
      if (onOpen!= null) {
        onOpen.call(menuItem);
      };
    },
  );
}

Widget _userHeader(User user) {
  return PlantDrawerHeader(
    child: Center(
      child: Column(
        children: <Widget>[
          CircleAvatar(
            backgroundImage: NetworkImage(user.avatar),
            radius: 40,
          ),
          Container(
            margin: const EdgeInsets.only(
              top: 8,
            ),
            child: Text(
              user.username,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    ),
    decoration: const ShapeDecoration(
      color: Colors.green,
      shape: LeafBottomShapeBorder(),
    ),
  );
}
