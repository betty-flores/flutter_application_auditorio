import 'package:flutter/material.dart';
import 'package:flutter_application_auditorio/bienvenida.dart';
import 'inicio.dart';

void main() {
  runApp(MaterialApp(
    routes: {
      '/login': (context) => Login(),
      '/bienvenida': (context) => Bienvenida(),
    },
    initialRoute: '/login',
  ));
}
