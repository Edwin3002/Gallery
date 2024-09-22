mixin AppLocale {
  static const String title = 'title';
  static const String settings = 'settings';
  static const String language = 'language';
  static const String columns = 'columns';
  static const String selected = 'selected';
  static const String thisIs = 'thisIs';

  static const Map<String, dynamic> EN = {
    title: 'Gallery',
    settings: "Settings",
    language: "Language",
    columns: "Number of columns",
    selected: "Selected",
    thisIs: 'This is %a package, version %a.',
  };
  static const Map<String, dynamic> ES = {
    title: 'Galería',
    settings: "Ajustes",
    language: "Idioma",
    columns: "Número de columnas",
    selected: "Seleccionado",
    thisIs: 'Galería',
  };
}
