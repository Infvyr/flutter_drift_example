import 'package:flutter/material.dart' show GlobalKey, ScaffoldMessengerState;

class GlobalKeys {
  static final GlobalKey<ScaffoldMessengerState> globalScaffoldKey = GlobalKey<ScaffoldMessengerState>();

  static ScaffoldMessengerState get globalScaffold {
    final context = globalScaffoldKey.currentState;
    if (context == null) {
      throw Exception(
        'ScaffoldMessengerContext not found. You must initialize it in the MaterialApp widget before using it',
      );
    }

    return context;
  }
}
