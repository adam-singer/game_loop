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

part of game_loop_common;

/** Called when it is time to draw. */
typedef void GameLoopRenderFunction(GameLoop gameLoop);

/** Called once per game logic frame. See [updateTimeStep] and
 * [maxAccumulatedTime] */
typedef void GameLoopUpdateFunction(GameLoop gameLoop);

/** The game loop */
abstract class GameLoop {
  /** The time step used for game updates. */
  double updateTimeStep = 0.015;

  /** Maximum amount of time between subsequent request animation frame
   * calls that is accumulated. Accumulated time is used to drive onUpdate
   * calls.
   */
  double maxAccumulatedTime = 0.03;
  double get _accumulatedTime;
  /** Seconds of accumulated time. */
  double get accumulatedTime => _accumulatedTime;

  /** Frame counter value. Incremented once per frame. */
  int get _frameCounter;
  int get frame => _frameCounter;
  /** Current time as seen by onUpdate calls. */
  double get gameTime => _gameTime;
  double _gameTime = 0.0;
  /** Seconds between requestAnimationFrameTime calls. */
  double get _frameTime;
  double get frameTime => _frameTime;
  /** Time elapsed in current frame. */
  double get dt => updateTimeStep;
  double _renderInterpolationFactor = 0.0;
  /** Interpolation value between 0.0 and 1.0 */
  double get renderInterpolationFactor => _renderInterpolationFactor;
  /** The minimum amount of time between two onResize calls in seconds*/
  double resizeLimit = 0.05;
  static double timeStampToSeconds(timeStamp) => timeStamp / 1000.0;
  static double milliseconds(int x) => x / 1000.0;
  static double seconds(int x) => x.toDouble();
  static double minutes(int x) => x.toDouble() * 60.0;

  /** Current time. */
  double get time => timeStampToSeconds(new DateTime.now().millisecondsSinceEpoch);

  /** Construct a new game loop */
  GameLoop() {
  }

  void processTimers() {
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

  /** Start the game loop. */
  void start();

  /** Stop the game loop. */
  void stop();

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
  /** Called when it is time to draw. */
  GameLoopRenderFunction onRender;
}