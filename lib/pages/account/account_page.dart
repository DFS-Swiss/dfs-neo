import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:neo/constants/links.dart';
import 'package:neo/hooks/use_user_data.dart';
import 'package:neo/pages/account/bottomtexttile_widget.dart';
import 'package:neo/pages/account/change_password_page.dart';
import 'package:neo/pages/account/logout_widget.dart';
import 'package:neo/pages/account/middletexttile_widget.dart';
import 'package:neo/pages/account/settingstile_widget.dart';
import 'package:neo/pages/account/texttile_widget.dart';
import 'package:neo/pages/account/toptexttile_widget.dart';
import 'package:neo/utils/display_popup.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../service_locator.dart';
import '../../services/analytics_service.dart';

class AccountPage extends HookWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loading = useState<bool>(true);
    final usePackageInfo = useState<PackageInfo?>(null);
    final userData = useUserData();
    final usernamecontroller = useTextEditingController(text: "...");
    final mailcontroller = useTextEditingController(text: "...");

    final lockApp = useState(false);

    useEffect(() {
      if (loading.value) {
        PackageInfo.fromPlatform().then((f) {
          loading.value = false;
          usePackageInfo.value = f;
        });
      }
    }, [loading.value]);

    useEffect(() {
      if (!userData.loading) usernamecontroller.text = userData.data!.id;
      if (!userData.loading) mailcontroller.text = userData.data!.email;
      return;
    }, [userData.loading]);

    useEffect(() {
      SharedPreferences.getInstance().then((value) {
        lockApp.value = value.getBool("wants_biometric_auth") ?? true;
      });
      return;
    }, ["_"]);

    useEffect(() {
      locator<AnalyticsService>().trackEvent("display:account");
      return;
    }, ["_"]);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.account_title),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            child: Theme(
              data: ThemeData(
                inputDecorationTheme: InputDecorationTheme(
                  focusColor: Color(0xFF202532),
                  floatingLabelStyle: TextStyle(color: Color(0xFF202532)),
                  suffixIconColor: Colors.grey,
                ),
              ),
              child: TextFormField(
                enabled: false,
                autofocus: false,
                controller: usernamecontroller,
                decoration: InputDecoration(
                  suffix: userData.loading
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.grey,
                            strokeWidth: 3,
                          ))
                      : Icon(
                          Icons.check_circle,
                          color: Theme.of(context).primaryColor,
                          size: 20,
                        ),
                  labelText: AppLocalizations.of(context)!.account_user,
                  labelStyle: TextStyle(color: Color(0xFF202532)),
                  isDense: true,
                  contentPadding: EdgeInsets.only(bottom: 8),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            child: Theme(
              data: ThemeData(
                inputDecorationTheme: InputDecorationTheme(
                  focusColor: Color(0xFF202532),
                  floatingLabelStyle: TextStyle(color: Color(0xFF202532)),
                  suffixIconColor: Colors.grey,
                ),
              ),
              child: TextFormField(
                enabled: false,
                autofocus: false,
                controller: mailcontroller,
                decoration: InputDecoration(
                  suffix: userData.loading
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.grey,
                            strokeWidth: 3,
                          ))
                      : Icon(
                          Icons.check_circle,
                          color: Theme.of(context).primaryColor,
                          size: 20,
                        ),
                  labelText: AppLocalizations.of(context)!.account_mail,
                  labelStyle: TextStyle(color: Color(0xFF202532)),
                  isDense: true,
                  contentPadding: EdgeInsets.only(bottom: 8),
                ),
              ),
            ),
          ),
          TextTile(
            text: AppLocalizations.of(context)!.account_changepass,
            callback: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChangePasswordPage(),
                ),
              );
            },
          ),
          TextTile(
            text: AppLocalizations.of(context)!.account_delacc,
            callback: () {
              displayInfoPage(context);
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
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
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            child: Text(
              AppLocalizations.of(context)!.account_links,
              style: TextStyle(color: Color(0xFF909090), fontSize: 12),
            ),
          ),
          TopTextTile(AppLocalizations.of(context)!.account_open, () {
            launchUrl(Uri.parse(OPENSOURCE_PROJECTS));
          }),
          Divider(
            color: Color(0xFFEFEFEF),
            height: 0,
            thickness: 1,
            indent: 20,
            endIndent: 20,
          ),
          MiddleTextTile(AppLocalizations.of(context)!.account_imprint, () {
            launchUrl(Uri.parse(IMPRINT));
          }),
          Divider(
            color: Color(0xFFEFEFEF),
            height: 0,
            thickness: 1,
            indent: 20,
            endIndent: 20,
          ),
          MiddleTextTile(AppLocalizations.of(context)!.account_privacy, () {
            launchUrl(Uri.parse(ACCOUNT_PRIVACY));
          }),
          Divider(
            color: Color(0xFFEFEFEF),
            height: 0,
            thickness: 1,
            indent: 20,
            endIndent: 20,
          ),
          BottomTextTile(AppLocalizations.of(context)!.account_contact,
              () async {
            final Uri emailLaunchUri = Uri(
              scheme: 'mailto',
              path: 'nils@dfsneo.com',
              queryParameters: {
                'subject':
                    'Supportrequest from DFSneo App - Version ${usePackageInfo.value!.version}'
              },
            );
            launchUrl(emailLaunchUri);
            if (await canLaunchUrl(emailLaunchUri)) {
            } else {
              throw 'Could not launch $emailLaunchUri';
            }
          }),
          LogoutTextButton(),
          SizedBox(
            height: 24,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(!loading.value
                  ? "App version ${usePackageInfo.value!.version}"
                  : ""),
            ],
          ),
          SizedBox(
            height: 24,
          ),
        ],
      ),
    );
  }
}
