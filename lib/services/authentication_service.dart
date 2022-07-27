import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:neo/enums/app_state.dart';
import 'package:neo/services/app_state_service.dart';
import 'package:neo/services/data_service.dart';
import 'package:neo/services/stockdata_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../service_locator.dart';
import 'cognito_service.dart';

class AuthenticationService extends ChangeNotifier {
  // Inject dependencies
  final CognitoService _cognitoService = locator<CognitoService>();
  final AppStateService _appStateService = locator<AppStateService>();

  Future<String> getCurrentApiKey() async {
    if (!_cognitoService.isSessionPresent()) {
      throw "User not authenticated";
    }
    if (_cognitoService.isIdTokenExpired()) {
      if (!await tryRefreshingSession()) {
        throw "Session is expired and could not be restored";
      }
    }
    return _cognitoService.getIdJwtToken()!;
  }

  login(String userName, String password) async {
    try {
      await _cognitoService.createAndAuthenticateUser(userName, password);
    } on CognitoUserNewPasswordRequiredException catch (e) {
      print(e);
      _appStateService.state = AppState.newPasswordRequired;
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
      _appStateService.state = AppState.verifyAccount;
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
    _appStateService.state = AppState.signedIn;
    notifyListeners();
    // TODO: Use secure storage
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("refresh_token", _cognitoService.getRefreshToken()!);
    prefs.setString("user_name", userName);
    print(_cognitoService.getAccesTokenJwtToken());
    log(_cognitoService.getAccesTokenJwtToken() ?? "Error");
    log(_cognitoService.getIdJwtToken() ?? "Error");
  }

  logOut() async {
    await _cognitoService.logoutCurrentPoolUser();
    _appStateService.state = AppState.signedOut;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("user_name");
    await prefs.remove("refresh_token");
    DataService.getInstance().clearCache();
    StockdataService.getInstance().clearCache();
    notifyListeners();
  }

  Future register(String userName, String email, String password) async {
    try {
      await _cognitoService.registerUser(userName, email, password);
    } on CognitoClientException catch (e) {
      print(e);
      rethrow;
    }
    await login(userName, password);
  }

  Future completeForceChangePassword(String newPassword) async {
    if (_appStateService.state == AppState.newPasswordRequired &&
        _cognitoService.isUserPresent()) {
      try {
        await _cognitoService.sendNewPasswordRequired(newPassword);
      } catch (e) {
        rethrow;
      }
      _appStateService.state = AppState.signedOut;
      notifyListeners();
    }
  }

  Future confirmEmail(String code) async {
    if (_appStateService.state == AppState.verifyAccount &&
        _cognitoService.isUserPresent()) {
      await _cognitoService.confirmRegistration(code);
      _appStateService.state = AppState.signedOut;

      notifyListeners();
    }
  }

  Future resendConfirmationCode() async {
    if (_appStateService.state == AppState.verifyAccount &&
        _cognitoService.isUserPresent()) {
      await _cognitoService.resendConfirmationCode();
    }
  }

  Future<bool> tryRefreshingSession() async {
    if (_cognitoService.isSessionPresent() && _cognitoService.isUserPresent()) {
      try {
        await _cognitoService.refreshSession();
        return true;
      } catch (e) {
        print(e);
        _appStateService.state = AppState.signedOut;
        notifyListeners();
        return false;
      }
    }
    throw "Could not reresh session; Missing user or session object";
  }

  Future<bool> changePassword(String oldPassword, String newPassword) async {
    if (_cognitoService.isSessionPresent() && _cognitoService.isUserPresent()) {
      try {
        await _cognitoService.changePassword(oldPassword, newPassword);
        return true;
      } catch (e) {
        rethrow;
      }
    }
    throw "Could not change password";
  }

  initForgotPassword(String username) async {
    await _cognitoService.initForgotPassword(username);
  }

  completeForgotPassword(String code, String newPassword) async {
    await _cognitoService.completeForgotPassword(code, newPassword);
  }

  Future<bool> tryReauth() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString("refresh_token") != null &&
        prefs.getString("user_name") != null) {
      // TODO: We need constants for these strings. We should use constants for all strings in general
      _cognitoService.createCognitoUser(prefs.getString("user_name"));
      try {
        await _cognitoService.setRefreshSession();
        _appStateService.state = AppState.signedIn;
        notifyListeners();
        return true;
      } catch (e) {
        return false;
      }
    }
    return false;
  }
}
