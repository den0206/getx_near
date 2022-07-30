import 'package:flutter/material.dart';

enum AlertVoice { police, help, alert }

extension AlertVoiceEXT on AlertVoice {
  String get soundPath {
    switch (this) {
      case AlertVoice.police:
        return "assets/sounds/police_sound.mp3";
      case AlertVoice.help:
        return "assets/sounds/help_sound.mp3";
      case AlertVoice.alert:
        return "assets/sounds/danger_sound.mp3";
    }
  }

  String get imagePath {
    switch (this) {
      case AlertVoice.police:
        return "assets/images/police.png";
      case AlertVoice.help:
        return "assets/images/help.png";
      case AlertVoice.alert:
        return "assets/images/alarm.png";
    }
  }

  IconData get iconData {
    switch (this) {
      case AlertVoice.police:
        return Icons.local_police_outlined;
      case AlertVoice.help:
        return Icons.front_hand;
      case AlertVoice.alert:
        return Icons.campaign;
      //  return Icons.crisis_alert
    }
  }

  String get description {
    switch (this) {
      case AlertVoice.police:
        return "Call The Police!";
      case AlertVoice.help:
        return "Please Help me!";
      case AlertVoice.alert:
        return "The Alarm goes off!";
    }
  }
}
