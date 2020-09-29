#lang racket/gui
(require opengl
         opengl/util)
(require ffi/vector
         ffi/unsafe
         ffi/unsafe/define)
(require "model-loading.rkt")

;function to resize the gl-viewport
(define (resize w h)
  (glViewport 0 0 w h)
  ;#t
  )
(define gl-canvas%
  (class* canvas% ()
    (inherit with-gl-context swap-gl-buffers)

    ;Variable initialization
    (field (vao 0))
    (field (vbo 0))
    (field (model (new model%)))
    (field (clear-color (list 0.0 0.0 0.0 1.0)))
    
    ;Setting up the on-paint method
    (define/override (on-paint)
      (with-gl-context
          (lambda ()
            (apply glClearColor clear-color)
            (glClear GL_COLOR_BUFFER_BIT)
            (glBindVertexArray (u32vector-ref vao 0))
            (glDrawArrays GL_TRIANGLES 0 (f32vector-length (send model get-indexed-vertices)))
            (swap-gl-buffers)
          )
        )
      )
    
    ;Overriding the resize method
    (define/override (on-size width height)
      (with-gl-context
          (lambda ()
            (resize width height)
             )))
    
    ;Function to load vertices into a model
    (define/public (load-model new-model)
      (set! model new-model)
      (setup-buffers))
    
    ;function to setup VAO
    (define/public (setup-vao)
      (with-gl-context
          {lambda()
            (set! vao (glGenVertexArrays 1))}))
    
    ;Functiont to setup VBO
    (define/public (setup-vbo)
      (with-gl-context
          {lambda()
            (set! vbo (glGenBuffers 1))}))
    
    ;Function to setup the buffers with data
    (define/public (setup-buffers)
      (with-gl-context
          (lambda()
            (glBindVertexArray (u32vector-ref vao 0))
            (glBindBuffer GL_ARRAY_BUFFER (u32vector-ref vbo 0))
            (glBufferData GL_ARRAY_BUFFER (* (f32vector-length (send model get-indexed-vertices)) (ctype-sizeof _float)) (send model get-indexed-vertices) GL_STATIC_DRAW)
            (glEnableVertexAttribArray 0)
            (glVertexAttribPointer 0 3 GL_FLOAT #f 0 0)
            (glBindVertexArray 0))))

    ;GETTERS
    (define/public (get-model)
      model)
    
    ;Super instantiation
    (super-instantiate [] [style '(gl)])
    )
)

;Making the window to put the gl-canvas in
(define window (new frame% [label "New GL Test"]
                           [min-width 700]
                           [min-height 500]))
(define h-panel (new horizontal-panel% [parent window]))

(define gl-context (new gl-canvas% [parent h-panel]))

;Creating a vertical panel to run down the right side of the gl context
(define v-panel (new vertical-panel% [parent h-panel]
                                     [stretchable-width #f]
                                     [border 10]))

;adding elements to the vertical panel
;Adding textfield to type in an object path
(define path-text (new text-field% [parent v-panel]
                 [label "Path"]))
;Adding a button to load in the model in the text-field path
(new button% [parent v-panel]
             [label "Click"]
             [callback (lambda(button event)
                         (send gl-context load-model (read-file-to-model (send path-text get-value)))
                         (send gl-context refresh))])

;Showing the window
(send window show #t)

;Setting up the vao and vbo
(send gl-context setup-vao)
(send gl-context setup-vbo)

;Create a loop to render the opengl so long as the window is open
(define (renderloop)
  (if (send window is-shown?)
      (
       (send window refresh)
       (renderloop)
       )
      (print "closed")
  )
 )

