import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pryind/Providers/usuario_provider.dart';
import 'package:pryind/firebase_service.dart';

class Options extends StatefulWidget {
  const Options({Key? key});

  @override
  State<Options> createState() => _OptionsState();
}

class _OptionsState extends State<Options> {
  late String _id;
  late String _nombre = "";
  late String _apellido = "";
  late String _username = "";
  late String _email = "";
  late String _password = "";
  late String _confirmpassword = "";
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isValidoEmail(String email) {
    final RegExp emailRegex = RegExp(
        r'^[a-zA-Z0-9]+([._%+-]?[a-zA-Z0-9]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*(\.[a-zA-Z]{2,})+$');
    return emailRegex.hasMatch(email);
  }

  bool isValidoPassword(String password) {
    final RegExp passwordRegex =
        RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[A-Za-z\d@$!%*?&]{8,}$');
    return passwordRegex.hasMatch(password);
  }

  @override
  Widget build(BuildContext context) {
    final usuarioProvider = Provider.of<UsuarioProvider>(context);
    final usuario = usuarioProvider.usuario;
    _id = usuario!.id;
    _nombre = usuario.nombre;
    _apellido = usuario.apellido;
    _username = usuario.nombreUsuario;
    _email = usuario.correoElectronico;
    _password = usuario.contrasena;
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Configuración de Usuario y Cuenta'),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircleAvatar(
                  radius: 60,
                  backgroundImage: AssetImage('images/hombre.jpg'), 
                  backgroundColor: Colors.transparent,
                ),
                SizedBox(height: 20),
                TextFormField(
                  initialValue: _nombre,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'Nombre',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese su nombre';
                    }
                    return null;
                  },
                  onSaved: (String? value) {
                    _nombre = value!;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  initialValue: _apellido,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'Apellido',
                    prefixIcon: Icon(Icons.person_outline),
                    border: OutlineInputBorder(),
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese su apellido';
                    }
                    return null;
                  },
                  onSaved: (String? value) {
                    _apellido = value!;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  initialValue: _username,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'Nombre de Usuario',
                    prefixIcon: Icon(Icons.account_circle),
                    border: OutlineInputBorder(),
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese su nombre de usuario';
                    } else if (value != value.toLowerCase()) {
                      return 'El nombre de usuario debe estar en minúsculas';
                    }
                    return null;
                  },
                  onSaved: (String? value) {
                    _username = value!;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  initialValue: _email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Correo Electrónico',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese su correo electrónico';
                    } else if (!isValidoEmail(value)) {
                      return 'Por favor ingrese un correo válido';
                    }
                    return null;
                  },
                  onSaved: (String? value) {
                    _email = value!;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  initialValue: _password,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(),
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese una contraseña';
                    } else if (!isValidoPassword(value)) {
                      return 'La contraseña debe tener al menos una mayúscula, una minúscula y un número.';
                    }
                    _password = value;
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  initialValue: _confirmpassword,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Confirmar Contraseña',
                    prefixIcon: Icon(Icons.lock_outline),
                    border: OutlineInputBorder(),
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese la misma contraseña para confirmación';
                    } else if (value != _password) {
                      return 'Las contraseñas no coinciden';
                    }
                    return null;
                  },
                  onChanged: (String value) {
                    _confirmpassword = value;
                  },
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      try {
                        await updateUsuario(
                          id: _id,
                          nombre: _nombre,
                          apellido: _apellido,
                          nombreUsuario: _username,
                          correoElectronico: _email,
                          contrasena: _password,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Datos actualizados exitosamente')),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error al actualizar datos: $e')),
                        );
                      }
                    }
                  },
                  child: Text(
                    'Guardar Cambios',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    textStyle: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Text(
                  'Opciones Adicionales:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                ListTile(
                  leading: Icon(Icons.color_lens, color: Colors.deepPurple),
                  title: Text('Tema de la Aplicación'),
                  onTap: () {},
                ),
                ListTile(
                  leading: Icon(Icons.language, color: Colors.deepPurple),
                  title: Text('Idioma de la Aplicación'),
                  onTap: () {},
                ),
                ListTile(
                  leading: Icon(Icons.notifications, color: Colors.deepPurple),
                  title: Text('Notificaciones'),
                  onTap: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
