import 'dart:async';

import 'message.dart';

class MessageBus {
  static final MessageBus instance = MessageBus._internal();

  final StreamController<Message> _controller = StreamController<Message>.broadcast();

  Stream<Message> get messages => _controller.stream;

  void addMessage(Message message) => _controller.add(message);

  MessageBus._internal();
}
