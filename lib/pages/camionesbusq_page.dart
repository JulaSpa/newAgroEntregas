import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import "package:flutter_application_1/album/album.dart";
import 'package:http/http.dart' as http;
import 'dart:convert';

class CamionesBusq extends StatefulWidget {
  const CamionesBusq({super.key});

  @override
  State<CamionesBusq> createState() => _CamionesBusq();
}

class _CamionesBusq extends State<CamionesBusq> {
  String? nroCPSrch;
  late Future<List<Album>> futureAlbum;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // Obtener los valores de SharedPreferences
    _getStoredUserData();
  }

  Future<void> _getStoredUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      nroCPSrch = prefs.getString('nroCPSrch');
    });
    _loadAlbumData();
  }

  void _loadAlbumData() {
    futureAlbum = fetchAlbum().then((result) {
      return result;
    }).catchError((error) {
      print("Error fetching album: $error");
      return <Album>[]; // Devuelve una lista vacía en caso de error.
    }).whenComplete(() {
      setState(() {
        // Cuando se complete la operación, establece isLoading en falso.
        isLoading = false;
      });
    });
  }

  Future<List<Album>> fetchAlbum() async {
    final requestData = {'nrocp': nroCPSrch};
    final response = await http.post(
      Uri.parse(
        'https://net.agroentregas.com.ar/RestServiceImpl.svc/CamioneroCP',
      ),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Methods": "POST, GET, OPTIONS, PUT, DELETE, HEAD",
      },
      body: jsonEncode(requestData),
    );

    if (response.statusCode == 200) {
      final exp = RegExp(r'<[^>]*>', multiLine: true, caseSensitive: true);
      final jsonContent = response.body.replaceAll(exp, '');

      try {
        final List<dynamic> responseJson = jsonDecode(jsonContent);
        final List<Album> albums =
            responseJson.map((albumJson) => Album.fromJson(albumJson)).toList();
        return albums;
      } catch (e) {
        print("Error decoding JSON: $e");
        throw Exception('Failed to decode JSON');
      }
    } else {
      throw Exception('Failed to load album');
    }
  }

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
          ),
          body: DecoratedBox(
            decoration: const BoxDecoration(
              color: Color.fromRGBO(255, 255, 255, 0.863),
            ),
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : FutureBuilder<List<Album>>(
                    future: futureAlbum,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        var albums = snapshot.data!;
                        return ListView.builder(
                          itemCount: albums.length,
                          itemBuilder: (context, index) {
                            var album = albums[index];
                            var situacion = album.nombreSit;
                            var rech = situacion.toString();
                            situacion = situacion.replaceFirst(
                                situacion[0], situacion[0].toUpperCase());
                            Map<String, Color> colorMap = {
                              "RECHAZO": Colors.red,
                              "CALADO": Colors.green,
                              "AUTORIZADO": Colors.blue,
                              "POSICION": Colors.lightBlue,
                              "DEMORADO": Colors.yellow,
                              "EN TRANSITO": Colors.pink,
                              "PROBLEMA EN C.P.": Colors.brown,
                              "HABLADO PROBLEMA CP":
                                  const Color.fromARGB(255, 80, 48, 73),
                              "DESCARGADO": const Color.fromARGB(255, 2, 99, 5)
                            };

                            Color backgroundColor =
                                colorMap[rech] ?? Colors.grey;
                            return Column(
                              children: [
                                InkWell(
                                  child: Container(
                                    color: backgroundColor,
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(5, 10, 5, 10),
                                          child: Icon(
                                            (rech == "RECHAZO" ||
                                                    rech == "RECHAZADO")
                                                ? Icons.cancel
                                                : Icons.check,
                                            color: Colors.white,
                                            size: 30,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(0, 10, 0, 10),
                                          child: Text(
                                            situacion,
                                            style: const TextStyle(
                                              fontSize: 20,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  5, 0, 0, 0),
                                          child: Text(
                                            "TITULAR: ",
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Expanded(
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
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  5, 0, 0, 0),
                                          child: Text(
                                            "PROCEDENCIA: ",
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Expanded(
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
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  5, 0, 0, 0),
                                          child: Text(
                                            "NÚMERO CP: ",
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Expanded(
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
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  5, 0, 0, 0),
                                          child: Text(
                                            "CORREDOR: ",
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Expanded(
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
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  5, 0, 0, 0),
                                          child: Text(
                                            "OBSERVACION: ",
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            album.observacionesana
                                                .toUpperCase(),
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
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  5, 0, 0, 0),
                                          child: Text(
                                            "PATENTE: ",
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Expanded(
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
                                  ],
                                )
                              ],
                            );
                          },
                        );
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  ),
          ),
        ),
      ],
    );
  }
}
