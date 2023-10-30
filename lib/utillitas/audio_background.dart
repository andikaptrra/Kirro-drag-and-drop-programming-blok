import 'package:assets_audio_player/assets_audio_player.dart';

class AudioService {
  static AssetsAudioPlayer _assetsAudioPlayer = AssetsAudioPlayer.newPlayer();
  static bool _isPlaying = false;

  static Future<void> play() async {
    await _assetsAudioPlayer.open(
      Audio('assets/music/music_background2.mp3'),
      showNotification: false,
      loopMode: LoopMode.single, // tambahkan parameter loopMode disini
    );
    _isPlaying = true;
  }

  static Future<void> pause() async {
    await _assetsAudioPlayer.pause();
    _isPlaying = false;
    print(_isPlaying);
  }

  static Future<void> stop() async {
    await _assetsAudioPlayer.stop();
    _isPlaying = false;
  }

  static bool get isPlaying => _isPlaying;
}
