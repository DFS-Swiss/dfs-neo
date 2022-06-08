import 'package:flutter/material.dart';
import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:neo/enums/auth_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationService extends ChangeNotifier {
  static final _userPool = CognitoUserPool(
    'eu-central-1_Zg1jNzpcV',
    '1io15mo8qbo38kcheuobpifsbc',
  );

  static AuthenticationService? _instance;
  AuthenticationService._();

  static AuthenticationService getInstance() {
    return _instance ??= AuthenticationService._();
  }

  AuthState authState = AuthState.signedOut;
  CognitoUserSession? session;

  login(String userName, String password) async {
    final cognitoUser = CognitoUser(userName, _userPool);
    final authDetails = AuthenticationDetails(
      username: userName,
      password: password,
    );

    try {
      session = await cognitoUser.authenticateUser(authDetails);
    } on CognitoUserNewPasswordRequiredException catch (e) {
      rethrow;
      // handle New Password challenge
    } on CognitoUserMfaRequiredException catch (e) {
      rethrow;

      // handle SMS_MFA challenge
    } on CognitoUserSelectMfaTypeException catch (e) {
      rethrow;

      // handle SELECT_MFA_TYPE challenge
    } on CognitoUserMfaSetupException catch (e) {
      rethrow;

      // handle MFA_SETUP challenge
    } on CognitoUserTotpRequiredException catch (e) {
      rethrow;

      // handle SOFTWARE_TOKEN_MFA challenge
    } on CognitoUserCustomChallengeException catch (e) {
      rethrow;

      // handle CUSTOM_CHALLENGE challenge
    } on CognitoUserConfirmationNecessaryException catch (e) {
      rethrow;

      // handle User Confirmation Necessary
      // TODO: Handle verify
    } on CognitoClientException catch (e) {
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
  }

  logOut() async {
    await (await _userPool.getCurrentUser())!.signOut();
    authState = AuthState.signedOut;
    notifyListeners();
  }

  Future<bool> tryReauth() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString("refresh_token") != null &&
        prefs.getString("user_name") != null) {
      final cognitoUser = CognitoUser(prefs.getString("user_name")!, _userPool);
      try {
        session = await cognitoUser.refreshSession(
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
