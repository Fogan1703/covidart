import 'package:animations/animations.dart';
import 'package:declarative_refresh_indicator/declarative_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

import '../../../bloc/statistic.dart';
import '../../../models/statistic.dart';
import '../../../theme.dart';
import '../../../widgets/country_selector.dart';
import '../../../widgets/country_tab_bar.dart';
import '../../../widgets/statistic_grid.dart';

class StatisticView extends StatefulWidget {
  const StatisticView({Key? key}) : super(key: key);

  @override
  State<StatisticView> createState() => _StatisticViewState();
}

class _StatisticViewState extends State<StatisticView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _totalController;

  bool _isTotal = true;

  @override
  void initState() {
    super.initState();
    _totalController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      value: 1,
    );
  }

  @override
  void dispose() {
    _totalController.dispose();
    super.dispose();
  }

  Widget _buildStatistic(Statistic statistic, bool isTotal) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: PageTransitionSwitcher(
        transitionBuilder: (
          child,
          animation,
          secondaryAnimation,
        ) {
          return FadeThroughTransition(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            child: child,
            fillColor: Colors.transparent,
          );
        },
        child: StatisticGrid(
          key: ValueKey<bool>(_isTotal),
          statistic: statistic,
          isTotal: isTotal,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context)!;

    final totalTodayTexts = [
      localizations.total,
      localizations.today,
    ];

    return BlocBuilder<StatisticCubit, StatisticState>(
      builder: (context, state) {
        state = state as StatisticSuccess;

        return DeclarativeRefreshIndicator(
          refreshing: state.refreshing == RefreshingStatus.loading,
          onRefresh: context.read<StatisticCubit>().refresh,
          child: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                child: Column(
                  children: [
                    Expanded(
                      child: ColoredBox(
                        color: AppTheme.purple,
                        child: DefaultTabController(
                          length: 2,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 24,
                                  top: 24,
                                  right: 25,
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          localizations.statistics,
                                          style: theme.textTheme.headline5,
                                        ),
                                        const Spacer(),
                                        const CountrySelector(),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16),
                                      child: BlocBuilder<StatisticCubit,
                                          StatisticState>(
                                        builder: (context, state) {
                                          state = state as StatisticSuccess;

                                          TextStyle style =
                                              theme.textTheme.bodyText2!;
                                          final color =
                                              style.color!.withOpacity(0.5);
                                          style = style.copyWith(
                                            color: color,
                                            height: 1,
                                          );

                                          return Text(
                                            localizations.lastUpdate(
                                              DateFormat('MMM d, HH:mm').format(
                                                state.lastUpdate,
                                              ),
                                            ),
                                            style: style,
                                          );
                                        },
                                      ),
                                    ),
                                    const CountryTabBar(),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: List.generate(
                                          totalTodayTexts.length,
                                          (index) {
                                            return AnimatedBuilder(
                                              animation: _totalController,
                                              builder: (context, child) {
                                                final tween = index == 0
                                                    ? Tween<double>(
                                                        begin: 0.6, end: 1)
                                                    : Tween<double>(
                                                        begin: 1, end: 0.6);

                                                return FadeTransition(
                                                  opacity: tween.animate(
                                                      _totalController),
                                                  child: child,
                                                );
                                              },
                                              child: GestureDetector(
                                                behavior:
                                                    HitTestBehavior.translucent,
                                                onTap: () {
                                                  setState(() {
                                                    if (index == 0) {
                                                      if (_isTotal == false) {
                                                        _isTotal = true;
                                                        _totalController
                                                            .forward();
                                                      }
                                                    } else if (index == 1) {
                                                      if (_isTotal) {
                                                        _isTotal = false;
                                                        _totalController
                                                            .reverse();
                                                      }
                                                    }
                                                  });
                                                },
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    vertical: 16,
                                                    horizontal: 8,
                                                  ),
                                                  child: Text(
                                                    totalTodayTexts[index],
                                                    style: theme
                                                        .textTheme.bodyText1,
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: TabBarView(
                                  children: [
                                    state.countryStatistic != null
                                        ? _buildStatistic(
                                            state.countryStatistic!,
                                            _isTotal,
                                          )
                                        : Center(
                                            child: SizedBox(
                                              width: (MediaQuery.of(context)
                                                          .size
                                                          .width -
                                                      48) *
                                                  0.6,
                                              child: Text(
                                                localizations
                                                    .pleaseSelectCountry,
                                                textAlign: TextAlign.center,
                                                style:
                                                    theme.textTheme.bodyText1,
                                              ),
                                            ),
                                          ),
                                    _buildStatistic(
                                      state.worldStatistic,
                                      _isTotal,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
