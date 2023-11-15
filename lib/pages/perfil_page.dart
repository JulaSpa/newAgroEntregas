import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Perfil extends StatefulWidget {
  const Perfil({super.key});

  @override
  State<Perfil> createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  String? username;
  String? password;
  String? tok;
  var nombre = TextEditingController();
  var mail = TextEditingController();
  var telefono = TextEditingController();
  //ACTIVAR ALERTAS
  bool alertCheck = false;
  //ACTIVAR MENSAJES
  bool msjCheck = false;
  @override
  void initState() {
    super.initState();
    // Obtener los valores de SharedPreferences
    _getStoredUserData();
  }

  Future<void> _getStoredUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username');
      password = prefs.getString('password');
      //SHAREDPRF PERFIL:
      nombre.text = prefs.getString("nombreC") ??
          ''; // Obtén el nombre, o un valor predeterminado si no se encuentra
      mail.text = prefs.getString("mailC") ?? '';
      telefono.text = prefs.getString("telC") ?? '';
      alertCheck = prefs.getBool("alertC") ?? false;
      msjCheck = prefs.getBool("msjC") ?? false;
    });
    /* print(prefs.getString("nombreC"));
    print(prefs.getBool("alertC"));
    print(prefs.getBool("msjC")); */
    print(prefs.getBool("msjC"));
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
          toolbarHeight: 60,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FractionallySizedBox(
                  widthFactor: 0.8,
                  child: Container(
                    child: TextField(
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey)),
                        prefixIcon: Icon(
                          Icons.account_circle_outlined,
                          color: Colors.white,
                        ),
                        labelText: "Nombre y apellido",
                        labelStyle: TextStyle(
                            color: Color.fromARGB(255, 252, 250, 250),
                            fontSize: 11),
                      ),
                      //CONTROLADOR NOMBRE Y APELLIDO
                      controller: nombre,
                    ),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: 0.8,
                  child: Container(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 20),
                    child: TextField(
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey)),
                        prefixIcon: Icon(
                          Icons.account_circle_outlined,
                          color: Colors.white,
                        ),
                        labelText: "Mail",
                        labelStyle: TextStyle(
                            color: Color.fromARGB(255, 252, 250, 250),
                            fontSize: 11),
                      ),
                      //CONTROLADOR Mail
                      controller: mail,
                    ),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: 0.8,
                  child: Container(
                    child: TextField(
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey)),
                        prefixIcon: Icon(
                          Icons.account_circle_outlined,
                          color: Colors.white,
                        ),
                        labelText: "Teléfono",
                        labelStyle: TextStyle(
                            color: Color.fromARGB(255, 252, 250, 250),
                            fontSize: 11),
                      ),
                      //CONTROLADOR TELEFONO
                      controller: telefono,
                    ),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: 0.8,
                  child: Container(
                    child: CheckboxListTile(
                      side: const BorderSide(color: Colors.white),
                      title: const Text(
                        "Activar alertas",
                        style: TextStyle(color: Colors.white, fontSize: 11),
                      ),
                      value: alertCheck,
                      onChanged: (bool? value) {
                        setState(() {
                          alertCheck = value!;
                        });
                      },
                    ),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: 0.8,
                  child: Container(
                    child: CheckboxListTile(
                      side: const BorderSide(color: Colors.white),
                      title: const Text(
                        "Activar mensajes",
                        style: TextStyle(color: Colors.white, fontSize: 11),
                      ),
                      value: msjCheck,
                      onChanged: (bool? value) {
                        setState(() {
                          msjCheck = value!;
                        });
                      },
                    ),
                  ),
                ),
                ElevatedButton(
                  //STATUS SIEMPRE 200

                  onPressed: () async {
                    final String nombreC = nombre.text;
                    final String mailC = mail.text;
                    final String telC = telefono.text;
                    final bool alertC = alertCheck;
                    final bool msjC = msjCheck;
                    // Guardar en SharedPreferences
                    final prefs = await SharedPreferences.getInstance();
                    username = prefs.getString('username');
                    password = prefs.getString('password');
                    tok = prefs.getString("tok");
                    await prefs.setString('nombreC', nombreC);
                    await prefs.setString('mailC', mailC);
                    await prefs.setString('telC', telC);
                    await prefs.setBool('alertC', alertC);
                    await prefs.setBool('msjC', msjC);

                    /* print(prefs.getString("username")); */
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
                        "Access-Control-Allow-Methods":
                            "POST, GET, OPTIONS, PUT, DELETE, HEAD",
                      },
                      body: jsonEncode(requestData),
                    );
                    if (response.statusCode == 200) {
                      print("INFO GUARDADA");
                      print(response.body);
                      print(msjC);
                    } else {
                      throw Exception('Cant send data to firebase');
                    }
                    Navigator.pushNamed(context, "/home");
                  },
                  child: const Text("Guardar"),
                ),
              ],
            ),
          ),
        ),
      )
    ]);
  }
}
