import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

import '../models/statistic.dart';
import '../theme.dart';

class StatisticGrid extends StatelessWidget {
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
        Row(
          children: [
            _buildTile(
              title: localizations.affected,
              value: isTotal ? statistic.cases : statistic.todayCases,
              color: AppTheme.yellow,
              textTheme: textTheme,
            ),
            const SizedBox(width: 16),
            _buildTile(
              title: localizations.deaths,
              value: isTotal ? statistic.deaths : statistic.todayDeaths,
              color: AppTheme.red,
              textTheme: textTheme,
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            _buildTile(
              title: localizations.recovered,
              value: isTotal ? statistic.recovered : statistic.todayRecovered,
              color: AppTheme.green,
              textTheme: textTheme,
            ),
            const SizedBox(width: 16),
            _buildTile(
              title: localizations.active,
              value: statistic.active,
              color: AppTheme.lightBlue,
              textTheme: textTheme,
            ),
            const SizedBox(width: 16),
            _buildTile(
              title: localizations.critical,
              value: statistic.critical,
              color: AppTheme.purpleLight,
              textTheme: textTheme,
            ),
          ],
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
    return Expanded(
      child: DecoratedBox(
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
              const SizedBox(height: 32),
              Text(
                NumberFormat.compact().format(value),
                style: textTheme.subtitle1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
