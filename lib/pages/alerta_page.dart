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
  bool allIndicesAreRCZO = false;
  bool allIndicesAreDEMO = false;

  String? username;
  String? password;
  late Future<List<Album>> futureAlbum;
  bool isLoading =
      true; // Agregar una variable para rastrear si se está cargando
//BUSCAR POR PALABRA CLAVE
  var searchController = TextEditingController();
  String ordenarPor = 'Seleccionar';
  @override
  void initState() {
    super.initState();
    // Obtener los valores de SharedPreferences
    _getStoredUserData();
    ordenarPor = 'Seleccionar';
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

  bool isOptionsVisible = false;
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
            actions: [
              GestureDetector(
                onTap: () {
                  // Toggle the visibility of options
                  setState(() {
                    isOptionsVisible = !isOptionsVisible;
                  });
                },
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.search),
                ),
              ),
            ],
          ),
          body: DecoratedBox(
            decoration: const BoxDecoration(
              color: Color.fromRGBO(255, 255, 255, 0.863),
            ),
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Column(
                    children: [
                      Column(
                        children: [
                          if (isOptionsVisible)
                            ListTile(
                              title: TextField(
                                controller: searchController,
                                decoration: const InputDecoration(
                                  hintText: 'Buscar por palabra clave',
                                ),
                                onChanged: (text) {
                                  setState(() {
                                    // Actualizar el estado del controlador
                                    searchController.text = text;
                                  });
                                },
                              ),
                            ),
                          // Ordenar por
                          if (isOptionsVisible)
                            // Ordenar por

                            OptionWidget(
                              title: 'Ordernar por:',
                              selectedValue: ordenarPor,
                              onSelected: (value) {
                                setState(() {
                                  ordenarPor = value;
                                });
                                print('Opción seleccionada: $value');
                              },
                            ),
                        ],
                      ),
                      Expanded(
                        child: FutureBuilder<List<Album>>(
                          future: futureAlbum,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              var albums = snapshot.data!;
                              // Filtrar la lista según el texto del searchController
                              var filteredAlbums = albums
                                  .where((album) =>
                                      album.nroCP.toLowerCase().startsWith(searchController.text.toLowerCase()) ||
                                      album.xtitular.toLowerCase().startsWith(
                                          searchController.text
                                              .toLowerCase()) ||
                                      album.xcorredor.toLowerCase().startsWith(
                                          searchController.text
                                              .toLowerCase()) ||
                                      album.xdestinatario
                                          .toLowerCase()
                                          .startsWith(searchController.text
                                              .toLowerCase()) ||
                                      album.xdestino.toLowerCase().startsWith(
                                          searchController.text
                                              .toLowerCase()) ||
                                      album.nombreMe.toLowerCase().startsWith(
                                          searchController.text.toLowerCase()) ||
                                      album.nombrePrc.toLowerCase().startsWith(searchController.text.toLowerCase()) ||
                                      album.chasisFl.toLowerCase().startsWith(searchController.text.toLowerCase()) ||
                                      album.acopreFl.toLowerCase().startsWith(searchController.text.toLowerCase()) ||
                                      album.rem2.toLowerCase().startsWith(searchController.text.toLowerCase()) ||
                                      album.remCom.toLowerCase().startsWith(searchController.text.toLowerCase()) ||
                                      album.rem1.toLowerCase().startsWith(searchController.text.toLowerCase()) ||
                                      album.rem3.toLowerCase().startsWith(searchController.text.toLowerCase()) ||
                                      album.xcorredor1.toLowerCase().startsWith(searchController.text.toLowerCase()) ||
                                      album.xcorredor2.toLowerCase().startsWith(searchController.text.toLowerCase()))
                                  .toList();
                              //ordenar desc nro cp
                              // Ordenar la lista según la opción seleccionada
                              if (ordenarPor == 'Numerocp') {
                                filteredAlbums.sort((a, b) => int.parse(a.nroCP)
                                    .compareTo(int.parse(b.nroCP)));
                              } else if (ordenarPor == 'Puerto') {
                                filteredAlbums.sort((a, b) {
                                  // Función de comparación personalizada para ordenar por puerto
                                  if (a.xdestino.startsWith('A') &&
                                      !b.xdestino.startsWith('A')) {
                                    return -1; // 'A' viene primero
                                  } else if (!a.xdestino.startsWith('A') &&
                                      b.xdestino.startsWith('A')) {
                                    return 1; // 'A' va después de otros
                                  } else {
                                    return a.xdestino.compareTo(b.xdestino);
                                  }
                                });
                              } else if (ordenarPor == 'Situación') {
                                filteredAlbums.sort((a, b) {
                                  // Función de comparación personalizada para ordenar por situación
                                  return a.nombreSit.compareTo(b.nombreSit);
                                });
                              }
                              return ListView.builder(
                                itemCount: filteredAlbums.length,
                                itemBuilder: (context, index) {
                                  var album = filteredAlbums[index];
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
                                    "DESCARGADO":
                                        const Color.fromARGB(255, 2, 99, 5),
                                    "SIN CUPO": Colors.green,
                                    "SOLICITA RECHAZO": Colors.purple,
                                    "HABLADO":
                                        const Color.fromARGB(255, 176, 39, 96)
                                  };

                                  Color backgroundColor =
                                      colorMap[rech] ?? Colors.grey;
                                  // Controlar el estado del Checkbox en función de si el índice está en la lista de selectedIndices
                                  bool isChecked =
                                      selectedIndices.contains(index);

                                  void onCheckboxTapped(int index) {
                                    setState(() {
                                      if (selectedIndices.contains(index)) {
                                        selectedIndices.remove(index);
                                      } else {
                                        selectedIndices.add(index);
                                      }

                                      // Verificar si todos los índices seleccionados son de tipo RCZO
                                      allIndicesAreRCZO = selectedIndices.every(
                                          (index) =>
                                              albums[index].idSit == "RCZO");

                                      // Verificar si todos los índices seleccionados son de tipo DEMO
                                      allIndicesAreDEMO = selectedIndices.every(
                                          (index) =>
                                              albums[index].idSit == "DEMO");
                                    });
                                  }

                                  return Column(
                                    children: [
                                      InkWell(
                                        child: Container(
                                          color: backgroundColor,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(
                                                        35, 10, 5, 10),
                                                child: Icon(
                                                  (album.idSit == "RCZO")
                                                      ? Icons.cancel
                                                      : (album.idSit == "AUTO")
                                                          ? Icons.check
                                                          : (album.idSit ==
                                                                  "DEMO")
                                                              ? Icons
                                                                  .access_time
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
                                                padding:
                                                    const EdgeInsetsDirectional
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
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(0, 0, 0, 0),
                                                child: Checkbox(
                                                  value: isChecked,
                                                  onChanged: (bool? value) {
                                                    onCheckboxTapped(index);

                                                    List<Map<String, dynamic>>
                                                        CompartirLista =
                                                        selectedIndices
                                                            .map((index) {
                                                      return {
                                                        'Estado':
                                                            albums[index].idSit,
                                                        'Titular': albums[index]
                                                            .xtitular,
                                                        'Observaciones': albums[
                                                                index]
                                                            .observacionesana,
                                                        'Procedencia':
                                                            albums[index]
                                                                .nombrePrc,
                                                        'Número carta de porte':
                                                            albums[index].nroCP,
                                                        'Corredor':
                                                            albums[index]
                                                                .xcorredor,
                                                        'Mercaderia':
                                                            albums[index]
                                                                .nombreMe,
                                                        'Destino': albums[index]
                                                            .xdestino,
                                                        'Patente': albums[index]
                                                            .chasisFl,
                                                      };
                                                    }).toList();
                                                    if (selectedIndices
                                                        .contains(index)) {
                                                      _showOptionsModal(
                                                          context,
                                                          album.idFl,
                                                          album.nroCP,
                                                          album.idSit,
                                                          rech,
                                                          allIndicesAreRCZO,
                                                          allIndicesAreDEMO,
                                                          selectedIndices,
                                                          albums,
                                                          CompartirLista);
                                                    }
                                                    ;
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(40, 10, 0, 0),
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
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                          .fromSTEB(
                                                          0, 10, 0, 0),
                                                  child: Text(
                                                    album.xtitular
                                                        .toUpperCase(),
                                                    style: const TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.lightBlue,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(40, 0, 0, 0),
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(40, 0, 0, 0),
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(40, 0, 0, 0),
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(40, 0, 0, 0),
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(40, 0, 0, 0),
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
                                          final prefs = await SharedPreferences
                                              .getInstance();
                                          await prefs.setString('nroCP', nroCP);
                                          _downLoad(username, password, nroCP,
                                              context);
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
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(40, 0, 0, 0),
                                                  child: Text(
                                                    "IMAGEN: ",
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    album.imagen,
                                                    style: const TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.lightBlue,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(0, 10, 0, 10),
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
                      )
                    ],
                  ),
          ),
        ),
      ],
    );
  }
}

class OptionWidget extends StatelessWidget {
  final String title;
  final String selectedValue;
  final Function(String) onSelected;

  const OptionWidget({
    Key? key,
    required this.title,
    required this.selectedValue,
    required this.onSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          if (title == 'Ordernar por:')
            DropdownButton<String>(
              value: selectedValue, // Establecer el valor seleccionado
              onChanged: (String? value) {
                if (value != null) {
                  // Llama al callback con la opción seleccionada
                  onSelected(value);
                }
              },
              items: ['Seleccionar', 'Numerocp', 'Puerto', 'Situación']
                  .map<DropdownMenuItem<String>>(
                    (String value) => DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    ),
                  )
                  .toList(),
            ),
        ],
      ),
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

void _showOptionsModal(
    BuildContext context,
    String? uid,
    String? nroCP,
    String? idSit,
    String? rech,
    bool? allIndicesAreRCZO,
    bool? allIndicesAreDEMO,
    List<int> selectedIndices,
    List albums,
    List compartirLista) {
  print(uid);

  showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 100,
          color: Color.fromARGB(255, 17, 34, 71),
          child: Center(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment
                      .spaceEvenly, // Distribuye uniformemente los elementos
                  children: [
                    if (allIndicesAreRCZO != null && allIndicesAreRCZO)
                      // RECHAZO CGT O AUTORIZAR O NULL
                      Expanded(
                        child: Column(
                          children: [
                            IconButton(
                              onPressed: () {
                                // Acción para la opción api rechazo cgt
                                _rechazo(context, uid, nroCP, idSit,
                                    selectedIndices, albums);
                              },
                              icon: const Icon(
                                Icons.cancel,
                                color: Colors.white,
                              ),
                              color: Colors.white,
                            ),
                            const Text(
                              "Pedir rechazo de CGT",
                              style:
                                  TextStyle(fontSize: 10, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    if (allIndicesAreDEMO != null && allIndicesAreDEMO)
                      Expanded(
                        child: Column(
                          children: [
                            IconButton(
                              onPressed: () {
                                // Acción para la opción api rechazo cgt
                                _autorizado(context, uid, nroCP, idSit,
                                    selectedIndices, albums);
                                ;
                              },
                              icon: const Icon(
                                Icons.check,
                                color: Colors.white,
                              ),
                              color: Colors.white,
                            ),
                            const Text(
                              "Autorizar",
                              style:
                                  TextStyle(fontSize: 10, color: Colors.white),
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
                            onPressed: () async {
                              await _leido(context, uid, nroCP, idSit,
                                  selectedIndices, albums);
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

                    //Compartir
                    Expanded(
                      child: Column(
                        children: [
                          IconButton(
                            onPressed: () async {
                              await _compartir(context, compartirLista);
                            },
                            icon: const Icon(Icons.share_outlined),
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
      });
}

//COMPARTIR
Future<void> _compartir(context, List? compartirLista) async {
  final String textoCompartir = compartirLista!.join('\n');

  try {
    await Share.share(textoCompartir);
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error al compartir: $e'),
      ),
    );
  }
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
Future<void> _rechazo(context, String? uid, String? nroCP, String? idSit,
    List<int> selectedIndices, List albums) async {
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

  if (nombreC != "" &&
      nombreC != null &&
      mailC != "" &&
      mailC != null &&
      telC != "" &&
      telC != null) {
    List<Map<String, dynamic>> requestDataList = selectedIndices.map((index) {
      return {
        'usuario': username,
        'contraseña': password,
        'nrocp': albums[index].nroCP,
        'imei': imei,
        'numero': nroCel,
        'dispositivo': dispositivo,
        'situacion': albums[index].idSit,
        'idfl': albums[index].idFl,
      };
    }).toList();
    for (var requestData in requestDataList) {
      final response = await http.post(
        Uri.parse(
          'http://net.entreganet.com/RestServiceImpl.svc/Rechazos',
        ),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "Access-Control-Allow-Origin": "*",
          "Access-Control-Allow-Methods":
              "POST, GET, OPTIONS, PUT, DELETE, HEAD",
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
    }
  } else {
    print("Perfil incompleto!");
    _showIncompleteProfileModal(context);
  }
}

//API AUTORIZADO
Future<void> _autorizado(context, String? uid, String? nroCP, String? idSit,
    List<int> selectedIndices, List albums) async {
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

  if (nombreC != "" &&
      nombreC != null &&
      mailC != "" &&
      mailC != null &&
      telC != "" &&
      telC != null) {
    List<Map<String, dynamic>> requestDataList = selectedIndices.map((index) {
      return {
        'usuario': username,
        'contraseña': password,
        'nrocp': albums[index].nroCP,
        'imei': imei,
        'numero': nroCel,
        'dispositivo': dispositivo,
        'idfl': albums[index].idFl,
      };
    }).toList();
    for (var requestData in requestDataList) {
      final response = await http.post(
        Uri.parse(
          'http://net.entreganet.com/RestServiceImpl.svc/Autorizado',
        ),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "Access-Control-Allow-Origin": "*",
          "Access-Control-Allow-Methods":
              "POST, GET, OPTIONS, PUT, DELETE, HEAD",
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
    }
  } else {
    print("Perfil incompleto!");
    _showIncompleteProfileModal(context);
  }
}

//LEIDO
Future<void> _leido(context, String? uid, String? nroCP, String? idSit,
    List<int> selectedIndices, List albums) async {
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

  if (nombreC != "" &&
      nombreC != null &&
      mailC != "" &&
      mailC != null &&
      telC != "" &&
      telC != null) {
    List<Map<String, dynamic>> requestDataList = selectedIndices.map((index) {
      return {
        'usuario': username,
        'contraseña': password,
        'nrocp': albums[index].nroCP,
        'imei': imei,
        'numero': nroCel,
        'dispositivo': dispositivo,
        'situacion': albums[index].idSit,
        'idfl': albums[index].idFl,
      };
    }).toList();
    for (var requestData in requestDataList) {
      final response = await http.post(
        Uri.parse(
          'http://net.entreganet.com/RestServiceImpl.svc/Hablados',
        ),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "Access-Control-Allow-Origin": "*",
          "Access-Control-Allow-Methods":
              "POST, GET, OPTIONS, PUT, DELETE, HEAD",
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
