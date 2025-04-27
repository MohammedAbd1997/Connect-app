import 'dart:convert';
import 'dart:typed_data';

class AudioMessage {
  final String id;
  final List<String> audioChunks; // Base64 encoded audio chunks
  final String sender;
  final int timestamp;
  final Duration duration;

  AudioMessage({
    required this.id,
    required this.audioChunks,
    required this.sender,
    required this.timestamp,
    required this.duration,
  });

  factory AudioMessage.fromMap(Map<dynamic, dynamic> map, String id) {
    final audioChunks = List<String>.from(map['audio_chunks'] ?? []);
    final sender = map['sender'] ?? '';
    final timestamp = map['timestamp'] ?? 0;
    final duration = _calculateDuration(audioChunks, 16000, 1);

    return AudioMessage(
      id: id,
      audioChunks: audioChunks,
      sender: sender,
      timestamp: timestamp,
      duration: duration,
    );
  }

  /// Merge all audio chunks into a single Uint8List
  Uint8List getMergedAudio() {
    final merged = <int>[];
    for (final chunk in audioChunks) {
      merged.addAll(base64Decode(chunk));
    }
    return Uint8List.fromList(merged);
  }

  /// Calculate the duration based on sample rate and number of channels
  static Duration _calculateDuration(
      List<String> chunks, int sampleRate, int numChannels) {
    final totalBytes =
    chunks.fold<int>(0, (sum, chunk) => sum + base64Decode(chunk).length);
    final durationMs = (totalBytes / (sampleRate * numChannels * 2) * 1000).round();
    return Duration(milliseconds: durationMs);
  }
}
