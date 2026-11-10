import 'dart:async';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../services/scam_detector.dart';
import '../services/share_service.dart';
import '../services/text_extractor.dart';
import '../widgets/call_bubble.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.supabaseConfigured});

  final bool supabaseConfigured;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _messageController = TextEditingController();
  final _detector = const ScamDetector();
  final _picker = ImagePicker();
  final _textExtractor = TextExtractor();
  final _shareService = ShareService();
  StreamSubscription<SharedContent>? _shareSubscription;
  bool _isReadingImage = false;

  @override
  void initState() {
    super.initState();
    _shareSubscription = _shareService.sharedContent.listen(
      _onSharedContent,
      onError: (Object error) => _showMessage('Could not receive shared content: $error'),
    );
    unawaited(_shareService.start().catchError((Object error) {
      if (mounted) _showMessage('Sharing is unavailable: $error');
    }));
  }

  void _onSharedContent(SharedContent content) {
    if (content.type == SharedContentType.text) {
      setState(() => _messageController.text = content.value);
    } else {
      unawaited(_readImage(content.value));
    }
  }

  Future<void> _readImage(String path) async {
    setState(() => _isReadingImage = true);
    try {
      final text = await _textExtractor.extractFromImage(path);
      if (!mounted) return;
      if (text.isEmpty) {
        _showMessage('No readable text was found in that image.');
      } else {
        setState(() => _messageController.text = text);
        _showMessage('Text copied from image. Review it, then scan.');
      }
    } catch (error) {
      if (mounted) _showMessage('Could not read the image: $error');
    } finally {
      if (mounted) setState(() => _isReadingImage = false);
    }
  }

  Future<void> _pickImage() async {
    try {
      final image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) await _readImage(image.path);
    } catch (error) {
      if (mounted) _showMessage('Could not select an image: $error');
    }
  }

  void _scanMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) {
      _showMessage('Paste a message before scanning.');
      return;
    }
    Navigator.of(context).pushNamed(
      '/result',
      arguments: _detector.scan(text),
    );
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    _messageController.dispose();
    _shareSubscription?.cancel();
    _shareService.dispose();
    _textExtractor.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('CallSense'),
          actions: [
            IconButton(
              tooltip: 'Privacy',
              onPressed: () => Navigator.of(context).pushNamed('/privacy'),
              icon: const Icon(Icons.lock_outline),
            ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (!widget.supabaseConfigured)
              const Card(
                child: ListTile(
                  leading: Icon(Icons.cloud_off_outlined),
                  title: Text('Online verification is not configured'),
                  subtitle: Text(
                    'Message scanning works locally. Add Supabase build settings '
                    'to enable company and family services.',
                  ),
                ),
              ),
            Text(
              'Check a message',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            const Text(
              'Paste a text or select a screenshot. Scanning happens on this device.',
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _messageController,
              minLines: 5,
              maxLines: 10,
              decoration: const InputDecoration(
                labelText: 'Message text',
                hintText: 'Paste a suspicious message here',
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: _isReadingImage ? null : _pickImage,
              icon: _isReadingImage
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.image_outlined),
              label: Text(_isReadingImage ? 'Reading image…' : 'Read screenshot'),
            ),
            const SizedBox(height: 8),
            FilledButton.icon(
              onPressed: _scanMessage,
              icon: const Icon(Icons.search),
              label: const Text('Scan message'),
            ),
            const SizedBox(height: 16),
            CallBubble(
              onTap: () => Navigator.of(context).pushNamed('/questions'),
            ),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ActionChip(
                  avatar: const Icon(Icons.business_outlined),
                  label: const Text('Verify a company'),
                  onPressed: () => Navigator.of(context).pushNamed('/questions'),
                ),
                ActionChip(
                  avatar: const Icon(Icons.family_restroom),
                  label: const Text('Family safety'),
                  onPressed: () => Navigator.of(context).pushNamed('/family'),
                ),
                ActionChip(
                  avatar: const Icon(Icons.notifications_outlined),
                  label: const Text('Family alerts'),
                  onPressed: () => Navigator.of(context).pushNamed('/alerts'),
                ),
              ],
            ),
          ],
        ),
      );
}
