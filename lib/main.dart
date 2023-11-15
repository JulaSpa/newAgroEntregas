import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/login_page.dart';
import 'package:flutter_application_1/pages/home_page.dart';
import 'package:flutter_application_1/pages/alerta_page.dart';

import 'package:flutter_application_1/pages/posicion_page.dart';
import 'package:flutter_application_1/pages/historico_page.dart';
import 'package:flutter_application_1/pages/herramienta_page.dart';
import 'package:flutter_application_1/pages/buscar_page.dart';
import 'package:flutter_application_1/pages/perfil_page.dart';
import 'package:flutter_application_1/pages/inicio_page.dart';
import 'package:flutter_application_1/pages/camionesCP_page.dart';
import 'package:flutter_application_1/pages/camionesbusq_page.dart';
import 'package:flutter_application_1/pages/mensajes_page.dart';
import 'package:flutter_application_1/src/providers.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      initialRoute: "/inicio",
      onGenerateRoute: (settings) {
        if (settings.name == '/mensajes') {
          // Si la ruta es "/mensajes", extrae los argumentos y crea la página
          final args = settings.arguments;
          if (args is List<MensajesArguments>) {
            return MaterialPageRoute(
              builder: (context) {
                return Mensajes(
                  arguments: args,
                );
              },
            );
          }
        }
        // Otras rutas...

        // Si ninguna condición anterior se cumple, devuelve una ruta nula o la ruta que corresponda
        return null; // O devuelve otra ruta en función de tus necesidades
      },
      routes: {
        "/inicio": (context) => const Inicio(),
        "/camionesCP": (context) => const Camiones(),
        "/camionesBusq": (context) => const CamionesBusq(),
        "/login": (context) => const Login(),
        "/home": (context) => const MyHomePage(),
        "/perfil": (context) => const Perfil(),
        "/alert": (context) => const Alert(),
        "/position": (context) => const Position(),
        "/historic": (context) => const Historic(),
        "/tool": (context) => const Tool(),
        "/buscar": (context) => const Buscar(),
      },
    );
  }
}
