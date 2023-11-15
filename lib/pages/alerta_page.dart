import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import "package:flutter_application_1/album/album.dart";
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_application_1/pages/detalles_page.dart';

class Alert extends StatefulWidget {
  const Alert({super.key});

  @override
  State<Alert> createState() => _AlertState();
}

class _AlertState extends State<Alert> {
  List<int> selectedIndices = [];
  String? username;
  String? password;
  late Future<List<Album>> futureAlbum;
  bool isLoading =
      true; // Agregar una variable para rastrear si se está cargando

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
    final requestData = {
      'usuario': username,
      'contraseña': password,
    };
    final response = await http.post(
      Uri.parse(
        'http://sapp.agroentregas.com.ar/RestServiceImpl.svc/Alertas',
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
                            // Controlar el estado del Checkbox en función de si el índice está en la lista de selectedIndices
                            bool isChecked = selectedIndices.contains(index);

                            // Actualizar la lista de selectedIndices cuando se toca el Checkbox
                            void onCheckboxTapped() {
                              setState(() {
                                if (isChecked) {
                                  selectedIndices.remove(index);
                                } else {
                                  selectedIndices.clear();
                                  selectedIndices.add(index);
                                }
                              });
                            }

                            return Column(
                              children: [
                                InkWell(
                                  child: Container(
                                    color: backgroundColor,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(35, 10, 5, 10),
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
                                        const Spacer(),
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(0, 0, 0, 0),
                                          child: Checkbox(
                                            value: isChecked,
                                            onChanged: (bool? value) {
                                              onCheckboxTapped();
                                              if (isChecked == false) {
                                                _showOptionsModal(
                                                    context,
                                                    album.idFl,
                                                    album.nroCP,
                                                    rech);
                                              }
                                            },
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
                                                  40, 10, 0, 0),
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
                                          child: Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(0, 10, 0, 0),
                                            child: Text(
                                              album.xtitular.toUpperCase(),
                                              style: const TextStyle(
                                                fontSize: 15,
                                                color: Colors.lightBlue,
                                                fontWeight: FontWeight.bold,
                                              ),
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
                                                  40, 0, 0, 0),
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
                                                  40, 0, 0, 0),
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
                                                  40, 0, 0, 0),
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
                                                  40, 0, 0, 0),
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
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0, 10, 0, 10),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              AlertDetails(album: album),
                                        ),
                                      );
                                    },
                                    child: const Text("Más información"),
                                  ),
                                ),
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

