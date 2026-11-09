import 'package:flutter/material.dart';

class ReasonTile extends StatelessWidget {
  const ReasonTile({super.key, required this.reason});

  final String reason;

  @override
  Widget build(BuildContext context) => ListTile(
        leading: const Icon(Icons.info_outline),
        title: Text(reason),
        contentPadding: EdgeInsets.zero,
      );
}
