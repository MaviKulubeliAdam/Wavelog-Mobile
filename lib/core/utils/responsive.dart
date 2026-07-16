import 'package:flutter/material.dart';

abstract final class Responsive {
  static const double _tabletBreakpoint = 600;

  static bool isTablet(BuildContext context) =>
      MediaQuery.sizeOf(context).shortestSide >= _tabletBreakpoint;

  static bool isLandscape(BuildContext context) =>
      MediaQuery.orientationOf(context) == Orientation.landscape;

  /// True on tablets in landscape — use two-column layout.
  static bool useTabletLayout(BuildContext context) =>
      isTablet(context) && isLandscape(context);
}
