// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_application_auditorio/bienvenida.dart';
import 'package:flutter_application_auditorio/usuario.dart';
import 'package:flutter_geofence/geofence.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final user = TextEditingController();
  final password = TextEditingController();
  var en_auditorio = false;

  static const routeName = '/login';

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();

  Geolocation location = Geolocation(
      latitude: -2.738011,
      longitude: -78.8480901,
      radius: 50.0,
      id: "Auditorio");

  String us = '';
  String pass = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 50, horizontal: 20),
            alignment: Alignment.center,
            child: Image.asset('assets/logo.png'),
          ),
          Container(
            padding: EdgeInsets.all(15),
            child: TextField(
              controller: user,
              decoration:
                  InputDecoration(hintText: 'Usuario', icon: Icon(Icons.email)),
            ),
          ),
          Container(
            padding: EdgeInsets.all(15),
            child: TextField(
              controller: password,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Contraseña',
                icon: Icon(Icons.vpn_key),
              ),
            ),
          ),
          Container(
              padding: EdgeInsets.all(15),
              alignment: Alignment.center,
              child: RaisedButton(
                onPressed: () {
                  us = user.text;
                  pass = password.text;

                  if (us != '' && pass != '') {
                    guardar_datos(us, pass);
                    getUser(us);
                  } else {
                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(''),
                            content: SingleChildScrollView(
                              child: ListBody(
                                children: [Text('Verifica tus datos')],
                              ),
                            ),
                            actions: [
                              FlatButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Aceptar')),
                            ],
                          );
                        });
                  }

                  //print(us + ' ' + pass);

                  user.text = '';
                  password.text = '';
                },
                child: Text(
                  'Ingresar',
                  style: TextStyle(
                    fontFamily: 'rbold',
                    fontSize: 18,
                  ),
                ),
              ))
        ],
      ),
    );
  }

  /*

  getUserData() async {
    var response =
        await http.get(Uri.https('jsonplaceholder.typicode.com', 'users'));
    var datos = jsonDecode(response.body);
    print(datos);
    List<Usuario> usuarios = [];

    for (var u in datos) {
      Usuario usuario = Usuario(u['email']);
      usuarios.add(usuario);
    }

    print(usuarios.length);
    return usuarios;
  }*/

  getUser(String us) async {
    var url = 'http://0ad6-186-66-181-202.ngrok.io/autenticar';
    var response = await http.get(Uri.parse(url));
    var datos = jsonDecode(response.body);
    var ex = false;

    for (var u in datos) {
      Usuario usuario = Usuario(u['email']);
      if (usuario.usuario == us) {
        ex = true;
      }
    }

    if (ex == true) {
      Navigator.pushNamed(context, Bienvenida.routeName,
          arguments: Usuario(us));
      print('Bienvenido');
    } else {
      print('Usuario no encontrado');
    }
  }

  Future<void> guardar_datos(usuario, contrasena) async {
    SharedPreferences prefers = await SharedPreferences.getInstance();
    prefers.setString('usuario', usuario);
  }

  Future<void> mostrar_datos() async {
    SharedPreferences prefers = await SharedPreferences.getInstance();
    setState(() {
      us = prefers.getString('usuario') ?? ' ';
    });

    if (us != ' ') {
      Navigator.pushNamed(context, Bienvenida.routeName,
          arguments: Usuario(us));
    }
  }

  void scheduleNotification(String title, String subtitle) {
    print("scheduling one with $title and $subtitle");
    var rng = new Random();
    Future.delayed(Duration(seconds: 5)).then((result) async {
      var androidPlatformChannelSpecifics = AndroidNotificationDetails(
          'your channel id', 'your channel name',
          channelDescription: 'your channel description',
          importance: Importance.high,
          priority: Priority.high,
          ticker: 'ticker');
      var iOSPlatformChannelSpecifics = IOSNotificationDetails();
      var platformChannelSpecifics = NotificationDetails(
          android: androidPlatformChannelSpecifics,
          iOS: iOSPlatformChannelSpecifics);
      await flutterLocalNotificationsPlugin.show(
          rng.nextInt(100000), title, subtitle, platformChannelSpecifics,
          payload: 'item x');
    });
  }

  Future<void> initPlatformState() async {
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
    Geofence.initialize();
    Geofence.requestPermissions();
    Geofence.addGeolocation(location, GeolocationEvent.entry).then((onValue) {
      scheduleNotification("Georegion added", "Your geofence has been added!");
    }).catchError((error) {
      print("failed with $error");
    });
    Geofence.getCurrentLocation().then((coordinate) {
      print(
          "great got latitude: ${coordinate?.latitude} and longitude: ${coordinate?.longitude}");
    });

    Geofence.startListening(GeolocationEvent.entry, (entry) {
      en_auditorio = true;
      scheduleNotification("Entry of a georegion", "Welcome to: ${entry.id}");
    });

    Geofence.startListening(GeolocationEvent.exit, (entry) {
      en_auditorio = false;
      scheduleNotification("Exit of a georegion", "Byebye to: ${entry.id}");
    });

    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initPlatformState();
    mostrar_datos();
    Geofence.startListeningForLocationChanges();
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS =
        IOSInitializationSettings(onDidReceiveLocalNotification: null);
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: null);
  }
}
