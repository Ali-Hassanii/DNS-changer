class Server {
  int? id;
  String title;
  String address1;
  String address2;

  Server({
    this.id,
    required this.title,
    required this.address1,
    required this.address2,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "server1": address1,
      "server2": address2,
    };
  }
}
