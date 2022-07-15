import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:neo/pages/tutorial/backgroundgraphic_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:neo/pages/tutorial/tutorialwrapper_page.dart';
import 'package:neo/style/theme.dart';
import 'package:neo/widgets/branded_button.dart';

import '../../enums/app_state.dart';
import '../../service_locator.dart';
import '../../services/app_state_service.dart';

class Onboarding extends HookWidget {
  const Onboarding({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final phase = useState(0);

    return Scaffold(
      body: phase.value == 0
          ? Stack(
              children: [
                BackgroundGraphic(
                  drawCircle: false,
                ),
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 100,
                          vertical: MediaQuery.of(context).size.height * 0.1),
                      child: Image.asset("assets/dfsicon.png"),
                    ),
                    Text(
                      AppLocalizations.of(context)!.onboard_welcome,
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      AppLocalizations.of(context)!.onboard_welcome_slogan,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Image.asset("assets/images/graph.png"),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 24),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: BrandedButton(
                                onPressed: () {
                                  phase.value = 1;
                                },
                                child: Text(
                                  AppLocalizations.of(context)!.onboard_button,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(color: Colors.white),
                                )),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      AppLocalizations.of(context)!.onboard_subtitle,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: (() {
                            locator<AppStateService>().state =
                                AppState.signedOut;
                          }),
                          child: Text(
                            AppLocalizations.of(context)!.onboard_signin1,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    color: NeoTheme.of(context)!
                                        .linkTextStyle
                                        .color,
                                    decoration: TextDecoration.underline),
                          ),
                        ),
                        Text(
                          AppLocalizations.of(context)!.onboard_signin2,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            )
          : TutorialWrapper(),
    );
  }
}
