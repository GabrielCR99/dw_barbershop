import 'package:flutter/material.dart';

extension NavigatorHelper on BuildContext {
  NavigatorState get _navigator => Navigator.of(this, rootNavigator: true);

  void pop<T>([T? result]) => _navigator.pop<T>(result);
}
