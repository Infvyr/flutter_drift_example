import 'dart:async';

import 'package:flutter/material.dart';

import '../helpers/global_keys_helper.dart';

extension ContextExtension on BuildContext {
  double get screenHeight => MediaQuery.sizeOf(this).height;

  double get screenWidth => MediaQuery.sizeOf(this).width;

  double get keyboardBottomOffset => MediaQuery.viewInsetsOf(this).bottom;

  void hideKeyboard() => FocusScope.of(this).unfocus();

  Color get scaffoldBackgroundColor => Theme.of(this).scaffoldBackgroundColor;

  Color get primaryColor => Theme.of(this).colorScheme.primary;

  Color get secondaryColor => Theme.of(this).colorScheme.secondary;

  Color get tertiaryColor => Theme.of(this).colorScheme.tertiary;

  Color get onPrimaryColor => Theme.of(this).colorScheme.onPrimary;

  Color get onSecondaryColor => Theme.of(this).colorScheme.onSecondary;

  Color get onTertiaryColor => Theme.of(this).colorScheme.onTertiary;

  Color get onSurfaceColor => Theme.of(this).colorScheme.onSurface;

  Color get primaryFadedColor => Theme.of(this).colorScheme.primary.withOpacity(0.5);

  Color get onSurfaceFadeColor => Theme.of(this).colorScheme.onSurface.withOpacity(0.5);

  void popRoute<T extends Object?>([T? result]) => Navigator.of(this).pop<T>(result);

  void popRouteWithValue([bool? value]) => Navigator.pop(this, value);

  void pushNamed<T extends Object?>(String routeName, {Object? arguments}) =>
      Navigator.of(this).pushNamed<T>(routeName, arguments: arguments);

  void push<T extends Object?>(Route<T> route) => Navigator.of(this).push<T>(route);

  void showBanner({
    required String message,
    bool showActions = true,
    String cancelText = 'Close',
    int duration = 5,
    VoidCallback? onSuccess,
  }) {
    final globalScaffoldMessanger = GlobalKeys.globalScaffold;

    void hideBanner() {
      globalScaffoldMessanger.hideCurrentMaterialBanner();
      onSuccess?.call();
    }

    final banner = MaterialBanner(
      elevation: 5,
      content: Text(message),
      actions: showActions
          ? [
              TextButton(
                onPressed: hideBanner,
                child: Text(cancelText),
              ),
            ]
          : [const SizedBox.shrink()],
      onVisible: () {
        if (duration > 0) {
          Future.delayed(Duration(seconds: duration), hideBanner);
        }
      },
    );

    globalScaffoldMessanger.showMaterialBanner(banner);
  }

  void hideBanner() => ScaffoldMessenger.of(this).hideCurrentMaterialBanner();

  Future<bool?> showConfirmationDialog({
    required String title,
    required String content,
    String cancelText = 'No',
    String confirmText = 'Yes',
    VoidCallback? onCancel,
    VoidCallback? onConfirm,
  }) async {
    return showDialog<bool>(
      context: this,
      builder: (context) {
        return AlertDialog.adaptive(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () {
                onCancel?.call();
                popRouteWithValue(false);
              },
              child: Text(cancelText),
            ),
            TextButton(
              onPressed: () {
                onConfirm?.call();
                popRouteWithValue(true);
              },
              child: Text(confirmText),
            ),
          ],
        );
      },
    );
  }
}
