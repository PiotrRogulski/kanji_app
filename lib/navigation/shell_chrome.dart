import 'dart:async';

import 'package:flutter/foundation.dart';

/// The screens ask the shell to draw their scroll-to-top button, as it only
/// melts into the navigation bar in the same glass layer.
class ShellChrome() extends ChangeNotifier {
  final _scrollToTop = <Object, VoidCallback>{};
  var _disposed = false;

  VoidCallback? get onScrollToTop => _scrollToTop.values.lastOrNull;

  void offerScrollToTop(Object owner, VoidCallback onScrollToTop) {
    _scrollToTop[owner] = onScrollToTop;
    _notify();
  }

  void withdrawScrollToTop(Object owner) {
    if (_scrollToTop.remove(owner) != null) {
      _notify();
    }
  }

  // Screens call in while they build, when the shell can't be rebuilt.
  void _notify() => scheduleMicrotask(() {
    if (!_disposed) {
      notifyListeners();
    }
  });

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
