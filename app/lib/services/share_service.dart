import 'dart:async';

import 'package:receive_sharing_intent/receive_sharing_intent.dart';

enum SharedContentType { text, image }

class SharedContent {
  const SharedContent({required this.value, required this.type});

  final String value;
  final SharedContentType type;
}

class ShareService {
  final StreamController<SharedContent> _controller =
      StreamController<SharedContent>.broadcast();
  final List<StreamSubscription<dynamic>> _subscriptions = [];

  Stream<SharedContent> get sharedContent => _controller.stream;

  Future<void> start() async {
    _subscriptions.add(
      ReceiveSharingIntent.instance.getMediaStream().listen(
        (files) {
          for (final file in files) {
            _addMedia(file);
          }
        },
        onError: _controller.addError,
      ),
    );

    final initialMedia = await ReceiveSharingIntent.instance.getInitialMedia();
    for (final file in initialMedia) {
      _addMedia(file);
    }
  }

  void _addMedia(SharedMediaFile file) {
    switch (file.type) {
      case SharedMediaType.image:
        _controller.add(
          SharedContent(value: file.path, type: SharedContentType.image),
        );
      case SharedMediaType.text:
      case SharedMediaType.url:
        final text = file.path.trim().isNotEmpty ? file.path : file.message;
        if (text != null && text.trim().isNotEmpty) {
          _controller.add(
            SharedContent(value: text, type: SharedContentType.text),
          );
        }
      case SharedMediaType.video:
      case SharedMediaType.file:
        break;
    }
  }

  Future<void> dispose() async {
    for (final subscription in _subscriptions) {
      await subscription.cancel();
    }
    await _controller.close();
  }
}
