import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:voice_chat/Helper/SharedPreferance/shared_preferance.dart';

class VoiceChatController extends GetxController {
  StreamController<Uint8List> _audioStreamController =
      StreamController<Uint8List>.broadcast();
  final DatabaseReference voiceStreamRef =
      FirebaseDatabase.instance.ref('voice_stream');
  final DatabaseReference _statusRef =
      FirebaseDatabase.instance.ref('call_status');

  FlutterSoundRecorder recorder = FlutterSoundRecorder();
  final FlutterSoundPlayer _player = FlutterSoundPlayer();
  RxList<Map<String, dynamic>> users = <Map<String, dynamic>>[].obs;
  final DatabaseReference dbRef = FirebaseDatabase.instance.ref('users');
  StreamSubscription<DatabaseEvent>? _userSubscription;

  void listenToUsers() {
    _userSubscription = dbRef.onValue.listen((DatabaseEvent event) {
      final dataSnapshot = event.snapshot;
      final Map<dynamic, dynamic>? usersMap =
          dataSnapshot.value as Map<dynamic, dynamic>?;

      if (usersMap != null) {
        final List<Map<String, dynamic>> loadedUsers = [];

        usersMap.forEach((key, value) {
          final user = Map<String, dynamic>.from(value);
          user['id'] = key; // attach the Firebase key as user ID
          loadedUsers.add(user);
        });
        String userId = SpHelper.spHelper.getUserId();
        users.value = loadedUsers;
      } else {
        users.clear();
      }
    });
  }

  getAllUser() async {
    final DatabaseReference dbRef = FirebaseDatabase.instance.ref();

    DataSnapshot dataSnapshot = await dbRef.child('users').get();
    dataSnapshot.key;
  }

  // Configuration
  final int _sampleRate = 16000;
  final int _numChannels = 1;
  final Duration _sendInterval =
      Duration(milliseconds: 500); // Reduced interval

  // State variables
  bool _isRecording = false;
  bool _isPlaying = false;
  bool _isInCall = false;
  String? _currentCallId;
  StreamSubscription<DatabaseEvent>? _voiceSubscription;

  // Audio buffers
  List<Uint8List> _audioChunksBuffer = [];
  Timer? _sendTimer;
  bool _isPlayerInitialized = false;
  bool _isRecorderInitialized = false;

  @override
  void onClose() {
    _stopAll();
    _audioStreamController.close();
    _userSubscription?.cancel();

    super.onClose();
  }

  Future<void> init() async {
    try {
      listenToUsers();
      await Permission.microphone.request();
      await Permission.storage.request();

      await _initializeRecorder();
      await _initializePlayer();

      debugPrint('Audio components initialized successfully');
    } catch (e) {
      debugPrint('Error initializing audio: $e');
    }
  }

  Future<void> _initializeRecorder() async {
    if (_isRecorderInitialized) return;
    log("_initializeRecorder");
    await recorder.openRecorder();
    await recorder.setSubscriptionDuration(Duration(milliseconds: 50));
    _isRecorderInitialized = true;
  }

  Future<void> _initializePlayer() async {
    if (_isPlayerInitialized) return;

    await _player.openPlayer();
    await _player.setSubscriptionDuration(Duration(milliseconds: 20));
    _player.setVolume(1.0);
    _isPlayerInitialized = true;
  }

  Future<void> startVoiceStream() async {
    log("STATERECORDER ${recorder.recorderState.toString()}");
    // await init();

    if (_isRecording || !_isInCall || _currentCallId == null) return;

    try {
      await _initializeRecorder();

      _isRecording = true;
      _audioChunksBuffer.clear();
      update();
      if (_audioStreamController.isClosed) {
        _audioStreamController = StreamController<Uint8List>.broadcast();
      }
      // Start periodic sending
      // _sendTimer = Timer.periodic(_sendInterval, (timer) {
      //   if (_audioChunksBuffer.isNotEmpty) {
      //     _sendBufferedAudio();
      //   }
      // });
      await recorder.startRecorder(
        toStream: _audioStreamController.sink,
        codec: Codec.pcm16,
        sampleRate: _sampleRate,
        numChannels: _numChannels,
      );

      _audioStreamController.stream.listen((Uint8List audioChunk) {
        log("HERE");
        if (_isInCall && _currentCallId != null) {
          _audioChunksBuffer.add(audioChunk);
        }
      });
    } catch (e) {
      debugPrint('Error starting recorder: $e');
      _isRecording = false;
      update();
    }
  }

