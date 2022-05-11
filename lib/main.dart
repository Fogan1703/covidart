import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bloc/statistic.dart';
import 'pages/home/home_page.dart';
import 'pages/loading.dart';
import 'pages/no_connection.dart';
import 'pages/onboarding.dart';
import 'router.dart';
import 'theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();

  final seen = prefs.getBool('seen') ?? false;

  final StatisticCubit statisticCubit;
  if (seen) {
    statisticCubit = StatisticCubit(prefs: prefs);
  } else {
    statisticCubit = StatisticCubit.withInitial(prefs: prefs);
  }

  runApp(
    BlocProvider<StatisticCubit>.value(
      value: statisticCubit,
      child: App(seen: seen),
    ),
  );
}

class App extends StatelessWidget {
  final bool seen;

  const App({
    Key? key,
    required this.seen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String initialRoute;

    if (seen) {
      final statisticState = context
          .read<StatisticCubit>()
          .state;

      if (statisticState is StatisticLoading) {
        initialRoute = LoadingPage.routeName;
      } else if (statisticState is StatisticNoConnection) {
        initialRoute = NoConnectionPage.routeName;
      } else {
        initialRoute = HomePage.routeName;
      }
    } else {
      initialRoute = OnboardingPage.routeName;
    }

    return MaterialApp(
      title: 'Covidart',
      theme: AppTheme.theme,
      scrollBehavior: AppTheme.scrollBehavior,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      initialRoute: initialRoute,
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}
