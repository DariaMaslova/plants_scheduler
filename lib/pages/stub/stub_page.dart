import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plants_scheduler/generated/l10n.dart';
import 'package:plants_scheduler/main.dart';

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
        title: Text(title ?? S.of(context).stubUnknownPage),
      ) : null,
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              S.of(context).stubStubText,
              textAlign: TextAlign.center,
            ),
          ]),
    );
  }
}
