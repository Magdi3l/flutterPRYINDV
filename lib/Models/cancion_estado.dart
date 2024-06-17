import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pryind/Models/canciones_model.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:share/share.dart';

class PlayerStateNotifier extends ChangeNotifier {
  final AudioPlayer _audioPlayer = AudioPlayer();
  List<Cancion> _canciones = [];
  int _currentSongIndex = 0;
  bool _isShuffle = false;
  Cancion? _currentCancion;
  bool _isPlaying = false;
  double _currentPosition = 0.0;
  Duration _duration = const Duration();
  double _currentVolume = 0.5;

  AudioPlayer get audioPlayer => _audioPlayer;
  Cancion? get currentCancion => _currentCancion;
  bool get isPlaying => _isPlaying;
  double get currentPosition => _currentPosition;
  Duration get duration => _duration;
  bool get isShuffle => _isShuffle;
  double get currentVolume => _currentVolume;


  set canciones(List<Cancion> canciones) {
    _canciones = canciones;
    notifyListeners();
  }

  void shareCurrentSong() {
  if (_currentCancion != null) {
    String shareText = 'Escuchando "${_currentCancion!.name}" de ${_currentCancion!.artist}';
    Share.share(shareText);
  }
}

  void toggleShuffle() {
    _isShuffle = !_isShuffle;
    notifyListeners();
  }

  void setVolume(double volume) {
    _currentVolume = volume;
    _audioPlayer.setVolume(volume);
    notifyListeners();
  }

  void nextSong() {
  if (_canciones.isNotEmpty) {
    if (_isShuffle) {
      int nextIndex = Random().nextInt(_canciones.length);
      if (_canciones.length > 1) {
        while (nextIndex == _currentSongIndex) {
          nextIndex = Random().nextInt(_canciones.length);
        }
      }
      _currentSongIndex = nextIndex;
    } else {
      _currentSongIndex = (_currentSongIndex + 1) % _canciones.length;
    }
    playCancion(_canciones[_currentSongIndex]);
  }
}

  void previousSong() {
    if (_canciones.isNotEmpty) {
      _currentSongIndex = (_currentSongIndex - 1 + _canciones.length) % _canciones.length;
      playCancion(_canciones[_currentSongIndex]);
    }
  }

  PlayerStateNotifier() {
    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (state == PlayerState.completed) {
        _isPlaying = false;
        _currentPosition = 0.0;
        notifyListeners();
      }
    });

    _audioPlayer.onDurationChanged.listen((duration) {
      _duration = duration;
      notifyListeners();
    });

    _audioPlayer.onPositionChanged.listen((position) {
      _currentPosition = position.inMilliseconds.toDouble();
      notifyListeners();
    });
  }

  

  void playCancion(Cancion cancion) async {
    _currentCancion = cancion;
    await _audioPlayer.play(BytesSource(cancion.bytes));
    _isPlaying = true;
    notifyListeners();
  }

  void togglePlaying() {
    if (_isPlaying) {
      _audioPlayer.pause();
    } else {
      _audioPlayer.resume();
    }
    _isPlaying = !_isPlaying;
    notifyListeners();
  }

  void seek(double position) {
    _audioPlayer.seek(Duration(milliseconds: position.toInt()));
    _currentPosition = position;
    notifyListeners();
  }
}
