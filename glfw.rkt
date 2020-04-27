#lang racket

(require ffi/unsafe
         ffi/unsafe/define)
(require opengl
         opengl/util)

(define-ffi-definer define-glfw (ffi-lib "glfw3"))
;(define-ffi-definer define-glfw (ffi-lib "C:/ActualLibraries/opengl/glfw/lib-vc2015/glfw3"))

(define _GLFWwindow-pointer (_cpointer 'GLFWwindow))
(define _GLFWmonitor-pointer (_cpointer 'GLFWmonitor))

(define-glfw glfwInit (_fun -> _int))
(define-glfw glfwWindowHint(_fun _int _int -> _void))
(define-glfw glfwCreateWindow(_fun _int _int _string (_or-null _GLFWmonitor-pointer)
                                   (_or-null _GLFWwindow-pointer) -> _GLFWwindow-pointer))
(define-glfw glfwMakeContextCurrent(_fun _GLFWwindow-pointer -> _void))
(define-glfw glfwSwapInterval(_fun _int -> _void))
(define-glfw glfwSwapBuffers(_fun _GLFWwindow-pointer -> _void))
(define-glfw glfwWindowShouldClose(_fun _GLFWwindow-pointer -> _int))

(define _glfw-version
  (_enum '(glfw-version-major = 3
           glfw-version-minor = 2
           glfw-version-revision = 0)
         _int))
(define _glfw-boolean
  (_enum '(glfw-true = 1
           glfw-false = 0)
         _int))
(define _glfw-key-press
  (_enum '(glfw-release = 0
           glfw-press
           glfw-repeat)
         _int))
(define _glfw-key
  (_enum '(glfw-key-unknown = -1
           glfw-key-space = 32
           glfw-key-apostrophe = 39
           glfw-key-comma = 44
           glfw-key-minus
           glfw-key-period
           glfw-key-slash
           glfw-key-0
           glfw-key-1
           glfw-key-2
           glfw-key-3
           glfw-key-4
           glfw-key-5
           glfw-key-6
           glfw-key-7
           glfw-key-8
           glfw-key-9
           glfw-key-semicolon = 59
           glfw-key-equal = 61
           glfw-key-a = 65
           glfw-key-b
           glfw-key-c
           glfw-key-d
           glfw-key-e
           glfw-key-f
           glfw-key-g
           glfw-key-h
           glfw-key-i
           glfw-key-j
           glfw-key-k
           glfw-key-l
           glfw-key-m
           glfw-key-n
           glfw-key-o
           glfw-key-p
           glfw-key-q
           glfw-key-r
           glfw-key-s
           glfw-key-t
           glfw-key-u
           glfw-key-v
           glfw-key-w
           glfw-key-x
           glfw-key-y
           glfw-key-z
           glfw-key-left-bracket
           glfw-key-backslash
           glfw-key-right-accent
           glfw-key-grave-accent = 96
           glfw-key-world-1 = 161
           glfw-key-world-2
           glfw-key-escape = 256
           glfw-key-enter
           glfw-key-tab
           glfw-key-backspace
           glfw-key-insert
           glfw-key-delete
           glfw-key-right
           glfw-key-left
           glfw-key-down
           glfw-key-up
           glfw-key-page-up
           glfw-key-page-down
           glfw-key-home
           glfw-key-end
           glfw-caps-lock = 280
           glfw-scroll-lock
           glfw-num-lock
           glfw-key-print-screen
           glfw-key-pause
           glfw-key-f1 = 290
           glfw-key-f2
           glfw-key-f3
           glfw-key-f4
           glfw-key-f5
           glfw-key-f6
           glfw-key-f7
           glfw-key-f8
           glfw-key-f9
           glfw-key-f10
           glfw-key-f11
           glfw-key-f12
           glfw-key-f13
           glfw-key-f14
           glfw-key-f15
           glfw-key-f16
           glfw-key-f17
           glfw-key-f18
           glfw-key-f19
           glfw-key-f20
           glfw-key-f21
           glfw-key-f22
           glfw-key-f23
           glfw-key-f24
           glfw-key-f25
           glfw-key-kp-0 = 320
           glfw-key-kp-1
           glfw-key-kp-2
           glfw-key-kp-3
           glfw-key-kp-4
           glfw-key-kp-5
           glfw-key-kp-6
           glfw-key-kp-7
           glfw-key-kp-8
           glfw-key-kp-9
           glfw-key-kp-decimal
           glfw-key-kp-divide
           glfw-key-kp-multiply
           glfw-key-kp-subtract
           glfw-key-kp-add
           glfw-key-kp-enter
           glfw-key-kp-equal
           glfw-key-left-shift = 340
           glfw-key-left-control
           glfw-key-left-alt
           glfw-key-left-super
           glfw-key-right-shift
           glfw-key-right-control
           glfw-key-right-alt
           glfw-key-right-super
           glfw-key-menu
           glfw-key-last = 348)
         _int))
