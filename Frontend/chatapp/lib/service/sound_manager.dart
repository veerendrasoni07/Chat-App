import 'dart:async';
import 'package:audioplayers/audioplayers.dart';

class SoundManager {
  static final AudioPlayer _player = AudioPlayer();
  static bool _isMuted = false;

  static Future<void> preload() async {
    await _player.setSource(AssetSource('sounds/mixkit-sci-fi-interface-zoom-890.wav'));
    await _player.setSource(AssetSource('sounds/mixkit-interface-hint-notification-911.wav'));
  }

  static void mute(bool mute) {
    _isMuted = mute;
  }

  static Future<void> playSendSound() async {
    if (_isMuted) return;
    await _playWithFade('sounds/mixkit-sci-fi-interface-zoom-890.wav');
  }

  static Future<void> playReceiveSound() async {
    if (_isMuted) return;
    await _playWithFade('sounds/mixkit-interface-hint-notification-911.wav');
  }
  static Future<void> _playWithFade(String path) async {
    final player = AudioPlayer();
    await player.setVolume(0);
    await player.play(AssetSource(path));

    const fadeInDuration = Duration(milliseconds: 150);
    const fadeOutDuration = Duration(milliseconds: 150);
    const totalDuration = Duration(milliseconds: 1000);

    // Fade In
    Timer.periodic(const Duration(milliseconds: 30), (timer) async {
      final progress = timer.tick * 30 / fadeInDuration.inMilliseconds;
      if (progress >= 1.0) {
        await player.setVolume(1.0);
        timer.cancel();

        // Fade Out near the end
        Future.delayed(totalDuration - fadeOutDuration, () async {
          double v = 1.0;
          Timer.periodic(const Duration(milliseconds: 30), (t) async {
            v -= 0.2;
            if (v <= 0) {
              await player.setVolume(0);
              await player.stop();
              t.cancel();
            } else {
              await player.setVolume(v);
            }
          });
        });
      } else {
        await player.setVolume(progress.clamp(0.0, 1.0));
      }
    });
  }
}
