\documentclass[11pt]{article}

\usepackage[T1]{fontenc}
\usepackage{lmodern}
\usepackage[a4paper,margin=1in]{geometry}
\usepackage{amsmath,amssymb,amsthm}
\usepackage[hidelinks]{hyperref}
\usepackage{microtype}

\newtheorem{proposition}{Proposition}
\DeclareMathOperator{\SO}{SO}
\DeclareMathOperator{\Sp}{Sp}
\DeclareMathOperator{\End}{End}
\DeclareMathOperator{\Span}{span}
\DeclareMathOperator{\Ad}{Ad}
\DeclareMathOperator{\wt}{wt}
\newcommand{\A}{\mathbb A}
\newcommand{\g}{\mathfrak g}
\newcommand{\h}{\mathfrak h}
\newcommand{\red}{\mathbin{/\mkern-6mu/}}

\title{Bessel reduction of the generalized Shalika Hamiltonian space}
\author{}
\date{}

\begin{document}
\maketitle

We work over a field \(k\) of characteristic zero. All groups are split,
and the character normalizations are chosen compatibly as specified below.
The subscript \(\lambda\) in a twisted cotangent space denotes an algebraic
character, or its differential. Over a local field with a fixed additive
character \(\psi\), the corresponding analytic character is
\(\psi\circ\lambda\). We use compatible trace pairings and conventions
for which the residual moment maps have the forms written below.

\begin{proposition}\label{prop:main}
Let
\[
G=\SO_{4n},\qquad n\geq 2,
\]
and let \(S_{\mathrm{gSh}}=\Sp_{2n}\ltimes U_S\) be its generalized
Shalika subgroup, where \(U_S\) is the unipotent radical of the Siegel
parabolic. Let \(\lambda_S\) be the standard generalized Shalika
character, and put
\[
M=T^*_{\lambda_S}(S_{\mathrm{gSh}}\backslash G).
\]
Let \((U_B,\lambda_B)\) be the Bessel datum associated with the nilpotent
partition
\[
[\,2n-1,1^{2n+1}\,],
\]
whose residual group is \(H=\SO_{2n+1}\). For the compatible principal
Whittaker datum \((N_H,\lambda_H)\) specified in the proof, there is an
\(H\)-equivariant symplectic isomorphism
\[
\boxed{
M\red_{\lambda_B}U_B
\simeq
T^*_{\lambda_H}(N_H\backslash H).
}
\]
It preserves the \(H\)-moment maps and is defined over the entire
adjoint quotient.
\end{proposition}

\begin{proof}
Let \((W,\omega)\) be a symplectic space of dimension \(2n\), and equip
\[
V=W\oplus W
\]
with the symmetric form
\[
B((v,w),(v',w'))
=\omega(v,w')-\omega(w,v').
\]
Thus \(G=\SO(V)\). Write
\[
\mathcal A=\{A\in\End(W):A^\dagger=A\},
\]
where the adjoint is taken with respect to \(\omega\), and set
\[
x_A(v,w)=(Aw,v).
\]
The self-adjointness of \(A\) implies that \(x_A\in\mathfrak{so}(V)\).

For the generalized Shalika triple, take
\[
f_S=\begin{pmatrix}0&0\\1&0\end{pmatrix},
\qquad
e_S=\begin{pmatrix}0&1\\0&0\end{pmatrix}.
\]
Its centralizer is \(\Sp(W)\), acting diagonally on \(V\). An element of
\(f_S+\g^{e_S}\) has the form
\[
\begin{pmatrix}D&A\\1&D\end{pmatrix},
\qquad
D\in\mathfrak{sp}(W),\quad A\in\mathcal A.
\]
The zero moment condition for \(\Sp(W)\) sets \(D=0\). The generalized
Whittaker slice presentation therefore gives
\begin{equation}\label{eq:shalika-slice}
M\simeq G\times^{\Sp(W)}\mathcal A,
\qquad
\mu_G([g,A])=gx_Ag^{-1}.
\end{equation}
This is the standard construction of generalized Whittaker Hamiltonian
spaces; see \cite[\S4.2.1]{GW}.

