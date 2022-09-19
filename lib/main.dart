import 'package:bugsnag_flutter/bugsnag_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:neo/enums/app_state.dart';
import 'package:neo/hooks/use_auth_state.dart';
import 'package:neo/hooks/use_brightness.dart';
import 'package:neo/pages/authentication/auth_page_wrapper.dart';
import 'package:neo/pages/navigation/mainnavigation_page.dart';
import 'package:neo/pages/onboarding/onboarding_page.dart';
import 'package:neo/service_locator.dart';
import 'package:neo/services/analytics_service.dart';
import 'package:neo/services/app_state_service.dart';
import 'package:neo/services/authentication_service.dart';
import 'package:neo/services/settings/settings_service.dart';
import 'package:neo/style/dark_material_theme.dart';
import 'package:neo/style/light_material_theme.dart';
import 'package:neo/style/theme.dart';
import 'package:neo/widgets/prefetching_loader.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  locator<SettingsService>().init().then((value) {
    bugsnag.start(
      apiKey: 'cd4315afc1dcc9c6bbeff235758398d3',
      runApp: () => runApp(const MyApp()),
    );
  });
}

class MyApp extends HookWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var brightness = useBrightness();

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
          Locale('de', ''),
        ],
        debugShowCheckedModeBanner: false,
        home: AuthWrapper(),
        theme: brightness == Brightness.light ? lightTheme : darkTheme,
        builder: (context, child) {
          return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
              child: child!);
        },
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
