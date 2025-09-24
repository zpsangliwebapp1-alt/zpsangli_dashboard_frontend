import 'package:flutter/material.dart';
import '../../../../core/widgets/responsive_layout.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobile: const _HomeMobile(),
      tablet: const _HomeTablet(),
      desktop: const _HomeDesktop(),
    );
  }
}

class _HomeMobile extends StatelessWidget {
  const _HomeMobile();

  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text("Mobile Home")));
}

class _HomeTablet extends StatelessWidget {
  const _HomeTablet();

  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text("Tablet Home")));
}

class _HomeDesktop extends StatelessWidget {
  const _HomeDesktop();

  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text("Desktop Home")));
}