Choose the Bessel triple so that
\[
V=E\perp V_H,
\qquad
\dim E=2n-1,\quad \dim V_H=2n+1,
\]
with the triple acting principally on \(E\) and trivially on \(V_H\).
Then \(H=\SO(V_H)\). Let \(q_0\in E\) be a highest vector and put
\[
\varepsilon=B(q_0,f_B^{2n-2}q_0)\neq 0.
\]
By the Slodowy cross-section theorem,
\begin{equation}\label{eq:bessel-slice}
\mathcal R:=M\red_{\lambda_B}U_B
\simeq
\mu_G^{-1}(f_B+\g^{e_B}).
\end{equation}
Indeed, the action map identifies the character moment level in
\(\g^*\) with \(U_B\) times the slice; pulling back along \(\mu_G\)
and quotienting gives \eqref{eq:bessel-slice}.
See \cite[Lemma~2.1]{GG}.

For a representative \([g,A]\), write
\[
q=g^{-1}q_0=(v,w),\qquad x=x_A.
\]
If \(\xi\in f_B+\g^{e_B}\), the vectors
\[
q_0,\xi q_0,\ldots,\xi^{2n-2}q_0
\]
span \(E\), and their initial moments satisfy
\[
B(q_0,\xi^j q_0)=0\quad(j<2n-2),
\qquad
B(q_0,\xi^{2n-2}q_0)=\varepsilon.
\]
Since
\[
B(q,x^{2j}q)=2\omega(v,A^jw),
\qquad
B(q,x^{2j+1}q)=0,
\]
these conditions become
\begin{equation}\label{eq:initial-moments}
\omega(v,A^jw)=0\quad(0\leq j<n-1),
\qquad
\omega(v,A^{n-1}w)=\varepsilon/2.
\end{equation}

Set
\[
K=\Span(q,xq,\ldots,x^{2n-2}q).
\]
Its Gram matrix has zero entries before its anti-diagonal and fixed
nonzero anti-diagonal entries, so \(K\) is nondegenerate.

Conversely, suppose that \((A,v,w)\) satisfies
\eqref{eq:initial-moments}. Let \(C\) be the compression of \(x\) to
\(K\). Then
\[
C^iq=x^iq\qquad(0\leq i\leq 2n-2),
\]
so \(q\) is cyclic for \(C\). There is a unique isometry
\[
\alpha:K\xrightarrow{\sim}E
\]
carrying \((C,q)\) to the principal Kostant normal form with the same
characteristic polynomial and distinguished vector \(q_0\).
To verify this, map the two cyclic bases to one another: their initial
moments agree, and the Cayley--Hamilton relation determines all
subsequent moments.

Moreover, \(x\) sends
\[
\Span(q,\ldots,x^{2n-3}q)
\]
into \(K\). Thus its component \(K\to K^\perp\) is a vector times the
covector \(B(q,-)\). Under \(\alpha\), this is precisely the
off-diagonal term allowed in \(f_B+\g^{e_B}\).

Consequently, \(\mathcal R\) is the space of data
\begin{equation}\label{eq:frame-data}
(A,v,w,\beta),
\qquad
\beta:K^\perp\xrightarrow{\sim}V_H,
\end{equation}
satisfying \eqref{eq:initial-moments}, modulo \(\Sp(W)\), with the
orientation of \(\beta\) chosen so that
\(\alpha\oplus\beta\) belongs to \(G\).

We next determine the quotient of the triples \((A,v,w)\).
Because \(A\) is symplectically self-adjoint,
\[
\omega(A^iv,A^jv)=\omega(A^iw,A^jw)=0,
\]
whereas
\[
\omega(A^iv,A^jw)=\omega(v,A^{i+j}w).
\]
By \eqref{eq:initial-moments}, the cross-pairing matrix between
\[
v,Av,\ldots,A^{n-1}v
\quad\text{and}\quad
w,Aw,\ldots,A^{n-1}w
\]
has invertible anti-diagonal. Hence these \(2n\) vectors form a basis.

The two halves span Lagrangians \(L_v,L_w\). They are \(A\)-invariant:
for example, \(A^nv\) pairs trivially with every \(A^iv\), so it belongs
to \(L_v^\perp=L_v\). Self-adjointness identifies the two restrictions
of \(A\) as transpose operators. They therefore have the same monic
degree-\(n\) polynomial
\begin{equation}\label{eq:polynomial}
P(s)=s^n+c_1s^{n-1}+\cdots+c_n,
\qquad P(A)=0.
\end{equation}

