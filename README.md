# game_loop #
==============

## Introduction ##

Games require a main loop to drive the game forward. This main loop is primarily responsible
for three things: first, processing inputs from keyboards, mice, gamepads, and time. 
Secondly, managing pointer lock and fullscreen state. The final main loop responsibility,
is running the game specific update and rendering code. The `game_loop` library
provides a main loop for games with a powerful input subsystem.

If you are familiar with GLUT, game_loop provides that and more.

## Features ##

* Main loop optimized for games.
* Keyboard input.
* Mouse input.
* Fullscreen management.
* Pointer lock management.
* Timers.

## Why game_loop ? ##

1\. Focus on your game not on the browser platform. A perfect main loop requires code
which properly combines input, display, and state management. Writing
this code is tedious, error prone, and ultimately, a waste of time.

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

1\. test.html

## Examples ##

1\. Initialize a game loop:

```dart
main() {
  // Construct a game loop.
  GameLoop gameLoop = new GameLoop();
}
```

2\. Hook your game update function up:

```dart
main() {
  // Construct a game loop.
  GameLoop gameLoop = new GameLoop();
  gameLoop.onUpdate = ((gameLoop) {
    print('${gameLoop.frame}: ${gameLoop.frameTime} [dt = ${gameLoop.dt}].');
  });
}
```
