import 'package:flutter/widgets.dart';

class AppRouter {
  AppRouter._();

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      default:
        return AppPageRouteBuilder(
          page: Center(
            child: Text('There is no route with name ${settings.name}'),
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
