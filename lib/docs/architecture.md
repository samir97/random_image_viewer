# Architecture

Layered, feature-based structure using Riverpod. Overkill for one screen, but the point is to show how I'd lay the groundwork for a real app.

## Folder Structure

```
lib/
├── main.dart
│
├── core/                       # Shared infrastructure, no business logic
│   ├── constants/              # API base URL, endpoint paths
│   ├── exceptions/             # Sealed exception types + error mapper
│   ├── utils/                  # Color extraction (pixel sampling on isolate)
│   └── network/                # Dio setup with timeouts
│
├── domain/                     # Pure Dart, no Flutter imports
│   ├── entities/               # RandomImage
│   └── repositories/           # Abstract ImageRepository
│
├── data/                       # Talks to the outside world
│   ├── models/                 # DTO with fromJson/toDomain
│   └── repositories/           # Implements ImageRepository, translates errors
│
├── application/                # Riverpod providers wiring domain to data
│
├── presentation/               # Shared widgets and theme config
│   ├── theme/                  # Light/dark ThemeData, default colors
│   └── widgets/                # Gradient background, full-screen error
│
└── features/home/              # Everything for the home screen
    ├── models/                 # HomeState (image + colors + loading flag)
    ├── providers/              # AsyncNotifier that fetches + extracts colors
    ├── pages/                  # HomePage
    └── widgets/                # ImageCard, AnotherButton
```

## Dependency Flow

```
        features/home/
              │
     ┌────────┴────────┐
     ▼                  ▼
presentation/     application/
                        │
               ┌────────┴────────┐
               ▼                 ▼
           domain/    ◄───    data/
               │                 │
               └────────┬────────┘
                        ▼
                      core/
```

Arrows only point down. Features don't import other features. Data implements domain interfaces but domain never imports data.

## How Errors Work

Repository catches raw exceptions (DioException, FormatException, etc.) and passes them through `AppExceptionHandler`, which maps them to sealed `AppException` subtypes:

```dart
sealed class AppException implements Exception { ... }
class NetworkException extends AppException { ... }
class ServerException extends AppException { ... }
class UnknownException extends AppException { ... }
```

UI widgets pattern-match on the type to pick icons and messages. Sealed class means the compiler catches any unhandled case.

## Testing

| Layer       | What's tested              | What's mocked              |
| ----------- | -------------------------- | -------------------------- |
| `core/`     | Exception mapping, color extraction | Nothing - pure functions |
| `data/`     | DTO parsing, repo error handling | Dio                     |
| `features/` | Notifier state transitions, widget rendering | Repository (provider override) |

## Why These Packages

- **flutter_riverpod** - state management + DI. Provider overrides make testing easy without a service locator.
- **dio** - HTTP client. Typed error handling maps cleanly to the sealed exception hierarchy.
- **cached_network_image** - handles caching, fade-in, and placeholder/error states for remote images.