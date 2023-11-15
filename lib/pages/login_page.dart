import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/gestures.dart';

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

  //recordar usuario y contraseña
  bool isChecked = false;
  //aceptar términos y condiciones
  bool readCheck = false;
  @override
  void initState() {
    super.initState();
    // Obtener los valores de SharedPreferences
    _getStoredUserData();
  }

  Future<void> _getStoredUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isChecked = prefs.getBool("rememberUserData") ?? false;
      if (isChecked) {
        myController.text = prefs.getString("username") ??
            ''; // Obtén el nombre, o un valor predeterminado si no se encuentra
        pass.text = prefs.getString("password") ?? "";
      } else {
        myController.text = "";
        pass.text = "";
      }
    });

    /* print(prefs.getString("nombreC")); */
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
          toolbarHeight: 120,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 100),
                  child: const Text(
                    "Acceso clientes",
                    style: TextStyle(
                        color: Color.fromARGB(255, 252, 250, 250),
                        fontSize: 20),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsetsDirectional.fromSTEB(100, 90, 100, 3),
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
                Container(
                  padding:
                      const EdgeInsetsDirectional.fromSTEB(100, 0, 100, 20),
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
                Container(
                  padding: const EdgeInsetsDirectional.fromSTEB(100, 0, 100, 0),
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
                Container(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(100, 0, 100, 10),
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
                    )),
                ElevatedButton(
                  //STATUS SIEMPRE 200

                  onPressed: () async {
                    if (readCheck == true) {
                      final String username = myController.text;
                      final String password = pass.text;
                      // Guardar en SharedPreferences
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setString('username', username);
                      await prefs.setString('password', password);

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
              ],
            ),
          ),
        ),
      )
    ]);
  }
}
