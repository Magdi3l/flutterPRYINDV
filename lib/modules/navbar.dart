import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pryind/Providers/usuario_provider.dart';

class NavBar extends StatelessWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final usuarioProvider = Provider.of<UsuarioProvider>(context);
    final usuario = usuarioProvider.usuario;

    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Row(
              children: [
                Text(usuario != null ? '${usuario.nombre} ${usuario.apellido}' : 'Invitado'),
                SizedBox(width: 10),
                Text(
                  usuario?.nombreUsuario ?? '',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white70,
                  ),
                )
              ],
            ),
            accountEmail: Text(usuario?.correoElectronico ?? ""),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Image.asset("images/hombre.jpg"),
              ),
            ),
          ),
          if (usuario != null) 
          ListTile(
            leading: Icon(Icons.library_music),
            title: Text("Lista de Canciones"),
            onTap: () {
              Navigator.pushNamed(context, '/Lista_songs');
            },
          ),
          if (usuario == null) 
            ListTile(
              leading: Icon(Icons.face),
              title: Text("Login"),
              onTap: () {
                Navigator.pushNamed(context, '/login');
              },
            ),
          if (usuario == null)
            ListTile(
              leading: Icon(Icons.person_add),
              title: Text("Register"),
              onTap: () {
                Navigator.pushNamed(context, '/register');
              },
            ),
          if (usuario != null) 
            ListTile(
              leading: Icon(Icons.settings),
              title: Text("Configuraciones"),
              onTap: () {
                Navigator.pushNamed(context, '/options');
              },
            ),
            ListTile(
              leading: Icon(Icons.description),
              title: Text("Nosotros"),
              onTap: () {
                Navigator.pushNamed(context, '/description');
              },
            ),
          Spacer(),
          if (usuario != null)
            ListTile(
              leading: Icon(Icons.logout),
              title: Text("Cerrar Sesión"),
              onTap: () {
                usuarioProvider.clearUsuario();
                Navigator.pushNamed(context, '/login');
              },
            ),
        ],
      ),
    );
  }
}
