import 'dart:async';

import 'package:bugsnag_flutter/bugsnag_flutter.dart';

import '../service_locator.dart';
import 'cognito_service.dart';

class CrashlyticsService {
  void start({
    String? apiKey,
    FutureOr<void> Function()? runApp,
  }) {
    bugsnag.start(apiKey: apiKey, runApp: runApp);
  }

  Future<void> identifyUser() async {
    final authServie = locator<CognitoService>();
    if (authServie.isUserPresent()) {
      await bugsnag.setUser(id: authServie.getUser()!.username!);
    }
  }

  Future<void> logError(dynamic error, StackTrace? trace) async {
    return bugsnag.notify(error, trace);
  }

  Future<void> leaveBreadcrumb(
    String eventType, {
    Map<String, Object>? eventProperties,
    BugsnagBreadcrumbType type = BugsnagBreadcrumbType.manual,
  }) async {
    return bugsnag.leaveBreadcrumb(
      eventType,
      metadata: eventProperties,
      type: type,
    );
  }
}
