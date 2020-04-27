#lang racket

(require opengl
         opengl/util)
(require ffi/vector
         ffi/unsafe)

(define shader%
  (class object%
    (init path)    ;Initialization takes in the path for the shader

    (define program (glCreateProgram))

    )
  )