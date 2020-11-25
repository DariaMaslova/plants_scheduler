import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plants_scheduler/main.dart';
import 'package:plants_scheduler/resources/strings.dart';

class StubPage extends StatelessWidget {

  final String title;
  final bool hasActionBar;

  const StubPage({Key key, this.title, this.hasActionBar = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: hasActionBar ? AppBar(
        leading: GestureDetector(
          onTap: () => AppNavigator.of(context).pop(),
          child: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: Text(title),
      ) : null,
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              StubStrings.STUB_TEXT,
              textAlign: TextAlign.center,
            ),
          ]),
    );
  }
}
