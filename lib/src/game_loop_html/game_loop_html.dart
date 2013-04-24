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

/** Called when it is time to draw. */
typedef void GameLoopRenderFunction(GameLoop gameLoop);

/** Called whenever the element is resized. */
typedef void GameLoopResizeFunction(GameLoop gameLoop);

/** Called whenever the element moves between fullscreen and non-fullscreen
 * mode.
 */
typedef void GameLoopFullscreenChangeFunction(GameLoop gameLoop);

/** Called whenever the element moves between locking the pointer and
 * not locking the pointer.
 */
typedef void GameLoopPointerLockChangeFunction(GameLoop gameLoop);

/** Called whenever a touch event begins */
typedef void GameLoopTouchEventFunction(GameLoop gameLoop, GameLoopTouch touch);

/** The game loop */
class GameLoopHtml extends GameLoop {
  final Element element;
  int _frameCounter = 0;
  bool _initialized = false;
  bool _interrupt = false;
  double _previousFrameTime;
  double _frameTime = 0.0;
  double get frameTime => _frameTime;
  bool _resizePending = false;
  double _nextResize = 0.0;

  /** Seconds of accumulated time. */
  double get accumulatedTime => _accumulatedTime;

  /** Frame counter value. Incremented once per frame. */
  int get frame => _frameCounter;

  double maxAccumulatedTime = 0.03;
  double _accumulatedTime = 0.0;
  /** Width of game display [Element] */
  int get width => element.client.width;
  /** Height of game display [Element] */
  int get height => element.client.height;

  double _gameTime = 0.0;
  double get gameTime => _gameTime;

  double _renderInterpolationFactor = 0.0;
  double get renderInterpolationFactor => _renderInterpolationFactor;
  /** The minimum amount of time between two onResize calls in seconds*/
  double resizeLimit = 0.05;

  PointerLock _pointerLock;
  PointerLock get pointerLock => _pointerLock;

  Keyboard _keyboard;
  /** Keyboard. */
  Keyboard get keyboard => _keyboard;
  Mouse _mouse;
  /** Mouse. */
  Mouse get mouse => _mouse;
  GameLoopGamepad _gamepad0;
  /** Gamepad #0. */
  GameLoopGamepad get gamepad0 => _gamepad0;
  /** Touch */
  GameLoopTouchSet _touchSet;
  GameLoopTouchSet get touchSet => _touchSet;

  /** Construct a new game loop attaching it to [element] */
  GameLoopHtml(this.element) : super() {
    _keyboard = new Keyboard(this);
    _mouse = new Mouse(this);
    _gamepad0 = new GameLoopGamepad(this);
    _pointerLock = new PointerLock(this);
    _touchSet = new GameLoopTouchSet(this);
  }

  void _processInputEvents() {
    for (KeyboardEvent keyboardEvent in _keyboardEvents) {
      DigitalButtonEvent event;
      bool down = keyboardEvent.type == "keydown";
      double time = GameLoop.timeStampToSeconds(keyboardEvent.timeStamp);
      int buttonId = keyboardEvent.keyCode;
      event = new DigitalButtonEvent(buttonId, down, frame, time);
      _keyboard.digitalButtonEvent(event);
    }
    _keyboardEvents.clear();
    mouse._resetAccumulators();
    int canvasX = element.offset.left;
    int canvasY = element.offset.top;
    for (MouseEvent mouseEvent in _mouseEvents) {
      bool moveEvent = mouseEvent.type == 'mousemove';
      bool wheelEvent = mouseEvent.type == 'mousewheel';
      bool down = mouseEvent.type == 'mousedown';
      double time = GameLoop.timeStampToSeconds(mouseEvent.timeStamp);
      if (moveEvent) {
        int mouseX = mouseEvent.page.x;
        int mouseY = mouseEvent.page.y;
        int x = mouseX - canvasX;
        int y = mouseY - canvasY;
        int clampX = 0;
        int clampY = 0;
        bool withinCanvas = false;
        if(mouseX < canvasX) {
          clampX = 0;
        } else if(mouseX > canvasX+width) {
          clampX = width;
        } else {
          clampX = x;
          withinCanvas = true;
        }
        if(mouseY < canvasY) {
          clampY = 0;
          withinCanvas = false;
        } else if(mouseY > canvasY+height) {
          clampY = height;
          withinCanvas = false;
        } else {
          clampY = y;
        }

        int dx = mouseEvent.movement.x;
        int dy = mouseEvent.movement.y;
        var event = new GameLoopMouseEvent(x, y, dx, dy, clampX, clampY, withinCanvas, time, frame);
        _mouse.gameLoopMouseEvent(event);
      } else if (wheelEvent) {
        WheelEvent wheel = mouseEvent as WheelEvent;
        _mouse._accumulateWheel(wheel.deltaX, wheel.deltaY);
      } else {
        int buttonId = mouseEvent.button;
        var event = new DigitalButtonEvent(buttonId, down, frame, time);
        _mouse.digitalButtonEvent(event);
      }
    }
    _mouseEvents.clear();
    for (_GameLoopTouchEvent touchEvent in _touchEvents) {
      switch (touchEvent.type) {
        case _GameLoopTouchEvent.Start:
          _touchSet._start(touchEvent.event);
          break;
        case _GameLoopTouchEvent.End:
          _touchSet._end(touchEvent.event);
          break;
        case _GameLoopTouchEvent.Move:
          _touchSet._move(touchEvent.event);
          break;
        default:
          throw new StateError('Invalid _GameLoopTouchEven type.');
      }
    }
    _touchEvents.clear();
  }

