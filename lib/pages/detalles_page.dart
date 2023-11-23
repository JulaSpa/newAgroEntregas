import 'package:flutter/material.dart';
import "package:flutter_application_1/album/album.dart";

class AlertDetails extends StatelessWidget {
  final Album album;

  const AlertDetails({super.key, required this.album});

  @override
  Widget build(BuildContext context) {
    String sit = album.nombreSit.toUpperCase();
    Map<String, Color> colorMap = {
      "RECHAZO": Colors.red,
      "CALADO": Colors.green,
      "AUTORIZADO": const Color.fromARGB(255, 3, 1, 126),
      "POSICION": Colors.lightBlue,
      "DEMORADO": Colors.yellow,
      "EN TRANSITO": Colors.pink,
      "PROBLEMA EN C.P.": Colors.brown,
      "HABLADO PROBLEMA CP": const Color.fromARGB(255, 176, 39, 96),
      "DESCARGADO": const Color.fromARGB(255, 2, 99, 5),
      "SIN CUPO": Colors.green,
      "SOLICITA RECHAZO": Colors.purple,
      "HABLADO": const Color.fromARGB(255, 176, 39, 96),
      "HABLADO RECHAZO": const Color.fromARGB(255, 176, 39, 96),
      "HABLADO SIN CUPO": const Color.fromARGB(255, 176, 39, 96),
      "DESVIADO": Colors.black
    };

    Color backgroundColor = colorMap[sit] ?? Colors.grey;
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("lib/images/camiones.jpg"),
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
          body: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                color: Color.fromRGBO(255, 255, 255, 0.863),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    color: backgroundColor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              35, 10, 5, 10),
                          child: Icon(
                            (album.idSit == "RCZO")
                                ? Icons.cancel
                                : (album.idSit == "AUTO")
                                    ? Icons.check
                                    : (album.idSit == "DEMO")
                                        ? Icons.access_time
                                        : (album.idSit == "PECP")
                                            ? Icons.change_history
                                            : (album.idSit == "SCUP")
                                                ? Icons.stop_circle
                                                : (album.idSit == "SRZO")
                                                    ? Icons.change_history
                                                    : (album.idSit == "HABL")
                                                        ? Icons.check
                                                        : (album.idSit ==
                                                                "HRZO")
                                                            ? Icons
                                                                .change_history
                                                            : (album.idSit ==
                                                                    "HPCP")
                                                                ? Icons
                                                                    .change_history
                                                                : (album.idSit ==
                                                                        "HSCU")
                                                                    ? Icons
                                                                        .stop_circle
                                                                    : (album.idSit ==
                                                                            "DESC")
                                                                        ? Icons
                                                                            .check
                                                                        : Icons
                                                                            .change_history,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              0, 10, 0, 10),
                          child: Text(
                            sit,
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(40, 0, 0, 0),
                        child: Text(
                          "NÚMERO CP: ",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(40, 0, 0, 0),
                        child: Text(
                          album.nroCP.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.lightBlue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(
                        40, 5, 40, 5), // Añade relleno solo al lado derecho
                    child: Divider(
                      color: Colors.black,
                      thickness: 0.5,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(40, 0, 0, 0),
                        child: Text(
                          "TITULAR: ",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(40, 0, 0, 0),
                        child: Text(
                          album.xtitular.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.lightBlue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(
                        40, 0, 40, 5), // Añade relleno solo al lado derecho
                    child: Divider(
                      color: Colors.black,
                      thickness: 0.5,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(40, 0, 0, 0),
                        child: Text(
                          "CORREDOR: ",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(40, 0, 0, 0),
                        child: Text(
                          album.xcorredor.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.lightBlue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(
                        40, 0, 40, 5), // Añade relleno solo al lado derecho
                    child: Divider(
                      color: Colors.black,
                      thickness: 0.5,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(40, 0, 0, 0),
                        child: Text(
                          "DESTINATARIO: ",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(40, 0, 0, 0),
                        child: Text(
                          album.xdestinatario.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.lightBlue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(
                        40, 0, 40, 5), // Añade relleno solo al lado derecho
                    child: Divider(
                      color: Colors.black,
                      thickness: 0.5,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(40, 0, 0, 0),
                        child: Text(
                          "DESTINO: ",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(40, 0, 0, 0),
                        child: Text(
                          album.xdestino.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.lightBlue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(
                        40, 0, 40, 5), // Añade relleno solo al lado derecho
                    child: Divider(
                      color: Colors.black,
                      thickness: 0.5,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(40, 0, 0, 0),
                        child: Text(
                          "MERCADERIA: ",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(40, 0, 0, 0),
                        child: Text(
                          album.nombreMe.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.lightBlue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(
                        40, 0, 40, 5), // Añade relleno solo al lado derecho
                    child: Divider(
                      color: Colors.black,
                      thickness: 0.5,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(40, 0, 0, 0),
                        child: Text(
                          "PROCEDENCIA: ",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(40, 0, 0, 0),
                        child: Text(
                          album.nombrePrc.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.lightBlue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(
                        40, 0, 40, 5), // Añade relleno solo al lado derecho
                    child: Divider(
                      color: Colors.black,
                      thickness: 0.5,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(40, 0, 0, 0),
                        child: Text(
                          "PATENTE CAMIÓN: ",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(40, 0, 0, 0),
                        child: Text(
                          album.chasisFl.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.lightBlue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(
                        40, 0, 40, 5), // Añade relleno solo al lado derecho
                    child: Divider(
                      color: Colors.black,
                      thickness: 0.5,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(40, 0, 0, 0),
                        child: Text(
                          "PATENTE ACOPLADO: ",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(40, 0, 0, 0),
                        child: Text(
                          album.acopreFl.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.lightBlue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(
                        40, 0, 40, 5), // Añade relleno solo al lado derecho
                    child: Divider(
                      color: Colors.black,
                      thickness: 0.5,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(40, 0, 0, 0),
                        child: Text(
                          "OBSERVACIÓN: ",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(40, 0, 0, 0),
                        child: Text(
                          album.observacionesana.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.lightBlue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
