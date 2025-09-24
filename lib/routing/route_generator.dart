import 'package:flutter/material.dart';
import 'package:zp_sangali_dashboard_flutter/features/all_roles/BDO_dashboard/presentation/bdo_dashboard_page.dart';
import 'package:zp_sangali_dashboard_flutter/features/all_roles/ekatmik_balvikas_yojna_dashboard/presentation/ekatmik_balvikas_yojna_dashboard_page.dart';
import 'package:zp_sangali_dashboard_flutter/routing/route_names.dart';

import '../core/constants/splash_screen.dart';
import '../features/all_roles/ceo_dashboard/presentation/ceo_dashboard_page.dart';
import '../features/auth/presentation/pages/app_entry.dart';
import '../features/auth/presentation/pages/home_page.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../features/auth/presentation/pages/registration_page.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case RouteNames.appEntry:
        return MaterialPageRoute(builder: (_) => const AppEntry());
      case RouteNames.login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      // case RouteNames.registration:
      //   return MaterialPageRoute(builder: (_) => const RegistartionPage());
      case RouteNames.home:
        return MaterialPageRoute(builder: (_) => const HomePage());


        ///ceo dashboard
      case RouteNames.ceo_dashboard:
        return MaterialPageRoute(builder: (_) => const CeoDashboardPage());

    ///bdo dashboard
      case RouteNames.bdo_dashboard:
        return MaterialPageRoute(builder: (_) => const BdoDashboardPage());

    ///17 Department dashboard

      case RouteNames.ekatmikBalvikasYojnaDashboardPage:
        return MaterialPageRoute(builder: (_) => const EkatmikBalvikasYojnaDashboardPage());



    /// 17 Departments Login

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return const Scaffold(
        body: Center(child: Text("404 - Page not found")),
      );
    });
  }
}
