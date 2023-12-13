import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import "package:flutter_application_1/album/album.dart";
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:flutter_application_1/pages/detalles_page.dart';

class Buscar extends StatefulWidget {
  const Buscar({super.key});

  @override
  State<Buscar> createState() => _BuscarState();
}

class _BuscarState extends State<Buscar> {
  String? username;
  String? password;
  String? fromDate;
  String? toDate;
  Future<List<Album>> futureAlbum = Future.value([]);
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
      username = prefs.getString('username');
      password = prefs.getString('password');
      fromDate = prefs.getString('fromDate');
      toDate = prefs.getString('toDate');
    });
    _loadAlbumData();
    if (username != null &&
        password != null &&
        fromDate != null &&
        toDate != null) {
      futureAlbum = fetchAlbum();
    }
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
      'fechad': fromDate,
      'fechah': toDate,
    };

    final response = await http.post(
      Uri.parse('http://net.entreganet.com/RestServiceImpl.svc/Historicos'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
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
                                Container(
                                  color: backgroundColor,
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(5, 10, 5, 10),
                                        child: Icon(
                                          rech == "RECHAZADO"
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
