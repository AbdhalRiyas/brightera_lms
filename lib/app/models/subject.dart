class Subject {
  final String id, name;
  final bool isActive, isHidden;
  final String icon;

  Subject(
      {required this.id,
      required this.name,
      required this.isActive,
      required this.isHidden,
      this.icon = ''});
}