void _showOptionsModal(
    BuildContext context, String? uid, String? nroCP, String? rech) {
  print(uid);

  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Container(
        height: 100,
        color: const Color.fromARGB(255, 17, 34, 71),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment
                    .spaceEvenly, // Distribuye uniformemente los elementos
                children: [
                  // LLAMADA
                  Expanded(
                    child: Column(
                      children: [
                        IconButton(
                          onPressed: () {
                            _llamada(context, uid, nroCP);
                            // Acción para la opción 1
                          },
                          icon: const Icon(Icons.phone),
                          color: Colors.white,
                        ),
                        const Text(
                          "Llamada o WhatsApp",
                          style: TextStyle(fontSize: 10, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  // RECHAZO CGT O AUTORIZAR
                  Expanded(
                    child: Column(
                      children: [
                        IconButton(
                          onPressed: () {
                            if (rech == "RECHAZO" || rech == "RECHAZADO") {
                              // Acción para la opción api rechazo cgt
                              _rechazo(context, uid, nroCP);
                            } else {
                              // Acción para api autorizar
                              _autorizado(context, uid, nroCP);
                            }
                          },
                          icon: rech == "RECHAZO" || rech == "RECHAZADO"
                              ? const Icon(Icons.cancel)
                              : const Icon(Icons.check),
                          color: Colors.white,
                        ),
                        Text(
                          rech == "RECHAZO" || rech == "RECHAZADO"
                              ? "Pedir rechazo de CGT"
                              : "Autorizar", // Cambia el texto según el valor de 'rech'
                          style: const TextStyle(
                              fontSize: 10, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  // LEIDO
                  Expanded(
                    child: Column(
                      children: [
                        IconButton(
                          onPressed: () {
                            _leido(context, uid, nroCP);
                          },
                          icon: const Icon(Icons.visibility),
                          color: Colors.white,
                        ),
                        const Text(
                          "Leido",
                          style: TextStyle(fontSize: 10, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  // COMPARTIR
                  Expanded(
                    child: Column(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context); // Cierra el modal
                            // Acción para la opción 4
                          },
                          icon: const Icon(Icons.share),
                          color: Colors.white,
                        ),
                        const Text(
                          "Compartir",
                          style: TextStyle(fontSize: 10, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

//API LLAMADA
Future<void> _llamada(context, String? uid, String? nroCP) async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

  String? username;
  String? password;
  String imei = androidInfo.id;
  String? nroCel;
  String? dispositivo = androidInfo.model;
  final prefs = await SharedPreferences.getInstance();
  username = prefs.getString('username');
  password = prefs.getString('password');
  nroCel = prefs.getString("telC");

  final requestData = {
    'usuario': username,
    'contraseña': password,
    "NroCP": nroCP,
    "imei": imei,
    "numero": nroCel,
    "dispositivo": dispositivo,
    "nota": "Solicito llamada",
  };
  print(requestData);
  final response = await http.post(
    Uri.parse(
      'http://sapp.agroentregas.com.ar/RestServiceImpl.svc/Llamada',
    ),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Methods": "POST, GET, OPTIONS, PUT, DELETE, HEAD",
    },
    body: jsonEncode(requestData),
  );
  if (response.statusCode == 200) {
    final dynamic jsonResponse = json.decode(response.body);
    final String llamadaResult = jsonResponse["LlamadaResult"];
    _showResponseModal(context, llamadaResult);
  } else {
    throw Exception('Failed to send llamada');
  }
}

void _showResponseModal(BuildContext context, String responseBody) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Respuesta del servidor'),
        content: Text(responseBody),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cerrar'),
          ),
        ],
      );
    },
  );
}

//API RECHAZO
Future<void> _rechazo(context, String? uid, String? nroCP) async {
  final GlobalKey<_AlertState> alertKey = GlobalKey<_AlertState>();
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

  String? username;
  String? password;
  String imei = androidInfo.id;
  String? nroCel;
  String? dispositivo = androidInfo.model;
  final prefs = await SharedPreferences.getInstance();
  username = prefs.getString('username');
  password = prefs.getString('password');
  nroCel = prefs.getString("telC");

  final requestData = {
    'usuario': username,
    'contraseña': password,
    "NroCP": nroCP,
    "imei": imei,
    "numero": nroCel,
    "dispositivo": dispositivo,
    "Situacion": "Solicito Rechazo CGT",
    "idfl": uid
  };
  print(requestData);
  final response = await http.post(
    Uri.parse(
      'http://net.entreganet.com/RestServiceImpl.svc/Rechazos',
    ),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Methods": "POST, GET, OPTIONS, PUT, DELETE, HEAD",
    },
    body: jsonEncode(requestData),
  );
  if (response.statusCode == 200) {
    print(response.body);
    alertKey.currentState?._loadAlbumData();
  } else {
    throw Exception('Failed to send llamada');
  }
}

//API AUTORIZADO
Future<void> _autorizado(context, String? uid, String? nroCP) async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

  String? username;
  String? password;
  String imei = androidInfo.id;
  String? nroCel;
  String? dispositivo = androidInfo.model;
  final prefs = await SharedPreferences.getInstance();
  username = prefs.getString('username');
  password = prefs.getString('password');
  nroCel = prefs.getString("telC");

  final requestData = {
    'usuario': username,
    'contraseña': password,
    "NroCP": nroCP,
    "imei": imei,
    "numero": nroCel,
    "dispositivo": dispositivo,
    "Situacion": "Autorizar",
    "idfl": uid
  };
  print(requestData);
  final response = await http.post(
    Uri.parse(
      'http://net.entreganet.com/RestServiceImpl.svc/Autorizado',
    ),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Methods": "POST, GET, OPTIONS, PUT, DELETE, HEAD",
    },
    body: jsonEncode(requestData),
  );
  if (response.statusCode == 200) {
    print(response.body);
  } else {
    throw Exception('Failed to send llamada');
  }
}

//LEIDO
Future<void> _leido(context, String? uid, String? nroCP) async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

  String? username;
  String? password;
  String imei = androidInfo.id;
  String? nroCel;
  String? dispositivo = androidInfo.model;
  final prefs = await SharedPreferences.getInstance();
  username = prefs.getString('username');
  password = prefs.getString('password');
  nroCel = prefs.getString("telC");

  final requestData = {
    'usuario': username,
    'contraseña': password,
    "NroCP": nroCP,
    "imei": imei,
    "numero": nroCel,
    "dispositivo": dispositivo,
    "Situacion": "Leido",
    "idfl": uid
  };
  print(requestData);
  final response = await http.post(
    Uri.parse(
      'http://net.entreganet.com/RestServiceImpl.svc/Hablados',
    ),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Methods": "POST, GET, OPTIONS, PUT, DELETE, HEAD",
    },
    body: jsonEncode(requestData),
  );
  if (response.statusCode == 200) {
    print(response.body);
  } else {
    throw Exception('Failed to send llamada');
  }
}
