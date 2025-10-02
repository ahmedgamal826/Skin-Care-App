//t2 Core Packages Imports
import 'package:flutter/material.dart';

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
    //t2 -Values
    //t2 -Values
    //
    //t2 -Widgets
    //t2 -Widgets
    //!SECTION

    //SECTION - Build Return
    return Scaffold(
      // backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          // mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/banner.png',
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 16),
            Text.rich(
              TextSpan(
                text: 'Welcome to ',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                children: <InlineSpan>[
                  TextSpan(
                    text: 'Glowify',
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "your ultimate skincare companion!  Discover personalized skincare routines, expert tips, and the best products tailored just for you.",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            )
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              child: PrimaryButton(
                title: "Sign in",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => const SignInScreen(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: SecondaryButton(
                title: "Sign up",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => const SignUpScreen(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 26),
          ],
        ),
      ),
    );

    //!SECTION
  }
}
