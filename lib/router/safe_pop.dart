import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import 'routes.dart';

extension SafePop on BuildContext {
  /// Goes back, or to the dashboard when there is nothing to go back to.
  ///
  /// `context.pop()` throws `GoError: There is nothing to pop` whenever the
  /// screen is the first entry in the stack — which happens on a cold start
  /// into a deep link, after a notification tap, and after a sign-in that
  /// replaced the stack. Every back button in the app is reachable in that
  /// state, so none of them may assume a caller is underneath.
  void backOrHome() {
    if (canPop()) {
      pop();
    } else {
      go(Routes.dashboard);
    }
  }
}
