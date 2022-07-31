import 'package:amplitude_flutter/amplitude.dart';
import 'package:neo/service_locator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'cognito_service.dart';

class AnalyticsService {
  final amplitude = Amplitude.getInstance();
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    await amplitude.init("742b3f148c2c99820e1d3fed433d78c9");
    await amplitude.trackingSessionEvents(true);
    await amplitude.logEvent(
      'Startup',
      eventProperties: {
        'first_time': prefs.getString("last_startup") == null,
        'time_since_last_startup': prefs.getString("last_startup") != null
            ? DateTime.parse(prefs.getString("last_startup")!)
                .difference(DateTime.now())
                .toString()
            : null,
      },
    );
    await prefs.setString("last_startup", DateTime.now().toIso8601String());
  }

  Future<void> identifyUser() async {
    final authServie = locator<CognitoService>();
    if (authServie.isUserPresent()) {
      await amplitude.setUserId(authServie.getUser()!.username!);
    }
  }

  Future<void> trackEvent(
    String eventType, {
    Map<String, dynamic>? eventProperties,
    bool? outOfSession,
  }) async {
    return amplitude.logEvent(
      eventType,
      eventProperties: eventProperties,
      outOfSession: outOfSession,
    );
  }
}
