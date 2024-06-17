import 'package:flutter/material.dart';

class Description extends StatelessWidget {
  const Description({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Acerca de MusicApp'),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Bienvenido a MusicApp',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'MusicApp es tu nuevo compañero musical, diseñado para ofrecer la mejor experiencia de reproducción de música en cualquier momento y lugar. Descubre una amplia variedad de funciones que te permitirán disfrutar de tu música favorita como nunca antes.',
                style: TextStyle(fontSize: 18, color: Colors.black87),
              ),
              SizedBox(height: 20),
              Text(
                'Características Principales:',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              SizedBox(height: 10),
              _buildFeatureItem(
                icon: Icons.library_music,
                title: 'Biblioteca de Música',
                description:
                    'Accede a una vasta colección de canciones de todos los géneros y épocas.',
              ),
              _buildFeatureItem(
                icon: Icons.playlist_play,
                title: 'Listas de Reproducción Personalizadas',
                description:
                    'Crea y organiza tus propias listas de reproducción según tu estado de ánimo o actividad.',
              ),
              _buildFeatureItem(
                icon: Icons.radio,
                title: 'Radio en Vivo',
                description:
                    'Sintoniza estaciones de radio en vivo de todo el mundo y descubre nuevos artistas.',
              ),
              _buildFeatureItem(
                icon: Icons.equalizer,
                title: 'Ecualizador Personalizado',
                description:
                    'Ajusta el sonido a tu gusto con nuestro ecualizador avanzado.',
              ),
              _buildFeatureItem(
                icon: Icons.download,
                title: 'Descarga de Música',
                description:
                    'Descarga tus canciones favoritas para escucharlas sin conexión.',
              ),
              SizedBox(height: 20),
              Text(
                'Interfaz Intuitiva:',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Nuestra aplicación cuenta con una interfaz limpia y fácil de usar, diseñada para que encuentres y reproduzcas tu música de manera rápida y sencilla. Navega a través de tus canciones, álbumes y artistas favoritos con unos pocos toques.',
                style: TextStyle(fontSize: 18, color: Colors.black87),
              ),
              SizedBox(height: 20),
              Text(
                '¡Descarga MusicApp ahora y lleva tu experiencia musical al siguiente nivel!',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                  
                  },
                  child: Text('Descargar MusicApp'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    textStyle: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem(
      {required IconData icon,
      required String title,
      required String description}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.deepPurple, size: 30),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
