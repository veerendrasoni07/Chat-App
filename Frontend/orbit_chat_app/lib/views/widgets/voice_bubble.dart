import 'dart:async';
import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class VoiceBubble extends StatefulWidget {
  final String url;
  final bool isMe;

  const VoiceBubble({super.key, required this.url, required this.isMe});

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
  String? errorText;

  StreamSubscription? _positionSub;
  StreamSubscription? _stateSub;
  StreamSubscription? _processingSub;
  StreamSubscription? _durationSub;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _waveController = PlayerController();
    _init();
  }

  @override
  void didUpdateWidget(covariant VoiceBubble oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.url != widget.url) {
      _reload();
    }
  }

  Future<void> _init() async {
    try {
      errorText = null;
      localPath = await _resolvePlayablePath(widget.url);
      if (!mounted) return;

      await _player.setFilePath(localPath!);
      total = _player.duration ?? Duration.zero;
      isAudioReady = true;

      await _waveController.preparePlayer(path: localPath!);
      isWaveReady = true;

      _durationSub = _player.durationStream.listen((d) {
        if (!mounted || d == null) return;
        total = d;
        setState(() {});
      });

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
          if (!mounted) return;
          isPlaying = false;
          current = Duration.zero;
          setState(() {});
        }
      });
    } catch (_) {
      errorText = "Unable to load audio";
      isAudioReady = false;
      isWaveReady = false;
    }
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _reload() async {
    await _positionSub?.cancel();
    await _stateSub?.cancel();
    await _processingSub?.cancel();
    await _durationSub?.cancel();
    await _player.stop();

    isWaveReady = false;
    isAudioReady = false;
    isPlaying = false;
    total = Duration.zero;
    current = Duration.zero;
    localPath = null;
    errorText = null;

    await _init();
  }

  Future<String> _resolvePlayablePath(String source) async {
    if (source.startsWith('http://') || source.startsWith('https://')) {
      return _downloadAudio(source);
    }

    final normalizedPath = source.startsWith('file://')
        ? Uri.parse(source).toFilePath()
        : source;
    final file = File(normalizedPath);
    if (!file.existsSync()) {
      throw Exception("Audio source does not exist");
    }
    return file.path;
  }

  Future<String> _downloadAudio(String url) async {
    final dir = await getTemporaryDirectory();
    final uri = Uri.parse(url);
    final originalPath = uri.path;
    final ext = p.extension(originalPath).isEmpty ? '.m4a' : p.extension(originalPath);
    final file = File("${dir.path}/${DateTime.now().millisecondsSinceEpoch}$ext");
    final response = await http.get(uri);
    if (response.statusCode != 200) {
      throw Exception("Download failed");
    }
    await file.writeAsBytes(response.bodyBytes);
    return file.path;
  }

  String fmt(Duration d) {
    final m = d.inMinutes;
    final s = d.inSeconds % 60;
    return "$m:${s.toString().padLeft(2, '0')}";
  }

  @override
  void dispose() {
    _positionSub?.cancel();
    _stateSub?.cancel();
    _processingSub?.cancel();
    _durationSub?.cancel();
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
              } else {
                await _player.play();
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
                ? Text(
                    errorText ?? "Loading...",
                    style: const TextStyle(color: Colors.white),
                  )
                : AudioFileWaveforms(
                    size: const Size(double.infinity, 40),
                    playerController: _waveController,
                    enableSeekGesture: false,
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
            fmt(isPlaying ? current : total),
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
