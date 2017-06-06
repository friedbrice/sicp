# Answers to Exercises in __Structure and Interpretation of Computer Programs__

## Chapter 1

### Exercise 1.1

__Below is a sequence of expressions. What is the result printed by the interpreter in response to each expression? Assume that the sequence is to be evaluated in the order in which it is presented.__

    10
    ; 10

    (+ 5 3 4)
    ; 12

    (- 9 1)
    ; 8

    (/ 6 2)
    ; 3

    (+ (* 2 4) (- 4 6))
    ; (+ 8 -2)
    ; 6

    (define a 3)
    ; a

    (define b (+ a 1))
    ; b

    (+ a b (* a b))
    ; (+ 3 (+ a 1) (* 3 (+ a 1)))
    ; (+ 3 (+ 3 1) (* 3 (+ 3 1)))
    ; (+ 3 4 (* 3 4))
    ; (+ 3 4 12)
    ; 19

    (= a b)
    ; #f

    (if (and (> b a) (< b (* a b)))
        b
        a)
    ; (if #t 4 3)
    ; 4

    (cond ((= a 4) 6)
          ((= b 4) (+ 6 7 a))
          (else 25))
    ; (cond (#f 6) (#t 16) (#t 25))
    ; 16

    (+ 2 (if (> b a) b a))
    ; (+ 2 (if #t b a))
    ; (+ 2 b)
    ; (+ 2 4)
    ; 6

    (* (cond ((> a b) a)
             ((< a b) b)
             (else -1))
       (+ a 1))
    ; (* (cond (#f 3) (#t 4) (#t -1)) 4)
    ; (* 4 4)
    ; 16

### Exercise 1.2

__Translate the following expression into prefix form__

\[
\frac{5 + 4 + (2 - (3 - (6 + \frac{4}{5})))}{3(6 - 2)(2 - 7)}
\]

    (/ (+ 5 4 (- 2 (- 3 (+ 6 (/ 4 5))))) (* 3 (- 6 2) (- 2 7)))

### Exercise 1.3

__Define a procedure that takes three numbers as arguments and returns the sum of the squares of the two larger numbers.__

    (define (f x y z)
            (cond ((and (< z x) (< z y)) (+ (square x) (square y)))
                  ((and (< x y) (< x z)) (+ (square y) (square z)))
                  (else (+ (square z) (square x)))))

### Exercise 1.4

__Observe that our model of evaluation allows for combinations whose operators are compound expressions. Use this observation to describe the behavior of the following procudeure:__

    (define (a-plus-abs-b a b)
      ((if (> b 0) + -) a b))

`a-plus-abs-b <x> <y>` resolves to an expression whose operator is an `if` clause. Our model of execution evaluates the operator first, then evaluates each argument, so we will evaluate the `if` clause `(if (> <x> 0) + -)` before evaluating `<x>` and `<y>` (though this particular `if` clause forces the evaluation of `<x>`, and furthermore the call to `a-plus-abs-b` has already evaluated `<x>` and `<y>` before resolving). An equivalent way to write the procedure would be:

    (define (a-plus-abs-b a b)
      ((if (> b 0) (+ a b) (- a b))))

Basically, we observe that procedures are first-class values that can stand on their own apart from an evaluation statement.

### Exercise 1.5

__Ben Bitdiddle has invented a test to determine whether the interpreter he is faced with is using applicative-order evaluation or normal-order evaluation. He defines the following two procedures:__

    (define (p) (p))

    (define (test x y)
      (if (= x 0)
          0
          y))

__Then he evaluates the expression__

    (test 0 (p))

__What behavior will Ben observe with an interpreter that uses applicative-order evaluation? What behavior will he observe with an interpreter that uses normal-order evaluation? Explain your answer. (Assume that the evaluation rule for the special form if is the same whether the interpreter is using normal or applicative order: The predicate expression is evaluated first, and the result determines whether to evaluate the consequent or the alternative expression.)__

An applicative-order interpreter will evaluate arguments before attempting to resolve an operator. As applied to `(test 0 (p))`, an applicative-order interpreter will evaluate the argument `0` (already in normal form) and the argument `(p)` (causing an infinite descent) before resolving the operator `test`.

A normal-order interpreter will resolve operators before evaluating arguments. As applied to `(test 0 (p))`, a normal-order interpreter will resolve `test` first, yielding `(if (= 0 0) 0 (p))`. The `if` form is special in that it only ever evaluates either its alternative or, in this case, its consequent, so the call to evaluate `p` is ignored and the procedure returns `0`.

### Exercise 1.6

__Alyssa P. Hacker doesn't see why `if` needs to be provided as a special form. "Why can't I just define it as an ordinary procedure in terms of `cond`?" she asks. Alyssa's friend Eva Lu Ator claims this can indeed be done, and she defines a new version of `if`:__

    (define (new-if predicate then-clause else-clause)
      (cond (predicate then-clause)
            (else else-clause)))

__Eva demonstrates the program for Alyssa:__

    (new-if (= 2 3) 0 5)
    ; 5

    (new-if (= 1 1) 0 5)
    ; 0

__Delighted, Alyssa uses `new-if` to rewrite the square-root program:__

    (define (sqrt-iter guess x)
      (new-if (good-enough? guess x)
              guess
              (sqrt-iter (improve guess x)
                         x)))

__What happens when Alyssa attempts to use this to compute square roots? Explain.__

Alyssa's program fails to terminate. `new-if` evaluates its three arguments before it is resolved, so every call to `square-iter` causes exactly one more call to `square-iter`.

### Exercise 1.7

__The `good-enough?` test used in computing square roots will not be very effective for finding the square roots of very small numbers. Also, in real computers, arithmetic operations are almost always performed with limited precision. This makes our test inadequate for very large numbers. Explain these statements, with examples showing how the test fails for small and large numbers. An alternative strategy for implementing `good-enough?` is to watch how `guess` changes from one iteration to the next and to stop when the change is a very small fraction of the guess. Design a `square-root` procedure that uses this kind of end test. Does this work better for small and large numbers?__

Using the given implementation of `sqrt` (provided below for completeness), `(sqrt <x>)` where $0.999 < x \leq 1.001$ will erroneously return 1, since the improved guess, 1.0005, is within 0.001 of the initial guess, 1.

    (define (sqrt-iter guess x)
      (if (good-enough? guess x)
          guess
          (sqrt-iter (improve guess x)
                     x)))

    (define (improve guess x)
      (average guess (/ x guess)))

    (define (average x y)
      (/ (+ x y) 2))

    (define (good-enough? guess x)
      (< (abs (- (square guess) x)) 0.001))

    (define (sqrt x)
      (sqrt-iter 1.0 x))

(There is no problem for "very small numbers" other than round-off error, since the average between one and a number close to 0 is a number close to 0.5, which is well outside the tolerance of 0.001.)

There doesn't seem to be a huge problem for large numbers in the current implementation of MIT Scheme, as `(sqrt 999999999999999)` and `(sqrt 999999999999998)` return distinct values that differ in the hundred-millionths place.

Reimplemented according to the exercises suggestions, we have:

    (define (sqrt-iter old-guess x)
      (let ((new-guess (improve old-guess x)))
        (if (good-enough? old-guess new-guess)
            new-guess
            (sqrt-iter new-guess x))))

    (define (improve guess x)
      (average guess (/ x guess)))

    (define (average x y)
      (/ (+ x y) 2))

    (define (good-enough? old-guess new-guess)
      (< (abs (- new-guess old-guess)) (* 0.001 old-guess)))

    (define (sqrt x)
      (sqrt-iter 1.0 x))

Under the new implementation, `(sqrt 0.9991)` and `(sqrt 1.001)` return distinct values.

### Exercise 1.8

__Newton's method for cube roots is based on the fact that if $y$ is an approximation to the cube root of $x$, then a better approximation is given by the value__

\[
\frac{x/y^2 + 2y}{3}
\]

__Use this formula to implement a cube-root procedure analogous to the square-root procedure. (In section 1.3.4 we will see how to implement Newton's method in general as an abstraction of these square-root and cube-root procedures.)__

    (define (cbrt x)
      (define (good-enough old new)
        (< (abs (- new old)) (* 0.001 old)))
      (define (improve guess)
        (/ (+ (/ x (* guess guess)) (* 2 guess)) 3.0))
      (define (helper old-guess)
        (let ((new-guess (improve old-guess)))
          (if (good-enough old-guess new-guess)
              new-guess
              (helper new-guess))))
      (helper 1))

### Exercise 1.9

__Each of the following two procedures defines a method for adding two positive integers in terms of the procedures `inc`, which increments its argument by 1, and `dec`, which decrements its argument by 1.__

    (define (+ a b)
      (if (= a 0)
          b
          (inc (+ (dec a) b))))

    (define (+ a b)
      (if (= a 0)
          b
          (+ (dec a) (inc b))))

__Using the substitution model, illustrate the process generated by each procedure in evaluating `(+ 4 5)`. Are these processes iterative or recursive?__

*First Implementation:*

    (+ 4 5)
    ; (inc (+ 3 5))
    ; (inc (inc (+ 2 5)))
    ; (inc (inc (inc (+ 1 5))))
    ; (inc (inc (inc (inc (+ 0 5)))))
    ; (inc (inc (inc (inc 5))))
    ; (inc (inc (inc 6)))
    ; (inc (inc 7))
    ; (inc 8)
    ; 9

This implementation is a linear recursive process.

*Second Implementation:*

    (+ 4 5)
    ; (+ 3 6)
    ; (+ 2 7)
    ; (+ 1 8)
    ; (+ 0 9)
    ; 9

This implementation is a linear iterative process.

### Exercise 1.10

__The following procedure computes a mathematical function called Ackermann's function.__

    (define (A x y)
      (cond ((= y 0) 0)
            ((= x 0) (* 2 y))
            ((= y 1) 2)
            (else (A (- x 1)
                     (A x (- y 1))))))

__What are the values of the following expressions?__

    (A 1 10)

    (A 2 4)

    (A 3 3)

__Consider the following procedures, wehre `A` is the procedure defined above:__

    (define (f n) (A 0 n))

    (define (g n) (A 1 n))

    (define (h n) (A 2 n))

    (define (k n) (* 5 n n))

__Give concise mathematical definitions for the functions computed by the procedures `f`, `g`, and `h` for positive integer values `n`. For example, `(k n)` computes $5n^2$.__

Obviously, $A(0, n) = 2n$.

*Proposition:* For $n > 0$, $A(1, n) = 2^n$.

Notice $A(1, 1) = 2 = 2^1$. Now, assume for induction that $A(1, k) = 2^k$ for some $k$. Then $A(1, k + 1) = A(0, A(1, k)) = 2 A(1, k) = 2 \cdot 2^k = 2^{k + 1}$, as desired. \qed

*Proposition:* For $n > 0$, $A(2, n) = \underbrace{2^2^.^.^.^2}{n}$.

First, $A(2, 1) = 2 = \underbrace{2}{1}$. Now, assume for induction that $A(2, k) = \underbrace{2^2^.^.^.^2}{k}$ for some $k$. Then $A(2, k + 1) = A(1, A(2, k)) = 2^{A(2, k)} = 2^{\underbrace{2^2^.^.^.^2}{k}} = \underbrace{2^2^.^.^.^2}{k + 1}$, as desired. \qed

Now, we evaluate

\[
A(1, 10) = 2^10
\]

\]
A(2, 4) = 2^2^2^2
\]

\begin{align*}
A(3, 2) &= A(2, A(3, 1)) \\
        &= \underbrace{2^2^.^.^.^2}{A(3, 1)} \\
        &= \underbrace{2^2^.^.^.^2}{2} \\
        &= 2^2 = 4 \\
A(3, 3) &= A(2, A(3, 2)) \\
        &= \underbrace{2^2^.^.^.^2}{A(3, 2)} \\
        &= \underbrace{2^2^.^.^.^2}{4} \\
        &= 2^2^2^2
\end{align*}

### Exercise 1.11

__A function $f$ is defined by the rule that $f(n) = n$ if $n < 3$ and $f(n) = f(n - 1) + 2f(n - 2) + 3f(n - 3)$ if $n \geq 3$. Write a procedure that computes $f$ by means of a recursive process. Write a procedure that computes $f$ by means of an iterative process.__

*Recursive Process:*

    (define (f n)
      (cond ((< n 3) n)
            (else (+ (f (- n 1))
                     (* 2 (f (- n 2)))
                     (* 3 (f (- n 3)))))))

*Iterative Process:*

    (define (f n)
      (define (g x y z)
        (+ z (* 2 y) (* 3 x)))
      (define (h i x y z)
        (if (= i 0)
          x
          (h (- i 1) y z (g x y z))))
      (h n 0 1 2))

### Exercise 1.12

__The following pattern of numbers is called __Pascal's triangle.____

        1
       1 1
      1 2 1
     1 3 3 1
    1 4 6 4 1
       ...

__The numbers at the edge of the triangle are all 1, and each number inside the triangle is the sum of the two numbers above it. Write a procedure that computes elements of Pascal's triangle by means of a recursive process.__

    (define (pascal r c)
      (cond ((> c r) (error "index out of bound" r c))
            ((= r 0) 1)
            ((= c 0) 1)
            ((= c 1) r)
            ((= c r) 1)
            ((= c (- r 1)) r)
            (else (+ (pascal (- r 1) (- c 1))
                     (pascal (- r 1) c)))))

### Exercise 1.13

__Prove that $Fib(n)$ is the closest integer to $\phi^n / \sqrt{5}$, where $\phi = (1 + \sqrt{5}) / 2$. __Hint:__ Let $\psi = (1 - \sqrt{5}) / 2$. Use induction and the definition of the Fibonacci numbers (see section 1.2.2) to prove that $Fib(n) = (\phi^n - \psi^n) / \sqrt{5}$.__

*Proposition:* For $n \geq 0$, $Fib(n) = \frac{\phi^n - \psi^n}{\sqrt{5}}$.

First, notice that $\frac{\phi^0 - \psi^0}{\sqrt{5}} = 0 = Fib(0)$ and $\frac{\phi^1 - \psi^1}{\sqrt{5}} = \frac{(1 + \sqrt{5}) / 2 - (1 - \sqrt{5}) / 2}{\sqrt{5}} = 1 = Fib(1)$. Now, assume for induction that for $n < k$ we have $Fib(n) = \frac{\phi^n - \psi^n}{\sqrt{5}}$. Then

\begin{align*}
Fib(k) &= Fib(k - 1) + Fib(k - 2) \\
       &= \frac{\phi^{k - 1} - \psi^{k - 1}}{\sqrt{5}}
        + \frac{\phi^{k - 2} + \psi^{k - 2}}{\sqrt{5}} \\
       &= \frac{1}{\sqrt{5}}
          \left(
            \phi^{k - 1} + \phi^{k - 2} - (\psi^{k - 1} + \psi^{k - 2})
          \right) \\
       &= \frac{1}{\sqrt{5}}
          \left(
            \phi^k \left( \phi^{-1} + \phi^{-2} \right)
            - \psi^k \left( \psi^{-1} + \psi^{-2} \right)
          \right) \\
       &= \frac{1}{\sqrt{5}}
          \left( \phi^k - \psi^k \right)
\end{align*}

since

\begin{align*}
\phi^{-1} + \phi^{-2} &= \frac{2}{1 + \sqrt{5}}
                       + \frac{4}{(1 + \sqrt{5})^2} \\
                      &= \frac{2(1 + \sqrt{5}) + 4}{(1 + \sqrt{5})^2} \\
                      &= \frac{6 + 2 \sqrt{5}}{6 + 2\sqrt{5}} = 1
\end{align*}

and

\begin{align*}
\phi^{-1} + \phi^{-2} &= \frac{2}{1 - \sqrt{5}}
                       + \frac{4}{(1 - \sqrt{5})^2} \\
                      &= \frac{2(1 - \sqrt{5}) + 4}{(1 - \sqrt{5})^2} \\
                      &= \frac{6 - 2 \sqrt{5}}{6 - 2 \sqrt{5}} = 1 \qed
\end{align*}

*Proposition:* $Fib(n)$ is the closest integer to $\phi^n / \sqrt{5}$.

First, notice that when $n \geq 1$ we have $\psi^n / \sqrt{5} < 1/2$, so

\begin{align*}
Fib(n) &= \phi^n / \sqrt{5} - \psi^n / \sqrt{5} \\
Fib(n) - \phi^n / sqrt{5} &= - \psi^n / \sqrt{5} \\
\left\vert Fib(n) - \phi^n / sqrt{5} \right\vert &= \psi^n / \sqrt{5} < 1/2
\end{align*}

when $n \geq 1$.

When $n = 0$, we have $\phi^n / \sqrt{5} = 1 / \sqrt{5} = 0.447... < 1/2$, completing the proof. \qed

### Exercise 1.14

__Draw the tree illustrating the process generated by the `count-change` procedure of section 1.2.2 in making change for 11 cents. What are the orders of growth of the space and number of steps used by this process as the amount to be changed increases?__

    ;; TODO

### Exercise 1.15

__The sine of an angle (specified in radians) can be computed by making use of the approximation $\sin x \approx x$ if $x$ is sufficiently small, and the trigonometric identity__

\[
\sin x = 3 \sin \frac{x}{3} - 4 \sin^3 \frac{x}{3}
\]

__to reduce the size of the argument of $\sin$. (For the purposes of this exercise an angle is considered "sufficiently small" if its magnitude is not greater than 0.1 radians.) These ideas are incorporated in the following procedures:__

    (define (cube x) (* x x x))
    (define (p x) (- (* 3 x) (* 4 (cube x))))
    (define (sine angle)
      (if (not (> (abs angle) 0.1))
          angle
          (p (sine (/ angle 3.0)))))

__a. How many times is the procedure `p` applied when `(sine 12.15)` is evaluated?__

`p` is applied 5 times, once to each of 4.05, 1.35, 0.45, 0.15, and 0.05.

__b. What is the order of growth in space and number of steps (as a function of $a$) used by the process generated by the `sine` procedure when `(sine a)` is evaluated?__

Using $a = 12.15$ to estimate the algorithm complexity:

    (sine 12.15)
    ; (p (sine 4.05))
    ; (p (p (sine 1.35)))
    ; (p (p (p (sine 0.45))))
    ; (p (p (p (p (sine 0.15)))))
    ; (p (p (p (p (p (sine 0.05))))))
    ; (p (p (p (p (p 0.05)))))
    ; (p (p (p (p 0.149...))))
    ; (p (p (p 0.435...)))
    ; (p (p 0.975...))
    ; (p -0.789...)
    ; -0.399...

Based on this rudimentary analysis, it appears that `sine` grows linearly, in both time and space, with its argument.

### Exercise 1.16

__Design a procedure that evolves an iterative exponentiation process that uses successive squaring and uses a logarithmic number of steps, as does `fast-expt`. (__Hint:__ Using the observation that $(b^{n/2})^2 = (b^2)^{n/2}$, keep, along with the exponent $n$ and the base $b$, an additional state variable $a$, and define the state transformation in such a way that the product $a b^n$ is unchanged from state to state. At the beginning of the process $a$ is taken to be 1, and the answer is given by the value of $a$ at the end of the process. In general, the technique of defining an __invariant quantity__ that remains unchanged from state to state is a powerful way to think about the design of iterative algorithms.)__

    (define (log-iter-expt base exponent)
      (define (even n) (= (remainder n 2) 0))
      (define (helper b n a)
        (cond ((= n 0) a)
              ((even n) (helper (* b b) (/ n 2) a))
              (else (helper b (- n 1) (* b a)))))
      (helper base exponent 1))
