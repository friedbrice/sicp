# Answers to Exercises in _Structure and Interpretation of Computer Programs_

## Chapter 1

### Exercise 1.1

_Below is a sequence of expressions. What is the result printed by the interpreter in response to each expression? Assume that the sequence is to be evaluated in the order in which it is presented._

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

_Translate the following expression into prefix form_

\begin{equation*}
\frac{5 + 4 + (2 - (3 - (6 + \frac{4}{5})))}{3(6 - 2)(2 - 7)}
\end{equation*}

In prefix notation, the expression is

    (/ (+ 5 4 (- 2 (- 3 (+ 6 (/ 4 5))))) (* 3 (- 6 2) (- 2 7)))

### Exercise 1.3

_Define a procedure that takes three numbers as arguments and returns the sum of the squares of the two larger numbers._

    (define (f x y z)
            (cond ((and (< z x) (< z y)) (+ (square x) (square y)))
                  ((and (< x y) (< x z)) (+ (square y) (square z)))
                  (else (+ (square z) (square x)))))

### Exercise 1.4

_Observe that our model of evaluation allows for combinations whose operators are compound expressions. Use this observation to describe the behavior of the following procudeure:_

    (define (a-plus-abs-b a b)
      ((if (> b 0) + -) a b))

`a-plus-abs-b <x> <y>` resolves to an expression whose operator is an `if` clause. Our model of execution evaluates the operator first, then evaluates each argument, so we will evaluate the `if` clause `(if (> <x> 0) + -)` before evaluating `<x>` and `<y>` (though this particular `if` clause forces the evaluation of `<x>`, and furthermore the call to `a-plus-abs-b` has already evaluated `<x>` and `<y>` before resolving). An equivalent way to write the procedure would be:

    (define (a-plus-abs-b a b)
      ((if (> b 0) (+ a b) (- a b))))

Basically, we observe that procedures are first-class values that can stand on their own apart from an evaluation statement.

### Exercise 1.5

_Ben Bitdiddle has invented a test to determine whether the interpreter he is faced with is using applicative-order evaluation or normal-order evaluation. He defines the following two procedures:_

    (define (p) (p))

    (define (test x y)
      (if (= x 0)
          0
          y))

_Then he evaluates the expression_

    (test 0 (p))

_What behavior will Ben observe with an interpreter that uses applicative-order evaluation? What behavior will he observe with an interpreter that uses normal-order evaluation? Explain your answer. (Assume that the evaluation rule for the special form if is the same whether the interpreter is using normal or applicative order: The predicate expression is evaluated first, and the result determines whether to evaluate the consequent or the alternative expression.)_

An applicative-order interpreter will evaluate arguments before attempting to resolve an operator. As applied to `(test 0 (p))`, an applicative-order interpreter will evaluate the argument `0` (already in normal form) and the argument `(p)` (causing an infinite descent) before resolving the operator `test`.

A normal-order interpreter will resolve operators before evaluating arguments. As applied to `(test 0 (p))`, a normal-order interpreter will resolve `test` first, yielding `(if (= 0 0) 0 (p))`. The `if` form is special in that it only ever evaluates either its alternative or, in this case, its consequent, so the call to evaluate `p` is ignored and the procedure returns `0`.

### Exercise 1.6

_Alyssa P. Hacker doesn't see why `if` needs to be provided as a special form. "Why can't I just define it as an ordinary procedure in terms of `cond`?" she asks. Alyssa's friend Eva Lu Ator claims this can indeed be done, and she defines a new version of `if`:_

    (define (new-if predicate then-clause else-clause)
      (cond (predicate then-clause)
            (else else-clause)))

_Eva demonstrates the program for Alyssa:_

    (new-if (= 2 3) 0 5)
    ; 5

    (new-if (= 1 1) 0 5)
    ; 0

_Delighted, Alyssa uses `new-if` to rewrite the square-root program:_

    (define (sqrt-iter guess x)
      (new-if (good-enough? guess x)
              guess
              (sqrt-iter (improve guess x)
                         x)))

_What happens when Alyssa attempts to use this to compute square roots? Explain._

Alyssa's program fails to terminate. `new-if` evaluates its three arguments before it is resolved, so every call to `square-iter` causes exactly one more call to `square-iter`.

### Exercise 1.7

