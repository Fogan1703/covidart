import 'package:covidart/pages/home/home_page.dart';
import 'package:flutter/widgets.dart';

class AppRouter {
  AppRouter._();

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case HomePage.routeName:
        return AppPageRouteBuilder(
          page: const HomePage(),
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
