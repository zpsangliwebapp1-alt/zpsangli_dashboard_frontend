import 'package:flutter/material.dart';
import '../widgets/responsive_layout.dart';

/// Extension on [BuildContext] for responsive text scaling
extension ResponsiveText on BuildContext {
  double scaleText(double baseSize) {
    if (ResponsiveLayout.isDesktop(this)) {
      return baseSize * 1.4; // 40% larger on desktop
    } else if (ResponsiveLayout.isTablet(this)) {
      return baseSize * 1.2; // 20% larger on tablet
    } else {
      return baseSize; // base size on mobile
    }
  }

  double scaledFont(double base) {
    final systemScale = MediaQuery.of(this).textScaleFactor;
    return scaleText(base) * systemScale;
  }
}
