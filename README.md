# CineLog Flutter

Aplicación móvil desarrollada en Flutter para gestionar una biblioteca personal de películas y series.

Este proyecto está planteado como una app de portfolio creada desde cero: no usa código de empresa, no incluye datos reales, no contiene claves privadas y no depende de APIs externas.

## Funcionalidades

- Añadir películas y series.
- Editar título, año, género, tipo de contenido y plataforma.
- Marcar contenido como visto o pendiente.
- Valorar de 0 a 5 estrellas.
- Añadir notas personales.
- Buscar por título, género o plataforma.
- Filtrar por todo, visto y pendiente.
- Ver estadísticas rápidas de la biblioteca.
- Persistencia local usando `shared_preferences` y JSON.

## Tecnologías

- Flutter
- Dart
- Provider
- SharedPreferences
  
## Estructura

```txt
lib/
├── controllers/
│   └── film_library_controller.dart
├── models/
│   └── film_entry.dart
├── screens/
│   ├── editor_screen.dart
│   └── home_screen.dart
├── services/
│   └── film_storage_service.dart
├── widgets/
│   ├── film_card.dart
│   └── library_stats.dart
└── main.dart
```

## Instalación

```bash
git clone https://github.com/BugHunter096/cinelog-flutter.git
cd cinelog-flutter
flutter create --platforms=android,ios,web --org com.pelayoalonso .
flutter pub get
flutter run
```

## Mejoras futuras

- Ordenar por nota, fecha o año.
- Añadir portadas manualmente.
- Añadir integración opcional con una API pública de películas.
- Sincronización con Firebase.
- Exportar la biblioteca a CSV.
- Crear tests de controlador y persistencia.

## Licencia

Este proyecto está bajo licencia MIT. Consulta el archivo `LICENSE` para más detalles.
