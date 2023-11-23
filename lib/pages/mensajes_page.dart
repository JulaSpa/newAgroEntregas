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
      appBar: AppBar(
        title: Image.asset("lib/images/logoAgroEntregas.png"),
        backgroundColor: Colors.blue,
        elevation: 0,
        centerTitle: true,
        toolbarHeight: 60,
        iconTheme: const IconThemeData(color: Colors.white),
        automaticallyImplyLeading: true,
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
                  ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Mostrar el cuadro de diálogo de confirmación
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Confirmación"),
                content: const Text(
                    "¿Estás seguro de que deseas eliminar los mensajes?"),
                actions: [
                  // Botón para cancelar
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("Cancelar"),
                  ),
                  // Botón para confirmar y navegar a /home
                  TextButton(
                    onPressed: () {
                      // Acción que se realiza al confirmar
                      Navigator.of(context)
                          .pop(); // Cerrar el cuadro de diálogo
                      Navigator.pushNamed(context, "/home");
                    },
                    child: const Text("Confirmar"),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.delete),
        backgroundColor: Colors.red,
      ),
    );
  }
}

class MensajeWidget extends StatelessWidget {
  final List<String> title;
  final List<String> body;

  const MensajeWidget({
    Key? key,
    required this.title,
    required this.body,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsetsDirectional.fromSTEB(40, 10, 0, 0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: IntrinsicWidth(
          child: Card(
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var i = 0; i < title.length; i++)
                    Column(
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.message, // Ícono de burbuja de diálogo
                              color: Colors.blue, // Color del ícono
                            ),
                            const SizedBox(width: 8.0),
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
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
