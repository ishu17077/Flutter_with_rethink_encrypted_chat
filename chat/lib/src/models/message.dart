// @dart=2.9
class Message {
  String get id => _id;
  final String from;
  final String to;
  final DateTime timestamp;
  final String contents;
  String _id;
  Message({
    this.from,
    this.to,
    this.timestamp,
    this.contents,
  });
  toJson() => {
        'from': this.from,
        'to': this.to,
        'timestamp': this.timestamp,
        'contents': this.contents,
      };
  factory Message.fromJson(Map<String, dynamic> json) {
    var message = Message(
      from: json['from'],
      to: json['to'],
      timestamp: json['timestamp'],
      contents: json['contents'],
    );
    message._id = json['id'];
    return message;
  }
}
