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

part of game_loop_isolate;

/** The game loop */
class GameLoopIsolate extends GameLoop {
  bool _initialized = false;
  bool _interrupt = false;
  int _frameCounter = 0;
  double _previousFrameTime;
  double _frameTime = 0.0;
  double get frameTime => _frameTime;
  double _nextResize = 0.0;

  double _accumulatedTime = 0.0;
  /** Seconds of accumulated time. */
  double get accumulatedTime => _accumulatedTime;

  /** Frame counter value. Incremented once per frame. */
  int get frame => _frameCounter;

  double _gameTime = 0.0;
  double get gameTime => _gameTime;

  /** Current time. */
  double get time => GameLoop.timeStampToSeconds(_watch.elapsedMicroseconds / 1000.0);
  Stopwatch _watch;
  Duration _duration;

  /** Construct a new game loop */
  GameLoopIsolate() : super() {
    _watch = new Stopwatch();
    _duration = new Duration(milliseconds: (updateTimeStep*1000.0).toInt());
  }

  void _processInputEvents() {
  }

  double _timeLost = 0.0;
  void _update() {
    if (_previousFrameTime == null) {
      _frameTime = time;
      _previousFrameTime = _frameTime;
      _processInputEvents();
      new Timer(_duration, _update);
      return;
    }
    if (_interrupt == true) {
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
      processTimers();
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
}