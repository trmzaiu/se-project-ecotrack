import 'package:flutter/cupertino.dart';

class MyNavigatorObserver extends NavigatorObserver {
  final List<Route<dynamic>> _stack = [];

  @override
  void didPush(Route route, Route? previousRoute) {
    _stack.add(route);
    _logStack('PUSH');
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    _stack.remove(route);
    _logStack('POP');
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    _stack.remove(route);
    _logStack('REMOVE');
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    _stack.remove(oldRoute);
    if (newRoute != null) _stack.add(newRoute);
    _logStack('REPLACE');
  }

  void _logStack(String action) {
    print('====== [$action] Current Stack ======');
    for (final route in _stack) {
      print('→ ${route.settings.name ?? route.runtimeType}');
    }
    print('====================================');
  }
}
