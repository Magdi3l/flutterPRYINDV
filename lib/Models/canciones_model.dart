import 'dart:convert';
import 'dart:typed_data';

class Cancion {
  final String name;
  final String artist;
  final String imagen;
  final Uint8List bytes;

  Cancion({
    required this.name,
    required this.artist,
    required this.imagen,
    required this.bytes,
  });

  factory Cancion.fromJson(Map<String, dynamic> json) {
    return Cancion(
      name: json['name'],
      artist: json['artist'],
      imagen: json['imagen'],
      bytes: base64Decode(json['bytes']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'artist': artist,
      'imagen': imagen,
      'bytes': base64Encode(bytes),
    };
  }
}
