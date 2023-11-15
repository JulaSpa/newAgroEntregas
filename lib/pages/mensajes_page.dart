import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/providers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';

class Mensajes extends StatefulWidget {
  final List<MensajesArguments> arguments;
  const Mensajes({super.key, required this.arguments});

  @override
  State<Mensajes> createState() => _Mensajes();
}

class _Mensajes extends State<Mensajes> {
  bool? msjC;
  late PushNotProv pushNotProv;
  late ValueNotifier<int> messageCountNotifier;
  List<MensajesArguments>? lastMessage;
  bool firebaseInitialized = false;
  @override
  void initState() {
    super.initState();
    // Imprimir los argumentos al inicializar la página
    /* print("Arguments in Mensajes: ${widget.arguments}"); */
    getStoredUserData();
    //FUNCION QUE ACTUALIZA /MENSAJES CUANDO LLEGA UNO.
    WidgetsFlutterBinding.ensureInitialized();
    Firebase.initializeApp().then((_) {
      // La inicialización de Firebase se ha completado
      pushNotProv = PushNotProv();
      // ENVIA TOKEN A FIREBASE
      pushNotProv.initNotifications(); // Utiliza la instancia existente
      setState(() {
        if (mounted) {
          firebaseInitialized = true; // Marca que Firebase se ha inicializado
        }
      });
      pushNotProv.mensajes.listen((List<MensajesArguments> messages) {
        if (mounted) {
          setState(() {
            lastMessage = messages;
          });
        }
      });
    }).catchError((error) {
      print("Error al inicializar Firebase: $error");
    });
  }

  Future<void> getStoredUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      msjC = prefs.getBool("msjC") ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Image.asset("lib/images/logoAgroEntregas.png"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        toolbarHeight: 60,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("lib/images/camiones.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            child: Column(
              children: <Widget>[
                for (var message in widget.arguments)
                  MensajeWidget(
                    title: message.title,
                    body: message.body,
                    msj: msjC,
                  ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Acción que se realiza al presionar el botón flotante
          // MANEJO DE NOTIFICACIONES
          Navigator.pushNamed(
            context,
            "/home",
          );
        },
        child: const Icon(Icons.delete),
      ),
    );
  }
}

class MensajeWidget extends StatelessWidget {
  final List<String> title;
  final List<String> body;
  final bool? msj;

  const MensajeWidget({
    Key? key,
    required this.title,
    required this.body,
    required this.msj,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(70, 10, 0, 0),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.2,
        child: Card(
          margin: const EdgeInsets.all(5),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var i = 0; i < title.length; i++)
                  Column(
                    children: [
                      if (msj == true)
                        Row(
                          children: [
                            const Icon(
                              Icons.message, // Ícono de burbuja de diálogo
                              color: Colors.blue, // Color del ícono
                            ),
                            SizedBox(width: 8.0),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    title[i],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(body[i]),
                                ],
                              ),
                            ),
                          ],
                        )
                      else
                        const Text("Tienes los mensajes desactivados"),
                      const SizedBox(height: 1.0),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
