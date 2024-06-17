import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pryind/Models/usuario_model.dart';

FirebaseFirestore bdMovil = FirebaseFirestore.instance;

Future<List> getUsuario() async {
  List usuario = [];
  CollectionReference collectionReference = bdMovil.collection('usuarios');
  QuerySnapshot queryUsuario = await collectionReference.get();

  queryUsuario.docs.forEach((documento) {
    usuario.add(documento.data());
  });
  return usuario;
}

Future<void> createUsuario({
  required String nombre,
  required String apellido,
  required String nombreUsuario,
  required String email,
  required String password,
}) async {
  try {
    if (await usuarioOCorreoExiste(nombreUsuario, email)) {
      throw Exception(
          'El nombre de usuario o el correo electrónico ya existen.');
    }

    await bdMovil.collection('usuarios').add({
      'nombre': nombre,
      'apellido': apellido,
      'nombre_usuario': nombreUsuario,
      'correo': email,
      'contraseña': password,
    });
    print('Usuario creado exitosamente.');
  } catch (e) {
    print('Error al crear usuario: $e');
  }
}

Future<bool> usuarioOCorreoExiste(String nombreUsuario, String email) async {
  var usuarioExistente = await bdMovil
      .collection('usuarios')
      .where('nombre_usuario', isEqualTo: nombreUsuario)
      .get();

  if (usuarioExistente.docs.isNotEmpty) {
    return true;
  }

  var emailExistente = await bdMovil
      .collection('usuarios')
      .where('correo', isEqualTo: email)
      .get();

  if (emailExistente.docs.isNotEmpty) {
    return true;
  }

  return false;
}

Future<UsuarioModel?> validarCredenciales(
    String usuarioOCorreo, String password) async {
  var usuarioQuery = await bdMovil
      .collection('usuarios')
      .where('nombre_usuario', isEqualTo: usuarioOCorreo)
      .get();
  if (usuarioQuery.docs.isNotEmpty) {
    var usuarioDoc = usuarioQuery.docs.first;
    var usuarioData = usuarioQuery.docs.first.data();
    if (usuarioData['contraseña'] == password) {
      return UsuarioModel(
        id: usuarioDoc.id,
        nombre: usuarioData['nombre'],
        apellido: usuarioData['apellido'],
        nombreUsuario: usuarioData['nombre_usuario'],
        correoElectronico: usuarioData['correo'],
        contrasena: usuarioData['contraseña'],
      );
    }
  }

  var correoQuery = await bdMovil
      .collection('usuarios')
      .where('correo', isEqualTo: usuarioOCorreo)
      .get();
  if (correoQuery.docs.isNotEmpty) {
    var correoDoc = correoQuery.docs.first;
    var usuarioData = correoQuery.docs.first.data();
    if (usuarioData['contraseña'] == password) {
      return UsuarioModel(
        id: correoDoc.id,
        nombre: usuarioData['nombre'],
        apellido: usuarioData['apellido'],
        nombreUsuario: usuarioData['nombre_usuario'],
        correoElectronico: usuarioData['correo'],
        contrasena: usuarioData['contraseña'],
      );
    }
  }
  return null;
}

Future<void> updateUsuario({
  required String id,
  required String nombre,
  required String apellido,
  required String nombreUsuario,
  required String correoElectronico,
  required String contrasena,
}) async {
  try {
    await bdMovil.collection('usuarios').doc(id).update({
      'nombre': nombre,
      'apellido': apellido,
      'nombre_usuario': nombreUsuario,
      'correo': correoElectronico,
      'contraseña': contrasena,
    });
    print('Usuario actualizado exitosamente.');
  } catch (e) {
    print('Error al actualizar usuario: $e');
  }
}
