import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bloc/statistic.dart';
import 'pages/home/home_page.dart';
import 'pages/loading.dart';
import 'pages/no_connection.dart';
import 'router.dart';
import 'theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();

  final seen = prefs.getBool('seen') ?? false;
  if (seen == false) {
    prefs.setBool('seen', true);
  }

  runApp(
    BlocProvider<StatisticCubit>(
      create: (context) => StatisticCubit(prefs: prefs),
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
    final statisticState = context.read<StatisticCubit>().state;

    return MaterialApp(
      title: 'Covidart',
      theme: AppTheme.theme,
      scrollBehavior: AppTheme.scrollBehavior,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      initialRoute: statisticState is StatisticLoading
          ? LoadingPage.routeName
          : statisticState is StatisticNoConnection
              ? NoConnectionPage.routeName
              : HomePage.routeName,
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}
