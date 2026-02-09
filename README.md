# Random Image Viewer

Fetches a random image from the API, displays it as a square, and pulls colors from the image edges to create an animated gradient background.

## Demo

The video walks through fetching new images with smooth gradient transitions, error handling for corrupted or unavailable images, and the inline snackbar that appears when the device loses connectivity.

## Setup

```bash
flutter pub get
flutter run
```

## Architecture

Layered with Riverpod, feature-based structure. More detail in [`lib/docs/architecture.md`](lib/docs/architecture.md).

```
core → domain → data → application → presentation → features
```

## Notes

- Color extraction is done manually -- pixel sampling on a background isolate, dividing the image into 5 equal horizontal bands and averaging each to build a full-image gradient.
- Sealed exception types with exhaustive matching so error states can't fall through silently.
- Light/dark mode follows system preference.

## Tests

```bash
flutter test
```
