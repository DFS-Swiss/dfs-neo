import 'package:neo/enums/publisher_event.dart';
import 'package:rxdart/subjects.dart';
import 'package:rxdart/rxdart.dart';

class PublisherService {

  final PublishSubject<PublisherEvent> _source = PublishSubject<PublisherEvent>();

  PublishSubject<PublisherEvent> getSource() {
    return _source;
  }

  addEvent(PublisherEvent subscription) {
    _source.add(subscription);
  }

  close() {
    _source.close();
  }
}