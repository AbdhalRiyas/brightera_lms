class Download {
  final String name;
  final Uri link;

  Download({required this.name, required this.link});

  factory Download.fromJson(Map<String, dynamic> json) =>
      Download(name: json['name'], link: Uri.parse(json['link']));

  Map<String, dynamic> toJson() => {
        'name': name,
        'link': link.toString(),
      };
}
