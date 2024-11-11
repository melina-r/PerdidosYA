
class Mensaje {
  String body;
  String title;
  String from;
  dynamic received;

  Mensaje({required this.body, required this.title, required this.from, required this.received});

  factory Mensaje.fromMap(Map<String, dynamic> mensaje) {
    return Mensaje(
      body: mensaje['body'] ?? '',
      title: mensaje['title'] ?? '',
      from: mensaje['from'] ?? '',
      received: mensaje['received'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'body': body,
      'title': title,
      'from': from,
      'received': received,
    };
  }
}