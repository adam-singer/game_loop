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

/** Called when the timer fires. */
typedef GameLoopTimerFunction(GameLoopTimer timer);

/** A cancellable timer that calls a [GameLoopTimerFunction] when it fires.
 * A timer can only fire once, afterwards it is dead.
 */
class GameLoopTimer {
  /** Game loop timer was created by */
  final GameLoop gameLoop;
  /** Callback function that will be call when timer fires. */
  final GameLoopTimerFunction onTimer;
  double _timeToFireRemaining = 0.0;
  /** Time until timer fires. */
  double get timeToFire => _timeToFireRemaining;

  final double _timeToFire;
  bool _periodic;
  bool get periodic => _periodic;

  GameLoopTimer._internal(this.gameLoop, this._timeToFire, this.onTimer,
      {this._periodic: false}) {
    _timeToFireRemaining = _timeToFire;
  }
  void _update(double dt) {
    if (_isDead) {
      // Dead.
      return;
    }
    _timeToFireRemaining -= dt;
    if (_timeToFireRemaining <= 0.0) {
      if (onTimer != null) {
        onTimer(this);
      }
    }
  }

  bool get _isDead {
    bool expired = _timeToFireRemaining <= 0.0;
    if (expired && periodic) {
      _timeToFireRemaining = _timeToFire;
      return false;
    } if (expired) {
      return true;
    } else {
      return false;
    }
  }

  /** Cancel the timer. */
  void cancel() {
    _timeToFireRemaining = -1.0;
    _periodic = false;
  }
}
