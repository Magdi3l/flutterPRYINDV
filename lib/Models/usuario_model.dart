class UsuarioModel {
  final String id;
  final String nombre;
  final String apellido;
  final String nombreUsuario;
  final String correoElectronico;
  final String contrasena;

  UsuarioModel(
      {
      required this.id,
      required this.nombre,
      required this.apellido,
      required this.nombreUsuario,
      required this.correoElectronico,
      required this.contrasena});
}
