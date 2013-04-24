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

part of game_loop_html;

class GameLoopMouseEvent {
  final int x;
  final int y;
  final int dx;
  final int dy;
  final int clampX;
  final int clampY;
  final double time;
  final bool withinCanvas;
  final int frame;
  GameLoopMouseEvent(this.x, this.y, this.dx, this.dy, this.clampX, this.clampY, this.withinCanvas, this.time, this.frame);
}

/** A mouse input. Has digital buttons corresponding to mouse buttons:
 * [LEFT], [MIDDLE], [RIGHT]. Also implements the [GameLoopPositionInput]
 * interface.
 */
class Mouse extends DigitalInput implements PositionInput {
  /** Left mouse button */
  static const LEFT = 0;
  /** Middle mouse button */
  static const MIDDLE = 1;
  /** Right mouse button */
  static const RIGHT = 2;
  static final List<int> _buttonIds = [LEFT, MIDDLE, RIGHT];

  int _dx = 0;
  /** Mouse movement in x direction since previous frame. */
  int get dx => _dx;

  int _dy = 0;
  /** Mouse movement in y direction since previous frame. */
  int get dy => _dy;

  int _x = 0;
  /** Mouse position in x direction relative to element. */
  int get x => _x;

  int _y = 0;
  /** Mouse position in y direction relative to element. */
  int get y => _y;

  int _clampX = 0;
  /** Mouse position in x direction within element. */
  int get clampX => _clampX;

  int _clampY = 0;
  /** Mouse position in y direction within element. */
  int get clampY => _clampY;

  int _wheelDx = 0;
  /** Mouse wheel movement in x direction since previous frame. */
  int get wheelDx => _wheelDx;

  int _wheelDy = 0;
  /** Mouse wheel movement in y direction since previous frame. */
  int get wheelDy => _wheelDy;

  bool _withinCanvas = false;
  /** Tells if Mouse is within element. */
  bool get withinCanvas => _withinCanvas;

  double _time = 0.0;
  /** Time at which mouse position was last updated. */
  double get time => _time;

  int _frame  = 0;
  /** Frame at which mouse position was last updated. */
  int get frame => _frame;

  Mouse(gameLoop) : super(gameLoop, _buttonIds);

  /** Process one [GameLoopMouseEvent]. */
  void gameLoopMouseEvent(GameLoopMouseEvent event) {
    _x = event.x;
    _y = event.y;
    _time = event.time;
    _frame = event.frame;
    _dx += event.dx;
    _dy += event.dy;
    _clampX = event.clampX;
    _clampY = event.clampY;
    _withinCanvas = event.withinCanvas;
  }

  void _accumulateWheel(int dx, int dy) {
    _wheelDx += dx;
    _wheelDy += dy;
  }

  void _resetAccumulators() {
    _wheelDx = 0;
    _wheelDy = 0;
    _dx = 0;
    _dy = 0;
  }
}
