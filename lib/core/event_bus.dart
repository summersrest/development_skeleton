import 'dart:async';

class EventBus {
  final StreamController<EventMessage> _streamController;

  EventBus._() : _streamController = StreamController.broadcast();

  static final instance = EventBus._();

  StreamSubscription<EventMessage> listen(void Function(EventMessage event)? onData) =>
      _streamController.stream.listen(onData);

  Stream<EventMessage> where(bool Function(EventMessage event) func) => _streamController.stream.where((func));

  Stream<EventMessage> distinct() => _streamController.stream.distinct();

  send(EventMessage event) => _streamController.sink.add(event);

  close() => _streamController.close();
}

class EventMessage {
  int eventId;
  dynamic message;

  EventMessage(this.eventId, {this.message});

  Map<String, dynamic> toJson() => {
        'eventId': eventId,
        'message': message,
      };
}
