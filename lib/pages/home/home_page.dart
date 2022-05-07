import 'package:animations/animations.dart';
import 'package:covidart/bloc/statistic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../theme.dart';
import 'views/home.dart';
import 'views/info.dart';
import 'views/statistic.dart';
import 'views/symptoms.dart';

class HomePage extends StatefulWidget {
  static const String routeName = 'home';

  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _noInternetController;

  int _currentIndex = 0;

  static const _views = [
    StatisticView(),
    HomeView(),
    SymptomsView(),
    InfoView(),
  ];

  @override
  void initState() {
    super.initState();
    _noInternetController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 300,
      ),
    );
  }

  @override
  void dispose() {
    _noInternetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return BlocListener<StatisticCubit, StatisticState>(
      listener: (context, state) {
        state = state as StatisticSuccess;

        if (state.refreshing == RefreshingStatus.noConnection) {
          _noInternetController.forward();
        } else {
          _noInternetController.reverse();
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              AnimatedBuilder(
                animation: _noInternetController,
                builder: (context, child) {
                  return SizeTransition(
                    sizeFactor: _noInternetController,
                    child: ColoredBox(
                      color: AppTheme.purpleDark,
                      child: FadeTransition(
                        opacity: _noInternetController,
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.cloud_off,
                                color: Colors.white,
                                size: 16,
                              ),
                              const SizedBox(width: 16),
                              Text(
                                localizations.checkYourInternetConnection,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              Expanded(
                child: PageTransitionSwitcher(
                  transitionBuilder:
                      (child, primaryAnimation, secondaryAnimation) {
                    return FadeThroughTransition(
                      animation: primaryAnimation,
                      secondaryAnimation: secondaryAnimation,
                      child: child,
                    );
                  },
                  child: _views[_currentIndex],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.insert_chart_outlined),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.library_add_check_outlined),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.info),
              label: '',
            ),
          ],
        ),
      ),
    );
  }
}
