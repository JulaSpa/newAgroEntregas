import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Tool extends StatefulWidget {
  const Tool({super.key});

  @override
  State<Tool> createState() => _ToolState();
}

class _ToolState extends State<Tool> {
  @override
  Widget build(BuildContext context) {
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
            automaticallyImplyLeading: true,
          ),
          body: DecoratedBox(
            decoration: const BoxDecoration(
              color: Color.fromARGB(22, 0, 0, 0),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  SizedBox(
                    width: double.infinity,
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              launch("https://agroentregas.com.ar/");
                            },
                            child: Column(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(bottom: 0, top: 0),
                                  child: Icon(
                                    Icons.newspaper,
                                    color: Colors.white,
                                    size: 60,
                                  ),
                                ),
                                Container(
                                  child: const Text(
                                    "Noticias del sector",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              launch(
                                  "https://agroentregas.com.ar/condiciones-de-recibo-en-planta");
                            },
                            child: Column(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(bottom: 0, top: 0),
                                  child: Icon(
                                    Icons.description,
                                    color: Colors.white,
                                    size: 60,
                                  ),
                                ),
                                Container(
                                  child: RichText(
                                    text: const TextSpan(
                                      children: [
                                        TextSpan(
                                          text: "Condiciones de recibo",
                                        ),
                                      ],
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              launch(
                                  "https://agroentregas.com.ar/total-de-camiones-en-el-puerto");
                            },
                            child: Column(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(bottom: 0, top: 0),
                                  child: Icon(
                                    Icons.local_shipping,
                                    color: Colors.white,
                                    size: 42,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(0),
                                  child: const Text(
                                    "Total de camiones por puerto",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              launch(
                                  "https://agroentregas.com.ar/tipos-de-camiones");
                            },
                            child: Column(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(bottom: 0, top: 0),
                                  child: Icon(
                                    Icons.fire_truck,
                                    color: Colors.white,
                                    size: 60,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(0),
                                  child: const Text(
                                    "Tipos de camiones",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              launch(
                                  "https://agroentregas.com.ar/herramientas/costos-de-servicio-en-acondicionadoras-y-puertos");
                            },
                            child: Column(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(bottom: 0, top: 0),
                                  child: Icon(
                                    Icons.request_page,
                                    color: Colors.white,
                                    size: 60,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(0),
                                  child: const Text(
                                    "Costo y acondicionamientos",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              launch(
                                  "https://agroentregas.com.ar/herramientas/horarios-de-fin-de-semana-y-feriados");
                            },
                            child: Column(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(bottom: 0, top: 0),
                                  child: Icon(
                                    Icons.calendar_month,
                                    color: Colors.white,
                                    size: 42,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(0),
                                  child: const Text(
                                    "Horarios fin de semanas/feriados",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              launch(
                                  "https://agroentregas.com.ar/herramientas/horarios-de-vigencia-de-los-cupos");
                            },
                            child: Column(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(bottom: 0, top: 0),
                                  child: Icon(
                                    Icons.calendar_month,
                                    color: Colors.white,
                                    size: 60,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(0),
                                  child: const Text(
                                    "Horario de vigencia de cupos",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              launch("https://agroentregas.com.ar");
                            },
                            child: Column(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(bottom: 0, top: 0),
                                  child: Icon(
                                    Icons.edit_document,
                                    color: Colors.white,
                                    size: 60,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(0),
                                  child: const Text(
                                    "Confeccion carta de porte",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Image.asset(
                    "lib/images/logoAgroEntregas.png",
                    width: 200,
                    height: 150,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
