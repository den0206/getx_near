import 'dart:async';

import 'package:flutter/services.dart';
import 'package:get/state_manager.dart';
import 'package:getx_near/src/model/alert_voice.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';

class SOSController extends GetxController {
  late AudioPlayer _player;
  Timer? _timer;

  void play() => _player.play();

  void pause() => _player.pause();

  RxBool isPlaying = false.obs;
  AlertVoice currentAlert = AlertVoice.police;

  @override
  void onInit() async {
    super.onInit();
    await _setupSession();
    await _loadAsset();
    continuousViblation();
  }

  void releaseController(GetBuilderState<SOSController> state) {
    print("close SOS");
    _timer?.cancel();
    // _player.stop();
    _player.dispose();
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
  }

  void continuousViblation() {
    _player.playingStream.listen((playing) {
      isPlaying.call(playing);
      if (playing) {
        // 一秒毎にバイブレーション
        _timer = Timer.periodic(
          Duration(seconds: 1),
          (timer) {
            HapticFeedback.vibrate();
          },
        );
      } else {
        _timer?.cancel();
      }
    });
  }

  void selectAlert(AlertVoice alert) async {
    currentAlert = alert;
    await _loadAsset();
    update();
  }
}
