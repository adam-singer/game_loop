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

part of game_loop_io;

/** The game loop */
class GameLoopIo extends GameLoop {
  bool _initialized = false;
  bool _interrupt = false;
  double _interruptTime = 0.0;
  int _frameCounter = 0;
  double _previousFrameTime;
  double _frameTime = 0.0;
  double _nextResize = 0.0;

  double _accumulatedTime = 0.0;
  double _gameTime = 0.0;

  static double timeStampToSeconds(timeStamp) => timeStamp / 1000.0;
  static double milliseconds(int x) => x / 1000.0;
  static double seconds(int x) => x.toDouble();
  static double minutes(int x) => x.toDouble() * 60.0;

  /** Current time. */
  double get time => timeStampToSeconds(_watch.elapsedMicroseconds / 1000.0);
  Stopwatch _watch;
  Duration _duration;

  /** Construct a new game loop attaching it to [element] */
  GameLoopIo() : super() {
    _watch = new Stopwatch();
    _duration = new Duration(milliseconds: (updateTimeStep*1000.0).toInt());
  }

  void _processInputEvents() {
  }

  void _processTimers() {
    int _timersLength = _timers.length;
    for (int i = 0; i < _timersLength; i++) {
      _timers[i]._update(dt);
    }
    for (int i = _timers.length-1; i >= 0; i--) {
      int lastElement = _timers.length-1;
      if (_timers[i]._dead) {
        if (i != lastElement) {
          // Swap into i's place.
          _timers[i] = _timers[lastElement];
        }
        _timers.removeLast();
      }
    }
  }

  double _timeLost = 0.0;
  void _update() {
    //print(time);
    if (_previousFrameTime == null) {
      _frameTime = time;
      _previousFrameTime = _frameTime;
      _processInputEvents();
      new Timer(_duration, _update);
      //window.requestAnimationFrame(_requestAnimationFrame);
      return;
    }
    if (_interrupt == true) {
      _interruptTime = time;
      return;
    }

    _frameCounter++;
    _previousFrameTime = _frameTime;
    _frameTime = time;
    double timeDelta = _frameTime - _previousFrameTime;
    _accumulatedTime += timeDelta;
    if (_accumulatedTime > maxAccumulatedTime) {
      // If the animation frame callback was paused we may end up with
      // a huge time delta. Clamp it to something reasonable.
      _timeLost += _accumulatedTime-maxAccumulatedTime;
      _accumulatedTime = maxAccumulatedTime;
    }

    while (_accumulatedTime >= updateTimeStep) {
      _gameTime += updateTimeStep;
      //_processInputEvents();
      _processTimers();

      if (onUpdate != null) {
        onUpdate(this);
      }
      _accumulatedTime -= updateTimeStep;

    }
    new Timer(_duration, _update);
  }

  /** Start the game loop. */
  void start() {
    _watch.start();
    Timer.run(_update);

  }
  /** Stop the game loop. */
  void stop() {
    _watch.stop();
  }

  final List<GameLoopTimer> _timers = new List<GameLoopTimer>();

  /** Add a new timer which calls [callback] in [delay] seconds. */
  GameLoopTimer addTimer(GameLoopTimerFunction callback, double delay) {
    var timer = new GameLoopTimer._internal(this, delay, callback);
    _timers.add(timer);
    return timer;
  }

  /** Clear all existing timers. */
  void clearTimers() {
    _timers.clear();
  }

  /** Called once per game logic frame. */
  GameLoopUpdateFunction onUpdate;

}

