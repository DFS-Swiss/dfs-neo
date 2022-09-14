import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
import 'package:neo/service_locator.dart';
import 'package:neo/services/authentication/authentication_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BiometricAuth {
  Future ensureAuthed({required String localizedReason}) async {
    //Switch to disable in debug for convenience
    if (kDebugMode) {
      return;
    }

    print("Requested auth");
    final LocalAuthentication auth = LocalAuthentication();
    final prefs = await SharedPreferences.getInstance();
    // ···

    if (prefs.getBool("wants_biometric_auth") ?? true) {
      try {
        final bool didAuthenticate =
            await auth.authenticate(localizedReason: localizedReason);
        if (!didAuthenticate) {
          await locator<AuthenticationService>().logOut();
        }
        return didAuthenticate;
      } on PlatformException catch (e) {
        if (e.code == auth_error.notEnrolled) {
          await locator<AuthenticationService>().logOut();
          await prefs.setBool("wants_biometric_auth", false);
        } else if (e.code == auth_error.lockedOut ||
            e.code == auth_error.permanentlyLockedOut) {
          await locator<AuthenticationService>().logOut();
          await prefs.setBool("wants_biometric_auth", false);
        } else if (e.code == "auth_in_progress") {
        } else {
          await locator<AuthenticationService>().logOut();
          await prefs.setBool("wants_biometric_auth", false);
        }
      }
    }
  }
}