The polynomial \(P\) determines the triple up to a unique symplectic
isomorphism. Explicitly, put
\[
R_P=k[s]/P(s),\qquad W_P=R_P\oplus R_P,
\]
take \(A\) to be multiplication by \(s\), and take
\(v=(1,0)\), \(w=(0,1)\). If \(\ell_P\) extracts the coefficient of
\(s^{n-1}\) from the degree-\(<n\) representative, the symplectic form is
\begin{equation}\label{eq:frobenius-pairing}
\omega_P((a,b),(c,d))
=\frac{\varepsilon}{2}\,\ell_P(ad-bc).
\end{equation}
This is nondegenerate and satisfies \eqref{eq:initial-moments}.
Thus
\begin{equation}\label{eq:triple-quotient}
\{(A,v,w)\text{ satisfying \eqref{eq:initial-moments}}\}/\Sp(W)
\simeq \A^n_{c_1,\ldots,c_n}.
\end{equation}

It remains to identify the residual \(H\)-moment map and the frame in
\eqref{eq:frame-data}. Let \(\pi_K,\rho\) denote orthogonal projection
onto \(K,K^\perp\), respectively, and define
\begin{equation}\label{eq:Z-r-u}
Z=\rho x|_{K^\perp},
\qquad
r=(w,0),
\qquad
u=\rho x^{2n-1}q.
\end{equation}
After applying \(\beta\), the \(H\)-moment map is
\(\beta Z\beta^{-1}\).

We claim that
\begin{equation}\label{eq:key-identities}
r\in K^\perp,
\qquad
Zu=0,
\qquad
P(Z^2)r=-\frac12u.
\end{equation}
First, direct calculation gives
\begin{equation}\label{eq:mixed-moments}
B(q,x^jr)=0\quad(j<2n-1),
\qquad
B(q,x^{2n-1}r)=\varepsilon/2.
\end{equation}
In particular, \(r\perp K\).

For any vector \(y\), the coefficient of \(x^{2n-2}q\) in \(\pi_Ky\)
is
\[
\frac{B(q,y)}{\varepsilon}.
\]
Using \eqref{eq:mixed-moments}, induction therefore gives
\begin{equation}\label{eq:projected-powers}
Z^jr=\rho x^jr\qquad(0\leq j\leq 2n-1).
\end{equation}
At the next step, the coefficient just computed is \(1/2\), so
\[
Z^{2n}r=\rho x^{2n}r-\frac12u.
\]
Together with \(P(x^2)=0\), this proves the last identity in
\eqref{eq:key-identities}.

Similarly, \(B(q,x^{2n-1}q)=0\), so \(\pi_Kx^{2n-1}q\) has no
\(x^{2n-2}q\)-component. Multiplying that projection by \(x\) stays
inside \(K\). Also \(x^{2n}q\in K\), by \eqref{eq:polynomial}.
Hence
\[
Zu=\rho x\bigl(x^{2n-1}q-\pi_Kx^{2n-1}q\bigr)=0.
\]

Now regard \(V\) as a module over
\[
k[t]/P(t^2),
\]
with \(t\) acting by \(x\). It is free of rank two with basis \(q,r\):
indeed, \((v,0),r\) is such a basis and
\[
q=(v,0)+tr.
\]
It follows from \eqref{eq:projected-powers} that
\[
r,Zr,\ldots,Z^{2n-1}r,u
\]
is a basis of \(K^\perp\). By \eqref{eq:key-identities}, \(r\) is
cyclic for \(Z\), and
\begin{equation}\label{eq:characteristic-polynomial}
\boxed{\det(t-Z)=tP(t^2).}
\end{equation}

The cyclic moments are
\begin{equation}\label{eq:target-moments}
B(r,Z^jr)=0\quad(j<2n),
\qquad
B(r,Z^{2n}r)=\varepsilon/4.
\end{equation}
For the first assertion, use \eqref{eq:projected-powers} and
\(B(r,x^jr)=0\). For the second, use \eqref{eq:key-identities} and
\[
B(r,u)=B(r,x^{2n-1}q)=-\varepsilon/2.
\]

Choose a principal triple for \(H\), together with a highest vector
\(r_0\in V_H\), normalized by
\[
B(r_0,f_H^{2n}r_0)=\varepsilon/4.
\]
These are the compatible target Whittaker data.
The normalization is possible over \(k\): the split odd-dimensional
forms in the two cyclic normal forms have the same discriminant, as
follows from \(V=E\perp V_H\) being split.
Let
\[
\kappa_H(P)\in f_H+\h^{e_H}
\]
be the Kostant representative with characteristic polynomial
\(tP(t^2)\).

