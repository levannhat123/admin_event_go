import 'package:flutter/material.dart';

extension BuildContextExt on BuildContext {
  TextTheme get textTheme => Theme.of(this).textTheme;
  EdgeInsets get padding => MediaQuery.of(this).padding;
}

extension IntExt on int {
  SizedBox get sizeWidth => SizedBox(width: toDouble());
  SizedBox get sizeHeigth => SizedBox(height: toDouble());
}

extension DoubleExt on double {
  SizedBox get sizeWidth => SizedBox(width: this);
  SizedBox get sizeHeigth => SizedBox(height: this);
}
