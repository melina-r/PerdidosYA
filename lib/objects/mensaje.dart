
class Mensaje {
  String body;
  String title;
  String from;
  dynamic timestamp;

  Mensaje({required this.body, required this.title, required this.from, required this.timestamp});

  factory Mensaje.fromMap(Map<String, dynamic> mensaje) {
    return Mensaje(
      body: mensaje['body'] ?? '',
      title: mensaje['title'] ?? '',
      from: mensaje['from'] ?? '',
      timestamp: mensaje['timestamp'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'body': body,
      'title': title,
      'from': from,
      'timestamp': timestamp,
    };
  }
}