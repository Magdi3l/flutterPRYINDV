import 'dart:convert';
import 'dart:typed_data';
import 'package:provider/provider.dart';
import 'package:pryind/Models/cancion_estado.dart';
import 'package:pryind/Models/canciones_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:pryind/modules/navbar.dart';
import 'music_player.dart';

class SongList extends StatefulWidget {
  const SongList({Key? key}) : super(key: key);

  @override
  State<SongList> createState() => _SongListState();
}

class _SongListState extends State<SongList> {
  List<Cancion> _canciones = [];

  @override
  void initState() {
    super.initState();
    _loadSongsFromStorage();
  }

  void _loadSongsFromStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? cancionesJson = prefs.getStringList('canciones');

    if (cancionesJson != null) {
      List<Cancion> canciones =
          cancionesJson.map((json) => Cancion.fromJson(jsonDecode(json))).toList();
      setState(() {
        _canciones = canciones;
      });
    }
  }

  void _saveSongsToStorage(List<Cancion> canciones) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> cancionesJson =
        canciones.map((cancion) => jsonEncode(cancion.toJson())).toList();
    prefs.setStringList('canciones', cancionesJson);
  }

  Future<void> _selectSongs() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.audio,
        allowMultiple: true,
      );
      if (result != null) {
        List<PlatformFile> files = result.files;

        for (var file in files) {
          Uint8List bytes = file.bytes ?? Uint8List(0);
          String fileName = file.name;
          String? artist = await _showEditDialog(
            title: 'Ingrese el nombre del artista',
            initialValue: 'Desconocido',
          );
          String? image = await _showEditDialog(
            title: 'Ingrese la URL de la imagen',
            initialValue: '',
          );

          Cancion cancion = Cancion(
            name: fileName,
            artist: artist ?? 'Desconocido',
            imagen: image ?? '',
            bytes: bytes,
          );

          setState(() {
            _canciones.add(cancion);
          });
        }
        _saveSongsToStorage(_canciones);
      }
    } catch (E) {
      print('Error al seleccionar canción: $E');
    }
  }

  Future<String?> _showEditDialog({
  required String title,
  required String initialValue,
  String? additionalSubtitle,  
}) {
  TextEditingController textController = TextEditingController(text: initialValue);

  return showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (additionalSubtitle != null) 
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text('Archivo: $additionalSubtitle', 
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  )),
              ),
            Text('Actual: $initialValue',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              )),
            TextField(
              controller: textController,
              decoration: InputDecoration(hintText: 'Ingrese nuevo valor'),
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(textController.text);
            },
            child: Text('Guardar'),
          ),
        ],
      );
    },
  );
}


 void _editSong(Cancion oldCancion) async {
  String? name = await _showEditDialog(
    title: 'Editar nombre de la canción',
    initialValue: oldCancion.name,
  );
  String? artist = await _showEditDialog(
    title: 'Editar nombre del artista',
    initialValue: oldCancion.artist,
    additionalSubtitle: oldCancion.name,
  );
  String? image = await _showEditDialog(
    title: 'Editar URL de la imagen',
    initialValue: oldCancion.imagen,
  );

  if (name != null && artist != null && image != null) {
    setState(() {
      int index = _canciones.indexOf(oldCancion);
      if (index != -1) {
        _canciones[index] = Cancion(
          name: name,
          artist: artist,
          imagen: image,
          bytes: oldCancion.bytes,
        );
      }
      _saveSongsToStorage(_canciones);
    });
  }
}

  void _deleteSong(Cancion cancion) {
    setState(() {
      _canciones.remove(cancion);
    });
    _saveSongsToStorage(_canciones);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavBar(),
      appBar: AppBar(
        title: Text('Lista de Canciones'),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: SongSearchDelegate(_canciones));
            },
          ),
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: ListView.builder(
          itemCount: _canciones.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(_canciones[index].name),
              subtitle: Text(_canciones[index].artist),
              leading: CircleAvatar(
                backgroundImage: _canciones[index].imagen.isNotEmpty ? NetworkImage(_canciones[index].imagen) : null,
                child: _canciones[index].imagen.isNotEmpty ? Icon(Icons.music_note) : null,
              ),
              trailing: PopupMenuButton<String>(
                onSelected: (String value) {
                  if (value == 'edit') {
                    _editSong(_canciones[index]);
                  } else if (value == 'delete') {
                    _deleteSong(_canciones[index]);
                  }
                },
                itemBuilder: (BuildContext context) {
                  return [
                    PopupMenuItem<String>(
                      value: 'edit',
                      child: Text('Editar'),
                    ),
                    PopupMenuItem<String>(
                      value: 'delete',
                      child: Text('Eliminar'),
                    ),
                  ];
                },
              ),
              onTap: () {
                Provider.of<PlayerStateNotifier>(context, listen: false)
                    ..canciones = _canciones
                    ..playCancion(_canciones[index]);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MusicPlayer(compact: false),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _selectSongs,
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: MusicPlayer(compact: true),
    );
  }
}

class SongSearchDelegate extends SearchDelegate<String> {
  final List<Cancion> canciones;
  SongSearchDelegate(this.canciones);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final List<Cancion> results = canciones
        .where((cancion) => cancion.name.toLowerCase().contains(query.toLowerCase()) ||
                            cancion.artist.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(results[index].name),
          subtitle: Text(results[index].artist),
          leading: CircleAvatar(
            backgroundImage: results[index].imagen.isNotEmpty
                ? NetworkImage(results[index].imagen)
                : null,
            child: results[index].imagen.isNotEmpty ? Icon(Icons.music_note) : null,
          ),
          trailing: PopupMenuButton<String>(
            onSelected: (String value) {
              if (value == 'edit') {
                _editSong(context, results[index]);
              } else if (value == 'delete') {
                _deleteSong(context, results[index]);
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: 'edit',
                  child: Text('Editar'),
                ),
                PopupMenuItem<String>(
                  value: 'delete',
                  child: Text('Eliminar'),
                ),
              ];
            },
          ),
          onTap: () {
            Provider.of<PlayerStateNotifier>(context, listen: false)
                ..playCancion(results[index]);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MusicPlayer(compact: false),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<Cancion> suggestions = canciones
        .where((cancion) => cancion.name.toLowerCase().contains(query.toLowerCase()) ||
                            cancion.artist.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(suggestions[index].name),
          subtitle: Text(suggestions[index].artist),
          leading: CircleAvatar(
            backgroundImage: suggestions[index].imagen.isNotEmpty
                ? NetworkImage(suggestions[index].imagen)
                : null,
            child: suggestions[index].imagen.isNotEmpty ? Icon(Icons.music_note) : null,
          ),
          onTap: () {
            query = suggestions[index].name;
            showResults(context);
          },
        );
      },
    );
  }

  void _editSong(BuildContext context, Cancion cancion) {
  
  }

  void _deleteSong(BuildContext context, Cancion cancion) {
    
  }
}
