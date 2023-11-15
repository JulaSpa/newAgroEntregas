import 'package:flutter/material.dart';

class Inicio extends StatefulWidget {
  const Inicio({super.key});

  @override
  State<Inicio> createState() => _Inicio();
}

class _Inicio extends State<Inicio> {
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
          automaticallyImplyLeading: false,
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              const SizedBox(
                  height:
                      10), // Ajusta la distancia vertical según tus necesidades
              Container(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 50, 0, 200),
                constraints: const BoxConstraints(
                  minWidth:
                      500, // Ajusta la altura mínima según tus necesidades
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Soluciones innovadoras en la entrega de cereales",
                      style: TextStyle(
                        color: Color.fromARGB(255, 252, 250, 250),
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                constraints: BoxConstraints(minHeight: 40, maxWidth: 1000),
                child: FractionallySizedBox(
                  widthFactor: 0.5,
                  child: ElevatedButton(
                    onPressed: () async {
                      Navigator.pushNamed(
                        context,
                        "/login",
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor:
                          Colors.white, // Cambia el color de fondo aquí
                    ),
                    child: const Text("Clientes"),
                  ),
                ),
              ),
              const SizedBox(height: 25),
              Container(
                width: double.infinity,
                constraints: BoxConstraints(minHeight: 40, maxWidth: 1000),
                child: FractionallySizedBox(
                  widthFactor: 0.5,
                  child: ElevatedButton(
                    onPressed: () async {
                      Navigator.pushNamed(
                        context,
                        "/camionesCP",
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 247, 112, 1),
                      foregroundColor:
                          Colors.white, // Cambia el color de fondo aquí
                    ),
                    child: const Text("Camiones"),
                  ),
                ),
              ),
            ],
          ),
        ),
      )
    ]);
  }
}
