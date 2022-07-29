import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:neo/constants/links.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../widgets/buttons/branded_button.dart';

class FeatureNotImplementedDialog extends StatelessWidget {
  const FeatureNotImplementedDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
      ),
      elevation: 0,
      backgroundColor: Colors.white,
      child: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child:
                      Image.asset("assets/images/feature_not_implemented.png"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!
                          .feature_not_implemented_title,
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
                      height: 24,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: BrandedButton(
                            onPressed: () {
                              launchUrl(Uri.parse(WEBSITE));
                            },
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
          Positioned(
            left: 6.0,
            top: 12.0,
            child: InkWell(
              splashColor: Theme.of(context).primaryColor,
              overlayColor: MaterialStateProperty.all(
                Theme.of(context).primaryColor.withOpacity(0.25),
              ),
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                height: 20,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  color: Colors.white.withOpacity(0.75),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        Icons.close,
                        size: 18,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
