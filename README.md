# game_loop #
==============

## Introduction ##

All games require a main loop to drive the game forward. This main loop is responsible for
processing inputs from keyboards, mice, gamepads, and time. Also, the main loop
manages browser state, e.g., pointer lock and fullscreen. Finally, the main loop
calls the game specific update routine. The `game_loop` library
provides a main loop designed for games along with a powerful input subsystem.

If you are familiar with GLUT, game_loop provides that and more.

## Features ##

* Main loop optimized for games.
* Keyboard input.
* Mouse input.
* Fullscreen management.
* Pointer lock management.
* Timers.

## Why game_loop ? ##

1\. Focus on your game not on the browser platform. A perfect main loop requires
code which properly combines input, time, display, and state management. Writing
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

[Reference Manual](http://www.dartgamedevs.org/packages/game_loop/game_loop.html)

## Samples ##

1\. test.html

## Examples ##

1\. Initialize a game loop:

```dart
main() {
  // Construct a game loop.
  GameLoop gameLoop = new GameLoop(canvasElement);
}
```

2\. Hook your game update function up and start the main loop:

```dart
main() {
  // Construct a game loop.
  GameLoop gameLoop = new GameLoop(canvasElement);
  gameLoop.onUpdate = ((gameLoop) {
    // Update game logic here.
    print('${gameLoop.frame}: ${gameLoop.gameTime} [dt = ${gameLoop.dt}].');
  });
  gameLoop.start();
}
```

3\. Hook your game render function up and start drawing:

```dart
main() {
  // Construct a game loop.
  GameLoop gameLoop = new GameLoop(canvasElement);
  gameLoop.onUpdate = ((gameLoop) {
    // Update game logic here.
    print('${gameLoop.frame}: ${gameLoop.gameTime} [dt = ${gameLoop.dt}].');
  });
  gameLoop.onRender = ((gameLoop) {
    // Draw game into canvasElement using WebGL or CanvasRenderingContext here.
    // The interpolation factor can be used to draw correct inter-frame
  	print('Interpolation factor: ${gameLoop.renderInterpolationFactor}');
  });
  gameLoop.start();
}
```

3\. Add a timer to your game loop:

```dart
main() {
  // Construct a game loop.
  GameLoop gameLoop = new GameLoop(canvasElement);
  gameLoop.onUpdate = ((gameLoop) {
    print('${gameLoop.frame}: ${gameLoop.frameTime} [dt = ${gameLoop.dt}].');
  });
  gameLoop.start();
  // Add a timer which fires in half a second.
  var timer = gameLoop.addTimer((timer) => print('timer fired.', 0.5);
}
```
