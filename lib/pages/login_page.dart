import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_application_1/src/providers.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart'; // Agrega este import
import 'package:universal_io/io.dart' as uio;
import 'package:platform_device_id_v3/platform_device_id.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Login extends StatefulWidget {
  const Login({
    super.key,
  });

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var myController = TextEditingController();
  var pass = TextEditingController();
  bool logInOut = false;
  //recordar usuario y contraseña
  bool isChecked = false;
  //aceptar términos y condiciones
  bool readCheck = true;
//Firebase
  String? username;
  String? password;
  String? tok;
  String? deviceId;
  bool? alertC;
  bool? msjC;
//Inicio push
  late PushNotProv pushNotProv;
  bool firebaseInitialized = false;

  @override
  void initState() {
    super.initState();
    // Obtener los valores de SharedPreferences
    _getStoredUserData();
    _getDeviceId();
    if (uio.Platform.isAndroid || uio.Platform.isIOS) {
      WidgetsFlutterBinding.ensureInitialized();
      // Inicializa Firebase de manera asíncrona y espera a que esté listo
      Firebase.initializeApp().then((_) async {
        // La inicialización de Firebase se ha completado
        pushNotProv = PushNotProv();
        // ENVIA TOKEN A FIREBASE
        pushNotProv.initNotifications(); // Utiliza la instancia existente

        // Obtén el token de Firebase
        FirebaseMessaging messaging = FirebaseMessaging.instance;
        String? token = await messaging.getToken();

        // Guarda el token en SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('tok', token!);

        setState(() {
          firebaseInitialized = true; // Marca que Firebase se ha inicializado
          tok = token; // Asigna el token a la variable de clase
        });
      }).catchError((error) {
        print("Error al inicializar Firebase: $error");
      });
    }
  }

  Future<void> _getStoredUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final storedUsername = prefs.getString('username');
    final storedPassword = prefs.getString('password');
    final storedTok = prefs.getString("tok");
    final storedAlertC = prefs.getBool("alertC") ?? false;
    final storedMsjC = prefs.getBool("msjC") ?? false;
    setState(() {
      isChecked = prefs.getBool("rememberUserData") ?? false;
      username = storedUsername;
      password = storedPassword;
      tok = storedTok; // Cargar el token almacenado
      alertC = storedAlertC;
      msjC = storedMsjC;
      if (isChecked) {
        myController.text = prefs.getString("username") ?? '';
        pass.text = prefs.getString("password") ?? "";
      } else {
        myController.text = "";
        pass.text = "";
      }
    });
  }

  Future<void> _getDeviceId() async {
    try {
      deviceId = await PlatformDeviceId.getDeviceId;
    } catch (e) {
      print("Error al obtener el identificador del dispositivo: $e");
      deviceId = null;
    }
  }

  void _loadAlbumData() async {
    final requestData = {
      'usuario': username,
      'contraseña': password,
      "token": tok, // Asegúrate de que el token se ha asignado correctamente
      "alertas": alertC,
      "mensajes": msjC,
      "uuid": deviceId
    };
    final response = await http.post(
      Uri.parse(
        'https://net.agroentregas.com.ar/RestServiceImpl.svc/Firebase',
      ),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Methods": "POST, GET, OPTIONS, PUT, DELETE, HEAD",
      },
      body: jsonEncode(requestData),
    );
    if (response.statusCode == 200) {
      print("Data sent");
      print(requestData);
      print(response.statusCode);
    } else {
      print("send data error");
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
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 100),
          child: FractionallySizedBox(
            widthFactor: 1,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(bottom: 100),
                    child: const Text(
                      "Acceso clientes",
                      style: TextStyle(
                          color: Color.fromARGB(255, 252, 250, 250),
                          fontSize: 20),
                    ),
                  ),
                  Container(
                    constraints: BoxConstraints(maxWidth: 1000),
                    child: FractionallySizedBox(
                      widthFactor: 0.8,
                      child: TextField(
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)),
                          prefixIcon: Icon(
                            Icons.account_circle_outlined,
                            color: Colors.white,
                          ),
                          labelText: "Nombre de usuario",
                          labelStyle: TextStyle(
                              color: Color.fromARGB(255, 252, 250, 250),
                              fontSize: 11),
                        ),
                        //CONTROLADOR USUARIO
                        controller: myController,
                      ),
                    ),
                  ),
                  Container(
                    constraints: BoxConstraints(maxWidth: 1000),
                    child: FractionallySizedBox(
                      widthFactor: 0.8,
                      child: TextField(
                        style: const TextStyle(color: Colors.white),
                        obscureText: true,
                        decoration: const InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)),
                          prefixIcon: Icon(
                            Icons.lock_outlined,
                            color: Colors.white,
                          ),
                          labelText: "Contraseña",
                          labelStyle: TextStyle(
                              color: Color.fromARGB(255, 252, 250, 250),
                              fontSize: 11),
                        ),
                        //CONTROLADOR CONTRASEÑA
                        controller: pass,
                      ),
                    ),
                  ),
                  Container(
                    constraints: BoxConstraints(maxWidth: 1000),
                    child: FractionallySizedBox(
                      widthFactor: 0.8,
                      child: CheckboxListTile(
                        side: const BorderSide(color: Colors.white),
                        title: const Text(
                          "Recordar usuario y contraseña",
                          style: TextStyle(color: Colors.white, fontSize: 11),
                        ),
                        value: isChecked,
                        onChanged: (bool? value) async {
                          final prefs = await SharedPreferences.getInstance();
                          setState(() {
                            isChecked = value!;
                            prefs.setBool("rememberUserData",
                                isChecked); // Guarda el estado del checkbox en SharedPreferences
                          });
                        },
                      ),
                    ),
                  ),
                  Container(
                      constraints: BoxConstraints(maxWidth: 1000),
                      child: FractionallySizedBox(
                        widthFactor: 0.8,
                        child: CheckboxListTile(
                          side: const BorderSide(color: Colors.white),
                          title: RichText(
                            text: TextSpan(
                              text: 'Acepto los ',
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 11),
                              children: <TextSpan>[
                                TextSpan(
                                  text: 'Términos y condiciones',
                                  style: const TextStyle(
                                    color: Colors.blue, // Color del enlace
                                    decoration:
                                        TextDecoration.underline, // Subrayado
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      launch(
                                          "https://web.agroentregas.com.ar/terms"); // Abre la URL al tocar el enlace
                                    },
                                ),
                              ],
                            ),
                          ),
                          value: readCheck,
                          onChanged: (bool? value) {
                            setState(() {
                              readCheck = value!;
                            });
                          },
                        ),
                      )),
                  Container(
                    padding: EdgeInsets.only(top: 100, bottom: 15),
                    child: ElevatedButton(
                      //STATUS SIEMPRE 200

                      onPressed: () async {
                        if (readCheck == true) {
                          final String username = myController.text;
                          final String password = pass.text;
                          // Guardar en SharedPreferences
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.setString('username', username);
                          await prefs.setString('password', password);
                          await prefs.setBool('logInOut', true);

                          // Actualiza los valores antes de enviar la solicitud
                          setState(() {
                            this.username = username;
                            this.password = password;
                          });

                          // Carga los datos del álbum
                          _loadAlbumData();
                          Navigator.pushNamed(
                            context,
                            "/home",
                          );
                        } else {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return const AlertDialog(
                                content: Text(
                                    "Debes aceptar los términos y condiciones"),
                              );
                            },
                          );
                        }
                      },
                      child: const Text("Ingresar"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ]);
  }
}
