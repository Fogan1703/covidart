import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../bloc/statistic.dart';
import '../theme.dart';

class OnboardingPage extends StatefulWidget {
  static const String routeName = 'onboarding';

  const OnboardingPage({Key? key}) : super(key: key);

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  late final PageController _pageController;

  @override
  void initState() {
    _pageController = PageController()
      ..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);

    final _views = [
      _buildItem(
        const AssetImage('assets/images/onboarding/wash_hands.png'),
        localizations.wearMask,
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Volutpat felis sit eget euismod et vulputate. Vitae lacus, maecenas odio ac.',
        theme,
      ),
      _buildItem(
        const AssetImage('assets/images/onboarding/social_distancing.png'),
        localizations.washingHandsSanitizing,
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Volutpat felis sit eget euismod et vulputate. Vitae lacus, maecenas odio ac.',
        theme,
      ),
      _buildItem(
        const AssetImage('assets/images/onboarding/medical_care.png'),
        localizations.physicalDistancing,
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Volutpat felis sit eget euismod et vulputate. Vitae lacus, maecenas odio ac.',
        theme,
      ),
    ];

    final showGo = _pageController.positions.isNotEmpty &&
        _pageController.page != null &&
        _pageController.page! >= _views.length - 1.5;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 64,
          ),
          child: Center(
            child: Column(
              children: [
                Text(
                  'Covidart',
                  style: theme.textTheme.headline5!.copyWith(
                    color: AppTheme.purpleDark,
                  ),
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    children: _views,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _views.length * 2 - 1,
                      (index) {
                        const dotSize = 8.0;
                        const currentDotSize = dotSize * 3;

                        if (index.isOdd) {
                          return const SizedBox(width: dotSize);
                        }

                        index ~/= 2;

                        final progress = 1 -
                            ((_pageController.positions.isNotEmpty &&
                                            _pageController.page != null
                                        ? _pageController.page!
                                        : 0) -
                                    index)
                                .abs()
                                .clamp(0, 1)
                                .toDouble();

                        return SizedBox(
                          height: dotSize,
                          width:
                              dotSize + (currentDotSize - dotSize) * progress,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: Color.lerp(
                                AppTheme.purpleDark.withOpacity(0.25),
                                AppTheme.purpleDark,
                                progress,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (showGo) {
                      context.read<StatisticCubit>().refresh();
                      final prefs = await SharedPreferences.getInstance();
                      prefs.setBool('seen', true);
                    } else {
                      _pageController.nextPage(
                        duration: const Duration(
                          milliseconds: 300,
                        ),
                        curve: Curves.easeIn,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: AppTheme.purpleDark,
                    fixedSize: Size(
                      (mediaQuery.size.width - 48) * 0.75,
                      48,
                    ),
                  ),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    transitionBuilder: (child, animation) {
                      return ScaleTransition(
                        scale: animation,
                        child: FadeTransition(
                          opacity: animation,
                          child: child,
                        ),
                      );
                    },
                    child: Text(
                      showGo ? localizations.go : localizations.next,
                      key: ValueKey<bool>(showGo),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildItem(
    ImageProvider image,
    String title,
    String subtitle,
    ThemeData theme,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Expanded(
            child: Image(
              image: image,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: theme.textTheme.headline5!.copyWith(
              color: AppTheme.purpleDark,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyText2!.copyWith(
              color: AppTheme.purpleDark,
            ),
          ),
        ],
      ),
    );
  }
}
