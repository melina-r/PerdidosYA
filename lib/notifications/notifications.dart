import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

void initNotifications() async {
  // Ruta al archivo de clave de servicio descargado desde Firebase Console
  const serviceAccountPath = 'assets/service_account.json';
  final serviceAccount = json.decode(File(serviceAccountPath).readAsStringSync());

  // Datos importantes del archivo de clave
  final clientEmail = serviceAccount['client_email'];
  final privateKey = serviceAccount['private_key'];
  final projectId = serviceAccount['project_id'];

  // Generar el JWT
  final jwt = generateFirebaseJwt(clientEmail, privateKey);

  // Enviar una notificación de ejemplo
  await sendNotification(jwt, projectId);
}

String generateFirebaseJwt(String clientEmail, String privateKey) {
  // Crear el JWT
  final jwt = JWT(
    {
      "iss": clientEmail,
      "sub": clientEmail,
      "aud": "https://firebase.googleapis.com/",
      "iat": DateTime.now().millisecondsSinceEpoch ~/ 1000,
      "exp": (DateTime.now().millisecondsSinceEpoch ~/ 1000) + 3600, // Válido por 1 hora
    },
  );

  // Firmar el JWT usando la clave privada
  return jwt.sign(
    RSAPrivateKey(privateKey),
    algorithm: JWTAlgorithm.RS256,
  );
}


Future<void> sendNotification(String jwt, String projectId) async {
  final url = Uri.parse('https://fcm.googleapis.com/v1/projects/$projectId/messages:send');

  // Configuración del mensaje
  final message = {
    "message": {
      "token": "<user_device_token>", // Reemplaza con el token del dispositivo
      "notification": {
        "title": "¡Hola!",
        "body": "Notificación enviada con éxito desde HTTP v1"
      }
    }
  };

  // Realizar la solicitud HTTP
  final response = await http.post(
    url,
    headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $jwt", // Usa el JWT generado
    },
    body: json.encode(message),
  );

  if (response.statusCode == 200) {
    print("✅ Notificación enviada exitosamente.");
  } else {
    print("❌ Error al enviar la notificación: ${response.body}");
  }
}


