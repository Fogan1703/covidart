import 'dart:convert';

import 'package:covidart/bloc/statistic.dart';
import 'package:covidart/router.dart';
import 'package:covidart/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    return MaterialApp(
      title: 'Covidart',
      theme: AppTheme.theme,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}
