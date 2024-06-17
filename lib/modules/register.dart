// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:pryind/firebase_service.dart'; 

class Register extends StatefulWidget {
  const Register({Key? key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  late String _name = '';
  late String _apellido = '';
  late String _email = '';
  late String _password = '';
  late String _confirmPassword = '';
  late String _nombreUsuario = '';
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro de Usuario'),
        backgroundColor: Colors.deepPurple, 
      ),
      body: Padding(
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
              TextFormField(
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
                  _name = value!;
                },
              ),
              TextFormField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: 'Apellido',
                  prefixIcon: Icon(Icons.person_outline),
                  border: OutlineInputBorder(),
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Pro favor ingrese su apellido';
                  }
                  return null;
                },
                onSaved: (String? value) {
                  _apellido = value!;
                },
              ),
              TextFormField(
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
                  _nombreUsuario = value!;
                },
              ),
              TextFormField(
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
                    return 'Por favor ingresa un correo válido.';
                  }
                  return null;
                },
                onSaved: (String? value) {
                  _email = value!;
                },
              ),
              TextFormField(
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
              TextFormField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Confirmar contraseña',
                  prefixIcon: Icon(Icons.lock_outline),
                  border: OutlineInputBorder(),
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese la misma contraseña para confirmación';
                  } else if (value != _password) {
                    return 'Las contraseñas no coinciden.';
                  }
                  return null;
                },
                onChanged: (String value) {
                  _confirmPassword = value;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    bool existe =
                        await usuarioOCorreoExiste(_nombreUsuario, _email);
                    if (existe) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Error'),
                          content: Text(
                              'El nombre de usuario o correo electrónico ya existen.'),
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
                      return;
                    }

                    try {
                      await createUsuario(
                        nombre: _name,
                        apellido: _apellido,
                        nombreUsuario: _nombreUsuario,
                        email: _email,
                        password: _password,
                      );
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                            title: Text("Exito"),
                            content: Text('Usuario creado exitosamente.'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  Navigator.pushNamed(context, '/login');
                                },
                                child: Text('Aceptar'),
                              )
                            ]),
                      );
                      print('Nombre: $_name');
                      print('Apellido: $_apellido');
                      print('Nombre Usuario: $_nombreUsuario');
                      print('Correo Electrónico: $_email');
                      print('Contraseña: $_password');
                    } catch (e) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Error'),
                          content: Text(e.toString()),
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
                  'Registrarse',
                  style: TextStyle(
                  color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
