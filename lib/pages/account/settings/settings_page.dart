import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:neo/hooks/use_theme_state.dart';
import 'package:neo/pages/account/settings/brightness_selectable_widget.dart';
import 'package:neo/service_locator.dart';
import 'package:neo/services/settings_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../settingstile_widget.dart';

class SettingsPage extends HookWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeState = useThemeState();
    final lockApp = useState(false);

    useEffect(() {
      SharedPreferences.getInstance().then((value) {
        lockApp.value = value.getBool("wants_biometric_auth") ?? true;
      });
      return;
    }, ["_"]);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.account_settings),
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: IconButton(
            icon: Icon(
              Icons.arrow_back_outlined,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: ListView(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                child: Text(
                  AppLocalizations.of(context)!.account_security,
                  style: TextStyle(color: Color(0xFF909090), fontSize: 12),
                ),
              ),
              SettingsTile(
                text: AppLocalizations.of(context)!.biometrics_setting,
                value: lockApp.value,
                callback: (v) async {
                  (await SharedPreferences.getInstance())
                      .setBool("wants_biometric_auth", v);
                  lockApp.value = v;
                },
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                child: Text(
                  AppLocalizations.of(context)!.settings_brightness,
                  style: TextStyle(color: Color(0xFF909090), fontSize: 12),
                ),
              ),
              BrightnessSelectable(
                  callback: (state) {
                    locator<SettingsService>().themeState = state;
                  },
                  currentValue: themeState),
            ],
          ),
        ),
      ),
    );
  }
}
