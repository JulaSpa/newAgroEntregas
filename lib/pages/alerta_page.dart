import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import "package:flutter_application_1/album/album.dart";
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_application_1/pages/detalles_page.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';
import 'dart:io';

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
        'http://net.entreganet.com/RestServiceImpl.svc/Alertas',
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
            automaticallyImplyLeading: true,
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
                              "AUTORIZADO":
                                  const Color.fromARGB(255, 3, 1, 126),
                              "POSICION": Colors.lightBlue,
                              "DEMORADO": Colors.yellow,
                              "EN TRANSITO": Colors.pink,
                              "PROBLEMA EN C.P.": Colors.brown,
                              "HABLADO PROBLEMA CP":
                                  const Color.fromARGB(255, 80, 48, 73),
                              "DESCARGADO": const Color.fromARGB(255, 2, 99, 5),
                              "SIN CUPO": Colors.green,
                              "SOLICITA RECHAZO": Colors.purple,
                              "HABLADO": const Color.fromARGB(255, 176, 39, 96)
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
                                            (album.idSit == "RCZO")
                                                ? Icons.cancel
                                                : (album.idSit == "AUTO")
                                                    ? Icons.check
                                                    : (album.idSit == "DEMO")
                                                        ? Icons.access_time
                                                        : (album.idSit ==
                                                                "PECP")
                                                            ? Icons
                                                                .change_history
                                                            : (album.idSit ==
                                                                    "SCUP")
                                                                ? Icons
                                                                    .stop_circle
                                                                : (album.idSit ==
                                                                        "HABL")
                                                                    ? Icons
                                                                        .check
                                                                    : Icons
                                                                        .change_history,
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
                                                    album.idSit,
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
                                            "PATENTE CAMIÓN: ",
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
                                ),
                                InkWell(
                                  onTap: () async {
                                    final String nroCP = album.nroCP;
                                    final prefs =
                                        await SharedPreferences.getInstance();
                                    await prefs.setString('nroCP', nroCP);
                                    _downLoad(
                                        username, password, nroCP, context);
                                  },
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                              "IMAGEN: ",
                                              style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              album.imagen,
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

void _downLoad(
  String? username,
  String? password,
  String? nroCP,
  BuildContext context,
) async {
  /* print(nroCP);
  print(username);
  print(password); */
  final requestData = {
    'usuario': username,
    'contraseña': password,
    'nrocp': nroCP
  };
  /* print(requestData); */

  final response = await http.post(
    Uri.parse('http://net.entreganet.com/RestServiceImpl.svc/Imagen'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(requestData),
  );

  try {
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final base64Image = jsonResponse['ImagenResult'];
      _showImageDialog(context, base64Image);
    } else {
      print('Error al descargar la imagen');
    }
  } catch (e) {
    print('Error al descargar la imagen: $e');
    // Mostrar un diálogo de error
  }
}

void _showImageDialog(BuildContext context, String base64Image) {
  showDialog(
    context: context,
    builder: (context) {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 24.0,
                ),
              ),
              TextButton(
                onPressed: () {
                  _shareImage(base64Image);
                },
                child: const Icon(
                  Icons.share,
                  color: Colors.white,
                  size: 24.0,
                ),
              ),
            ],
          ),
          Expanded(
            child: PhotoViewGallery.builder(
              scrollPhysics: const BouncingScrollPhysics(),
              itemCount: 1,
              builder: (context, index) {
                return PhotoViewGalleryPageOptions(
                  imageProvider: MemoryImage(base64.decode(base64Image)),
                  minScale: PhotoViewComputedScale.contained,
                  maxScale: PhotoViewComputedScale.covered * 2,
                  heroAttributes: PhotoViewHeroAttributes(tag: index),
                );
              },
              backgroundDecoration: const BoxDecoration(
                color: Colors.transparent,
              ),
              pageController: PageController(),
            ),
          ),
        ],
      );
    },
  );
}

