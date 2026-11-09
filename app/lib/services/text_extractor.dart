import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class TextExtractor {
  final TextRecognizer _recognizer = TextRecognizer();

  Future<String> extractFromImage(String imagePath) async {
    final image = InputImage.fromFilePath(imagePath);
    final result = await _recognizer.processImage(image);
    return result.text.trim();
  }

  Future<void> dispose() => _recognizer.close();
}
