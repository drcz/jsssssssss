(writeln '(1 2 3 yes we do serialize ok! (o . -)))
(writeln '<%%!!weird-=-symbol??%%>)
(writeln (quote 'hehe))
(writeln (quote ''quote))

(writeln "hohoho   what\na\nstrange\t\"string\"\n\\πżółćµ\\")
(writeln #(a b c))
(writeln #(1 2 (a b c) () #f #t))

(writeln (if (eq? '() '()) 'ok '(nil != nil wtf)))
(writeln (if (eq? '() (cdr '(test))) 'ok '(nil != nil again)))
(writeln (if (eq? '() #f) '(false aint null) 'ok))

(writeln (if (eq? 'hey 'hey) 'ok '(symbol equality broken)))
(writeln (if (eq? 'hey 'ho) '(symbol equality broken) 'ok))

(writeln (if (eq? "hey" "hey") 'ok '(string equality broken)))
(writeln (if (eq? "hey" "HEY") '(string equality bad (case insensitive)) 'ok))
(writeln (if (eq? 'hey "hey") '(does not distinguish symbols from strings!) 'ok))

(writeln (if (eq? 5 (+ 2 3)) 'ok '(eq sucks)))
(writeln (if (eq? #t (null? '())) 'ok '(eq or null sucks)))
(writeln (if (eq? #f (pair? '())) 'ok '(eq or pair sucks)))

(writeln (if (null? '()) 'ok '(null bad)))
(writeln (if (null? #f) '(false aint null) 'ok))
(writeln (if "" 'ok '(empty string should be truthie too)))

(writeln (if (pair? (cons 2 3)) 'ok '(pair bad)))
(writeln (if (pair? '(hello)) 'ok '(pair bad)))
(writeln (if (pair? '(h e l l o)) 'ok '(pair bad)))
(writeln (if (pair? '(h e l l . o)) 'ok '(pair bad)))
(writeln (if (pair? '()) '(pair bad) 'ok))
(writeln (if (pair? (* 2 3)) '(pair bad) 'ok))
(writeln (if (pair? #t) '(pair bad) 'ok))
(writeln (if (pair? (eq? 2 3)) '(pair bad) 'ok))

(writeln (if (number? 23) 'ok '(number bad)))
(writeln (if (number? (* 2 3)) 'ok '(number bad)))
(writeln (if (number? (/ 1 0)) 'ok '(number not great)))
(writeln (if (number? 'a) '(number bad) 'ok))
(writeln (if (number? '()) '(number bad) 'ok))
(writeln (if (number? #f) '(number bad) 'ok))
(writeln (if (number? #t) '(number bad) 'ok))

(writeln (if (vector? #(a b c)) 'ok '(vector? bad)))
(writeln (if (vector? '(a b c)) '(list aint vector) 'ok))

(writeln (make-vector 3 'tora))
(writeln (vector? (make-vector 3 'tora)))
(writeln (vector 'a 'b 'c))
(writeln `(expecting r: ,(vector-ref #(q w e r t y) 3)))
(writeln `(expecting q: ,(vector-ref #(q w e r t y) 0)))

(begin
  (define vct (make-vector 5 'yes))
  (writeln vct)
  (vector-set! vct 3 'ABSOLUTELY)
  (writeln vct)
  (vector-fill! vct 'HA!)
  (writeln vct))

(writeln (if (eq? (((lambda (sq) (lambda (*) (sq 5)))
                        (lambda (x) (* x x)))
                       (lambda (a b) (+ a b))) 25)
                 'ok
                 '(scoping problemz?)))

(writeln (equal? 'a 'a))
(writeln (equal? '(a) '(a)))
(writeln (equal? '(a (b) c) '(a (b) c)))
(writeln (equal? "abc" "abc"))
(writeln (equal? 2 2))
(writeln (equal? #(a b #f (c . d)) #(a b #f (c . d))))
(writeln (equal? (make-vector 5 'a) (make-vector 5 'a)))

(writeln (equal? (vector->list (list->vector '(q w e))) '(q w e)))
(writeln (equal? (list->vector (vector->list #(q w e))) #(q w e)))

(define (Z f) ((lambda (R) (R R)) (lambda (x) (lambda () (f (x x))))))
(define ! ((Z (lambda (f) (lambda (n) (if (eq? n 0) 1 (* n ((f) (- n 1)))))))))
(writeln (if (eq? (! 5) 120) 'grrreat '(lost in zee)))

(define (f a b) x)
(define x 0)
(writeln (if (eq? (f (set! x (+ x 1)) (set! x (+ x x))) 1)
                 '(right to left)
                 '(left to right)))

(define (shmota n acc) (if (= n 0) acc (shmota (- n 1) (cons n acc))))
(define (iota n) (shmota n '()))
(writeln (iota 1000)) ;;; with 10k it fails ofc

(define (map1 f xs) (if (null? xs) '() (cons (f (car xs)) (map1 f (cdr xs)))))
(writeln (map1 (lambda (x) (* x x)) (iota 10)))

(define (mk-silly n) (lambda (x) (cons x n)))
(writeln (map1 (lambda (f) (f 'const)) (map1 mk-silly (iota 5)))) ;; gr8!

(define (list . x) x)
(writeln (list 'list 'works 'ok!))

(define (ogon a b . c) c)
(writeln (list 'expected '(i l) 'here: (ogon 't 'a 'i 'l)))

(define (map f . xs)
  (if (pair? (car xs))
      (cons (apply f (map1 car xs))
            (apply map f (map1 cdr xs)))
      '()))

(writeln (map (lambda (x) (* x x)) (iota 10)))
(writeln (map cons '(a b c d) '(1 2 3 4)))
(writeln (apply map list '((a b c) (d e f))))
(writeln (apply apply (list map list '((a b c) (1 2 3)))))

(define x 23)
(define (foo x) ((lambda (_) (* x x)) (set! x 10)))
(writeln `(expecting 100 here: ,(foo x)))
(writeln `(expecting 23 here: ,x))

(define x 23)
(define (boo y) ((lambda (_) (* y y)) (set! x 10)))
(writeln (list 'expecting 529 'here: (boo x)))
(writeln (list 'and 10 'here: x))

(writeln (list 'expecting 5 'here: ((if #t + *) 2 3)))
(writeln (list 'expecting 6 'here: ((if #f + *) 2 3)))
(writeln (if '() 'ok 'nope))
(writeln (if '(woo) 'ok 'nope))

(writeln (eq? 'lambda (car ((lambda lambda lambda) 'lambda)))) ;; niiice!
;;(writeln ((lambda (if) (if 'p 'c 'a)) (lambda (a b c) (cons a (cons b (cons c '())))))) ;; oww, to-js needs to be aware of bound symbols then...

(writeln '(now something really stupid, overwrite + with *))
(define old-+ +)
(set! + *)
(writeln `((+ 2 3) is now ,(+ 2 3)))
(set! + old-+)
(writeln `(and now (+ 2 3) is ,(+ 2 3) again))

(define old-list list)
(set! list (lambda x `(list: . ,x)))
(writeln (list 1 2 3 4 5))
(set! list old-list)
(writeln (list 1 2 3 4 5))

(define evil 13)
(writeln `(13 is ,evil))
(define evil 23)
(writeln `(23 is ,evil))

(define (foo x) (* x x))
(writeln '(define (foo x) (* x x)))
(writeln `((foo 3) is ,(foo 3)))

(define (foo x) (+ x x))
(writeln '(define (foo x) (+ x x)))
(writeln `(and now (foo 3) is ,(foo 3)))

(writeln '(expecting 25 below:))
(writeln
 ((lambda ()
    (define (sq x) (* x x))
    (define x 5)
    (sq x))))

(writeln
 `(expecting 9 here: 
	     ,((lambda (x)
		 (writeln 'ple-ple-ple)
		 (define (skwyr x) (* x x))
		 (define (ole! y) (set! x y) y)
		 (ole! (skwyr x))
		 x) (+ 2 1))))

(begin
  (writeln '(just some silly begin stuff))
  (define (fac n) (if (= n 0) 1 (* n (fac (- n 1)))))
  (writeln `((fac 5) is ,(fac 5)))
  (define more-than-100 (fac 5))
  (writeln `((and this should be sth around 14400:) ,(* more-than-100 more-than-100))))

(writeln '(expecting (5 25 (5 5) (25 25)) below:))
(writeln
 (let* ((x (+ 2 3))
        (y (* x x)))
   (define (dup x) (list x x))
   (list x y (dup x) (dup y))))

(begin
  (define leaky-var 23)
  (writeln `(leaky-var is ,leaky-var inside begin)))

(writeln `(leaky-var is ,leaky-var outside begin too))

(define (stupid x) (begin (writeln 'makes-no-sense-but-works) x))
(writeln (stupid (+ 2 3)))

(define (evil x) (writeln 'elo) (begin (set! x 7) (* x x)))
(writeln (list 'expecting 49 'here (evil 3)))

(define (evil* x) (writeln 'elo) (begin (set! x 7) (* x x)) (writeln 'hahaha) 42)
(writeln (list 'expecting 42 'here (evil* 3)))

(define (fooo)
  (begin (define x (+ 2 3)) ;; nb Scheme48 doesn't like this (syntax violation)
         (define y (* x x))
         (cons x y)))

(writeln (list 'expecting '(5 . 25) 'here (fooo)))

(define (fooooo)
  (writeln 'even-better?)
  (begin (define x (+ 2 3))
         (define y (* x x))
         (cons x y)))

(writeln (list 'expecting '(5 . 25) 'here 'as 'well (fooooo)))

(define x 23)
(define wat (begin (set! x 3) (* x x)))
(writeln (eq? wat 9))

(if #t (begin (writeln 'all-good) (writeln 'for-real!)))
(if #f 23 (begin (writeln 'still-good) 15))
((begin (writeln 'i.m.rator) (lambda (x) (* x x))) (begin (writeln 'i.r.rand) (+ 2 3)))

(writeln (begin (writeln 'haha) (< 2 3)))

(define wat 9)
(writeln (let ((wat 15)
               (y wat))
           (eq? y 9)))
(writeln (eq? wat 9))

(writeln (let* ((wat 15)
                (y wat))
           (eq? y 15)))

(writeln (let ((x 3)
               (y 5))
           (let ((x 7)
                 (y (* x x)))
             (eq? y 9))))

(writeln (let ((x 3)
               (y 5))
           (let* ((x 7)
                  (y (* x x)))
             (eq? y 49))))

(let* ((x (+ 2 3))
       (y (begin (writeln 'all-good) (* x x))))
  (begin
    (writeln 'here-as-well)
    (writeln (eq? y 25))))

(let ((x (begin (writeln 'all-good) (+ 2 3))))
  (begin
    (writeln 'here-as-well)
    (writeln (eq? x 5))))

(writeln (or #t))
(writeln (or #f #t))
(writeln (or #f #f #t))
(writeln (and))
(writeln (and #t))
(writeln (and #t #t #t))
(writeln (not (and #t #t #t #f #t)))

(writeln (let ((x (+ 2 3))
               (y (* 2 3)))
           (is x < y)))

(writeln (let ((x (+ 2 3))
               (y (* 2 3)))
           (isnt x > y)))

(writeln `(2 + 3 = ,(+ 2 3)))
(writeln `(`wat ,'wat))
(writeln `(,'quote))
(writeln `(,`,`,23))
(writeln `(unquote (+ 2 3)))
(writeln `(,'unquote (+ 2 3)))

(writeln (match '(a b c)
           (`(,h . ,t) `(h= ,h t= ,t))
           (_ 'boo)))

(writeln (match 'elo
           (_ (writeln '(implicit begin in match works ok))
              (writeln '(here is your 5:))
                  (+ 2 3))))

(writeln (match 'elo
           (_ (begin
                (writeln '(explicit begin in match works ok too))
                (writeln '(here is another 5:))
                (+ 2 3)))))

(define qwe '(q w e))
(define asd (append qwe '(a s d)))
(writeln `(me should be (q w e) -- ,qwe))
(writeln `(i are (q w e a s d) --  ,asd))

(define x 3)
((lambda ()
  (define x 3)
  (while (> x 0) (writeln x) (set! x (- x 1)))))
(writeln `(here x should be 3 again and is ,x))
((lambda ()
  (while (> x 0) (writeln x) (set! x (- x 1)))))
(writeln `(and here x should be 0 ,x))


(writeln (cond ((> 1 0) 'ok)
               ((< 1 0) 'wat?!)))

(writeln (cond ((> 0 0) 'wat?!)
               ((< 1 0) 'waaat?!)
               (else 'ok)))

(writeln `(expecting undefined here: ,(cond ((> 0 0) 'not-good)
                                            ((< 1 0) 'not-good))))

(define (caar x) (car (car x)))
(define (cadr x) (car (cdr x)))
(define (assv key alist)
  (cond ((not (pair? alist)) #f)
        ((eq? (caar alist) key) (car alist))
        (else (assv key (cdr alist)))))

(writeln (eq? 2 (cond ((assv 'b '((a 1) (b 2))) => cadr)
                      (else #f))))

(writeln 'numerals------)

(writeln (/ 1 0.0))
(writeln (/ -3 0.0))
(writeln (/ (/ 1 0.0)))
(writeln (= (/ 3 0.0) (/ 5 0.0)))
(writeln (not (= (/ 3 0.0) (/ -3 0.0))))
(writeln (= (/ (/ 1 0.0)) 0))

(writeln (+ (/ 1 0.0) 1))
(writeln (- (/ 1 0.0) 1))
(writeln (+ (/ -1 0.0) 1))
(writeln (- (/ -1 0.0) 1))
(writeln (+ (/ 3 0.0) (/ 2 0.0)))
(writeln (+ (/ -3 0.0) (/ -2 0.0)))

(writeln (- (/ 3 0.0) (/ 2 0.0)))

;;; niektóre tu się dublują bo je wklejam z osobnego testera, ale też
;;; lepije 2 razy przetestować to samo niż nie przetestować ani razu!

(writeln `(just-in-case it's a w: ,(cadr '(q w e))))

(writeln 'more-matching:)
(match '(q w e)
  (`(,a) (writeln `(a= ,a)))
  (`(,a ,b ,c) (writeln `(abc b= ,b)))
  (`,elo (writeln `(elo ,elo))))

(match '(q w)
  (`(,a) (writeln `(a= ,a)))
  (`(,a ,b ,c) (writeln `(abc b= ,b)))
  (`,elo (writeln `(elo ,elo))))

(match '(q)
  (`(,a) (writeln `(a= ,a)))
  (`(,a ,b ,c) (writeln `(abc b= ,b)))
  (`,elo (writeln `(elo ,elo))))

(match '23
  (_ (writeln 'pff))
  (`(,a ,b ,c) (writeln `(abc b= ,b)))
  (`,elo (writeln `(elo ,elo))))

(writeln (match '(q w e)
           (`(,a . ,ts) ts)
           (_ 'oooo)))

(writeln (match '(q w e)
           (`(,a ,@ts) ts)
           (_ 'oooo)))

(let ((bułka '(b u ł k a)))
  (writeln `(oto ,@bułka)))

(writeln 'params--------)
(define p (make-parameter 0))
(writeln (p))
(parameterize ((p 10))
  (writeln (p))
  (p (+ (p) 1))
  (writeln (p)))
(writeln (p))

(writeln 'dots----------)
(define (kropeczka x y . zs) zs)
(writeln (kropeczka 1 2 3 4 5 6))
(writeln (kropeczka 1 2 3))
(writeln (kropeczka 1 2))
(writeln (apply kropeczka `(1 2 3)))
(writeln (apply kropeczka `(1 2)))


(writeln 'map-----------)
(writeln (map cons '(q w e) '(1 2 3)))
(writeln (map list '(a b c) '(x x x) '(1 2 3)))
(writeln (apply map list '((1 2 3) (4 5 6))))
(writeln (apply map list '(a b c) '((1 2 3) (4 5 6))))

(writeln 'append--------)
(writeln (append '() '() '(he he)))
(writeln (append '(q w e) '()))
(writeln (append '(q w e) '(a s d) '(1 2 3) '(hej ho)))
(writeln (apply append '((q w) (e r t) (1 2 3))))
(writeln (apply append '(() (q w e) (r t y))))

(writeln 'append!-------)
(define a '(q w e))
(define b (append! a '(4 5 6) '(7 8 9)))
(writeln a)
(writeln b)
(writeln (append! '(a b c) 'd))
(define c '())
(writeln (append! c '(e l o)))

(writeln 'assoc---------)
(writeln (assoc 'a '((a . 23) (b 'elo))))
(writeln (assoc 'b '((a . 23) (b 'elo))))
(writeln (assoc 'c '((a . 23) (b 'elo))))
(writeln (assoc 'a '()))

(writeln 'union---------)
(writeln (union '(a b c) '(a c e)))
(writeln (union '(a b c) '(d e f)))
(writeln (union '(a b c) '(a b c)))
(writeln (union '(a b c) '(c a b)))
(writeln (union '() '(a b c)))
(writeln (union '(a b c) '()))
(writeln (union '(a b c) '(a b c) '(d a c) '(d d d)))
(writeln (union '(a b c) '(a b c) '(d a c) '(d a b)))
(writeln (union '(a (b c) c) '(a b c) '(d a (b c)) '(d a (b c))))

(writeln 'difference----)
(writeln (difference '() '(a (b c) d)))
(writeln (difference '(a (e)) '(a (b c) d)))
(writeln (difference '(a (e)) '(b (e) d)))
(writeln (difference '(a b) '()))

(writeln 'only----------)
(writeln (only even? '(1 2 3 4 5 6)))
(writeln (only odd? '(1 2 3 4 5 6)))
(writeln (only even? '()))
(writeln (only (lambda (x) (> x 3)) '(1 2 3 4 5 6 7)))
(writeln (only (lambda (x) (is x > 3)) '(1 2 3 4 5 6 7)))

(writeln 'member--------)
(writeln (member 'x '(q w e)))
(writeln (member 'x '(q x e)))
(writeln (member 'x '(q w x)))

(writeln 'take&drop-----)
(writeln (take 2 '(q w e r t y)))
(writeln (drop 2 '(q w e r t y)))
(writeln (take 5 '(1 2 3)))
(writeln (drop 5 '(1 2 3)))

(writeln 'fold-left-----)
(writeln (fold-left + 0 '(1 2 3 4 5)))
(writeln (fold-left * 1 '(1 2 3 4 5)))
(writeln (fold-left + 42 '()))
(writeln (fold-left (lambda x x) 'co '(ja tu robię?!)))

(writeln 'any-----------)
(writeln (any even? '(1 2 3 4 5)))
(writeln (any even? '(1 3 5)))
(writeln (any even? '()))

(writeln 'every---------)
(writeln (every even? '(0 2 4 6)))
(writeln (every even? '(0 2 4 5)))
(writeln (every even? '()))

(writeln 'immune-to-redefining-primops?)

(writeln (if (member x '(1 2 3)) 'wtf 'ok))
(define old-equal? equal?)
(define (equal? . _) #t)
(writeln (if (member x '(1 2 3)) 'oops 'ok))
(define equal? old-equal?)
(writeln (if (member x '(1 2 3)) 'wtf 'ok))

(writeln (append '(q w e) '(a b c)))
(define old-pair? pair?)
(define (pair? _) #f)
(writeln (append '(q w e) '(a b c)))
(define pair? old-pair?)
(writeln (append '(q w e) '(a b c)))
