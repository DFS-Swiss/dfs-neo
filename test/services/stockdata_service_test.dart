import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:neo/enums/publisher_event.dart';
import 'package:neo/service_locator.dart';
import 'package:neo/services/publisher_service.dart';
import 'package:neo/services/stockdata_service.dart';
import 'package:neo/utils/stockdata_handler.dart';
import 'package:rxdart/rxdart.dart';

import '../helpers/test_helpers.dart';

void main() {
  group('Stock Data Service Test - Constructor', () {
    setUp(() {
      registerServices();
      var publisherService = locator<PublisherService>();
      final PublishSubject<PublisherEvent> publishSubject =
          PublishSubject<PublisherEvent>();

      publishSubject.add(PublisherEvent.logout);

      when(publisherService.getSource())
          .thenAnswer((realInvocation) => publishSubject);
    });
    tearDown(() {
      unregisterServices();
    });

    test('constructor_handlersSetCorrectly', () async {
      // arrange
      StockdataService();
      var stockdataHandler = locator<StockdataHandler>();
      // assert
      //verify(stockdataHandler.clearCache()).called(1);
    });
  });
}
