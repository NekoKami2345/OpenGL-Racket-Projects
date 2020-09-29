#lang racket/gui

(define (read-vertices file acc)
  (let ([line (read-line file 'any)])
    (if (not (eof-object? line))
      (if (equal? (first (string-split line)) "v")
          (read-vertices file (cons (cdr (string-split line)) acc))
          (read-vertices file acc))
      (print acc)
      )
    )
  )
(define (read-all file value)
  (define (read-all-help acc)
   (let ([line (read-line file 'any)])
     (cond [(eof-object? line) acc]
           [(equal? (car (string-split line)) value)
              (read-all-help (cons (cdr (string-split line)) acc))]
           [else (read-all-help acc)]
           )
     )
  )
  (read-all-help '())
)

(define vertices-list (call-with-input-file "objs/rock.obj"
                        (lambda(in)
                          (read-all in "v"))))
(define (get-list-by-tag value file)
  (call-with-input-file file
    (lambda(in)
      (read-all in value))))


;(define (read-all file)
;  (let ([line (read-line file 'any)])
;    (unless (eof-object? line)
;      (if (equal? (first (string-split line)) "v")
;          (
;      (displayln line)
;      (read-all file))))
;(call-with-input-file "objs/rock.obj" read-all)