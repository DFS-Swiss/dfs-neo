import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:neo/enums/auth_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../service_locator.dart';
import 'cognito_service.dart';

class AuthenticationService extends ChangeNotifier {
  // Inject dependencies
  CognitoService cognitoService = locator<CognitoService>();
  AuthState authState = AuthState.signedOut;

  Future<String> getCurrentApiKey() async {
    if (cognitoService.getSession() == null) {
      throw "User not authenticated";
    }
    if (cognitoService.getSession()!.idToken.getExpiration() <
        DateTime.now().microsecondsSinceEpoch) {
      if (!await tryRefreshingSession()) {
        throw "Session is expired and could not be restored";
      }
    }
    log(cognitoService.getSession()!.getIdToken().jwtToken!);
    return cognitoService.getSession()!.getIdToken().jwtToken!;
  }

  login(String userName, String password) async {
    cognitoService.createCognitoUser(userName);
    final authDetails = AuthenticationDetails(
      username: userName,
      password: password,
    );

    try {
      cognitoService.setSession(
          await cognitoService.getCognitoUser()!.authenticateUser(authDetails));
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
        cognitoService.getSession()!.refreshToken!.getToken()!);
    prefs.setString("user_name", userName);
    print(cognitoService.getSession()!.getAccessToken().getJwtToken());
    log(cognitoService.getSession()!.getAccessToken().getJwtToken() ?? "Error");
    log(cognitoService.getSession()!.getIdToken().getJwtToken() ?? "Error");
  }

  logOut() async {
    await (await cognitoService.getCurrentPoolUser())!.signOut();
    authState = AuthState.signedOut;
    notifyListeners();
  }

  Future completeForceChangePassword(String newPassword) async {
    if (authState == AuthState.newPasswordRequired &&
        cognitoService.getCognitoUser() != null) {
      try {
        await cognitoService
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
        cognitoService.getCognitoUser() != null) {
      await cognitoService.getCognitoUser()!.confirmRegistration(code);
      authState = AuthState.signedOut;
      notifyListeners();
    }
  }

  Future resendConfirmationCode() async {
    if (authState == AuthState.verifyAccount &&
        cognitoService.getCognitoUser() != null) {
      await cognitoService.getCognitoUser()!.resendConfirmationCode();
    }
  }

  Future<bool> tryRefreshingSession() async {
    if (cognitoService.getSession() != null &&
        cognitoService.getCognitoUser() != null) {
      try {
        cognitoService
            .getCognitoUser()!
            .refreshSession(cognitoService.getSession()!.refreshToken!);
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
      cognitoService.createCognitoUser(prefs.getString("user_name"));
      try {
        cognitoService.setSession(await cognitoService
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
