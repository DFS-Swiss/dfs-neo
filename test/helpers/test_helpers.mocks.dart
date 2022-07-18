// Mocks generated by Mockito 5.2.0 from annotations
// in neo/test/helpers/test_helpers.dart.
// Do not manually edit this file.

import 'dart:async' as _i3;
import 'dart:ui' as _i7;

import 'package:amazon_cognito_identity_dart_2/cognito.dart' as _i4;
import 'package:mockito/mockito.dart' as _i1;
import 'package:neo/enums/app_state.dart' as _i6;
import 'package:neo/services/app_state_service.dart' as _i5;
import 'package:neo/services/cognito_service.dart' as _i2;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types

/// A class which mocks [CognitoService].
///
/// See the documentation for Mockito's code generation for more information.
class MockCognitoService extends _i1.Mock implements _i2.CognitoService {
  @override
  bool isIdTokenExpired() =>
      (super.noSuchMethod(Invocation.method(#isIdTokenExpired, []),
          returnValue: false) as bool);
  @override
  bool isSessionPresent() =>
      (super.noSuchMethod(Invocation.method(#isSessionPresent, []),
          returnValue: false) as bool);
  @override
  dynamic createAndAuthenticateUser(String? username, String? password) =>
      super.noSuchMethod(
          Invocation.method(#createAndAuthenticateUser, [username, password]));
  @override
  dynamic confirmRegistration(String? code) =>
      super.noSuchMethod(Invocation.method(#confirmRegistration, [code]));
  @override
  bool isUserPresent() =>
      (super.noSuchMethod(Invocation.method(#isUserPresent, []),
          returnValue: false) as bool);
  @override
  dynamic sendNewPasswordRequired(String? newPassword) => super
      .noSuchMethod(Invocation.method(#sendNewPasswordRequired, [newPassword]));
  @override
  _i3.Future<_i4.CognitoUser?> getCurrentPoolUser() =>
      (super.noSuchMethod(Invocation.method(#getCurrentPoolUser, []),
              returnValue: Future<_i4.CognitoUser?>.value())
          as _i3.Future<_i4.CognitoUser?>);
  @override
  dynamic registerUser(String? userName, String? email, String? password) =>
      super.noSuchMethod(
          Invocation.method(#registerUser, [userName, email, password]));
}

/// A class which mocks [AppStateService].
///
/// See the documentation for Mockito's code generation for more information.
class MockAppStateService extends _i1.Mock implements _i5.AppStateService {
  @override
  _i6.AppState get state => (super.noSuchMethod(Invocation.getter(#state),
      returnValue: _i6.AppState.signedOut) as _i6.AppState);
  @override
  set state(_i6.AppState? newState) =>
      super.noSuchMethod(Invocation.setter(#state, newState),
          returnValueForMissingStub: null);
  @override
  bool get hasListeners =>
      (super.noSuchMethod(Invocation.getter(#hasListeners), returnValue: false)
          as bool);
  @override
  void addListener(_i7.VoidCallback? listener) =>
      super.noSuchMethod(Invocation.method(#addListener, [listener]),
          returnValueForMissingStub: null);
  @override
  void removeListener(_i7.VoidCallback? listener) =>
      super.noSuchMethod(Invocation.method(#removeListener, [listener]),
          returnValueForMissingStub: null);
  @override
  void dispose() => super.noSuchMethod(Invocation.method(#dispose, []),
      returnValueForMissingStub: null);
  @override
  void notifyListeners() =>
      super.noSuchMethod(Invocation.method(#notifyListeners, []),
          returnValueForMissingStub: null);
}
