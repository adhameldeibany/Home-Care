import 'package:flutter/material.dart';
import 'package:graduation_project/view/pages/auth/login_screen.dart';
import '../../view/pages/auth/register_screen.dart';
import '../../view/pages/home_screens/home_screen.dart';
import '../../view_model/database/network/end_points.dart';

class Routes {
  static const String loginRoute = "/login";
  static const String homeScreen = "/Home";
  static const String registerRoute = "/";
  static const String forgotPasswordRoute = "/forgotPassword";
  static const String mainRoute = "/main";
  static const String storeDetailsRoute = "/storeDetails";
}

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case Routes.registerRoute:
        return MaterialPageRoute(builder: (_) =>  RegisterScreen());
      case Routes.loginRoute:
        return MaterialPageRoute(builder: (_) =>  LoginScreen());

      default:
        return unDefinedRoute();
    }
  }

  static Route<dynamic> unDefinedRoute() {
    return MaterialPageRoute(
        builder: (_) => Scaffold(
              appBar: AppBar(
                title: const Text(
                    "No Route Found"), // todo move this string to strings manager
              ),
              body: const Center(
                  child: Text(
                      "No Route Found")), // todo move this string to strings manager
            ));
  }
}