Equations \eqref{eq:characteristic-polynomial} and
\eqref{eq:target-moments} give a unique isometry
\begin{equation}\label{eq:canonical-frame}
\gamma_P:K^\perp\xrightarrow{\sim}V_H,
\qquad
Z^ir\longmapsto \kappa_H(P)^ir_0
\quad(0\leq i\leq 2n).
\end{equation}
Indeed, the Gram matrices agree: skew-adjointness expresses their entries
through cyclic moments, and Cayley--Hamilton determines those moments
from \eqref{eq:characteristic-polynomial} and \eqref{eq:target-moments}.

The orientation sign in \eqref{eq:canonical-frame} is constant over
\(\A^n\). Replacing \(r_0\) by \(-r_0\), if necessary, makes it agree
with the orientation required in \eqref{eq:frame-data}. Thus every frame
\(\beta\) is uniquely
\[
\beta=h\gamma_P,\qquad h\in H.
\]
We obtain an algebraic isomorphism
\begin{equation}\label{eq:moment-preserving-isomorphism}
\mathcal R\simeq H\times\A^n,
\qquad
\mu_H(h,P)=h\kappa_H(P)h^{-1}.
\end{equation}
The principal Whittaker cross-section identifies the right-hand side
with \(T^*_{\lambda_H}(N_H\backslash H)\), with exactly this moment map.

All the constructions are algebraic over the entire coefficient space:
the relevant Gram determinants are fixed nonzero constants. The cyclic
basis arguments also work over arbitrary \(k\)-algebras, so the
identifications are scheme-theoretic. In particular, no discriminant
of \(P\) has been inverted.

Finally, we check the symplectic forms. Write \(h_S(t)\), \(h_B(t)\),
and \(h_H(t)\) for the cocharacters of the three triples. The natural
Kazhdan action on the Bessel reduction is induced by
\begin{equation}\label{eq:kazhdan-action}
[g,A]\longmapsto
[h_B(t)g h_S(t)^{-1},\,t^4A].
\end{equation}
Its symplectic form has weight \(2\), since the action is induced by
cotangent scaling of weight \(2\), combined with cotangent lifts of
group actions. On the polynomial coefficients it acts by
\[
c_i\longmapsto t^{4i}c_i.
\]
On the residual cyclic pair in \(V_H\) it acts by
\[
(Z,r)\longmapsto(t^2Z,t^{-2n}r).
\]
Because \eqref{eq:canonical-frame} is defined by these cyclic pairs,
\eqref{eq:moment-preserving-isomorphism} intertwines
\eqref{eq:kazhdan-action} with the usual Whittaker grading
\[
(h,P)\longmapsto
(hh_H(t)^{-1},\,t\cdot P).
\]
The target symplectic form also has weight \(2\).

Let \(\eta\) be the difference between the source symplectic form and
the pullback of the target form. The isomorphism is \(H\)-equivariant
and preserves moment maps, so
\[
\iota_{\xi_H}\eta=0
\qquad(\xi\in\h).
\]
It is also \(H\)-invariant. Hence, under
\eqref{eq:moment-preserving-isomorphism},
\[
\eta=\operatorname{pr}_{\A^n}^*\beta
\]
for a regular \(2\)-form \(\beta\) on \(\A^n\).

This form would have weight \(2\). But every coordinate \(c_i\), and
therefore every \(dc_i\), has weight at least \(4\). No regular
\(2\)-form of weight \(2\) exists. Thus \(\beta=0\), proving that
\eqref{eq:moment-preserving-isomorphism} is symplectic.
\end{proof}

\begin{thebibliography}{GG}

\bibitem{GG}
W.~L.~Gan and V.~Ginzburg,
\emph{Quantization of Slodowy slices},
International Mathematics Research Notices 2002, no.~5, 243--255.
\href{https://arxiv.org/abs/math/0105225}{arXiv:math/0105225}.

\bibitem{GW}
W.~T.~Gan and B.~Wang,
\emph{Generalised Whittaker models as instances of relative Langlands duality},
2023.
\href{https://arxiv.org/abs/2309.08874}{arXiv:2309.08874}.

\end{thebibliography}

\end{document}
