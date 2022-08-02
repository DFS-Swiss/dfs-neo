import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:neo/constants/links.dart';
import 'package:neo/widgets/buttons/branded_button.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../service_locator.dart';
import '../../services/analytics_service.dart';

class FeatureNotImplemented extends HookWidget {
  const FeatureNotImplemented({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      locator<AnalyticsService>().trackEvent("display:debug_deposit");
      return;
    }, ["_"]);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_outlined,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 70),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Image.asset("assets/images/feature_not_implemented.png"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.feature_not_implemented_title,
                    style: Theme.of(context)
                        .textTheme
                        .headlineLarge!
                        .copyWith(color: Color(0xFF05889C)),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Text(
                    AppLocalizations.of(context)!
                        .feature_not_implemented_subtitle,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Text(
                    AppLocalizations.of(context)!
                        .feature_not_implemented_wait_list_info,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: BrandedButton(
                          onPressed: () => launchUrl(Uri.parse(WEBSITE)),
                          child: Text(AppLocalizations.of(context)!
                              .feature_not_implemented_visit_website),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