(define _glfw-key-mod
  (_enum '(glfw-mod-shift = #x0001
           glfw-mod-control = #x0002
           glfw-mod-alt = #x0004
           glfw-mod-super = #x0008)
         _int))
(define _glfw-mouse-buttons
  (_enum '(glfw-mouse-button-1 = 0
           glfw-mouse-button-2
           glfw-mouse-button-3
           glfw-mouse-button-4
           glfw-mouse-button-5
           glfw-mouse-button-6
           glfw-mouse-button-7
           glfw-mouse-button-8
           glfw-mouse-button-last = 7
           glfw-mouse-button-left = 0
           glfw-mouse-button-right = 1
           glfw-mouse-button-middle = 2)
         _int))
(define _glfw-joystick
  (_enum '(glfw-joystick-1 = 0
           glfw-joystick-2
           glfw-joystick-3
           glfw-joystick-4
           glfw-joystick-5
           glfw-joystick-6
           glfw-joystick-7
           glfw-joystick-8
           glfw-joystick-9
           glfw-joystick-10
           glfw-joystick-11
           glfw-joystick-12
           glfw-joystick-13
           glfw-joystick-14
           glfw-joystick-15
           glfw-joystick-16
           glfw-joystick-last = 15)
         _int))
(define _glfw-error-codes
  (_enum '(glfw-not-initialized = #x00010001
           glfw-no-current-context
           glfw-invalid-enum
           glfw-invalid-value
           glfw-out-of-memory
           glfw-api-unavailable
           glfw-version-unavailable
           glfw-platform-error
           glfw-format-unavailable
           glfw-no-window-context)
         _int))
(define _glfw-window-details
  (_enum '(glfw-focused = #x00020001
           glfw-iconified
           glfw-resizable
           glfw-visible
           glfw-decorated
           glfw-auto-iconify
           glfw-floating
           glfw-maximized)
         _int))
(define _glfw-window-av
  (_enum '(glfw-red-bits = #x00021001
           glfw-green-bits
           glfw-blue-bits
           glfw-alpha-bits
           glfw-depth-bits
           glfw-stencil-bits
           glfw-accum-red-bits
           glfw-accum-green-bits
           glfw-accum-blue-bits
           glfw-accume-alpha-bits
           glfw-aux-buffers
           glfw-stereo
           glfw-samples
           glfw-srgb-capable
           glfw-refresh-rate
           glfw-doublebuffer)
         _int))
(define _glfw-context
  (_enum '(glfw-client-api = #x00022001
           glfw-context-version-major
           glfw-context-version-minor
           glfw-context-revision
           glfw-context-robustness
           glfw-opengl-forward-compat
           glfw-opengl-debug-context
           glfw-opengl-profile
           glfw-context-release-behavior
           glfw-context-no-error
           glfw-context-creation-api)
         _int))
(define _glfw-api
  (_enum '(glfw-no-api = 0
           glfw-opengl-api = #x00031001
           glfw-opengl-es-api = #x00031002)
         _int))
(define _glfw-reset
  (_enum '(glfw-no-robustness = 0
           glfw-no-reset-notifications = #x00031001
           glfw-lose-context-on-reset = #x00031002)
         _int))
(define _glfw-profile
  (_enum '(glfw-opengl-any-profile = 0
           glfw-opengl-core-profile = #x00032001
           glfw-opengl-compat-profile)
         _int))
(define _glfw-sticky
  (_enum '(glfw-cursor = #x00033001
           glfw-sticky-keys
           glfw-sticky-mouse-buttons)
         _int))
(define _glfw-cursor
  (_enum '(glfw-cursor-normal = #x00034001
           glfw-cursor-hidden
           glfw-cursor-disabled)
         _int))
(define _glfw-release-behavior
  (_enum '(glfw-any-release-behavior = 0
          glfw-release-behavior-flush = #x00035001
          glfw-release-behavior-none)
         _int))
(define _glfw-context-api
  (_enum '(glfw-native-context-api = #x00036001
           glfw-egl-context-api)
         _int))
(define _glfw-custom-cursor
  (_enum '(glfw-arrow-cursor = #x00036001
           glfw-ibeam-cursor
           glfw-crosshair-cursor
           glfw-hand-cursor
           glfw-hrezise-cursor
           glfw-vresize-cursor)
         _int))
(define _glfw-connected
  (_enum '(glfw-connected = #x00040001
           glfw-disconnected)
         _int))
(define _glfw-dont-care
  (_enum '(glfw-dont-care = -1)
         _int))


(glfwInit)
(glfwWindowHint 'glfw-context-version-major 4)
(glfwWindowHint 'glfw-context-version-minor 2)
(glfwWindowHint 'glfw-opengl-profile 'glfw-opengl-core-profile)
(glfwWindowHint 'glfw-resizable 'gl-true)