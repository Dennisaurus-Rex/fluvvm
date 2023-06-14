# Changelog

## Version 1.0.0

Initial release

## Version 1.0.1

Updated desciption in pubspec.yaml

## Version 1.0.2

Added more documentation

## Version 2.0.0 __BREAKING CHANGES__

* Renamed `Intent` to `FluvvmIntent` and `State` to `FluvvmState` to mitigate name collisions with `flutter/material.dart` library.

* Added a `network_request_example.dart` that shows how to use the `NetworkRequest` class.

* Added more documentation to `README.md` and `NetworkRequest` class.

## Version 2.0.1

Updated README.md to reflect changes in version 2.0.0 that got lost in translation. 🤦

## Version 2.0.2

Made `NetworkRequestError` accessible by importing `fluvvm/fluvvm.dart`.

## Version 2.0.3

Corrected a stupid spelling mistake on a pretty important class... 🤫

## Version 2.1.0

* Added `fireAndMap` method to `NetworkRequest` class.
* Updated to Dart 3

## Version 2.2.0

* Added `initialState` property to `Viewmodel` class
* Updated documentation with the new [Dart 3 Switch expressions](https://dart.dev/language/branches#switch-expressions)

## Version 2.2.1

* Removed `initialState` property from `Viewmodel` class
* Added `onBound` method to `Viewmodel` class
* Added `onUnbind` method to `Viewmodel` class

## Version 2.3.0

* Added `keepAlive` to `NotifiedWidget` class

## Version 2.3.1

* Updated dependencies
