import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class Tool extends StatefulWidget {
  const Tool({super.key});

  @override
  State<Tool> createState() => _ToolState();
}

class _ToolState extends State<Tool> {
  String? linkNoticias;
  String? linkHDFS;
  String? linkHyV;
  String? linkCA;
  String? linkCondiciones;
  String? linkCamiones;
  String? linkRef;
  @override
  void initState() {
    super.initState();
    // Obtener los valores de SharedPreferences
    fetchData();
  }

  void fetchData() async {
    try {
      final response = await http.get(
        Uri.parse('http://net.entreganet.com/RestServiceImpl.svc/Noticias'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "Access-Control-Allow-Origin": "*",
          "Access-Control-Allow-Methods":
              "POST, GET, OPTIONS, PUT, DELETE, HEAD",
        },
      );
      final resHdfs = await http.get(
        Uri.parse('http://net.entreganet.com/RestServiceImpl.svc/Hfds'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "Access-Control-Allow-Origin": "*",
          "Access-Control-Allow-Methods":
              "POST, GET, OPTIONS, PUT, DELETE, HEAD",
        },
      );
      final resHyV = await http.get(
        Uri.parse('http://net.entreganet.com/RestServiceImpl.svc/Hvc'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "Access-Control-Allow-Origin": "*",
          "Access-Control-Allow-Methods":
              "POST, GET, OPTIONS, PUT, DELETE, HEAD",
        },
      );
      final resCA = await http.get(
        Uri.parse('http://net.entreganet.com/RestServiceImpl.svc/CA'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "Access-Control-Allow-Origin": "*",
          "Access-Control-Allow-Methods":
              "POST, GET, OPTIONS, PUT, DELETE, HEAD",
        },
      );
      final resCond = await http.get(
        Uri.parse('http://net.entreganet.com/RestServiceImpl.svc/Condiciones'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "Access-Control-Allow-Origin": "*",
          "Access-Control-Allow-Methods":
              "POST, GET, OPTIONS, PUT, DELETE, HEAD",
        },
      );
      final resCamiones = await http.get(
        Uri.parse('http://net.entreganet.com/RestServiceImpl.svc/Camiones'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "Access-Control-Allow-Origin": "*",
          "Access-Control-Allow-Methods":
              "POST, GET, OPTIONS, PUT, DELETE, HEAD",
        },
      );
      final resRef = await http.get(
        Uri.parse('http://net.entreganet.com/RestServiceImpl.svc/Referencias'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "Access-Control-Allow-Origin": "*",
          "Access-Control-Allow-Methods":
              "POST, GET, OPTIONS, PUT, DELETE, HEAD",
        },
      );

      if (response.statusCode == 200 ||
          resHdfs.statusCode == 200 ||
          resHyV.statusCode == 200 ||
          resCA.statusCode == 200 ||
          resCond.statusCode == 200 ||
          resCamiones.statusCode == 200 ||
          resRef.statusCode == 200) {
        final exp = RegExp(r'<[^>]*>', multiLine: true, caseSensitive: true);
        //REF xmls
        print("Referencias:");
        final jsonContentRef = resRef.body.replaceAll(exp, "");
        try {
          final dataRef = jsonContentRef;
          linkRef = dataRef;
          print(linkRef);
        } catch (e) {
          print('Error: No se encontró el inicio del JSON en la respuesta.');
        }
        //CAMIONES xmlns
        print("camiones:");
        final jsonContentCam = resCamiones.body.replaceAll(exp, "");
        try {
          final dataCam = jsonContentCam;
          linkCamiones = dataCam;
          print(linkCamiones);
        } catch (e) {
          print('Error: No se encontró el inicio del JSON en la respuesta.');
        }
        //CONDICIONES xmlns

        print("CONDICIONES:");
        final jsonContentCond = resCond.body.replaceAll(exp, '');

        try {
          final dataCond = jsonContentCond;
          linkCondiciones = dataCond;
          print(linkCondiciones);
        } catch (e) {
          print('Error: No se encontró el inicio del JSON en la respuesta.');
        }
        //COSTOS Y ACONDICIONAMIENTOS xmls
        final jsonContentCA = resCA.body.replaceAll(exp, '');
        print("CA:");
        try {
          final dataCa = jsonContentCA;
          linkCA = dataCa.replaceAll('"', '');
          print(linkCA);
        } catch (e) {
          print('Error: No se encontró el inicio del JSON en la respuesta.');
        }
        //HORARIOS Y VIGENCIA DE CUPOS xmls
        final jsonContenthyv = resHyV.body.replaceAll(exp, '');
        print("HyV:");
        try {
          final datahyv = jsonContenthyv;
          linkHyV = datahyv.replaceAll('"', '');
          print(linkHyV);
        } catch (e) {
          print('Error: No se encontró el inicio del JSON en la respuesta.');
        }
        //HORARIOS FINDES: xmls
        final jsonContenhdfs = resHdfs.body.replaceAll(exp, '');
        print("HDFS:");
        try {
          final datahdfs = jsonContenhdfs;
          linkHDFS = datahdfs;
          print(linkHDFS);
        } catch (e) {
          print('Error: No se encontró el inicio del JSON en la respuesta.');
        }
        //NOTICIAS DENTRO DE xmlns

        final jsonContent = response.body.replaceAll(exp, '');
        print("noticias");
        try {
          final dataNoti = jsonContent;
          linkNoticias = dataNoti;
          print(linkNoticias);
        } catch (e) {
          print('Error: No se encontró el inicio del JSON en la respuesta.');
        }
      } else {
        print('Error de red. Código de estado: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
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
                              launch(linkNoticias!);
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
                              launch(linkCondiciones!);
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
                              launch(linkCamiones!);
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
                              launch(linkRef!);
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
                              launch(linkCA!);
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
                              launch(linkHDFS!);
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
                              launch(linkHyV!);
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
