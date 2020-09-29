#lang racket/gui
(require ffi/vector
         ffi/unsafe
         ffi/unsafe/define)

(provide model%)
(provide read-file-to-model)

;Function to return a model object with the vertices and vertices-indices from a provided file
(define (read-all file)
  ;Recursive helper function
  (define (read-all-help acc)
   (let ([line (read-line file 'any)]
         [model (new model%)])
     
     ;End on EOF
     ;continue with expanded acc on value
     ;continue with anything else
     (cond [(eof-object? line)
            (send model set-vertices (list->f32vector (flatten (reverse (car acc)))))
            (send model set-faces (reverse (cdr acc)))
            model]
           [(equal? (string-split line) '())
            (read-all-help acc)]
           [(equal? (car (string-split line)) "v")
              (read-all-help (cons (cons (map string->number (cdr (string-split line))) (car acc)) (cdr acc)))]
           [(equal? (car (string-split line)) "f")
              (read-all-help (cons (car acc) (cons(map (lambda(string-list)
                                                         (map string->number string-list))
                                                       (map (lambda(string)
                                                          (string-split string "/"))
                                                        (cdr (string-split line)))) (cdr acc))))]
           [else (read-all-help acc)]
           )
     )
  )
  ;Actually call the function
  (read-all-help (cons '() '()))
)

;Function to return a model object with a given file as input
(define (read-file-to-model file)
  (call-with-input-file file
    (lambda(in)
      (read-all in))))


;Class to contain model details
(define model%
  (class object%
    ;FIELDS
    (field (vertices (f32vector)))
    (field (faces '()))
    (field (indexed-vertices (f32vector)))

    ;GETTERS
    (define/public (get-vertices)
      vertices)
    (define/public (get-faces)
      faces)
    (define/public (get-indexed-vertices)
      indexed-vertices)

    ;SETTERS
    (define/public (set-vertices new-vertices)
      (set! vertices new-vertices))
    (define/public (set-faces new-faces)
      (set! faces new-faces)
      (set! indexed-vertices (list->f32vector (flatten (for/list ([index (flatten (map (lambda(list) (map car list)) new-faces))])
                               (list (f32vector-ref vertices (* (- index 1) 3))
                               (f32vector-ref vertices (+ (* (- index 1) 3) 1))
                               (f32vector-ref vertices (+ (* (- index 1) 3) 2))))))))

    ;SUPERCLASS
    (super-new)
    )
  )
    