import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../theme.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final localizations = AppLocalizations.of(context)!;

    return Column(
      children: [
        DecoratedBox(
          decoration: const BoxDecoration(
            color: AppTheme.purple,
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(40),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Covid-19',
                  style: theme.textTheme.headline5,
                ),
                const SizedBox(height: 32),
                Text(
                  localizations.areYouFeelingSick,
                  style: theme.textTheme.subtitle1,
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: mediaQuery.size.width * 0.75,
                  child: Text(
                    localizations.ifYouFeelSick,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.phone),
                        label: Text(localizations.callNow),
                        style: ElevatedButton.styleFrom(
                          primary: AppTheme.red,
                        ),
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.sms),
                        label: Text(localizations.sendSMS),
                        style: ElevatedButton.styleFrom(
                          primary: AppTheme.blue,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Spacer(flex: 1),
                Text(
                  localizations.prevention,
                  style: theme.textTheme.headline6!.copyWith(
                    color: AppTheme.purpleDark,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildPreventionItem(
                      localizations.wearMask,
                      const AssetImage('assets/images/use_mask.png'),
                      theme,
                      mediaQuery,
                    ),
                    _buildPreventionItem(
                      localizations.washHandsOften,
                      const AssetImage('assets/images/wash_hands.png'),
                      theme,
                      mediaQuery,
                    ),
                    _buildPreventionItem(
                      localizations.avoidCloseContact,
                      const AssetImage('assets/images/close_contact.png'),
                      theme,
                      mediaQuery,
                    ),
                  ],
                ),
                const Spacer(flex: 2),
                _buildDoTest(theme, mediaQuery, localizations),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPreventionItem(
    String title,
    ImageProvider image,
    ThemeData theme,
    MediaQueryData mediaQuery,
  ) {
    final width = (mediaQuery.size.width - 48) / 3 - 24 * (2 / 3);

    return SizedBox(
      width: width,
      child: Column(
        children: [
          SizedBox.square(
            dimension: width,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: AppTheme.red.withOpacity(0.075),
                shape: BoxShape.circle,
              ),
              child: Image(
                image: image,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyText1!.copyWith(
              color: AppTheme.purpleDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDoTest(
    ThemeData theme,
    MediaQueryData mediaQuery,
    AppLocalizations localizations,
  ) {
    final contentWidth = mediaQuery.size.width - 48;

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: [
            AppTheme.purple.withOpacity(0.6),
            AppTheme.purple,
          ],
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.centerRight,
            children: [
              Positioned(
                left: 12,
                bottom: 0,
                top: -24,
                width: contentWidth / 3 - 12,
                child: Image.asset('assets/images/doctor.png'),
              ),
              SizedBox(
                width: contentWidth / 1.5,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        localizations.doYourOwnTest,
                        style: theme.textTheme.headline6,
                      ),
                      Text(localizations.followTheInstructions),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
