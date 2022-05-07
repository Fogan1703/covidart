import 'package:country/country.dart';
import 'package:covidart/bloc/statistic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../theme.dart';

class CountrySelector extends StatefulWidget {
  const CountrySelector({Key? key}) : super(key: key);

  @override
  State<CountrySelector> createState() => _CountrySelectorState();
}

class _CountrySelectorState extends State<CountrySelector> {
  bool _isSelecting = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context)!;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () async {
        setState(() {
          _isSelecting = true;
        });

        await showModalBottomSheet(
          context: context,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(32),
            ),
          ),
          builder: (context) => const CountrySelectorBottomSheet(),
        );

        if (mounted) {
          setState(() {
            _isSelecting = false;
          });
        }
      },
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(36),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 4,
            horizontal: 8,
          ),
          child: Row(
            children: [
              BlocBuilder<StatisticCubit, StatisticState>(
                builder: (context, state) {
                  state = state as StatisticSuccess;
                  final country = state.countryStatistic?.country;

                  return Text(
                    country != null
                        ? ('${country.flagEmoji} ${country.isoShortName}')
                        : localizations.selectCountry,
                    style: theme.textTheme.bodyText1!.copyWith(
                      color: AppTheme.purpleDark,
                    ),
                  );
                },
              ),
              AnimatedRotation(
                turns: _isSelecting ? -0.5 : 0,
                duration: const Duration(milliseconds: 150),
                child: const Icon(Icons.arrow_drop_down),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CountrySelectorBottomSheet extends StatefulWidget {
  const CountrySelectorBottomSheet({Key? key}) : super(key: key);

  @override
  State<CountrySelectorBottomSheet> createState() =>
      _CountrySelectorBottomSheetState();
}

class _CountrySelectorBottomSheetState
    extends State<CountrySelectorBottomSheet> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locale = Intl.getCurrentLocale().split('_').first;
    final countries = Countries.values
        .where(
          (country) => country.isoLongName.contains(_controller.text),
        )
        .toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(24),
          child: TextField(
            controller: _controller,
            textCapitalization: TextCapitalization.sentences,
            style: theme.textTheme.bodyText2!.copyWith(
              color: AppTheme.purpleDark,
              fontSize: 16,
            ),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(32),
              ),
              prefixIcon: const Icon(Icons.search),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: countries.length,
            itemBuilder: (context, index) {
              final country = countries[index];

              return Material(
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pop();

                    context.read<StatisticCubit>().refresh(newCountry: country);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 24,
                    ),
                    child: Row(
                      children: [
                        Text(
                          country.flagEmoji,
                          style: const TextStyle(fontSize: 32),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            country.isoShortNameByLanguage[locale] ??
                                country.isoShortName,
                            maxLines: 1,
                            softWrap: false,
                            overflow: TextOverflow.fade,
                            style: theme.textTheme.bodyText2!.copyWith(
                              color: AppTheme.purpleDark,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
