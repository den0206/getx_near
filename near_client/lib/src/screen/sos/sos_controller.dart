import 'package:flutter/services.dart';
import 'package:get/state_manager.dart';
import 'package:getx_near/src/model/alert_voice.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';

class SOSController extends GetxController {
  late AudioPlayer _player;

  void play() => _player.play();

  void pause() => _player.pause();

  RxBool isPlaying = false.obs;
  AlertVoice currentAlert = AlertVoice.police;

  @override
  void onInit() async {
    super.onInit();
    await _setupSession();
    await _loadAsset();
    _player.playingStream.listen((playing) {
      isPlaying.call(playing);
      if (playing) HapticFeedback.vibrate();
    });
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _setupSession() async {
    _player = AudioPlayer();
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration.speech());
  }

  Future<void> _loadAsset() async {
    try {
      await _player.setAsset(currentAlert.soundPath);
      await _player.setLoopMode(LoopMode.one);

      await _player.load();
    } catch (e) {
      print(e);
    }

    print(_player.duration);
    print(_player.volume);
  }

  void selectAlert(AlertVoice alert) async {
    currentAlert = alert;
    await _loadAsset();
    update();
  }
}
