import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/providers.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import "package:flutter_application_1/album/album.dart";
import 'package:http/http.dart' as http;
import 'dart:convert';

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? username;
  String? password;
  String? tok;
  bool? alertC;
  bool? msjC;
  List<MensajesArguments>? lastMessage;
  late Future<List<Album>> futureAlbum;
  late PushNotProv pushNotProv;
  bool firebaseInitialized = false;

  @override
  void initState() {
    super.initState();
    _getStoredUserData();

    // Escucha para obtener la última notificación

    WidgetsFlutterBinding.ensureInitialized();
    // Inicializa Firebase de manera asíncrona y espera a que esté listo
    Firebase.initializeApp().then((_) {
      // La inicialización de Firebase se ha completado
      pushNotProv = PushNotProv();
      // ENVIA TOKEN A FIREBASE
      pushNotProv.initNotifications(); // Utiliza la instancia existente
      setState(() {
        firebaseInitialized = true; // Marca que Firebase se ha inicializado
      });
      pushNotProv.mensajes.listen((List<MensajesArguments> messages) {
        setState(() {
          lastMessage = messages;
        });
      });
    }).catchError((error) {
      print("Error al inicializar Firebase: $error");
    });
    // Espera a que Firebase se haya inicializado antes de usar pushNotProv

    print("last message");
    print(lastMessage?.length);

    /* print("pushNotProv: $pushNotProv"); */
  }

  Future<void> _getStoredUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username');
      password = prefs.getString('password');
      tok = prefs.getString("tok");
      alertC = prefs.getBool("alertC");
      msjC = prefs.getBool("msjC") ?? false;
    });
    _loadAlbumData();
    /* print(username);
    print(tok);
    print(alertC);
    print(msjC); */
  }

  void _loadAlbumData() async {
    final requestData = {
      'usuario': username,
      'contraseña': password,
      "token": tok,
      "alertas": alertC,
      "mensajes": msjC,
      "uuid": "1234"
    };
    final response = await http.post(
      Uri.parse(
        'http://sapp.agroentregas.com.ar/RestServiceImpl.svc/Firebase',
      ),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Methods": "POST, GET, OPTIONS, PUT, DELETE, HEAD",
      },
      body: jsonEncode(requestData),
    );
    if (response.statusCode == 200) {
      print("TOKO OK");
      print(msjC);
    } else {
      throw Exception('Cant send data to firebase');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image:
                AssetImage("lib/images/camiones.jpg"), // <-- BACKGROUND IMAGE
            fit: BoxFit.cover,
          ),
        ),
      ),
      Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Image.asset("lib/images/logoAgroEntregas.png"),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          toolbarHeight: 70,
          iconTheme: const IconThemeData(color: Colors.white),
          automaticallyImplyLeading: false,
        ),
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              color: Color.fromRGBO(94, 232, 250,
                  0.5), // Cambia el color aquí según tu preferencia
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  //PERFIL
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, "/perfil");
                    },
                    child: const FractionallySizedBox(
                      widthFactor: 0.9,
                      child: Row(
                        children: [
                          Icon(
                            Icons.account_circle_outlined,
                            color: Colors.white,
                            size: 30,
                          ),
                          Text(
                            "Mi perfil",
                            style: TextStyle(
                              color: Color.fromARGB(255, 252, 250, 250),
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const FractionallySizedBox(
                    widthFactor: 0.9,
                    child: Divider(
                      color: Colors.white,
                      thickness: 1,
                    ),
                  ),

                  //ALERTAS
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, "/alert");
                    },
                    child: const FractionallySizedBox(
                      widthFactor: 0.9,
                      child: Row(
                        children: [
                          Icon(
                            Icons.campaign,
                            color: Colors.white,
                            size: 30,
                          ),
                          Text(
                            "Alertas",
                            style: TextStyle(
                              color: Color.fromARGB(255, 252, 250, 250),
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const FractionallySizedBox(
                    widthFactor: 0.9,
                    child: Divider(
                      color: Colors.white,
                      thickness: 1,
                    ),
                  ),
                  //EN POSICIÓN
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, "/position");
                    },
                    child: const FractionallySizedBox(
                      widthFactor: 0.9,
                      child: Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: Colors.white,
                            size: 30,
                          ),
                          Text(
                            "En posición",
                            style: TextStyle(
                              color: Color.fromARGB(255, 252, 250, 250),
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const FractionallySizedBox(
                    widthFactor: 0.9,
                    child: Divider(
                      color: Colors.white,
                      thickness: 1,
                    ),
                  ),
                  //HISTÓRICO
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, "/historic");
                    },
                    child: const FractionallySizedBox(
                      widthFactor: 0.9,
                      child: Row(
                        children: [
                          Icon(
                            Icons.description,
                            color: Colors.white,
                            size: 30,
                          ),
                          Text(
                            "Histórico CP",
                            style: TextStyle(
                              color: Color.fromARGB(255, 252, 250, 250),
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const FractionallySizedBox(
                    widthFactor: 0.9,
                    child: Divider(
                      color: Colors.white,
                      thickness: 1,
                    ),
                  ),
                  //HERRAMIENTAS
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, "/tool");
                    },
                    child: const FractionallySizedBox(
                      widthFactor: 0.9,
                      child: Row(
                        children: [
                          Icon(
                            Icons.build,
                            color: Colors.white,
                            size: 30,
                          ),
                          Text(
                            "Herramientas",
                            style: TextStyle(
                              color: Color.fromARGB(255, 252, 250, 250),
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const FractionallySizedBox(
                    widthFactor: 0.9,
                    child: Divider(
                      color: Colors.white,
                      thickness: 1,
                    ),
                  ),
                  //WHATSAPP
                  const InkWell(
                    child: FractionallySizedBox(
                      widthFactor: 0.9,
                      child: Row(
                        children: [
                          Icon(
                            Icons.call,
                            color: Colors.white,
                            size: 30,
                          ),
                          Text(
                            "WhatsApp",
                            style: TextStyle(
                              color: Color.fromARGB(255, 252, 250, 250),
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const FractionallySizedBox(
                    widthFactor: 0.9,
                    child: Divider(
                      color: Colors.white,
                      thickness: 1,
                    ),
                  ),
                  //CERRAR SESIÓN
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, "/inicio");
                    },
                    child: Container(
                      child: const FractionallySizedBox(
                        widthFactor: 0.9,
                        child: Row(
                          children: [
                            Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 30,
                            ),
                            Text(
                              "Cerrar sesión",
                              style: TextStyle(
                                color: Color.fromARGB(255, 252, 250, 250),
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: Stack(
          children: [
            FloatingActionButton(
              onPressed: () {
                // Acción que se realiza al presionar el botón flotante
                // MANEJO DE NOTIFICACIONES
                Navigator.pushNamed(
                  context,
                  "/mensajes",
                  arguments: lastMessage != null && lastMessage!.isNotEmpty
                      ? lastMessage!
                      : [
                          MensajesArguments(
                              title: ["No tienes mensajes"], body: [""])
                        ], /* onUpdate: updateLastMessage, */
                );
                /* print("HOME:");
                for (var message in lastMessage!) {
                  print("Title: ${message.title}");
                  print("Body: ${message.body}");
                } */
              },
              backgroundColor: Color.fromARGB(255, 37, 211, 102),
              child: const Icon(Icons.message),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: lastMessage != null && lastMessage!.isNotEmpty
                      ? Colors.red
                      : Colors.transparent,
                ),
                child: Text(
                  lastMessage != null && lastMessage!.isNotEmpty
                      ? "${lastMessage!.length}" // Muestra el número de mensajes no leídos
                      : "",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
      )
    ]);
  }
}
