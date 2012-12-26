# game_loop #
==============

## Introduction ##

The Game Loop for Dart games.

## Features ##

* A
* B

## Why game_loop ? ##

1\. 
2\. 

## Getting Started ##

1\. Add the following to your project's **pubspec.yaml** and run ```pub install```.

```yaml
dependencies:
  game_loop:
    git: https://github.com/johnmccutchan/game_loop.git
```

2\. Add the correct import for your project. 

```dart
import 'package:game_loop/game_loop.dart';
```

# Documentation #

## API ##

[Reference Manual](http://www.dartgamedevs.org/packages/game_loop/game_loop.thml)

## Samples ##

1\. unit.html

## Examples ##

1\. Initialize a game loop:

```dart
main() {
  // Construct a game loop.
  GameLoop gameLoop = new GameLoop();
}
```

2\. Hook your update function in:

```dart
main() {
  // Construct a game loop.
  GameLoop gameLoop = new GameLoop();
  gameLoop.update = ((dt, time) {
    print('$time [dt = $dt].');
  });
}
```
