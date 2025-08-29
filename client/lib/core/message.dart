enum MessageType { success, information, error, warning }

class Message {
  MessageType type;
  String message;

  Message(this.type, this.message);
}
