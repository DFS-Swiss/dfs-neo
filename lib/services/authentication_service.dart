import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:neo/enums/auth_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../service_locator.dart';
import 'cognito_service.dart';

class AuthenticationService extends ChangeNotifier {
  // Inject dependencies
  final CognitoService _cognitoService = locator<CognitoService>();
  AuthState authState = AuthState.signedOut;

  Future<String> getCurrentApiKey() async {
    if (_cognitoService.getSession() == null) {
      throw "User not authenticated";
    }
    if (_cognitoService.getSession()!.idToken.getExpiration() <
        DateTime.now().microsecondsSinceEpoch) {
      if (!await tryRefreshingSession()) {
        throw "Session is expired and could not be restored";
      }
    }
    log(_cognitoService.getSession()!.getIdToken().jwtToken!);
    return _cognitoService.getSession()!.getIdToken().jwtToken!;
  }

  login(String userName, String password) async {
    _cognitoService.createCognitoUser(userName);
    final authDetails = AuthenticationDetails(
      username: userName,
      password: password,
    );

    try {
      _cognitoService.setSession(await _cognitoService
          .getCognitoUser()!
          .authenticateUser(authDetails));
    } on CognitoUserNewPasswordRequiredException catch (e) {
      print(e);
      authState = AuthState.newPasswordRequired;
      notifyListeners();
      return;
    } on CognitoUserMfaRequiredException catch (e) {
      print(e);
      rethrow;

      // handle SMS_MFA challenge
    } on CognitoUserSelectMfaTypeException catch (e) {
      print(e);
      rethrow;

      // handle SELECT_MFA_TYPE challenge
    } on CognitoUserMfaSetupException catch (e) {
      print(e);
      rethrow;

      // handle MFA_SETUP challenge
    } on CognitoUserTotpRequiredException catch (e) {
      print(e);
      rethrow;

      // handle SOFTWARE_TOKEN_MFA challenge
    } on CognitoUserCustomChallengeException catch (e) {
      print(e);
      rethrow;

      // handle CUSTOM_CHALLENGE challenge
    } on CognitoUserConfirmationNecessaryException catch (e) {
      print(e);
      authState = AuthState.verifyAccount;
      notifyListeners();
      rethrow;
    } on CognitoClientException catch (e) {
      print(e);
      rethrow;
      // handle Wrong Username and Password and Cognito Client

    } catch (e) {
      print(e);
      rethrow;
    }
    authState = AuthState.signedIn;
    notifyListeners();
    // TODO: Use secure storage
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("refresh_token",
        _cognitoService.getSession()!.refreshToken!.getToken()!);
    prefs.setString("user_name", userName);
    print(_cognitoService.getSession()!.getAccessToken().getJwtToken());
    log(_cognitoService.getSession()!.getAccessToken().getJwtToken() ??
        "Error");
    log(_cognitoService.getSession()!.getIdToken().getJwtToken() ?? "Error");
  }

  logOut() async {
    await (await _cognitoService.getCurrentPoolUser())!.signOut();
    authState = AuthState.signedOut;
    notifyListeners();
  }

  Future completeForceChangePassword(String newPassword) async {
    if (authState == AuthState.newPasswordRequired &&
        _cognitoService.getCognitoUser() != null) {
      try {
        await _cognitoService
            .getCognitoUser()!
            .sendNewPasswordRequiredAnswer(newPassword);
      } catch (e) {
        rethrow;
      }
      authState = AuthState.signedOut;
      notifyListeners();
    }
  }

  Future confirmEmail(String code) async {
    if (authState == AuthState.verifyAccount &&
        _cognitoService.getCognitoUser() != null) {
      await _cognitoService.getCognitoUser()!.confirmRegistration(code);
      authState = AuthState.signedOut;
      notifyListeners();
    }
  }

  Future resendConfirmationCode() async {
    if (authState == AuthState.verifyAccount &&
        _cognitoService.getCognitoUser() != null) {
      await _cognitoService.getCognitoUser()!.resendConfirmationCode();
    }
  }

  Future<bool> tryRefreshingSession() async {
    if (_cognitoService.getSession() != null &&
        _cognitoService.getCognitoUser() != null) {
      try {
        _cognitoService
            .getCognitoUser()!
            .refreshSession(_cognitoService.getSession()!.refreshToken!);
        return true;
      } catch (e) {
        print(e);
        authState = AuthState.signedOut;
        notifyListeners();
        return false;
      }
    }
    throw "Could not reresh session; Missing user or session object";
  }

  Future<bool> tryReauth() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString("refresh_token") != null &&
        prefs.getString("user_name") != null) {
      // TODO: We need constants for these strings. We should use constants for all strings in general
      _cognitoService.createCognitoUser(prefs.getString("user_name"));
      try {
        _cognitoService.setSession(await _cognitoService
            .getCognitoUser()!
            .refreshSession(
                CognitoRefreshToken(prefs.getString("refresh_token"))));
        authState = AuthState.signedIn;
        notifyListeners();
        return true;
      } catch (e) {
        return false;
      }
    }
    return false;
  }
}
