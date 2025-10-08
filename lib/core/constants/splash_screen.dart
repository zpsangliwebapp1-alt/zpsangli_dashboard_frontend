import 'dart:async';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../../routing/route_names.dart';
import '../utils/fade_route.dart';
import '../widgets/responsive_layout.dart';
import 'app_strings.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late VideoPlayerController _controller;
  bool _fadeOut = false;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.asset(AppStrings.splashVideo)
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });

    Timer(const Duration(milliseconds: 2400), () {
      setState(() => _fadeOut = true);
    });

    Timer(const Duration(seconds: 5), () {
      Navigator.of(context).pushReplacementNamed(RouteNames.appEntry);

    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Decide video fit responsively
    final BoxFit fit = ResponsiveLayout.isDesktop(context)
        ? BoxFit.contain
        : BoxFit.cover;


    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: AnimatedOpacity(
          opacity: _fadeOut ? 0.0 : 1.0,
          duration: const Duration(milliseconds: 600),
          child: SizedBox.expand(
            child: FittedBox(
              fit: fit,
              child: SizedBox(
                width: _controller.value.size.width,
                height: _controller.value.size.height,
                child: VideoPlayer(_controller),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
