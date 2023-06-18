import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class ScreenLayout extends StatelessWidget {
  ScreenLayout(this.child, {this.padding = 15.0});
  final Widget child;
  double padding;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: EdgeInsets.symmetric(horizontal: padding),
      child: child,
    ));
  }
}
