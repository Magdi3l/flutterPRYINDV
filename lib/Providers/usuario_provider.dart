import 'package:flutter/material.dart';
import 'package:pryind/Models/usuario_model.dart';

class UsuarioProvider with ChangeNotifier {
  UsuarioModel? _usuario;
  UsuarioModel? get usuario => _usuario;
  void setUsuario(UsuarioModel usuario) {
    _usuario = usuario;
    notifyListeners();
  }

  void clearUsuario() {
    _usuario = null;
    notifyListeners();
  }
}
