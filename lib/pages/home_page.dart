import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/providers.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

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
  bool? logI;
  String isAccesoTrue = "";
  bool isLoading = true;
  List<MensajesArguments>? lastMessage;
  List<MensajesArguments>? lastm;
  List<dynamic>? alertas;
  List<dynamic>? posicion;
  late PushNotProv pushNotProv;
  bool firebaseInitialized = false;
  List? title;
  @override
  void initState() {
    super.initState();
    contarAlertas();
    contarPosicion();
    _getStoredUserData();

    // Escucha para obtener la última notificación

    WidgetsFlutterBinding.ensureInitialized();
    // Inicializa Firebase de manera asíncrona y espera a que esté listo
    Firebase.initializeApp().then((_) async {
      // La inicialización de Firebase se ha completado
      pushNotProv = PushNotProv();
      // ENVIA TOKEN A FIREBASE
      pushNotProv.initNotifications(); // Utiliza la instancia existente
      setState(() {
        firebaseInitialized = true; // Marca que Firebase se ha inicializado
      });
      pushNotProv.mensajes.listen((List<MensajesArguments> messages) async {
        setState(() {
          lastMessage = messages;
        });
      });

      /* if (lastMessage != null && lastMessage!.isNotEmpty) {
        // Recupera la lista actual de títulos de SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        List storedTitles = prefs.getStringList("m") ?? [];

        // Agrega los nuevos títulos a la lista
        for (var mensaje in lastMessage!) {
          storedTitles.add(mensaje.title);
        }

        // Guarda la lista actualizada en SharedPreferences
        for (var msjs in storedTitles) {
          await prefs.setStringList("m", msjs);
        }
      } */
    }).catchError((error) {
      print("Error al inicializar Firebase: $error");
    });
    // Espera a que Firebase se haya inicializado antes de usar pushNotProv

    print("last message");
    print(lastMessage?.length);
    print("LASTM");
    print(lastm);
  }

  Future<void> _getStoredUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username');
      password = prefs.getString('password');
      tok = prefs.getString("tok");
      alertC = prefs.getBool("alertC");
      msjC = prefs.getBool("msjC") ?? false;
      logI = prefs.getBool("logInOut");
      title = prefs.getStringList("m");
    });
    _loadAlbumData();

    /* print(username);
    print(tok);
    print(alertC);
    print(msjC); */
    print("LOGINOUT");
    print(logI);
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
    //VALIDA USUARIO Y CONTRASEÑA
    final req = {
      'usuario': username,
      'contraseña': password,
    };
    final res = await http.post(
      Uri.parse(
        'http://net.entreganet.com/RestServiceImpl.svc/Login',
      ),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Methods": "POST, GET, OPTIONS, PUT, DELETE, HEAD",
      },
      body: jsonEncode(req),
    );
    print("USUARIO TRUE O FALSE");
    // Extraer el valor de AccesoResult usando manipulación de cadenas
    const startTag = '<AccesoResult>';
    const endTag = '</AccesoResult>';
    final startIndex = res.body.indexOf(startTag) + startTag.length;
    final endIndex = res.body.indexOf(endTag);
    final accesoResult = res.body.substring(startIndex, endIndex);
    // Simular una espera adicional de 2 segundos
    await Future.delayed(const Duration(milliseconds: 300));
    setState(() {
      isAccesoTrue = accesoResult;
      isLoading = false;
    });

    //ENVIA DATOS A LA API
    final response = await http.post(
      Uri.parse(
        'http://net.entreganet.com/RestServiceImpl.svc/Firebase',
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
//contar alertas

  void contarAlertas() async {
    final prefs = await SharedPreferences.getInstance();
    final req = {
      'usuario': prefs.getString('username'),
      'contraseña': prefs.getString('password'),
    };
    final contadorAlertas = await http.post(
      Uri.parse(
        'http://net.entreganet.com/RestServiceImpl.svc/Alertas',
      ),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Methods": "POST, GET, OPTIONS, PUT, DELETE, HEAD",
      },
      body: jsonEncode(req),
    );

    final responseBody = contadorAlertas.body;
    const startTag = '<AlertasResult>';
    const endTag = '</AlertasResult>';
    final startIndex = responseBody.indexOf(startTag) + startTag.length;
    final endIndex = responseBody.indexOf(endTag);
    final jsonData = responseBody.substring(startIndex, endIndex);

    final alertas = jsonDecode(jsonData);

    print("Cantidad de alertas: ${alertas.length}");
    setState(() {
      this.alertas = alertas;
    });
  }
//contar posicion

  void contarPosicion() async {
    final prefs = await SharedPreferences.getInstance();
    final req = {
      'usuario': prefs.getString('username'),
      'contraseña': prefs.getString('password'),
    };
    final contadorPos = await http.post(
      Uri.parse(
        'http://net.entreganet.com/RestServiceImpl.svc/Posicion',
      ),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Methods": "POST, GET, OPTIONS, PUT, DELETE, HEAD",
      },
      body: jsonEncode(req),
    );

    final responseBody = contadorPos.body;
    const startTag = '<PosicionResult>';
    const endTag = '</PosicionResult>';
    final startIndex = responseBody.indexOf(startTag) + startTag.length;
    final endIndex = responseBody.indexOf(endTag);
    final jsonData = responseBody.substring(startIndex, endIndex);

    final posicion = jsonDecode(jsonData);

    print("Cantidad de posicion: ${posicion.length}");
    setState(() {
      this.posicion = posicion;
    });
  }

