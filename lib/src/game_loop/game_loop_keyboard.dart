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

/** A keyboard input. Has digital buttons corresponding to keyboard keys.
 */
class GameLoopKeyboard extends GameLoopDigitalInput {
  static const A = KeyCode.A;
  static const B = KeyCode.B;
  static const C = KeyCode.C;
  static const D = KeyCode.D;
  static const E = KeyCode.E;
  static const F = KeyCode.F;
  static const G = KeyCode.G;
  static const H = KeyCode.H;
  static const I = KeyCode.I;
  static const J = KeyCode.J;
  static const K = KeyCode.K;
  static const L = KeyCode.L;
  static const M = KeyCode.M;
  static const N = KeyCode.N;
  static const O = KeyCode.O;
  static const P = KeyCode.P;
  static const Q = KeyCode.Q;
  static const R = KeyCode.R;
  static const S = KeyCode.S;
  static const T = KeyCode.T;
  static const U = KeyCode.U;
  static const V = KeyCode.V;
  static const W = KeyCode.W;
  static const X = KeyCode.X;
  static const Y = KeyCode.Y;
  static const Z = KeyCode.Z;
  static const SHIFT = KeyCode.SHIFT;
  static const CTRL = KeyCode.CTRL;
  static const ALT = KeyCode.ALT;
  static const SPACE = KeyCode.SPACE;
  static const ZERO = KeyCode.ZERO;
  static const ONE = KeyCode.ONE;
  static const TWO = KeyCode.TWO;
  static const THREE = KeyCode.THREE;
  static const FOUR = KeyCode.FOUR;
  static const FIVE = KeyCode.FIVE;
  static const SIX = KeyCode.SIX;
  static const SEVEN = KeyCode.SEVEN;
  static const EIGHT = KeyCode.EIGHT;
  static const NINE = KeyCode.NINE;
  static const TILDE = KeyCode.TILDE;
  static const ENTER = KeyCode.ENTER;
  static const UP = KeyCode.UP;
  static const DOWN = KeyCode.DOWN;
  static const LEFT = KeyCode.LEFT;
  static const RIGHT = KeyCode.RIGHT;
  static final List<int> _buttonIds = [A, B, C,
                               D, E, F,
                               G, H, I,
                               J, K, L,
                               M, N, O,
                               P, Q, R,
                               S, T, U,
                               V, W, X,
                               Y, Z,
                               SHIFT,
                               CTRL,
                               ALT,
                               SPACE,
                               ZERO,
                               ONE,
                               TWO,
                               THREE,
                               FOUR,
                               FIVE,
                               SIX,
                               SEVEN,
                               EIGHT,
                               NINE,
                               TILDE,
                               ENTER,
                               UP,
                               DOWN,
                               LEFT,
                               RIGHT
                               ];

  GameLoopKeyboard(gameLoop) : super(gameLoop, _buttonIds);
}