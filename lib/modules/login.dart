import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pryind/Models/usuario_model.dart';
import 'package:pryind/Providers/usuario_provider.dart';
import 'package:pryind/firebase_service.dart';

class Login extends StatefulWidget {
  const Login({Key? key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late String _usuarioOCorreo;
  late String _password;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio de Sesión'),
        backgroundColor: Colors.deepPurple, 
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
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
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    labelText: 'Correo Electrónico o nombre de usuario',
                    icon: Icon(Icons.person_outline, color: Colors.deepPurple),
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese su correo electrónico o nombre de usuario';
                  }
                  return null;
                },
                onSaved: (String? value) {
                  _usuarioOCorreo = value!;
                },
              ),
              TextFormField(
                obscureText: true,
                decoration: InputDecoration(
                    labelText: 'Contraseña',
                    icon: Icon(Icons.lock_outline, color: Colors.deepPurple),
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese su contraseña';
                  }
                  return null;
                },
                onSaved: (String? value) {
                  _password = value!;
                },
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      Navigator.pushNamed(context, '/register');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple, 
                    ),
                    child: Text(
                      'Registrarse',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        UsuarioModel? usuario = await validarCredenciales(
                            _usuarioOCorreo, _password);

                        if (usuario != null) {
                          Provider.of<UsuarioProvider>(context, listen: false)
                              .setUsuario(usuario);
                          Navigator.of(context).popAndPushNamed('/Lista_songs');
                        } else {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Error'),
                              content: Text('Credenciales incorrectas.'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Aceptar'),
                                ),
                              ],
                            ),
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple, 
                    ),
                    child: Text(
                      'Iniciar Sesión',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
