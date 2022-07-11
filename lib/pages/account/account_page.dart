import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:neo/hooks/use_user_data.dart';
import 'package:neo/pages/account/bottomtexttile_widget.dart';
import 'package:neo/pages/account/logout_widget.dart';
import 'package:neo/pages/account/middletexttile_widget.dart';
import 'package:neo/pages/account/texttile_widget.dart';
import 'package:neo/pages/account/toptexttile_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class AccountPage extends HookWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userData = useUserData();
    final usernamecontroller = useTextEditingController(text: "...");
    final mailcontroller = useTextEditingController(text: "...");

    useEffect(() {
      if (!userData.loading) usernamecontroller.text = userData.data!.id;
      if (!userData.loading) mailcontroller.text = userData.data!.email;
      return;
    }, [userData.loading]);

    String? encodeQueryParameters(Map<String, String> params) {
      return params.entries
          .map((e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
          .join('&');
    }

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
              //TODO: Implement change passwort
            },
          ),
          TextTile(
            text: AppLocalizations.of(context)!.account_delacc,
            callback: () {
              //TODO: Implement delete account
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
            //TODO: Implement callback
          }),
          Divider(
            color: Color(0xFFEFEFEF),
            height: 0,
            thickness: 1,
            indent: 20,
            endIndent: 20,
          ),
          MiddleTextTile(AppLocalizations.of(context)!.account_imprint, () {
            //TODO: Implement callback
          }),
          Divider(
            color: Color(0xFFEFEFEF),
            height: 0,
            thickness: 1,
            indent: 20,
            endIndent: 20,
          ),
          MiddleTextTile(AppLocalizations.of(context)!.account_privacy, () {
            //TODO: Implement callback
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
              path: 'support@dfsneo.com',
              query: encodeQueryParameters(<String, String>{
                'subject': 'Example Subject & Symbols are allowed!'
              }),
            );
            launchUrl(emailLaunchUri);
            if (await canLaunchUrl(emailLaunchUri)) {
            } else {
              throw 'Could not launch $emailLaunchUri';
            }
          }),
          LogoutTextButton()
        ],
      ),
    );
  }
}
