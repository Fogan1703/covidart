import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/statistic.dart';
import 'pages/home/home_page.dart';
import 'pages/loading.dart';
import 'pages/no_connection.dart';

class AppRouter {
  AppRouter._();

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    final Widget page;

    switch (settings.name) {
      case HomePage.routeName:
        page = const HomePage();
        break;
      case NoConnectionPage.routeName:
        page = const NoConnectionPage();
        break;
      case LoadingPage.routeName:
        page = const LoadingPage();
        break;
      default:
        page = Center(
          child: Text(
            'There is no route with name ${settings.name}',
            textAlign: TextAlign.center,
          ),
        );
    }

    return AppPageRouteBuilder(
      page: BlocListener<StatisticCubit, StatisticState>(
        listenWhen: (previous, current) =>
            previous.runtimeType != current.runtimeType,
        listener: (context, state) {
          final navigator = Navigator.of(context);

          if (state is StatisticSuccess) {
            navigator.pushNamed(HomePage.routeName);
          }
          if (state is StatisticLoading) {
            navigator.pushNamed(LoadingPage.routeName);
          }
          if (state is StatisticNoConnection) {
            navigator.pushNamed(NoConnectionPage.routeName);
          }
        },
        child: page,
      ),
    );
  }
}

class AppPageRouteBuilder extends PageRouteBuilder {
  AppPageRouteBuilder({required Widget page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) {
            return page;
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curvedAnimation = CurvedAnimation(
              parent: animation,
              curve: Curves.easeInBack,
            );

            return ScaleTransition(
              scale: Tween(
                begin: 0.75,
                end: 1.0,
              ).animate(curvedAnimation),
              child: FadeTransition(
                opacity: curvedAnimation,
                child: child,
              ),
            );
          },
        );
}
