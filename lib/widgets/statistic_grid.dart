import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

import '../models/statistic.dart';
import '../theme.dart';

class StatisticGrid extends StatelessWidget {
  static final _valueFormat = NumberFormat.decimalPattern();

  final Statistic statistic;
  final bool isTotal;

  const StatisticGrid({
    Key? key,
    required this.statistic,
    required this.isTotal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final localizations = AppLocalizations.of(context)!;

    return Column(
      children: [
        Expanded(
          child: GridView(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3 / 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            children: [
              _buildTile(
                title: localizations.affected,
                value:
                    isTotal ? statistic.totalAffected : statistic.todayAffected,
                color: AppTheme.yellow,
                textTheme: textTheme,
              ),
              _buildTile(
                title: localizations.death,
                value: isTotal ? statistic.totalDeath : statistic.todayDeath,
                color: AppTheme.red,
                textTheme: textTheme,
              ),
              _buildTile(
                title: localizations.recovered,
                value: isTotal
                    ? statistic.totalRecovered
                    : statistic.todayRecovered,
                color: AppTheme.green,
                textTheme: textTheme,
              ),
              _buildTile(
                title: localizations.active,
                value: statistic.active,
                color: AppTheme.lightBlue,
                textTheme: textTheme,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTile({
    required String title,
    required int value,
    required Color color,
    required TextTheme textTheme,
  }) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: textTheme.subtitle2,
            ),
            Text(
              _valueFormat.format(value),
              style: textTheme.subtitle1,
            ),
          ],
        ),
      ),
    );
  }
}
