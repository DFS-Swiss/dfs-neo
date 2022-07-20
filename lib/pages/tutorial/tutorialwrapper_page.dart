import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:neo/enums/app_state.dart';
import 'package:neo/pages/tutorial/backgroundgraphic_widget.dart';
import 'package:neo/pages/tutorial/customprogressindicator_widget.dart';
import 'package:neo/pages/tutorial/tutorialcontent_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:neo/service_locator.dart';
import 'package:neo/services/app_state_service.dart';
import 'package:neo/widgets/buttons/branded_button.dart';

class TutorialWrapper extends HookWidget {
  TutorialWrapper({Key? key}) : super(key: key);

  final PageController _pageViewController = PageController(
    initialPage: 0,
  );
  @override
  Widget build(BuildContext context) {
    final currentPage = useState<int?>(null);
    useEffect(() {
      if (currentPage.value != null) {
        _pageViewController.animateToPage(currentPage.value ?? 0,
            duration: Duration(milliseconds: 400), curve: Curves.ease);
      }
      return;
    }, [currentPage.value]);
    return Stack(
      children: [
        BackgroundGraphic(
          drawCircle: true,
        ),
        Padding(
          padding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height * 0.2),
          child: SizedBox(
            child: PageView(
              onPageChanged: (a) {
                currentPage.value = a;
              },
              controller: _pageViewController,
              children: [
                TutorialContent(
                    image: "assets/images/tutorial1.png",
                    headline: AppLocalizations.of(context)!.tutorial_head1,
                    subtext: AppLocalizations.of(context)!.tutorial_body1),
                TutorialContent(
                    image: "assets/images/tutorial2.png",
                    headline: AppLocalizations.of(context)!.tutorial_head2,
                    subtext: AppLocalizations.of(context)!.tutorial_body2),
                TutorialContent(
                    image: "assets/images/tutorial3.png",
                    headline: AppLocalizations.of(context)!.tutorial_head3,
                    subtext: AppLocalizations.of(context)!.tutorial_body3),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.8,
              left: 24,
              right: 24),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              CustomProgressIndicator(
                triggered: currentPage.value == null || currentPage.value == 0
                    ? true
                    : false,
              ),
              CustomProgressIndicator(
                triggered: currentPage.value == 1 ? true : false,
              ),
              CustomProgressIndicator(
                triggered: currentPage.value == 2 ? true : false,
              ),
              Expanded(child: Container()),
              BrandedButton(
                  child: Container(
                    width: 120,
                    alignment: Alignment.center,
                    child: Text(
                      currentPage.value == 2 ? "Get Started" : "Next",
                    ),
                  ),
                  onPressed: () {
                    if (currentPage.value == 2) {
                      locator<AppStateService>().state = AppState.register;
                    } else {
                      if (currentPage.value == null || currentPage.value == 0) {
                        currentPage.value = 1;
                      } else {
                        currentPage.value = currentPage.value! + 1;
                      }
                    }
                  }),
            ],
          ),
        )
      ],
    );
  }
}
