import 'package:covidart/router.dart';
import 'package:covidart/theme.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Covidart',
      theme: AppTheme.theme,
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}
