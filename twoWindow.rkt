#lang racket/gui
(require opengl
         opengl/util)
(require ffi/vector
         ffi/unsafe
         ffi/unsafe/define)

(define list-vertices (list->f32vector(list .25 .25 0.0 .75 .25 0.0 .75 .75 0.0)))
(define size 9)

(define read-list
    (lambda (t-list)
      (unless (empty? t-list)
        (first t-list)
        (read-list (rest t-list)))))

(define (resize w h)
  (glViewport 0 0 w h)
  ;#t
  )
(define my-canvas%
  (class* canvas% ()
    (inherit with-gl-context swap-gl-buffers)

    (define vao 0)
    (define vbo 0)
    (define clear-color (list 0.0 0.0 0.0 1.0))
    
    (define/override (on-paint)
      (with-gl-context
          (lambda ()
            (apply glClearColor clear-color)
            (glClear GL_COLOR_BUFFER_BIT)
            (glBindVertexArray(u32vector-ref vao 0))
            (glBindBuffer GL_ARRAY_BUFFER (u32vector-ref vbo 0))
            (glBufferData GL_ARRAY_BUFFER (* (f32vector-length list-vertices) (ctype-sizeof _float)) list-vertices GL_STATIC_DRAW)
            (glEnableVertexAttribArray 0)
            (glVertexAttribPointer 0 3 GL_FLOAT #f 0 0)
            (glDrawArrays GL_TRIANGLES 0 (f32vector-length list-vertices))
            (swap-gl-buffers)
            )
        )
      )
    (define/override (on-size width height)
      (with-gl-context
          (lambda ()
            (resize width height)
            )
        )
      )
    (define (cleanup)
      (glDeleteBuffers 1 vbo)
      (glDeleteVertexArrays 1 vao)
      )
    (define/public (genVAO)
      (with-gl-context
          (lambda ()
            (set! vao (glGenVertexArrays 1))
            )))
    (define/public writeVAO
      (lambda ()
        (write (u32vector-ref vao 0))))
    (define/public (genVBO)
      (with-gl-context
          (lambda ()
            (set! vbo (glGenBuffers 1))
            )))
    (define/public (writeVBO)
        (write (u32vector-ref vbo 0)))

    ;Method to write new points into the vertex buffer(for now just sets new list-vertices points
    ;Passed points as strings
    (define/public (set-points points)
      (set! list-vertices (list->f32vector (map string->number (string-split points)))))
    
    (super-instantiate [] [style '(gl)])
    
    ;(with-gl-context
    ;    (lambda ()
    ;      (define x (glGenVertexArrays 1))
    ;      (write (u32vector-ref x 0))
    ;      (define y (glGenBuffers 1))
    ;      (glBindVertexArray(u32vector-ref x 0))
    ;      (glBindBuffer GL_ARRAY_BUFFER (u32vector-ref y 0))
    ;      (glBufferData GL_ARRAY_BUFFER size (list->f32vector list-vertices) GL_STATIC_DRAW)
    ;      (glEnableVertexAttribArray 0)
    ;      (glVertexAttribPointer 0 3 GL_FLOAT #f 0 0)))
          
    )
  )
(define win (new frame% (label "OpenGL Test") (min-width 200) (min-height 200)))
(define gl (new my-canvas% (parent win)))

(send win show #t)

(send gl genVAO)
(send gl writeVAO)
(send gl genVBO)
(send gl writeVBO)

(define (gameloop)
  (if (send win is-shown?)
      (
        (send win refresh)
        (gameloop)
        )
      (
        (send gl cleanup)
        )
      )
  )


(define edit-frame (new frame% [label "win2"]
                           [width 200]
                           [height 200]))
(new button% [parent edit-frame]
             [label "CLICK ME"]
             [callback (lambda (button event)
                         (send gl set-points (send point-text get-text)))])

(define points-canvas (new editor-canvas%
                           (parent edit-frame)
                           (label "Point Editor")))
(define point-text (new text%))
(send points-canvas set-editor point-text)

(send edit-frame show #t)