Future<void> _shareImage(String base64Image) async {
  try {
    // Decodificar la cadena base64 en bytes
    Uint8List bytes = base64.decode(base64Image);

    // Obtener un directorio temporal para guardar el archivo
    Directory tempDir = await getTemporaryDirectory();
    String tempFilePath = '${tempDir.path}/temp_image.png';

    // Guardar los bytes en un archivo temporal
    File tempFile = File(tempFilePath);
    await tempFile.writeAsBytes(bytes);

    // Compartir el archivo
    await Share.shareFiles([tempFilePath]);
  } catch (e) {
    print('Error al compartir la imagen: $e');
  }
}

void _showOptionsModal(BuildContext context, String? uid, String? nroCP,
    String? idSit, String? rech) {
  print(uid);

  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Container(
        height: 100,
        color: const Color.fromARGB(255, 17, 34, 71),
        child: Center(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment
                    .spaceEvenly, // Distribuye uniformemente los elementos
                children: [
                  if (idSit == "RCZO" || idSit == "DEMO")
                    // RECHAZO CGT O AUTORIZAR O NULL
                    Expanded(
                      child: Column(
                        children: [
                          IconButton(
                            onPressed: () {
                              if (idSit == "RCZO") {
                                // Acción para la opción api rechazo cgt
                                _rechazo(context, uid, nroCP, idSit);
                              } else if (idSit == "DEMO") {
                                // Acción para api autorizar
                                _autorizado(context, uid, nroCP, idSit);
                              } else {
                                null;
                              }
                            },
                            icon: Icon(
                              idSit == "RCZO"
                                  ? Icons.cancel
                                  : (idSit == "DEMO" ? Icons.check : null),
                              color: Colors.white,
                            ),
                            color: Colors.white,
                          ),
                          Text(
                            idSit == "RCZO"
                                ? "Pedir rechazo de CGT"
                                : idSit == "DEMO"
                                    ? "Autorizar"
                                    : "", // Cambia el texto según el valor de 'rech'
                            style: const TextStyle(
                                fontSize: 10, color: Colors.white),
                          ),
                        ],
                      ),
                    ),

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
                          "Solicitar llamada",
                          style: TextStyle(fontSize: 10, color: Colors.white),
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
                            _leido(context, uid, nroCP, idSit);
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
  String? nombreC;
  String? mailC;
  String? telC;
  final prefs = await SharedPreferences.getInstance();
  username = prefs.getString('username');
  password = prefs.getString('password');
  nroCel = prefs.getString("telC");
  nombreC = prefs.getString("nombreC");
  mailC = prefs.getString("mailC");
  telC = prefs.getString("telC");

  final requestData = {
    'usuario': username,
    'contraseña': password,
    "nrocp": nroCP,
    "imei": imei,
    "numero": nroCel,
    "dispositivo": dispositivo,
    "nota": "Solicito llamada",
  };
  print(requestData);
  if (nombreC != "" &&
      nombreC != null &&
      mailC != "" &&
      mailC != null &&
      telC != "" &&
      telC != null) {
    final response = await http.post(
      Uri.parse(
        'http://net.entreganet.com/RestServiceImpl.svc/Llamada',
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

      print("nombreC=");
      print(nombreC);
      print(mailC);
      print(telC);
    } else {
      throw Exception('Failed to send llamada');
    }
  } else {
    print("Perfil incompleto!");
    _showIncompleteProfileModal(context);
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
Future<void> _rechazo(
    context, String? uid, String? nroCP, String? idSit) async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

  String? username;
  String? password;
  String imei = androidInfo.id;
  String? nroCel;
  String? dispositivo = androidInfo.model;
  String? nombreC;
  String? mailC;
  String? telC;
  final prefs = await SharedPreferences.getInstance();
  username = prefs.getString('username');
  password = prefs.getString('password');
  nroCel = prefs.getString("telC");
  nombreC = prefs.getString("nombreC");
  mailC = prefs.getString("mailC");
  telC = prefs.getString("telC");

  final requestData = {
    'usuario': username,
    'contraseña': password,
    "nrocp": nroCP,
    "imei": imei,
    "numero": nroCel,
    "dispositivo": dispositivo,
    "situacion": idSit,
    "idfl": uid
  };
  print(requestData);
  if (nombreC != "" &&
      nombreC != null &&
      mailC != "" &&
      mailC != null &&
      telC != "" &&
      telC != null) {
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

      // Navegar a /home
      Navigator.pushNamed(context, "/home");

      // Esperar unos segundos (opcional)
      await Future.delayed(const Duration(milliseconds: 300));

      // Navegar a /alert
      Navigator.pushNamed(context, "/alert");
    } else {
      throw Exception('Failed to send llamada');
    }
  } else {
    print("Perfil incompleto!");
    _showIncompleteProfileModal(context);
  }
}

//API AUTORIZADO
Future<void> _autorizado(
    context, String? uid, String? nroCP, String? idSit) async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

  String? username;
  String? password;
  String imei = androidInfo.id;
  String? nroCel;
  String? dispositivo = androidInfo.model;
  String? nombreC;
  String? mailC;
  String? telC;
  final prefs = await SharedPreferences.getInstance();
  username = prefs.getString('username');
  password = prefs.getString('password');
  nroCel = prefs.getString("telC");
  nombreC = prefs.getString("nombreC");
  mailC = prefs.getString("mailC");
  telC = prefs.getString("telC");

  final requestData = {
    'usuario': username,
    'contraseña': password,
    "nrocp": nroCP,
    "imei": imei,
    "numero": nroCel,
    "dispositivo": dispositivo,
    "nota": idSit,
    "idfl": uid
  };
  print(requestData);
  if (nombreC != "" &&
      nombreC != null &&
      mailC != "" &&
      mailC != null &&
      telC != "" &&
      telC != null) {
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

      // Navegar a /home
      Navigator.pushNamed(context, "/home");

      // Esperar unos segundos (opcional)
      await Future.delayed(const Duration(milliseconds: 300));

      // Navegar a /alert
      Navigator.pushNamed(context, "/alert");
    } else {
      throw Exception('Failed to send llamada');
    }
  } else {
    print("Perfil incompleto!");
    _showIncompleteProfileModal(context);
  }
}

//LEIDO
Future<void> _leido(context, String? uid, String? nroCP, String? idSit) async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

  String? username;
  String? password;
  String imei = androidInfo.id;
  String? nroCel;
  String? dispositivo = androidInfo.model;
  String? nombreC;
  String? mailC;
  String? telC;
  final prefs = await SharedPreferences.getInstance();
  username = prefs.getString('username');
  password = prefs.getString('password');
  nroCel = prefs.getString("telC");
  nombreC = prefs.getString("nombreC");
  mailC = prefs.getString("mailC");
  telC = prefs.getString("telC");

  final requestData = {
    'usuario': username,
    'contraseña': password,
    "nrocp": nroCP,
    "imei": imei,
    "numero": nroCel,
    "dispositivo": dispositivo,
    "situacion": idSit,
    "idfl": uid
  };
  print(requestData);
  if (nombreC != "" &&
      nombreC != null &&
      mailC != "" &&
      mailC != null &&
      telC != "" &&
      telC != null) {
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

      // Navegar a /home
      Navigator.pushNamed(context, "/home");

      // Esperar unos segundos (opcional)
      await Future.delayed(const Duration(milliseconds: 300));

      // Navegar a /alert
      Navigator.pushNamed(context, "/alert");
    } else {
      throw Exception('Failed to send llamada');
    }
  } else {
    print("Perfil incompleto!");
    _showIncompleteProfileModal(context);
  }
}

// Función para mostrar el modal de perfil incompleto
void _showIncompleteProfileModal(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Perfil incompleto'),
        content: const Text(
            'Por favor, completa tu perfil antes de enviar la llamada.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Cierra el modal
              Navigator.pushReplacementNamed(
                  context, '/perfil'); // Navega a la nueva ruta
            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}
