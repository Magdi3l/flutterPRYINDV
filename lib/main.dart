import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:pryind/Models/cancion_estado.dart';
import 'package:pryind/Models/canciones_model.dart';
import 'package:pryind/Providers/usuario_provider.dart';
import 'firebase_options.dart';
import 'package:pryind/modules/description.dart';
import 'package:pryind/modules/lista_canciones.dart';
import 'package:pryind/modules/login.dart';
import 'package:pryind/modules/music_player.dart' as player;
import 'package:pryind/modules/navbar.dart';
import 'package:pryind/modules/options.dart';
import 'package:pryind/modules/register.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
      ChangeNotifierProvider(create: (_) => UsuarioProvider()),
      ChangeNotifierProvider(create: (_) => PlayerStateNotifier()),
    ], 
    child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/Lista_songs': (context) => SongList(),
        '/login': (context) => Login(),
        '/register': (context) => Register(),
        '/description': (context) => Description(),
        '/options': (context) => Options()
      },
      title: 'MusicPlayer',
      home: Scaffold(
        drawer: NavBar(),
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          title: const Center(
            child: Text(
              'MelodyPlayer',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          backgroundColor: Color.fromARGB(255, 15, 44, 43),
        ),
        body: const player.MusicPlayer(),
      ),
    );
  }
}

class SongSearchDelegate extends SearchDelegate<String> {
  SongSearchDelegate(List<Cancion> canciones);

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
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}
