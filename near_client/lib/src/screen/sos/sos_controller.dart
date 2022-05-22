import 'package:flutter/services.dart';
import 'package:get/state_manager.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';

class SOSController extends GetxController {
  late AudioPlayer _player;

  /* --- PLAYER CONTROL  --- */
  void play() => _player.play();

  void pause() => _player.pause();

  RxBool isPlaying = false.obs;

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
      await _player.setAsset("assets/sounds/sos_sound.mp3");
      await _player.setLoopMode(LoopMode.one);

      await _player.load();
    } catch (e) {
      print(e);
    }

    print(_player.duration);
    print(_player.volume);
  }
}
