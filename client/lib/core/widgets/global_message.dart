import 'package:flutter/material.dart';

import '../message.dart';
import '../message_bus.dart';

class GlobalMessage extends StatelessWidget {
  final Widget child;

  const GlobalMessage({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Message>(
      stream: MessageBus.instance.messages,
      builder: (BuildContext context, AsyncSnapshot<Message> snapshot) {
        if (snapshot.hasData) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(snapshot.data!.message)),
            );
          });
        }
        return child;
      },
    );
  }
}