//WHATS APP
  void _launchWhatsApp() {
    // Reemplaza "123456789" con el número de teléfono al que deseas enviar el mensaje
    String phoneNumber = "3415775140";

    // Forma la URL de WhatsApp
    String url = "https://wa.me/$phoneNumber/";

    // Lanza la URL
    launch(url);
  }

// Función para manejar la actualización de datos
  Future<void> _refresh() async {
    // Agrega aquí la lógica para actualizar tus datos
    // Puedes llamar a funciones asíncronas o realizar peticiones a una API, por ejemplo
    contarAlertas();
    contarPosicion();
    _getStoredUserData();
    // Simulando una pausa de 2 segundos
    await Future.delayed(const Duration(seconds: 1));
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
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : isAccesoTrue == "true"
                ? _buildScrollView()
                : _buildErrorText(),
        floatingActionButton: isAccesoTrue == "true"
            ? Stack(
                children: [
                  FloatingActionButton(
                    onPressed: () {
                      // Acción que se realiza al presionar el botón flotante
                      // MANEJO DE NOTIFICACIONES
                      Navigator.pushNamed(
                        context,
                        "/mensajes",
                      );
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
              )
            : null,
      )
    ]);
  }

  Widget _buildScrollView() {
    return RefreshIndicator(
      onRefresh: _refresh,
      child: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            color: Color.fromRGBO(
                94, 232, 250, 0.5), // Cambia el color aquí según tu preferencia
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
                  child: FractionallySizedBox(
                    widthFactor: 0.9,
                    child: Row(
                      children: [
                        Stack(
                          children: [
                            const Icon(
                              Icons.campaign,
                              color: Colors.white,
                              size: 30,
                            ),
                            Positioned(
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors
                                      .red, // Cambia el color según tus preferencias
                                ),
                                child: Builder(
                                  builder: (BuildContext context) {
                                    final alertasLength = alertas?.length ?? 0;
                                    return Text(
                                      alertasLength.toString(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                            width:
                                8), // Ajusta el espacio según tus preferencias
                        const Text(
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
                  child: FractionallySizedBox(
                    widthFactor: 0.9,
                    child: Row(
                      children: [
                        Stack(
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: Colors.white,
                              size: 30,
                            ),
                            Positioned(
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors
                                      .red, // Cambia el color según tus preferencias
                                ),
                                child: Builder(
                                  builder: (BuildContext context) {
                                    final posicionLength =
                                        posicion?.length ?? 0;
                                    return Text(
                                      posicionLength.toString(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                            width:
                                8), // Ajusta el espacio según tus preferencias
                        const Text(
                          "En posicion",
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
                InkWell(
                  onTap: _launchWhatsApp,
                  child: const FractionallySizedBox(
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
                  onTap: () async {
                    // Cambiar el valor de logI a false y guardarlo en SharedPreferences
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setBool('logInOut', false);

                    // Actualizar el estado en la aplicación
                    setState(() {
                      logI = false;
                    });
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
    );
  }

  Widget _buildErrorText() {
    return InkWell(
      onTap: () async {
        // Cambiar el valor de logI a false y guardarlo en SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('logInOut', false);

        // Actualizar el estado en la aplicación
        setState(() {
          logI = false;
        });
        Navigator.pushNamed(context, "/login");
      },
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(94, 232, 250, 0.5),
              Color.fromRGBO(94, 232, 250, 0.9),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 30,
            ),
            SizedBox(width: 16.0),
            Text(
              "Usuario o contraseña incorrecta",
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
