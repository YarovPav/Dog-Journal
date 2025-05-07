# Dog Journal (lite)

Небольшое Flutter‑приложение для локального ведения дневника заметок о собаке.

## Возможности
* Создание заметки с заголовком, комментарием и фотографией из галереи
* Хранение данных локально в Hive
* Просмотр списка всех заметок (заголовок + превью фото)

## Запуск

```bash
flutter pub get
flutter run
```

*Для генерации адаптеров Hive сборщик не требуется — `dog_note.g.dart` создан вручную.*

## Архитектура
* **State management**: `flutter_bloc` (Cubit)
* **Local storage**: `hive / hive_flutter`
* **Изображения**: `image_picker` + сохранение копии в `ApplicationDocumentsDirectory`
