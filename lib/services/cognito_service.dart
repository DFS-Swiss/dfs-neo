import 'package:amazon_cognito_identity_dart_2/cognito.dart';

class CognitoService {
  static final _userPool = CognitoUserPool(
    'eu-central-1_I3SXMv01c',
    '45pmj4rj6amqlvh337p9dsafh4',
  );

  CognitoUserSession? _session;
  CognitoUser? _cognitoUser;

  CognitoUserSession? getSession() {
    return _session;
  }

  bool isSessionPresent() {
    return _session != null;
  }

  bool isIdTokenExpired() {
    return _getIdTokenExpiration() < DateTime.now().microsecondsSinceEpoch;
  }

  int _getIdTokenExpiration() {
    return _session!.idToken.getExpiration();
  }

  String? getIdJwtToken() {
    return _session!.getIdToken().getJwtToken();
  }

  setSession(CognitoUserSession? userSession) {
    _session = userSession;
  }

  createCognitoUser(String? userName) {
    _cognitoUser = CognitoUser(userName, _userPool);
  }

  getCognitoUser() {
    return _cognitoUser;
  }

  refreshSession() {
    _cognitoUser!.refreshSession(_session!.refreshToken!);
  }

  Future<CognitoUser?> getCurrentPoolUser() async {
    return await _userPool.getCurrentUser();
  }
}
