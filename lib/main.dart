import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:neo/enums/auth_state.dart';
import 'package:neo/hooks/use_auth_state.dart';
import 'package:neo/pages/authentication/auth_page_wrapper.dart';
import 'package:neo/pages/authentication/login_widget.dart';
import 'package:neo/pages/main_page.dart';
import 'package:neo/services/authentication_service.dart';
import 'package:neo/style/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DFS Neo',
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        AppLocalizations.delegate
      ],
      supportedLocales: const [
        Locale('en', ''), // English, no country code
      ],
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        progressIndicatorTheme: ProgressIndicatorThemeData(color: Colors.white),
        scaffoldBackgroundColor: Color.fromARGB(255, 234, 248, 250),
        backgroundColor: Colors.white,
        primaryColor: const Color.fromRGBO(32, 209, 209, 1),
        inputDecorationTheme: InputDecorationTheme(
          focusColor: Color.fromRGBO(32, 209, 209, 1),
          floatingLabelStyle: TextStyle(color: Color.fromRGBO(32, 209, 209, 1)),
          suffixIconColor: Colors.grey,
          hintStyle: TextStyle(
              color: Colors.grey.withOpacity(0.8), fontSize: 12, height: 2.2),
          focusedBorder: const UnderlineInputBorder(
            borderSide: const BorderSide(
                color: Color.fromRGBO(32, 209, 209, 1), width: 2.0),
          ),
        ),
        textTheme: const TextTheme(
          titleSmall: TextStyle(
            color: Color.fromRGBO(187, 187, 187, 1),
            fontFamily: "Urbanist",
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          bodySmall: TextStyle(
            color: Color.fromRGBO(144, 144, 144, 1),
            fontFamily: "Urbanist",
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          bodyMedium: TextStyle(
            color: Color.fromRGBO(32, 37, 50, 1),
            fontFamily: "Urbanist",
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          headlineMedium: TextStyle(
            color: Color.fromRGBO(32, 37, 50, 1),
            fontFamily: "Urbanist",
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          headlineLarge: TextStyle(
            color: Color.fromRGBO(32, 37, 50, 1),
            fontFamily: "Urbanist",
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      home: NeoTheme(child: const AuthWrapper()),
    );
  }
}

class AuthWrapper extends HookWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authState = useAuthState();
    final tryingToReauth = useState(true);
    useEffect(() {
      AuthenticationService.getInstance().tryReauth().then((value) {
        tryingToReauth.value = false;
      });
      return;
    }, ["_"]);

    if (tryingToReauth.value) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    if (authState == AuthState.signedOut) return const AuthPageWrapper();
    if (authState == AuthState.signedIn) return const MainPage();
    return const Scaffold(
      body: Center(child: Text("Unknown state")),
    );
  }
}
