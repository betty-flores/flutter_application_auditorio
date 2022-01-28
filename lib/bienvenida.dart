import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_application_auditorio/menu.dart';
import 'package:flutter_application_auditorio/usuario.dart';

import 'itinerario.dart';

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
          ),
          Container(
            child: Card(
              child: FutureBuilder(
                future: getItinerario(),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.data == null) {
                    return Container(
                      child: Center(
                        child: Text(''),
                      ),
                    );
                  } else {
                    return ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, i) {
                          return ListTile(
                            title: Text(snapshot.data[i].presentador),
                            subtitle: Text(snapshot.data[i].hora),
                          );
                        });
                  }
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  getItinerario() async {
    var url = 'http://0ad6-186-66-181-202.ngrok.io/itinerario';
    var response = await http.get(Uri.parse(url));
    var datos = jsonDecode(response.body);
    print(datos);
    List<Itinerario> itinerarios = [];

    for (var i in datos) {
      Itinerario itin = Itinerario(i['hora'], i['presentador']);
      itinerarios.add(itin);
    }

    print(itinerarios.length);
    return itinerarios;
  }
}
