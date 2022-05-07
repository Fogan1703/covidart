import 'package:covidart/pages/home/home_page.dart';
import 'package:covidart/pages/loading.dart';
import 'package:covidart/pages/no_connection.dart';
import 'package:flutter/widgets.dart';

class AppRouter {
  AppRouter._();

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case HomePage.routeName:
        return AppPageRouteBuilder(
          page: const HomePage(),
        );
      case NoConnectionPage.routeName:
        return AppPageRouteBuilder(
          page: const NoConnectionPage(),
        );
      case LoadingPage.routeName:
        return AppPageRouteBuilder(
          page: const LoadingPage(),
        );
      default:
        return AppPageRouteBuilder(
          page: Center(
            child: Text(
              'There is no route with name ${settings.name}',
              textAlign: TextAlign.center,
            ),
          ),
        );
    }
  }
}

class AppPageRouteBuilder extends PageRouteBuilder {
  AppPageRouteBuilder({required Widget page})
      : super(
          pageBuilder: (context, _, __) {
            return page;
          },
        );
}