_The `good-enough?` test used in computing square roots will not be very effective for finding the square roots of very small numbers. Also, in real computers, arithmetic operations are almost always performed with limited precision. This makes our test inadequate for very large numbers. Explain these statements, with examples showing how the test fails for small and large numbers. An alternative strategy for implementing `good-enough?` is to watch how `guess` changes from one iteration to the next and to stop when the change is a very small fraction of the guess. Design a `square-root` procedure that uses this kind of end test. Does this work better for small and large numbers?_

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

There is no problem for "very small numbers" other than round-off error, since the average between one and a number close to 0 is a number close to 0.5, which is well outside the tolerance of 0.001.

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

_Newton's method for cube roots is based on the fact that if $y$ is an approximation to the cube root of $x$, then a better approximation is given by the value_

\begin{equation*}
\frac{x/y^2 + 2y}{3}
\end{equation*}

_Use this formula to implement a cube-root procedure analogous to the square-root procedure. (In section 1.3.4 we will see how to implement Newton's method in general as an abstraction of these square-root and cube-root procedures.)_

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

_Each of the following two procedures defines a method for adding two positive integers in terms of the procedures `inc`, which increments its argument by 1, and `dec`, which decrements its argument by 1._

    (define (+ a b)
      (if (= a 0)
          b
          (inc (+ (dec a) b))))

    (define (+ a b)
      (if (= a 0)
          b
          (+ (dec a) (inc b))))

_Using the substitution model, illustrate the process generated by each procedure in evaluating `(+ 4 5)`. Are these processes iterative or recursive?_

**First Implementation:**

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

**Second Implementation:**

    (+ 4 5)
    ; (+ 3 6)
    ; (+ 2 7)
    ; (+ 1 8)
    ; (+ 0 9)
    ; 9

This implementation is a linear iterative process.

### Exercise 1.10

_The following procedure computes a mathematical function called Ackermann's function._

    (define (A x y)
      (cond ((= y 0) 0)
            ((= x 0) (* 2 y))
            ((= y 1) 2)
            (else (A (- x 1)
                     (A x (- y 1))))))

_What are the values of the following expressions?_

    (A 1 10)

    (A 2 4)

    (A 3 3)

_Consider the following procedures, wehre `A` is the procedure defined above:_

    (define (f n) (A 0 n))

    (define (g n) (A 1 n))

    (define (h n) (A 2 n))

    (define (k n) (* 5 n n))

_Give concise mathematical definitions for the functions computed by the procedures `f`, `g`, and `h` for positive integer values `n`. For example, `(k n)` computes $5n^2$._

Obviously, $A(0, n) = 2n$.

**Proposition:** For $n > 0$, $A(1, n) = 2^n$.

Notice $A(1, 1) = 2 = 2^1$. Now, assume for induction that $A(1, k) = 2^k$ for some $k$. Then

\begin{equation*}
A(1, k + 1) = A(0, A(1, k)) = 2 A(1, k) = 2 \cdot 2^k = 2^{k + 1}
\end{equation*}

as desired. $\blacksquare$

**Proposition:** For $n > 0$, $A(2, n) = \underbrace{2^{2^{.^{.^{.^2}}}}}_{n}$.

First, $A(2, 1) = 2$. Now, assume for induction that $A(2, k) = \underbrace{2^{2^{.^{.^{.^2}}}}}_{k}$ for some $k$. Then

\begin{equation*}
A(2, k + 1) = A(1, A(2, k)) = 2^{A(2, k)} = 2^{\underbrace{2^{2^{.^{.^{.^2}}}}}_{k}} = \underbrace{2^{2^{.^{.^{.^2}}}}}_{k + 1}
\end{equation*}

as desired. $\blacksquare$

Now, we evaluate

\begin{equation*}
A(1, 10) = 2^{10}
\end{equation*}

\begin{equation*}
A(2, 4) = 2^{2^{2^2}}
\end{equation*}

\begin{equation*}
A(3, 2) = A(2, A(3, 1)) = \underbrace{2^{2^{.^{.^{.^2}}}}}_{A(3, 1)} = \underbrace{2^{2^{.^{.^{.^2}}}}}_{2} = 2^2 = 4
\end{equation*}

\begin{equation*}
A(3, 3) = A(2, A(3, 2)) = \underbrace{2^{2^{.^{.^{.^2}}}}}_{A(3, 2)} = \underbrace{2^{2^{.^{.^{.^2}}}}}_{4} = 2^{2^{2^2}}
\end{equation*}

### Exercise 1.11

_A function $f$ is defined by the rule that $f(n) = n$ if $n < 3$ and $f(n) = f(n - 1) + 2f(n - 2) + 3f(n - 3)$ if $n \geq 3$. Write a procedure that computes $f$ by means of a recursive process. Write a procedure that computes $f$ by means of an iterative process._

**Recursive Process:**

    (define (f n)
      (cond ((< n 3) n)
            (else (+ (f (- n 1))
                     (* 2 (f (- n 2)))
                     (* 3 (f (- n 3)))))))

**Iterative Process:**

    (define (f n)
      (define (g x y z)
        (+ z (* 2 y) (* 3 x)))
      (define (h i x y z)
        (if (= i 0)
          x
          (h (- i 1) y z (g x y z))))
      (h n 0 1 2))

### Exercise 1.12

_The following pattern of numbers is called _Pascal's triangle_._

        1
       1 1
      1 2 1
     1 3 3 1
    1 4 6 4 1
       ...

_The numbers at the edge of the triangle are all 1, and each number inside the triangle is the sum of the two numbers above it. Write a procedure that computes elements of Pascal's triangle by means of a recursive process._

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

_Prove that $Fib(n)$ is the closest integer to $\phi^n / \sqrt{5}$, where $\phi = (1 + \sqrt{5}) / 2$. _Hint:_ Let $\psi = (1 - \sqrt{5}) / 2$. Use induction and the definition of the Fibonacci numbers (see section 1.2.2) to prove that $Fib(n) = (\phi^n - \psi^n) / \sqrt{5}$._

**Proposition:** For $n \geq 0$, $Fib(n) = \frac{\phi^n - \psi^n}{\sqrt{5}}$.

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
\psi^{-1} + \psi^{-2} &= \frac{2}{1 - \sqrt{5}}
                       + \frac{4}{(1 - \sqrt{5})^2} \\
                      &= \frac{2(1 - \sqrt{5}) + 4}{(1 - \sqrt{5})^2} \\
                      &= \frac{6 - 2 \sqrt{5}}{6 - 2 \sqrt{5}} = 1
\end{align*}

completing the proof. $\blacksquare$

**Proposition:** $Fib(n)$ is the closest integer to $\phi^n / \sqrt{5}$.

First, notice that when $n \geq 0$ we have $\psi^n / \sqrt{5} < 1/2$, so when $n \geq 0$,

\begin{align*}
Fib(n)
  &= \phi^n / \sqrt{5} - \psi^n / \sqrt{5} \\
Fib(n) - \phi^n / \sqrt{5}
  &= - \psi^n / \sqrt{5} \\
\left\vert Fib(n) - \phi^n / \sqrt{5} \right\vert
  &= \psi^n / \sqrt{5} < 1/2
\end{align*}

which is what we wanted to show. $\blacksquare$

### Exercise 1.14

_Draw the tree illustrating the process generated by the `count-change` procedure of section 1.2.2 in making change for 11 cents. What are the orders of growth of the space and number of steps used by this process as the amount to be changed increases?_

    ;; TODO

### Exercise 1.15

_The sine of an angle (specified in radians) can be computed by making use of the approximation $\sin x \approx x$ if $x$ is sufficiently small, and the trigonometric identity_

\begin{equation*}
\sin x = 3 \sin \frac{x}{3} - 4 \sin^3 \frac{x}{3}
\end{equation*}

_to reduce the size of the argument of $\sin$. (For the purposes of this exercise an angle is considered "sufficiently small" if its magnitude is not greater than 0.1 radians.) These ideas are incorporated in the following procedures:_

    (define (cube x) (* x x x))
    (define (p x) (- (* 3 x) (* 4 (cube x))))
    (define (sine angle)
      (if (not (> (abs angle) 0.1))
          angle
          (p (sine (/ angle 3.0)))))

_a. How many times is the procedure `p` applied when `(sine 12.15)` is evaluated?_

`p` is applied 5 times, once for each of 4.05, 1.35, 0.45, 0.15, and 0.05.

_b. What is the order of growth in space and number of steps (as a function of $a$) used by the process generated by the `sine` procedure when `(sine a)` is evaluated?_

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

_Design a procedure that evolves an iterative exponentiation process that uses successive squaring and uses a logarithmic number of steps, as does `fast-expt`. (_Hint:_ Using the observation that $(b^{n/2})^2 = (b^2)^{n/2}$, keep, along with the exponent $n$ and the base $b$, an additional state variable $a$, and define the state transformation in such a way that the product $a b^n$ is unchanged from state to state. At the beginning of the process $a$ is taken to be 1, and the answer is given by the value of $a$ at the end of the process. In general, the technique of defining an _invariant quantity_ that remains unchanged from state to state is a powerful way to think about the design of iterative algorithms.)_

    (define (log-iter-expt base exponent)
      (define (even n) (= (remainder n 2) 0))
      (define (square x) (* x x))
      (define (helper acc b n)
        (cond ((= n 0) acc)
              ((even n) (helper acc (square b) (/ n 2)))
              (else (helper (* b acc) b (- n 1)))))
      (helper 1 base exponent))

### Exercise 1.17

_The exponentiation algorithms in this section are based on performing exponentiation by means of repeated multiplication. In a similar way, one can perform integer multiplication by means of repeated addition. The following multiplication procedure (in which it is assumed that our language can only add, not multiply) is analogous to the `expt` procedure:_

    (define (* a b)
      (if (= b 0)
          0
          (+ a (* a (- b 1)))))

_This algorithm takes a number of steps that is linear in `b`. Now suppose we include, together, with addition, operations `double`, which doubles an integer, and `halve`, which divides an (even) integer by 2. Using these, design a multiplication procedure analogous to `fast-expt` that uses a logarithmic number of steps._

    (define (fast-mult a b)
      (cond ((= b 0) 0)
            ((even b) (double (fast-mult a (halve b))))
            (else (* a (fast-mult a (- b 1))))))

### Exercise 1.18

_Using the results of exercises 1.16 and 1.17, devise a procedure that generates an iterative process for multiplying two integers in terms of adding, doubling, and halving and uses a logarithmic number of steps._

    (define (log-iter-mult left right)
      (define (even n) (= (remainder n 2) 0))
      (define (double n) (+ n n))
      (define (halve n) (/ n 2))
      (define (helper acc b n)
        (cond ((= n 0) acc)
              ((even n) (helper acc (double b) (halve n)))
              (else (helper (+ b acc) b (- n 1)))))
      (if (> left right) (helper 0 left right) (helper 0 right left)))

### Exercise 1.19

_There is a clevar algorithm for computing the Fibonacci numbers in a logarithmic number of steps. Recall the transformation of the state variables $a$ and $b$ in the `fib-iter` process of section 1.2.2: $a \leftarrow a + b$ and $b \leftarrow a$. Call this transformation $T$, and observe that applying $T$ over and over again $n$ times, starting with 1 and 0, produces the pair $Fib(n + 1)$ and $Fib(n)$. In other words, the Fibonacci numbers are produced by applying $T^n$, the $n$th power of the transformation $T$, starting with the pair $(1, 0)$. Now consider $T$ to be the special case of $p = 0$ and $q = 1$ in a family of transformations $T_{pq}$, where $T_{pq}$ transforms the pair $(a, b)$ according to $a \leftarrow bq + aq + ap$ and $b \leftarrow bp + aq$. Show that if we apply such a transformation $T_{pq}$ twice, the effect is the same as using a single transformation $T_{p'q'}$ of the same form, and computer $p'$ and $q'$ in terms of $p$ and $q$. This gives us an explicit way to square these transformations, and thus we can compute $T^n$ using successive squaring, as in the `fast-expt` procedure. Put this all together to complete the following procedure, which runs in a logarithmic number of steps:_

    (define (fib n)
      (fib-iter 1 0 0 1 n))
    (define (fib-iter a b p q count)
      (cond ((= count 0) b)
            ((even? count)
             (fib-iter a
                       b
                       <??>      ; compute p'
                       <??>      ; compute q'
                       (/ count 2)))
            (else (fib-iter (+ (* b q) (* a q) (* a p))
                            (+ (* b p) (* a q))
                            p
                            q
                            (- count 1)))))

Explicit computation gives

\begin{equation*}
p' = p^2 + q^2
\end{equation*}

and

\begin{equation*}
q' = 2pq + q^2
\end{equation*}

Thus, we have

    (define (fib n)
      (fib-iter 1 0 0 1 n))
    (define (fib-iter a b p q count)
      (cond ((= count 0) b)
            ((even? count)
             (fib-iter a
                       b
                       (+ (* p p) (* q q))
                       (+ (* 2 p q) (* q q))
                       (/ count 2)))
            (else (fib-iter (+ (* b q) (* a q) (* a p))
                            (+ (* b p) (* a q))
                            p
                            q
                            (- count 1)))))
