import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:neo/enums/auth_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationService extends ChangeNotifier {
  static final _userPool = CognitoUserPool(
    'eu-central-1_I3SXMv01c',
    '45pmj4rj6amqlvh337p9dsafh4',
  );

  static AuthenticationService? _instance;
  AuthenticationService._();

  static AuthenticationService getInstance() {
    return _instance ??= AuthenticationService._();
  }

  AuthState authState = AuthState.signedOut;
  CognitoUserSession? session;
  CognitoUser? cognitoUser;

  Future<String> getCurrentApiKey() async {
    if (session == null) {
      throw "User not authenticated";
    }
    if (session!.idToken.getExpiration() <
        DateTime.now().microsecondsSinceEpoch) {
      if (!await tryRefreshingSession()) {
        throw "Session is expired and could not be restored";
      }
    }
    log(session!.getIdToken().jwtToken!);
    return session!.getIdToken().jwtToken!;
  }

  login(String userName, String password) async {
    cognitoUser = CognitoUser(userName, _userPool);
    final authDetails = AuthenticationDetails(
      username: userName,
      password: password,
    );

    try {
      session = await cognitoUser!.authenticateUser(authDetails);
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
    prefs.setString("refresh_token", session!.refreshToken!.getToken()!);
    prefs.setString("user_name", userName);
    print(session!.getAccessToken().getJwtToken());
    log(session!.getAccessToken().getJwtToken() ?? "Error");
    log(session!.getIdToken().getJwtToken() ?? "Error");
  }

  logOut() async {
    await (await _userPool.getCurrentUser())!.signOut();
    authState = AuthState.signedOut;
    notifyListeners();
  }

  Future register(String userName, String email, String password) async {
    await _userPool.signUp(userName, password, userAttributes: [
      AttributeArg(name: "email", value: email),
    ], validationData: [
      AttributeArg(name: "email", value: email)
    ]);
    await login(userName, password);
  }

  Future completeForceChangePassword(String newPassword) async {
    if (authState == AuthState.newPasswordRequired && cognitoUser != null) {
      try {
        await cognitoUser!.sendNewPasswordRequiredAnswer(newPassword);
      } catch (e) {
        rethrow;
      }
      authState = AuthState.signedOut;
      notifyListeners();
    }
  }

  Future confirmEmail(String code) async {
    if (authState == AuthState.verifyAccount && cognitoUser != null) {
      await cognitoUser!.confirmRegistration(code);
      authState = AuthState.signedOut;
      notifyListeners();
    }
  }

  Future resendConfirmationCode() async {
    if (authState == AuthState.verifyAccount && cognitoUser != null) {
      await cognitoUser!.resendConfirmationCode();
    }
  }

  Future<bool> tryRefreshingSession() async {
    if (session != null && cognitoUser != null) {
      try {
        cognitoUser!.refreshSession(session!.refreshToken!);
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
      cognitoUser = CognitoUser(prefs.getString("user_name")!, _userPool);
      try {
        session = await cognitoUser!.refreshSession(
            CognitoRefreshToken(prefs.getString("refresh_token")));
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