  Future<void> stopVoiceStream() async {
    log("STATERECORDER ${recorder.recorderState.toString()}");

    if (!_isRecording) return;
    _audioStreamController.close();
    _isRecording = false;
    _sendTimer?.cancel();
    _sendTimer = null;
    update();

    try {
      await recorder.stopRecorder();
      // Send any remaining audio
      if (_audioChunksBuffer.isNotEmpty) {
        await _sendBufferedAudio();
      }
    } catch (e) {
      debugPrint('Error stopping recorder: $e');
    }
  }

  Future<void> _sendBufferedAudio() async {
    if (!_isInCall || _currentCallId == null || _audioChunksBuffer.isEmpty)
      return;

    try {
      final timestamp = DateTime.now().toUtc().millisecondsSinceEpoch;
      String userId = SpHelper.spHelper.getUserId();

      // Convert all chunks to base64 strings
      List<String> chunkList =
          _audioChunksBuffer.map((chunk) => base64Encode(chunk)).toList();

      await voiceStreamRef.child(_currentCallId!).push().set({
        'audio_chunks': chunkList, // Send as array
        'timestamp': timestamp,
        'sender': userId,
      });

      _audioChunksBuffer.clear();
    } catch (e) {
      debugPrint('Error sending audio chunks: $e');
    }
  }

// Player side (play chunk list)
  Future<void> playAudioChunks(List<dynamic> chunkList) async {
    try {
      // Convert base64 strings back to bytes
      List<Uint8List> audioChunks = chunkList
          .map((base64Str) => base64Decode(base64Str as String))
          .toList();

      // Merge for playback
      int totalLength = audioChunks.fold(0, (sum, chunk) => sum + chunk.length);
      Uint8List merged = Uint8List(totalLength);
      int offset = 0;

      for (var chunk in audioChunks) {
        merged.setRange(offset, offset + chunk.length, chunk);
        offset += chunk.length;
      }

      await _player.startPlayer(
        fromDataBuffer: merged,
        codec: Codec.pcm16,
        sampleRate: _sampleRate,
        numChannels: _numChannels,
      );
    } catch (e) {
      debugPrint('Error playing chunk list: $e');
    }
  }

  Future<void> _stopAll() async {
    await stopVoiceStream();
    _voiceSubscription?.cancel();
    await _player.stopPlayer();
    _isPlaying = false;
  }

  Future<void> joinCall(String callId) async {
    if (_isInCall) return;

    _currentCallId = callId;
    _isInCall = true;

    await _statusRef
        .child(callId)
        .child('participants')
        .set(ServerValue.increment(1));
    update();
    _listenForIncomingAudio(callId);
  }

  Future<void> endCall() async {
    if (!_isInCall || _currentCallId == null) return;

    await _statusRef
        .child(_currentCallId!)
        .child('participants')
        .set(ServerValue.increment(-1));
    _stopAll();
    _isInCall = false;
    _currentCallId = null;

    update();
  }

  void _listenForIncomingAudio(String callId) {
    _voiceSubscription?.cancel();
    String userId = SpHelper.spHelper.getUserId();

    _voiceSubscription = voiceStreamRef
        .child(callId)
        .orderByChild('timestamp')
        .startAt(DateTime.now().millisecondsSinceEpoch)
        .onChildAdded
        .listen((DatabaseEvent event) async {
      if (event.snapshot.value != null) {
        final data = event.snapshot.value as Map<dynamic, dynamic>;
        final audioData = data['audio_chunks'];
        log(data['sender'] as String);
        if (data['sender'] as String != userId) {
          log("Play Sound");
          await playAudioChunks(audioData);
        }
      }
    });
  }

  Stream<List<Map>> getVoiceStream(String roomId) {
    return voiceStreamRef.child(roomId).onValue.map((event) {
      final Map<dynamic, dynamic>? rooms = event.snapshot.value as Map?;
      if (rooms == null) return [];

      return rooms.entries.map((entry) {
        return {
          'id': entry.key,
          ...(entry.value as Map),
        };
      }).toList()
        ..sort(
            (a, b) => (b['timestamp'] as int).compareTo(a['timestamp'] as int));
    });
  }

  // Helper function to format duration as MM:SS
   String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
  // Getters for UI state
  bool get isRecording => _isRecording;

  bool get isInCall => _isInCall;

  String? get currentCallId => _currentCallId;
}
