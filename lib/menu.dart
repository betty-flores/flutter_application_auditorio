import 'package:flutter/material.dart';
import 'package:flutter_application_auditorio/usuario.dart';

class Menu extends StatefulWidget {
  Menu({Key? key}) : super(key: key);

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    final parametros = ModalRoute.of(context)!.settings.arguments as Usuario;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.all(0),
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(""),
            accountEmail: Text(parametros.usuario),
          ),
          ListTile(
            title: Text('Perfil'),
            leading: Icon(Icons.person),
            onTap: () {},
          ),
          ListTile(
            title: Text('Archivos'),
            leading: Icon(Icons.archive),
            onTap: () {},
          )
        ],
      ),
    );
  }
}
