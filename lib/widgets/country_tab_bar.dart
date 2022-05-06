import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
              Tab(text: localizations.country),
              Tab(text: localizations.global),
            ],
          ),
        ),
      ),
    );
  }
}
