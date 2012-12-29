/*
  Copyright (C) 2012 John McCutchan <john@johnmccutchan.com>

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

part of game_loop;

class GameLoopMouseEvent {
  final int x;
  final int y;
  final int dx;
  final int dy;
  final double time;
  final int frame;
  GameLoopMouseEvent(this.x, this.y, this.dx, this.dy, this.time, this.frame);
}

/** A mouse input. Has digital buttons corresponding to mouse buttons:
 * [LEFT], [MIDDLE], [RIGHT]. Also implements the [GameLoopPositionInput]
 * interface.
 */
class GameLoopMouse extends GameLoopDigitalInput implements GameLoopPositionInput {
  static const LEFT = 0;
  static const MIDDLE = 1;
  static const RIGHT = 2;
  static final List<int> buttonIds = [LEFT, MIDDLE, RIGHT];

  /** Mouse movement in x direction since previous frame. */
  int _dx = 0;
  int get dx => _dx;
  /** Mouse movement in y direction since previous frame. */
  int _dy = 0;
  int get dy => _dy;

  /** Mouse position in x direction within element. */
  int _x = 0;
  int get x => _x;
  /** Mouse position in y direction within element. */
  int _y = 0;
  int get y => _y;

  /** Time at which mouse position was last updated. */
  double _time = 0.0;
  double get time => _time;

  /** Frame at which mouse position was last updated. */
  int _frame  = 0;
  int get frame => _frame;

  GameLoopMouse(gameLoop) : super(gameLoop, buttonIds);

  void gameLoopMouseEvent(GameLoopMouseEvent event) {
    _x = event.x;
    _y = event.y;
    _time = event.time;
    _frame = event.frame;
    _dx += event.dx;
    _dy += event.dy;
  }

  void _resetAccumulators() {
    _dx = 0;
    _dy = 0;
  }
}
