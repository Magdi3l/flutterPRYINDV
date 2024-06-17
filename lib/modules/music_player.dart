import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pryind/Models/cancion_estado.dart';
import 'package:pryind/Models/canciones_model.dart';

class MusicPlayer extends StatelessWidget {
  final bool compact;
  final Cancion? cancion;

  const MusicPlayer({super.key, this.compact = false, this.cancion});

  @override
  Widget build(BuildContext context) {
    return Consumer<PlayerStateNotifier>(
      builder: (context, playerState, child) {
        if (cancion != null && playerState.currentCancion != cancion) {
          playerState.playCancion(cancion!);
        }
        return compact ? buildCompactPlayer(context, playerState) : buildFullPlayer(context, playerState);
      },
    );
  }

  Widget buildFullPlayer(BuildContext context, PlayerStateNotifier playerState) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple, 
        leading: IconButton(
          icon: Icon(Icons.keyboard_arrow_down, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {},
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                playerState.currentCancion?.name ?? 'Nombre de la canción',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                textAlign: TextAlign.center, 
              ),
            ),
          ),
          Text(
            playerState.currentCancion?.artist ?? 'Nombre del Artista',
            style: TextStyle(fontSize: 18, color: Colors.deepPurple.shade300),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.3),
              borderRadius: BorderRadius.circular(100), 
            ),
            child: playerState.currentCancion?.imagen.isNotEmpty == true
                ? ClipOval(
                    child: Image.network(playerState.currentCancion!.imagen, fit: BoxFit.cover)
                  )
                : Icon(Icons.music_note, size: 100, color: Colors.deepPurple),
          ),
          SizedBox(height: 20),
          SliderTheme(
            data: SliderThemeData(
              thumbColor: Colors.deepPurple,
              activeTrackColor: Colors.deepPurple.shade200,
              inactiveTrackColor: Colors.deepPurple.shade100,
              overlayColor: Colors.purple.withAlpha(32),
            ),
            child: Slider(
              value: playerState.currentPosition,
              onChanged: (value) {
                playerState.seek(value);
              },
              min: 0.0,
              max: playerState.duration.inMilliseconds.toDouble(),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.skip_previous, color: Colors.deepPurple),
                onPressed: () {
                  Provider.of<PlayerStateNotifier>(context, listen: false).previousSong();
                },
              ),
              IconButton(
                icon: Icon(playerState.isPlaying ? Icons.pause : Icons.play_arrow, color: Colors.deepPurple),
                onPressed: playerState.togglePlaying,
              ),
              IconButton(
                icon: Icon(Icons.skip_next, color: Colors.deepPurple),
                onPressed: () {
                  Provider.of<PlayerStateNotifier>(context, listen: false).nextSong();
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.shuffle),
                color: playerState.isShuffle ? Colors.orange : Colors.grey, 
                onPressed: () {
                  Provider.of<PlayerStateNotifier>(context, listen: false).toggleShuffle();
                },
              ),
            ],
          ),
          Slider(
            value: playerState.currentVolume,
            onChanged: (value) {
              playerState.setVolume(value);
            },
            min: 0.0,
            max: 1.0,
            divisions: 10,
            label: playerState.currentVolume.toStringAsFixed(1),
          ),
        ],
      ),
    );
  }

  Widget buildCompactPlayer(BuildContext context, PlayerStateNotifier playerState) {
    return Container(
      color: Colors.deepPurple.shade50,
      padding: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MusicPlayer(
                    compact: false,
                    cancion: playerState.currentCancion,
                  ),
                ),
              );
            },
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.3),
                borderRadius: BorderRadius.circular(25),
              ),
              child: playerState.currentCancion?.imagen.isNotEmpty == true
                  ? ClipOval(
                      child: Image.network(playerState.currentCancion!.imagen, fit: BoxFit.cover)
                    )
                  : Icon(Icons.album, size: 50, color: Colors.deepPurple),
            ),
          ),
          Expanded(
            child: Text(
              playerState.currentCancion?.name ?? 'Nombre de la canción',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.deepPurple),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            icon: Icon(playerState.isPlaying ? Icons.pause : Icons.play_arrow, color: Colors.deepPurple),
            onPressed: playerState.togglePlaying,
          ),
          IconButton(
            icon: Icon(Icons.shuffle, color: playerState.isShuffle ? Colors.orange : Colors.grey),
            onPressed: () {
              Provider.of<PlayerStateNotifier>(context, listen: false).toggleShuffle();
            },
          ),
        ],
      ),
    );
  }
}
