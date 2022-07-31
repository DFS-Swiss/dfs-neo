import 'package:bugsnag_flutter/bugsnag_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neo/enums/app_state.dart';
import 'package:neo/hooks/use_auth_state.dart';
import 'package:neo/pages/authentication/auth_page_wrapper.dart';
import 'package:neo/pages/navigation/mainnavigation_page.dart';
import 'package:neo/pages/onboarding/onboarding_page.dart';
import 'package:neo/service_locator.dart';
import 'package:neo/services/analytics_service.dart';
import 'package:neo/services/app_state_service.dart';
import 'package:neo/services/authentication_service.dart';
import 'package:neo/style/theme.dart';
import 'package:neo/widgets/prefetching_loader.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();

  bugsnag.start(
    apiKey: 'cd4315afc1dcc9c6bbeff235758398d3',
    runApp: () => runApp(const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NeoTheme(
      child: MaterialApp(
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
            bottomNavigationBarTheme: BottomNavigationBarThemeData(
              selectedIconTheme: IconThemeData(
                color: Color(0xFF05889C),
              ),
              selectedItemColor: Color(0xFF05889C),
            ),
            appBarTheme: AppBarTheme(
                backgroundColor: Color(0xFFF8F9FB),
                elevation: 0,
                systemOverlayStyle: SystemUiOverlayStyle.dark,
                titleTextStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                )),
            textButtonTheme: TextButtonThemeData(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all(
                  Color(0xFF909090),
                ),
                overlayColor: MaterialStateProperty.all(Colors.grey[200]),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              ),
            ),
            progressIndicatorTheme:
                ProgressIndicatorThemeData(color: Colors.white),
            scaffoldBackgroundColor: Color(0xFFF8F9FB),
            backgroundColor: Colors.white,
            primaryColor: const Color.fromRGBO(32, 209, 209, 1),
            inputDecorationTheme: InputDecorationTheme(
              focusColor: Color.fromRGBO(32, 209, 209, 1),
              floatingLabelStyle:
                  TextStyle(color: Color.fromRGBO(32, 209, 209, 1)),
              suffixIconColor: Colors.grey,
              hintStyle: TextStyle(
                  color: Colors.grey.withOpacity(0.8),
                  fontSize: 12,
                  height: 2.2),
              focusedBorder: const UnderlineInputBorder(
                borderSide: const BorderSide(
                    color: Color.fromRGBO(32, 209, 209, 1), width: 2.0),
              ),
            ),
            textTheme: GoogleFonts.urbanistTextTheme(
              TextTheme(
                titleSmall: TextStyle(
                  color: Color.fromRGBO(187, 187, 187, 1),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
                labelSmall: TextStyle(
                  color: Color(0xFF909090),
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                ),
                labelMedium: TextStyle(
                    color: Color(0xFF202532),
                    fontSize: 12,
                    fontWeight: FontWeight.w600),
                bodySmall: TextStyle(
                  color: Color.fromRGBO(144, 144, 144, 1),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
                bodyMedium: TextStyle(
                  color: Color.fromRGBO(32, 37, 50, 1),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                bodyLarge: TextStyle(
                  color: Color.fromRGBO(32, 37, 50, 1),
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
                headlineMedium: TextStyle(
                  color: Color.fromRGBO(32, 37, 50, 1),
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                headlineLarge: TextStyle(
                  color: Color.fromRGBO(32, 37, 50, 1),
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )),
        home: AuthWrapper(),
      ),
    );
  }
}

class AuthWrapper extends HookWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthenticationService authenticationService =
        locator<AuthenticationService>();
    AppStateService appStateService = locator<AppStateService>();
    final authState = useAppState();
    final tryingToReauth = useState(true);
    final isWaitingForFirstRun = useState(true);

    useEffect(() {
      locator<AnalyticsService>().init().then((value) {
        authenticationService.tryReauth().then((value) {
          tryingToReauth.value = false;
          appStateService.init().then((value) {
            isWaitingForFirstRun.value = false;
          });
        });
      });

      return;
    }, ["_"]);

    if (tryingToReauth.value || isWaitingForFirstRun.value) {
      return const Scaffold(
        body: PrefetchingLoader(),
      );
    }
    if (authState == AppState.onboarding) {
      return const Onboarding();
    }
    if (authState == AppState.signedOut ||
        authState == AppState.verifyAccount ||
        authState == AppState.newPasswordRequired ||
        authState == AppState.register) {
      return AuthPageWrapper();
    }
    //TODO: Handle basic wrapper for multiple pages via bottom nav bar
    if (authState == AppState.signedIn) return const MainNavigation();
    // if (authState == AppState.signedIn) return const MainPage();
    return const Scaffold(
      body: Center(child: Text("Unknown state")),
    );
  }
}
