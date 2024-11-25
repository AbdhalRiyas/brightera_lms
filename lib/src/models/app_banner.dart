class Appbanner {
  final String imagePath;
  final String? link;
  final bool isHidden;
  final int order;

  const Appbanner(
      {required this.imagePath,
      required this.link,
      this.isHidden = false,
      this.order = 1});
}
