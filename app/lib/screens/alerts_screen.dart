import 'package:flutter/material.dart';

import '../services/family_service.dart';

class AlertsScreen extends StatefulWidget {
  const AlertsScreen({super.key});

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  late final _service = FamilyService();
  late Future<List<FamilyAlert>> _alerts;

  @override
  void initState() {
    super.initState();
    _alerts = _service.getAlerts();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Family alerts')),
        body: FutureBuilder<List<FamilyAlert>>(
          future: _alerts,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text('Could not load alerts: ${snapshot.error}'),
                ),
              );
            }
            final alerts = snapshot.data ?? const <FamilyAlert>[];
            if (alerts.isEmpty) {
              return const Center(child: Text('No family alerts yet.'));
            }
            return RefreshIndicator(
              onRefresh: () async {
                setState(() => _alerts = _service.getAlerts());
                await _alerts;
              },
              child: ListView.builder(
                itemCount: alerts.length,
                itemBuilder: (context, index) {
                  final alert = alerts[index];
                  return ListTile(
                    leading: const Icon(Icons.notifications_active_outlined),
                    title: Text(alert.message),
                    subtitle: Text(alert.createdAt.toLocal().toString()),
                  );
                },
              ),
            );
          },
        ),
      );
}
