import 'package:assets_audio_player/assets_audio_player.dart';

class ButtonAudioService {
  static AssetsAudioPlayer _assetsAudioPlayer = AssetsAudioPlayer.newPlayer();

  static void playButtonSound() {
    _assetsAudioPlayer.open(
      Audio('assets/music/button_click.mp3'),
      showNotification: false,
      loopMode: LoopMode.single,
      playInBackground: PlayInBackground.enabled,
    );
  }
}
