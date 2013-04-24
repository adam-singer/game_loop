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

/** The state of an analog input button */
class AnalogButton {
  /** The button id */
  final int buttonId;
  /** Value of analog button, between -1.0 and 1.0 */
  double value = 0.0;
  /** The frame when the button was last updated */
  int frame = 0;
  /** The time when the button was last updated */
  double time = 0.0;
  AnalogButton(this.buttonId);
}

/** A collection of analog input buttons */
class AnalogInput {
  final GameLoop gameLoop;
  final Map<int, AnalogButton> buttons =
      new Map<int, AnalogButton>();

  /** Create a digital input that supports all buttons in buttonIds. */
  AnalogInput(this.gameLoop, List<int> buttonIds) {
    for (int buttonId in buttonIds) {
      buttons[buttonId] = new AnalogButton(buttonId);
    }
  }

  /** The time the button was updated. */
  double timeUpdated(int buttonId) {
    AnalogButton button = buttons[buttonId];
    if (button == null) {
      return 0.0;
    }
    return button.time;
  }

  /** The frame the button was updated. */
  int frameUpdated(int buttonId) {
    AnalogButton button = buttons[buttonId];
    if (button == null) {
      return 0;
    }
    return button.frame;
  }

  /** The value of [buttonId]. */
  double value(int buttonId) {
    AnalogButton button = buttons[buttonId];
    if (button == null) {
      return 0.0;
    }
    return button.value;
  }
}