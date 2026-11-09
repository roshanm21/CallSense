import 'package:flutter/material.dart';

class CallBubble extends StatelessWidget {
  const CallBubble({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Card(
        child: ListTile(
          leading: const CircleAvatar(child: Icon(Icons.call_end)),
          title: const Text('Just finished a call?'),
          subtitle: const Text('Check a message or verify a company.'),
          trailing: const Icon(Icons.chevron_right),
          onTap: onTap,
        ),
      );
}
