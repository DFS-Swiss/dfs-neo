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

  setSession(CognitoUserSession? userSession) {
    _session = userSession;
  }

  createCognitoUser(String? userName) {
    _cognitoUser = CognitoUser(userName, _userPool);
  }

  getCognitoUser() {
    return _cognitoUser;
  }

  Future<CognitoUser?> getCurrentPoolUser() async {
    return await _userPool.getCurrentUser();
  }
}
