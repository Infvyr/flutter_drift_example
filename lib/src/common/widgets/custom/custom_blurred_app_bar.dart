import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';

import '../../../utils/index.dart' show ContextExtension;

class BlurredAppBar extends StatelessWidget implements PreferredSizeWidget {
  const BlurredAppBar({
    super.key,
    this.title,
    this.leading,
    this.flexibleSpace,
    this.actions,
    this.forceMaterialTransparency = false,
    this.automaticallyImplyLeading = true,
    this.centerTitle,
    this.titleSpacing,
    this.leadingWidth,
    this.bottom,
    this.toolbarHeight,
  });

  final bool forceMaterialTransparency;
  final bool automaticallyImplyLeading;
  final Widget? title;
  final Widget? leading;
  final Widget? flexibleSpace;
  final List<Widget>? actions;
  final bool? centerTitle;
  final double? titleSpacing;
  final double? leadingWidth;
  final PreferredSizeWidget? bottom;
  final double? toolbarHeight;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: AppBar(
          forceMaterialTransparency: forceMaterialTransparency,
          title: title ?? const SizedBox.shrink(),
          elevation: 0,
          backgroundColor: context.scaffoldBackgroundColor.withAlpha(200),
          leading: leading,
          actions: actions,
          automaticallyImplyLeading: automaticallyImplyLeading,
          centerTitle: centerTitle,
          titleSpacing: titleSpacing,
          leadingWidth: leadingWidth,
          flexibleSpace: flexibleSpace,
          bottom: bottom,
          toolbarHeight: toolbarHeight ?? kToolbarHeight,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
