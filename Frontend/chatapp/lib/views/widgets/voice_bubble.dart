import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class VoiceBubble extends StatefulWidget {
  final String url;
  final bool isMe;

  const VoiceBubble({
    super.key,
    required this.url,
    required this.isMe,
  });

  @override
  State<VoiceBubble> createState() => _VoiceBubbleState();
}

class _VoiceBubbleState extends State<VoiceBubble> {
  late AudioPlayer _player;
  late PlayerController _waveController;

  bool isWaveReady = false;
  bool isAudioReady = false;
  bool isPlaying = false;

  Duration total = Duration.zero;
  Duration current = Duration.zero;

  String? localPath;

  /// STREAM SUBSCRIPTIONS
  StreamSubscription? _positionSub;
  StreamSubscription? _stateSub;
  StreamSubscription? _processingSub;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _waveController = PlayerController();
    _init();
  }

  Future<void> _init() async {
    // 1. DOWNLOAD audio file
    localPath = await _downloadAudio(widget.url);

    if (!mounted) return;

    // 2. LOAD into JustAudio
    await _player.setFilePath(localPath!);
    total = _player.duration ?? Duration.zero;
    isAudioReady = true;

    if (!mounted) return;

    // 3. Prepare Waveform
    await _waveController.preparePlayer(path: localPath!);
    isWaveReady = true;

    if (!mounted) return;

    // 4. STREAM LISTENERS — store them and guard setState
    _positionSub = _player.positionStream.listen((pos) {
      if (!mounted) return;
      current = pos;
      setState(() {});
    });

    _stateSub = _player.playerStateStream.listen((state) {
      if (!mounted) return;
      isPlaying = state.playing;
      setState(() {});
    });

    _processingSub = _player.processingStateStream.listen((state) async {
      if (state == ProcessingState.completed) {
        await _player.seek(Duration.zero);
        await _waveController.seekTo(0);
        await _waveController.pausePlayer();

        if (!mounted) return;
        isPlaying = false;
        setState(() {});
      }
    });

    if (mounted) {
      setState(() {});
    }
  }

  Future<String> _downloadAudio(String url) async {
    final dir = await getTemporaryDirectory();
    final file = File("${dir.path}/${DateTime.now().millisecondsSinceEpoch}.aac");

    final bytes = await http.readBytes(Uri.parse(url));
    await file.writeAsBytes(bytes);
    return file.path;
  }

  String fmt(Duration d) {
    final m = d.inMinutes;
    final s = d.inSeconds % 60;
    return "$m:${s.toString().padLeft(2, '0')}";
  }

  @override
  void dispose() {
    // CANCEL SUBSCRIPTIONS to prevent memory leaks
    _positionSub?.cancel();
    _stateSub?.cancel();
    _processingSub?.cancel();

    _player.dispose();
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bubbleColor = widget.isMe ? Colors.deepPurple : Colors.blue;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      width: MediaQuery.of(context).size.width * 0.70,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: bubbleColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () async {
              if (!isAudioReady || !isWaveReady) return;

              if (isPlaying) {
                await _player.pause();
                await _waveController.pausePlayer();
              } else {
                await _player.play();
                await _waveController.startPlayer();
              }
            },
            child: Icon(
              isPlaying ? Icons.pause_circle : Icons.play_circle,
              color: Colors.white,
              size: 36,
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: (!isAudioReady || !isWaveReady)
                ? const Text("Loading...", style: TextStyle(color: Colors.white))
                : AudioFileWaveforms(
              size: const Size(double.infinity, 40),
              playerController: _waveController,
              enableSeekGesture: true,
              waveformType: WaveformType.fitWidth,
              playerWaveStyle: const PlayerWaveStyle(
                fixedWaveColor: Colors.white30,
                liveWaveColor: Colors.white,
                waveThickness: 2.5,
              ),
            ),
          ),

          const SizedBox(width: 10),

          Text(
            fmt(total),
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
