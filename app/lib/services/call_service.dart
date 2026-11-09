import 'dart:async';

import 'package:flutter/services.dart';

class CallService {
  static const EventChannel _callEvents =
      EventChannel('app.callsense/call_events');

  Stream<DateTime> get callEndedAt => _callEvents
      .receiveBroadcastStream()
      .map((_) => DateTime.now());

  Future<void> requestPlatformPermission() async {
    const channel = MethodChannel('app.callsense/call_service');
    await channel.invokeMethod<void>('requestPermission');
  }
}
