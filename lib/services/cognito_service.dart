import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CognitoService {
  static final _userPool = CognitoUserPool(
    'eu-central-1_I3SXMv01c',
    '45pmj4rj6amqlvh337p9dsafh4',
  );

  CognitoUserSession? _session;
  CognitoUser? _cognitoUser;

  // Token

  bool isIdTokenExpired() {
    return _getIdTokenExpiration() <
        (DateTime.now().microsecondsSinceEpoch / 1000000);
  }

  int _getIdTokenExpiration() {
    return _session!.idToken.getExpiration();
  }

  String? getIdJwtToken() {
    return _session!.getIdToken().getJwtToken();
  }

  String? getAccesTokenJwtToken() {
    return _session!.getAccessToken().getJwtToken();
  }

  String? getRefreshToken() {
    return _session!.refreshToken!.getToken()!;
  }

  // Session

  bool isSessionPresent() {
    return _session != null;
  }

  setSession(CognitoUserSession? userSession) {
    _session = userSession;
  }

  setRefreshSession() async {
    final prefs = await SharedPreferences.getInstance();
    _session = await _cognitoUser!
        .refreshSession(CognitoRefreshToken(prefs.getString("refresh_token")));
  }

  refreshSession() async {
    _session = await _cognitoUser!.refreshSession(_session!.refreshToken!);
  }

  // User

  createAndAuthenticateUser(String username, String password) async {
    createCognitoUser(username);
    final authDetails = AuthenticationDetails(
      username: username,
      password: password,
    );
    setSession(await _cognitoUser!.authenticateUser(authDetails));
  }

  createCognitoUser(String? userName) {
    _cognitoUser = CognitoUser(userName, _userPool);
  }

  confirmRegistration(String code) async {
    await _cognitoUser!.confirmRegistration(code);
  }

  bool isUserPresent() {
    return _cognitoUser != null;
  }

  sendNewPasswordRequired(String newPassword) async {
    await _cognitoUser!.sendNewPasswordRequiredAnswer(newPassword);
  }

  resendConfirmationCode() async {
    await _cognitoUser!.resendConfirmationCode();
  }

  Future<CognitoUser?> getCurrentPoolUser() async {
    return await _userPool.getCurrentUser();
  }

  logoutCurrentPoolUser() async {
    await (await getCurrentPoolUser())!.signOut();
  }

  registerUser(String userName, String email, String password) async {
    await _userPool.signUp(userName, password, userAttributes: [
      AttributeArg(name: "email", value: email),
    ], validationData: [
      AttributeArg(name: "email", value: email)
    ]);
  }

  changePassword(String oldPassword, String newPassword) async {
    await _cognitoUser!.changePassword(oldPassword, newPassword);
  }

  initForgotPassword(String username) async {
    createCognitoUser(username);
    await _cognitoUser!.forgotPassword();
  }

  completeForgotPassword(String code, String newPassword) async {
    if (_cognitoUser == null) throw "No user";
    await _cognitoUser!.confirmPassword(code, newPassword);
  }

  CognitoUser? getUser() {
    return _cognitoUser;
  }
}
