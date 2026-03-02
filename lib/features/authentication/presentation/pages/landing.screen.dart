//t2 Core Packages Imports
import 'package:flutter/material.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/secondary_button.dart';
import 'sign_in.screen.dart';
import 'sign_up.screen.dart';

//t2 Dependencies Imports
//t3 Services
//t3 Models
//t1 Exports
class LandingScreen extends StatelessWidget {
  //SECTION - Widget Arguments
  //!SECTION
  //
  const LandingScreen({
    Key? key,
  }) : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    //SECTION - Build Setup
    final loc = AppLocalizations.of(context);
    //!SECTION

    //SECTION - Build Return
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight - 48),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/banner.png',
                      width: double.infinity,
                      height: constraints.maxHeight * 0.42,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 16),
                    Text.rich(
                      TextSpan(
                        text: loc.translate('welcome_to'),
                        style: Theme.of(context).textTheme.displaySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                        children: <InlineSpan>[
                          TextSpan(
                            text: loc.translate('glowify'),
                            style:
                                Theme.of(context).textTheme.displaySmall?.copyWith(
                                      color: Theme.of(context).colorScheme.tertiary,
                                    ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      loc.translate('landing_description'),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      child: PrimaryButton(
                        title: loc.translate('sign_in'),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) =>
                                  const SignInScreen(),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: SecondaryButton(
                        title: loc.translate('sign_up'),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) =>
                                  const SignUpScreen(),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );

    //!SECTION
  }
}
