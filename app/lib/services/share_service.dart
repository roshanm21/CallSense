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
      ReceiveSharingIntent.instance.getTextStream().listen(
        (text) {
          if (text.trim().isNotEmpty) {
            _controller.add(
              SharedContent(value: text, type: SharedContentType.text),
            );
          }
        },
        onError: _controller.addError,
      ),
    );
    _subscriptions.add(
      ReceiveSharingIntent.instance.getMediaStream().listen(
        (files) {
          for (final file in files) {
            if (file.type == SharedMediaType.image) {
              _controller.add(
                SharedContent(
                  value: file.path,
                  type: SharedContentType.image,
                ),
              );
            }
          }
        },
        onError: _controller.addError,
      ),
    );

    final initialText = await ReceiveSharingIntent.instance.getInitialText();
    if (initialText != null && initialText.trim().isNotEmpty) {
      _controller.add(
        SharedContent(value: initialText, type: SharedContentType.text),
      );
    }
    final initialMedia = await ReceiveSharingIntent.instance.getInitialMedia();
    for (final file in initialMedia) {
      if (file.type == SharedMediaType.image) {
        _controller.add(
          SharedContent(value: file.path, type: SharedContentType.image),
        );
      }
    }
  }

  Future<void> dispose() async {
    for (final subscription in _subscriptions) {
      await subscription.cancel();
    }
    await _controller.close();
  }
}
