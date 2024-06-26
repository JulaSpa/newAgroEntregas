import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Camiones extends StatefulWidget {
  const Camiones({super.key});

  @override
  State<Camiones> createState() => _Camiones();
}

class _Camiones extends State<Camiones> {
  var myController = TextEditingController();
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
          automaticallyImplyLeading: true,
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 100),
                child: const Text(
                  "Acceso camiones",
                  style: TextStyle(
                      color: Color.fromARGB(255, 252, 250, 250), fontSize: 20),
                ),
              ),
              Container(
                constraints: BoxConstraints(maxWidth: 1000),
                width: double.infinity,
                padding: const EdgeInsetsDirectional.fromSTEB(40, 50, 40, 50),
                child: TextField(
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)),
                    prefixIcon: Icon(
                      Icons.assignment,
                      color: Colors.white,
                    ),
                    labelText: "Número de carta de porte o patente",
                    labelStyle: TextStyle(
                        color: Color.fromARGB(255, 252, 250, 250),
                        fontSize: 11),
                  ),
                  //CONTROLADOR CARTA DE PORTE
                  controller: myController,
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  final String nroCPSrch = myController.text;
                  // Guardar en SharedPreferences
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setString('nroCPSrch', nroCPSrch);
                  Navigator.pushNamed(
                    context,
                    "/camionesBusq",
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor:
                      Colors.white, // Cambia el color de fondo aquí
                ),
                child: const Text("Consultar"),
              ),
            ],
          ),
        ),
      )
    ]);
  }
}
