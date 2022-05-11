import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../bloc/statistic.dart';
import '../theme.dart';

class NoConnectionPage extends StatelessWidget {
  static const String routeName = 'no_connection';

  const NoConnectionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Spacer(),
            Text(
              localizations.oops,
              textAlign: TextAlign.center,
              style: theme.textTheme.headline5!.copyWith(
                color: AppTheme.purpleDark,
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: mediaQuery.size.width * 0.75,
              child: Text(
                localizations.noInternetConnection,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyText2!.copyWith(
                  color: AppTheme.purpleDark,
                ),
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: context.read<StatisticCubit>().refresh,
              child: Text(localizations.reload),
            ),
          ],
        ),
      ),
    );
  }
}
