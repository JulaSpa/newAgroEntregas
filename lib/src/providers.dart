import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MensajesArguments {
  final List<String> title;
  final List<String> body;

  MensajesArguments({required this.title, required this.body});
}

class PushNotProv {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  bool? msjC;
  List<MensajesArguments> mensajesList = [];
  final _mensajeStreamControll =
      StreamController<List<MensajesArguments>>.broadcast();
  Stream<List<MensajesArguments>> get mensajes => _mensajeStreamControll.stream;

  initNotifications() {
    messaging.requestPermission();
    messaging.getToken().then((token) async {
      print("TOKEN:");
      print(token);
      final String tok = token!;

      // Guardar en SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      msjC = prefs.getBool("msjC");
      await prefs.setString('tok', tok);
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (msjC == true) {
        print('Got a message whilst in the foreground!');
        if (message.notification != null) {
          // Almacena el último mensaje

          MensajesArguments newMessage = MensajesArguments(
            title: [message.notification?.title ?? "no-data"],
            body: [message.notification?.body ?? "no-data"],
          );
// Añade el mensaje a la lista
          mensajesList.add(newMessage);

          // Añade el mensaje al stream
          _mensajeStreamControll.add(mensajesList);
          print("mensajesList prov");
          print(mensajesList);
        }
      } else {
        print("msj desact");
      }
    });

    // Manejar notificaciones cuando la aplicación está en segundo plano y el usuario toca la notificación
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (msjC == true) {
        print('Got a message whilst in the foreground!');
        if (message.notification != null) {
          // Almacena el último mensaje

          MensajesArguments newMessage = MensajesArguments(
            title: [message.notification?.title ?? "no-data"],
            body: [message.notification?.body ?? "no-data"],
          );

          mensajesList.add(newMessage);

          // Añade el mensaje al stream
          _mensajeStreamControll.add(mensajesList);
        }
      } else {
        print("msj desact");
      }
    });

    // Manejar notificaciones cuando la aplicación está completamente cerrada y el usuario toca la notificación
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    if (msjC == true) {
      print('Got a message whilst in the foreground!');
      if (message.notification != null) {
        // Almacena el último mensaje

        MensajesArguments newMessage = MensajesArguments(
          title: [message.notification?.title ?? "no-data"],
          body: [message.notification?.body ?? "no-data"],
        );

        mensajesList.add(newMessage);

        // Añade el mensaje al stream
        _mensajeStreamControll.add(mensajesList);
      }
    } else {
      print("msj desact");
    }
  }

  dispose() {
    _mensajeStreamControll.close();
  }
}
