import 'package:flutter/material.dart';

extension NavigatorHelper on BuildContext {
  NavigatorState get _navigator => Navigator.of(this, rootNavigator: true);

  void pop<T extends Object?>([T? result]) => _navigator.pop<T>(result);

  Future<T?> pushNamed<T extends Object?>(
    String routeName, {
    Object? arguments,
  }) =>
      _navigator.pushNamed<T>(routeName, arguments: arguments);

  Future<T?> navigateNamed<T extends Object?>(
    String newRouteName, {
    Object? arguments,
  }) =>
      _navigator.pushNamedAndRemoveUntil<T>(
        newRouteName,
        (_) => false,
        arguments: arguments,
      );
}
