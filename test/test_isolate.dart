
import 'dart:html';
import 'package:game_loop/game_loop_isolate.dart';

GameLoopIsolate gameLoop;

void update(GameLoopIsolate gameLoop) {
  if (gameLoop.gameTime < 0.0) {
    print("fail");
  }

  if (gameLoop.accumulatedTime < 0.0) {
    print("fail");
  }

  if (gameLoop.frame < 0) {
    print("fail");
  }

  if (gameLoop.frameTime < 0.0) {
    print("fail");
  }
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

void main() {
  gameLoop = new GameLoopIsolate();
  gameLoop.onUpdate = update;
  gameLoop.start();

  timer1 = gameLoop.addTimer(timerFired, 2.5);
  timer2 = gameLoop.addTimer(timerFired, 0.5);
  timer3 = gameLoop.addTimer(timerFired, 0.5, periodic: true);
}