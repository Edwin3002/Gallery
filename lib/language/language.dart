mixin AppLocale {
  static const String title = 'title';
  static const String settings = 'settings';
  static const String language = 'language';
  static const String columns = 'columns';
  static const String thisIs = 'thisIs';

  static const Map<String, dynamic> EN = {
    title: 'Gallery',
    settings: "Settings",
    language: "Language",
    columns: "Number of columns",
    thisIs: 'This is %a package, version %a.',
  };
  static const Map<String, dynamic> ES = {
    title: 'Galería',
    settings: "Ajustes",
    language: "Idioma",
    columns: "Número de columnas",
    thisIs: 'Galería',
  };
}