  void _requestAnimationFrame(num _) {
    if (_previousFrameTime == null) {
      _frameTime = time;
      _previousFrameTime = _frameTime;
      _processInputEvents();
      window.requestAnimationFrame(_requestAnimationFrame);
      return;
    }
    if (_interrupt == true) {
      return;
    }
    window.requestAnimationFrame(_requestAnimationFrame);
    _frameCounter++;
    _previousFrameTime = _frameTime;
    _frameTime = time;
    double timeDelta = _frameTime - _previousFrameTime;
    _accumulatedTime += timeDelta;
    if (_accumulatedTime > maxAccumulatedTime) {
      // If the animation frame callback was paused we may end up with
      // a huge time delta. Clamp it to something reasonable.
      _accumulatedTime = maxAccumulatedTime;
    }
    // TODO(johnmccutchan): Process input events in update loop.
    _processInputEvents();
    while (_accumulatedTime >= updateTimeStep) {
      processTimers();
      _gameTime += updateTimeStep;
      if (onUpdate != null) {
        onUpdate(this);
      }
      _accumulatedTime -= updateTimeStep;
    }
    if(_resizePending == true && onResize != null && _nextResize <= _frameTime){
      onResize(this);
      _nextResize = _frameTime + resizeLimit;
      _resizePending = false;
    }

    if (onRender != null) {
      _renderInterpolationFactor = _accumulatedTime/updateTimeStep;
      onRender(this);
    }
  }

  void _fullscreenChange(Event _) {
    if (onFullscreenChange == null) {
      return;
    }
    onFullscreenChange(this);
  }

  void _fullscreenError(Event _) {
    if (onFullscreenChange == null) {
      return;
    }
    onFullscreenChange(this);
  }

  final List<_GameLoopTouchEvent> _touchEvents = new List<_GameLoopTouchEvent>();
  void _touchStartEvent(TouchEvent event) {
    _touchEvents.add(new _GameLoopTouchEvent(event, _GameLoopTouchEvent.Start));
  }
  void _touchMoveEvent(TouchEvent event) {
    _touchEvents.add(new _GameLoopTouchEvent(event, _GameLoopTouchEvent.Move));
  }
  void _touchEndEvent(TouchEvent event) {
    _touchEvents.add(new _GameLoopTouchEvent(event, _GameLoopTouchEvent.End));
  }

  final List<KeyboardEvent> _keyboardEvents = new List<KeyboardEvent>();
  void _keyDown(KeyboardEvent event) {
    _keyboardEvents.add(event);
  }

  void _keyUp(KeyboardEvent event) {
    _keyboardEvents.add(event);
  }

  final List<MouseEvent> _mouseEvents = new List<MouseEvent>();
  void _mouseDown(MouseEvent event) {
    _mouseEvents.add(event);
  }

  void _mouseUp(MouseEvent event) {
    _mouseEvents.add(event);
  }

  void _mouseMove(MouseEvent event) {
    _mouseEvents.add(event);
  }

  void _mouseWheel(MouseEvent event) {
    _mouseEvents.add(event);
    event.preventDefault();
  }

  void _resize(Event _) {
    if (_resizePending == false) {
      _resizePending = true;
    }
  }

  /** Start the game loop. */
  void start() {
    if (_initialized == false) {
      document.onFullscreenError.listen(_fullscreenError);
      document.onFullscreenChange.listen(_fullscreenChange);
      window.onTouchStart.listen(_touchStartEvent);
      window.onTouchEnd.listen(_touchEndEvent);
      window.onTouchMove.listen(_touchMoveEvent);
      window.onKeyDown.listen(_keyDown);
      window.onKeyUp.listen(_keyUp);
      window.onResize.listen(_resize);

      window.onMouseMove.listen(_mouseMove);
      window.onMouseDown.listen(_mouseDown);
      window.onMouseUp.listen(_mouseUp);
      window.onMouseWheel.listen(_mouseWheel);
      _initialized = true;
    }
    _interrupt = false;
    window.requestAnimationFrame(_requestAnimationFrame);
  }

  /** Stop the game loop. */
  void stop() {
    _interrupt = true;
  }

  /** Is the element visible on the screen? */
  bool get isVisible => document.visibilityState == 'visible' && element.hidden == false;

  /** Is the element being displayed full screen? */
  bool get isFullscreen => document.fullscreenElement == element;

  /** Enable or disable fullscreen display of the element. */
  void enableFullscreen(bool enable) {
    if (enable) {
      element.requestFullscreen();
      return;
    }
    document.exitFullscreen();
  }

  /** Called when it is time to draw. */
  GameLoopRenderFunction onRender;

  /** Called when element is resized. */
  GameLoopResizeFunction onResize;
  /** Called when element enters or exits fullscreen mode. */
  GameLoopFullscreenChangeFunction onFullscreenChange;
  /** Called when the element moves between owning and not
   *  owning the pointer.
   */
  GameLoopPointerLockChangeFunction onPointerLockChange;
  /** Called when a touch begins. */
  GameLoopTouchEventFunction onTouchStart;
  /** Callled when a touch ends. */
  GameLoopTouchEventFunction onTouchEnd;
}