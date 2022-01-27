import 'package:flutter/material.dart';
import 'package:flutter_application_auditorio/menu.dart';
import 'package:flutter_application_auditorio/usuario.dart';

class Bienvenida extends StatefulWidget {
  static const routeName = '/bienvenida';

  @override
  State<Bienvenida> createState() => _BienvenidaState();
}

class _BienvenidaState extends State<Bienvenida> {
  @override
  Widget build(BuildContext context) {
    final parametros = ModalRoute.of(context)!.settings.arguments as Usuario;

    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      drawer: Menu(),
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.all(20),
            alignment: Alignment.center,
            child: Text(
              'Bienvenido ' + parametros.usuario,
            ),
          )
        ],
      ),
    );
  }
}
