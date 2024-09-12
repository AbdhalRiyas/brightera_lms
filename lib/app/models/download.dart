class Download {
  final String name, type;
  final Uri link;

  Download({required this.name, required this.type, required this.link});

  factory Download.fromJson(Map<String, dynamic> json) => Download(
      name: json['name'], type: json['type'], link: Uri.parse(json['link']));

  Map<String, dynamic> toJson() => {
        'name': name,
        'type': type,
        'link': link.toString(),
      };
}
