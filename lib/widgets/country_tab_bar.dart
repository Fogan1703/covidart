import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

import '../bloc/statistic.dart';

class CountryTabBar extends StatelessWidget {
  const CountryTabBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius: BorderRadius.circular(56),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: SizedBox(
          child: TabBar(
            tabs: [
              BlocBuilder<StatisticCubit, StatisticState>(
                builder: (context, state) {
                  state = state as StatisticSuccess;
                  return Tab(
                      text: state.countryStatistic?.country
                                  .isoShortNameByLanguage[
                              Intl.getCurrentLocale().split('_').first] ??
                          state.countryStatistic?.country.isoShortName ??
                          localizations.country);
                },
              ),
              Tab(text: localizations.world),
            ],
          ),
        ),
      ),
    );
  }
}
