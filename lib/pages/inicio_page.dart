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
          toolbarHeight:
              120, // Ajusta la altura del AppBar según tus necesidades
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              const SizedBox(
                  height:
                      10), // Ajusta la distancia vertical según tus necesidades
              Container(
                width: double.infinity,
                padding: const EdgeInsetsDirectional.fromSTEB(0, 50, 0, 50),
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
                padding: const EdgeInsetsDirectional.fromSTEB(30, 0, 30, 15),
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
              Container(
                width: double.infinity,
                padding: const EdgeInsetsDirectional.fromSTEB(30, 0, 30, 0),
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
