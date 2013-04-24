/*
  Copyright (C) 2013 John McCutchan <john@johnmccutchan.com>

  This software is provided 'as-is', without any express or implied
  warranty.  In no event will the authors be held liable for any damages
  arising from the use of this software.

  Permission is granted to anyone to use this software for any purpose,
  including commercial applications, and to alter it and redistribute it
  freely, subject to the following restrictions:

  1. The origin of this software must not be misrepresented; you must not
     claim that you wrote the original software. If you use this software
     in a product, an acknowledgment in the product documentation would be
     appreciated but is not required.
  2. Altered source versions must be plainly marked as such, and must not be
     misrepresented as being the original software.
  3. This notice may not be removed or altered from any source distribution.
*/

import 'dart:html';
import 'package:game_loop/game_loop_html.dart';

GameLoopHtml gameLoop;

void update(GameLoopHtml gameLoop) {
  bool mouseDown = gameLoop.mouse.isDown(Mouse.LEFT);
  if (mouseDown) {
    print('left down.');
  }
  bool down = gameLoop.keyboard.isDown(Keyboard.D);
  double timePressed = gameLoop.keyboard.timePressed(Keyboard.D);
  double timeReleased = gameLoop.keyboard.timeReleased(Keyboard.D);
  if (gameLoop.keyboard.released(Keyboard.D)) {
    print('D down: $down $timePressed $timeReleased');
    //gameLoop.enableFullscreen(true);
  }
  if (gameLoop.mouse.wheelDy != 0) {
    print('wheel: ${gameLoop.mouse.wheelDx} ${gameLoop.mouse.wheelDy}');
  }
  return;
  print('frame: ${gameLoop.frame}');
  print('gameTime: ${gameLoop.gameTime}');
  print('time: ${gameLoop.time}');
  print('dt: ${gameLoop.dt}');
}

void render(GameLoopHtml gameLoop) {
  //print('Interpolation factor: ${gameLoop.renderInterpolationFactor}');

  context.fillStyle = "rgb(160,160,160)";
  context.fillRect( 0 , 0 , context.canvas.width , context.canvas.height );
  context.fillStyle = "rgb(255,0,0)";
  int posX = gameLoop.mouse.clampX == context.canvas.width ? gameLoop.mouse.clampX-1 : gameLoop.mouse.clampX;
  int posY = gameLoop.mouse.clampY == context.canvas.height ? gameLoop.mouse.clampY-1 : gameLoop.mouse.clampY;
  context.fillRect(posX,posY,1,1);
}

GameLoopTimer timer1;
GameLoopTimer timer2;
GameLoopTimer timer3;
int periodicCount = 0;
void timerFired(GameLoopTimer timer) {
  if (timer == timer1) {
    print('timer1 fired.');
  } else if (timer == timer2) {
    print('timer2 fired.');
  } else if (timer == timer3) {
    print('timer3 fired. ${periodicCount++}');
    if (periodicCount == 3) {
      timer3.cancel();
    }
  }
}

final String canvasID = '#gameElement';
CanvasRenderingContext2D context;

void main() {
  CanvasElement canvas = query(canvasID);
  context = canvas.context2d;

  gameLoop = new GameLoopHtml(canvas);
  gameLoop.onUpdate = update;
  gameLoop.onRender = render;
  gameLoop.start();
  timer1 = gameLoop.addTimer(timerFired, 2.5);
  timer2 = gameLoop.addTimer(timerFired, 0.5);
  timer3 = gameLoop.addTimer(timerFired, 0.5, periodic: true);
}