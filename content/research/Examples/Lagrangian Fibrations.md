Extension of [[Hamiltonian Space#^c4aead]], the problem is $X=G$ so it should be $G \times G$ - action.

For the Whittaker model (or $X = G$ and $G \times G$ acts on it) of $G = GL_3$, relevant Lagrangians are $\Lambda_{\mathcal O,\xi}/(N \times N) \subset J_G = J_X = J_{G_X} \isom T^*G//_{\xi,\xi}(N \times N)$ . On the other hand, $J_G \to \mathfrak c_G \isom \mathbb A^3$ (here's the problem) is another Lagrangian fibration. So we can explore their Lagrangian intersections:

Let
$$
G=\mathrm{GL}_3,
\qquad
\mathfrak c_G
\isom T^*G//(G \times G) =
\mathfrak g^*//G
\simeq
\mathbb A^3.
$$
Write
$$
p_c(t)
=
t^3+c_1t^2+c_2t+c_3,
\qquad
c=(c_1,c_2,c_3)\in\mathfrak c_G,
$$
and choose the companion-matrix Kostant section
$$
S(c)
=
\begin{pmatrix}
0&0&-c_3\\
1&0&-c_2\\
0&1&-c_1
\end{pmatrix}.
$$
Thus
$$
\det(tI-S(c))=p_c(t).
$$

Since $S(c)$ is regular cyclic, every element of its centralizer has
the form
$$
g
=
u_0I+u_1S+u_2S^2.
$$
Explicitly,
$$
g
=
\begin{pmatrix}
u_0&
-c_3u_2&
c_3(c_1u_2-u_1)
\\
u_1&
u_0-c_2u_2&
-c_2u_1+(c_1c_2-c_3)u_2
\\
u_2&
u_1-c_1u_2&
u_0-c_1u_1+(c_1^2-c_2)u_2
\end{pmatrix}.
$$
Hence
$$
J_G
=
\left\{
(c_1,c_2,c_3;u_0,u_1,u_2):
D(c,u)\neq0
\right\},
$$
where
$$
D(c,u)
:=
\det(u_0I+u_1S(c)+u_2S(c)^2).
$$

We shall also use
$$
\delta
:=
u_1^2-c_1u_1u_2+c_2u_2^2-u_0u_2
$$
and
$$
\epsilon
:=
u_0u_1-c_1u_0u_2+c_3u_2^2.
$$

The universal centralizer carries the projection
$$
p:J_G\longrightarrow\mathfrak c_G,
\qquad
(c,u)\longmapsto c.
$$
Its fiber over $c$ is
$$
\mathcal T_c
:=
p^{-1}(c)
=
Z_G(S(c)).
$$
Since
$$
\dim J_G=6,
\qquad
\dim \mathcal T_c=3,
$$
each $\mathcal T_c$ is a Lagrangian subvariety of $J_G$.

Thus
$$
\boxed{
J_G
\longrightarrow
\mathfrak c_G
}
$$
is the Toda Lagrangian fibration.

Let
$$
\Delta=\{\alpha_1,\alpha_2\}.
$$
The four relevant Bruhat types are indexed by
$$
I\subset\Delta.
$$
The corresponding strata in $J_G$, together with their parameter
maps, are
$$
\begin{array}{c|c|c}
I & J_I & q_I
\\ \hline
\varnothing
&
\{u_2\delta\neq0\}
&
\displaystyle
q_{\varnothing}
=
\left(
u_2,
-\frac{\delta}{u_2},
\frac{D}{\delta}
\right)
\\[3mm]
\{\alpha_1\}
&
\{u_2=0,\ u_1\neq0\}
&
\displaystyle
q_1
=
\left(
u_1,
\frac{D}{u_1^2}
\right)
\\[3mm]
\{\alpha_2\}
&
\{u_2\neq0,\ \delta=0\}
&
\displaystyle
q_2
=
\left(
u_2,
-\frac{\epsilon}{u_2}
\right)
\\[3mm]
\Delta
&
\{u_2=u_1=0\}
&
q_{12}=u_0.
\end{array}
$$

For fixed parameters, the fibers are the reduced
relevant-orbit Lagrangians.

For $I=\varnothing$, write the parameter as
$$
(A,B,C)\in(\mathbb G_m)^3.
$$
Then
$$
\boxed{
\mathcal R_{\varnothing,(A,B,C)}
=
\left\{
u_2=A,\quad
\delta=-AB,\quad
D=-ABC
\right\}.
}
$$

For $I=\{\alpha_1\}$, with parameter
$$
(a,b)\in(\mathbb G_m)^2,
$$
we have
$$
\boxed{
\mathcal R_{1,(a,b)}
=
\left\{
u_2=0,\quad
u_1=a,\quad
D=a^2b
\right\}.
}
$$

For $I=\{\alpha_2\}$,
$$
\boxed{
\mathcal R_{2,(a,b)}
=
\left\{
u_2=a,\quad
\delta=0,\quad
\epsilon=-ab
\right\}.
}
$$

For $I=\Delta$, with parameter $z\in\mathbb G_m$,
$$
\boxed{
\mathcal R_{12,z}
=
\left\{
u_2=0,\quad
u_1=0,\quad
u_0=z
\right\}.
}
$$

Every fixed
$$
\mathcal R_{I,a}\subset J_G
$$
has dimension $3$, and hence is Lagrangian.

Thus $J_G$ carries two Lagrangian systems:
$$
\boxed{
\begin{array}{ccccc}
&&J_G&&
\\[1mm]
&\swarrow p&&q\searrow&
\\[1mm]
\mathfrak c_G
&&&
\bigsqcup_{I\subset\Delta}A_I.
\end{array}}
$$

For
$$
\mathcal R_{12,z}
=
\{u_0=z,\ u_1=u_2=0\},
$$
we have
$$
\boxed{
\mathcal T_c\cap\mathcal R_{12,z}
=
\{(c;z,0,0)\}.
}
$$
Thus there is exactly one intersection point for every
$c\in\mathfrak c_G$.

In fact
$$
\mathcal R_{12,z}
\simeq
\mathfrak c_G
$$
is a Lagrangian section of the Toda fibration.

Fix
$$
(a,b)\in(\mathbb G_m)^2.
$$
The equations are
$$
u_2=0,
\qquad
u_1=a,
\qquad
D=a^2b.
$$
Set
$$
y:=-\frac{u_0}{a}.
$$
Then
$$
u_0I+u_1S
=
a(S-yI).
$$
Therefore
$$
D
=
a^3\det(S-yI)
=
-a^3p_c(y).
$$
Hence
$$
D=a^2b
\quad\Longleftrightarrow\quad
p_c(y)=-\frac ba.
$$

Consequently,
$$
\boxed{
\mathcal T_c\cap\mathcal R_{1,(a,b)}
=
\left\{
(-ay,a,0):
p_c(y)+\frac ba=0
\right\}.
}
$$
Scheme-theoretically,
$$
\boxed{
\mathcal T_c\cap\mathcal R_{1,(a,b)}
\simeq
\operatorname{Spec}
\frac{k[y]}
{\left(p_c(y)+b/a\right)}.
}
$$
Thus the generic intersection consists of three points:
$$
\boxed{
\#\left(
\mathcal T_c\cap\mathcal R_{1,(a,b)}
\right)
=3.
}
$$

Non-transversality occurs precisely when
$$
\boxed{
p_c(y)+\frac ba=0,
\qquad
p_c'(y)=0.
}
$$
Equivalently,
$$
\boxed{
\operatorname{Disc}_y
\left(
p_c(y)+\frac ba
\right)
=0.
}
$$

The local intersection multiplicity is the multiplicity of $y$ as a
root of
$$
p_c(t)+\frac ba.
$$

Fix
$$
(a,b)\in(\mathbb G_m)^2.
$$
We impose
$$
u_2=a,
\qquad
\delta=0,
\qquad
\epsilon=-ab.
$$
Set
$$
y:=\frac{u_1}{a}-c_1.
$$
Then
$$
u_1=a(y+c_1).
$$
The equation $\delta=0$ gives
$$
u_0
=
a(y^2+c_1y+c_2).
$$
Substituting into $\epsilon$, one obtains
$$
\epsilon=a^2p_c(y).
$$
Thus
$$
\epsilon=-ab
\quad\Longleftrightarrow\quad
p_c(y)=-\frac ba.
$$

Therefore
$$
\boxed{
\mathcal T_c\cap\mathcal R_{2,(a,b)}
=
\left\{
a
\left(
y^2+c_1y+c_2,\,
y+c_1,\,
1
\right):
p_c(y)+\frac ba=0
\right\}.
}
$$
Again,
$$
\boxed{
\#\left(
\mathcal T_c\cap\mathcal R_{2,(a,b)}
\right)
=3
}
$$
generically, and non-transversality occurs when
$$
\boxed{
p_c(y)+\frac ba=0,
\qquad
p_c'(y)=0.
}
$$

There is a direct relation between the $I=\{\alpha_1\}$ and
$I=\{\alpha_2\}$ intersection points. Define
$$
g_1(y):=a(S-yI).
$$
Then
$$
g_2(y)
=
a\frac{p_c(S)-p_c(y)}{S-yI}.
$$
Since
$$
p_c(S)=0,
$$
we obtain
$$
g_2(y)
=
a
\left[
S^2+(y+c_1)S
+
(y^2+c_1y+c_2)I
\right].
$$
Moreover,
$$
g_1(y)g_2(y)
=
-a^2p_c(y)I.
$$
On the intersection locus
$$
p_c(y)=-\frac ba,
$$
hence
$$
\boxed{
g_1(y)g_2(y)=abI.
}
$$
Equivalently,
$$
\boxed{
g_2(y)=ab\,g_1(y)^{-1}.
}
$$

Thus the two maximal-parabolic Lagrangian systems have canonically
paired intersection points, related by inversion in the universal
centralizer group.

Fix
$$
(A,B,C)\in(\mathbb G_m)^3.
$$
The equations defining
$\mathcal R_{\varnothing,(A,B,C)}$ are
$$
u_2=A,
\qquad
\delta=-AB,
\qquad
D=-ABC.
$$
Introduce
$$
r:=\frac BA,
\qquad
s:=\frac CB,
\qquad
x:=\frac{u_1}{A}.
$$
The equation
$$
\delta=-AB
$$
gives
$$
\frac{u_0}{A}
=
h,
\qquad
h
:=
x^2-c_1x+c_2+r.
$$
Thus
$$
\boxed{
u_0=A h,\qquad
u_1=Ax,\qquad
u_2=A.
}
$$

Define
$$
q(t)
:=
\frac1A
\left(
u_0+u_1t+u_2t^2
\right)
=
t^2+xt+h.
$$

Euclidean division gives
$$
p_c(t)
=
(t+c_1-x)q(t)-r(t-y),
$$
where
$$
\boxed{
y
=
\frac{(x-c_1)h+c_3}{r}.
}
$$

Since
$$
D
=
A^3\operatorname{Res}(p_c,q),
$$
the Euclidean algorithm yields
$$
\frac{D}{A^3}
=
r^2q(y).
$$
On the other hand,
$$
D=-ABC=-A^3r^2s.
$$
Therefore
$$
q(y)=-s,
$$
i.e.
$$
\boxed{
y^2+xy+h+s=0.
}
$$

Set
$$
h(x)
=
x^2-c_1x+c_2+r,
$$
$$
y(x)
=
\frac{(x-c_1)h(x)+c_3}{r},
$$
and define
$$
\boxed{
F_{c;r,s}(x)
:=
r^2
\left(
y(x)^2+x\,y(x)+h(x)+s
\right).
}
$$
Then $F_{c;r,s}(x)$ is a monic polynomial of degree $6$.

Hence
$$
\boxed{
\mathcal T_c\cap
\mathcal R_{\varnothing,(A,B,C)}
\simeq
\operatorname{Spec}
\frac{k[x]}
{\left(F_{c;r,s}(x)\right)}.
}
$$
The corresponding point in $J_G$ is
$$
\boxed{
(u_0,u_1,u_2)
=
A(h(x),x,1).
}
$$
Thus generically
$$
\boxed{
\#\left(
\mathcal T_c
\cap
\mathcal R_{\varnothing,(A,B,C)}
\right)
=6.
}
$$

The equations admit the alternative form
$$
q(t)
=
(t+x+y)(t-y)-s,
$$
and hence
$$
\boxed{
p_c(t)
=
(t+c_1-x)
\left(
(t+x+y)(t-y)-s
\right)
-r(t-y).
}
$$
Equivalently,
$$
p_c(t)
=
\det
\left(
tI-
L(x,y;r,s)
\right),
$$
where
$$
\boxed{
L(x,y;r,s)
=
\begin{pmatrix}
x-c_1&1&0\\
r&-x-y&1\\
0&s&y
\end{pmatrix}.
}
$$

Thus
$$
\boxed{
\mathcal T_c\cap
\mathcal R_{\varnothing,(A,B,C)}
}
$$
is the inverse-spectral problem for the open Toda matrix
$L(x,y;r,s)$ with fixed couplings
$$
r=\frac BA,
\qquad
s=\frac CB
$$
and fixed characteristic polynomial $p_c(t)$.

The intersection fails to be transverse precisely when
$$
\boxed{
F_{c;r,s}(x)=0,
\qquad
F_{c;r,s}'(x)=0.
}
$$
Equivalently,
$$
\boxed{
\operatorname{Disc}_xF_{c;r,s}=0.
}
$$

The generic intersection numbers of the two Lagrangian systems are
$$
\boxed{
\begin{array}{c|c|c}
I
&
L_I
&
\#\left(
\mathcal T_c\cap\mathcal R_{I,a}
\right)
\\ \hline
\varnothing
&
T
&
6
\\
\{\alpha_1\}
&
\mathrm{GL}_2\times\mathrm{GL}_1
&
3
\\
\{\alpha_2\}
&
\mathrm{GL}_1\times\mathrm{GL}_2
&
3
\\
\Delta
&
G
&
1.
\end{array}}
$$
These numbers satisfy
$$
\boxed{
\#\left(
\mathcal T_c\cap\mathcal R_{I,a}
\right)
=
\frac{|W_G|}{|W_{L_I}|}.
}
$$
Indeed,
$$
W_G=S_3,
$$
and hence
$$
\frac{|S_3|}{1}=6,
\qquad
\frac{|S_3|}{|S_2|}=3,
\qquad
\frac{|S_3|}{|S_2|}=3,
\qquad
\frac{|S_3|}{|S_3|}=1.
$$

Thus
$$
\boxed{
6,\ 3,\ 3,\ 1
=
|W_G/W_{L_I}|.
}
$$

The Kostant base
$$
\mathfrak c_G\simeq\mathbb A^3
$$
has the Levi stratification
$$
\boxed{
\mathfrak c_G
=
\mathfrak c_G^{[(1,1,1)]}
\sqcup
\mathfrak c_G^{[(2,1)]}
\sqcup
\mathfrak c_G^{[(3)]},
}
$$
where
$$
\mathfrak c_G^{[(1,1,1)]}
=
\left\{
p_c(t):
p_c
\text{ has three distinct roots}
\right\},
$$
$$
\mathfrak c_G^{[(2,1)]}
=
\left\{
p_c(t)
=
(t-\lambda)^2(t-\mu),
\quad
\lambda\neq\mu
\right\},
$$
and
$$
\mathfrak c_G^{[(3)]}
=
\left\{
p_c(t)
=
(t-\lambda)^3
\right\}.
$$

Equivalently,
$$
\operatorname{Disc}(p_c)\neq0
$$
on the open Levi stratum, whereas
$$
\operatorname{Disc}(p_c)=0
$$
on the two lower strata.

This discriminant is different from the discriminant governing
non-transverse intersection of the two Lagrangian systems.

For the maximal-parabolic relevant families, tangency occurs when
$$
\boxed{
\operatorname{Disc}
\left(
p_c(t)+\frac ba
\right)
=0,
}
$$
not when
$$
\operatorname{Disc}(p_c)=0.
$$

For example, at the deepest Levi point
$$
p_c(t)=t^3,
$$
the intersection equation becomes
$$
y^3=-\frac ba.
$$
If $a,b\neq0$, this has three distinct roots over an algebraically
closed field of characteristic zero. Hence the two Lagrangians may
intersect transversely even over the deepest Levi stratum.

Thus there are two distinct discriminant structures:
$$
\boxed{
\begin{aligned}
\operatorname{Disc}(p_c)=0
&\qquad
&&\text{degeneration of the Toda fiber},\\
\operatorname{Disc}\left(p_c+b/a\right)=0
&\qquad
&&\text{tangency of the maximal-parabolic
Lagrangian systems},\\
\operatorname{Disc}_xF_{c;r,s}=0
&\qquad
&&\text{tangency of the open relevant
Lagrangian system}.
\end{aligned}}
$$

The relevant strata of $J_G$ are
$$
J_{\varnothing}
=
\{u_2\delta\neq0\},
$$
$$
J_{\alpha_1}
=
\{u_2=0,\ u_1\neq0\},
$$
$$
J_{\alpha_2}
=
\{u_2\neq0,\ \delta=0\},
$$
and
$$
J_{\Delta}
=
\{u_2=u_1=0\}.
$$
Their closure pattern is
$$
\boxed{
\begin{array}{ccccc}
&&J_{\varnothing}&&
\\
&\swarrow&&\searrow&
\\
J_{\alpha_1}
&&&&
J_{\alpha_2}
\\
&\searrow&&\swarrow&
\\
&&J_{\Delta}.&&
\end{array}}
$$

Thus the Bruhat degeneration of relevant orbits gives the boundary
stratification of the second Lagrangian system, whereas the root
collision
$$
\operatorname{Disc}(p_c)=0
$$
gives the Levi stratification of the first Lagrangian system.

For each $I\subset\Delta$, define the incidence variety
$$
\boxed{
\mathcal I_I
:=
\left\{
(c,a,z):
z\in
\mathcal T_c\cap\mathcal R_{I,a}
\right\}.
}
$$
It has a natural projection
$$
\boxed{
\pi_I:
\mathcal I_I
\longrightarrow
\mathfrak c_G\times A_I.
}
$$
Generically, this map is finite of degree
$$
\boxed{
\deg\pi_I
=
\frac{|W_G|}{|W_{L_I}|}.
}
$$
For $G=\mathrm{GL}_3$,
$$
\boxed{
\deg\pi_{\varnothing}=6,
\qquad
\deg\pi_{\alpha_1}=3,
\qquad
\deg\pi_{\alpha_2}=3,
\qquad
\deg\pi_{\Delta}=1.
}
$$

Its ramification locus is precisely the locus where the Toda
Lagrangian
$$
\mathcal T_c
$$
and the relevant-orbit Lagrangian
$$
\mathcal R_{I,a}
$$
fail to intersect transversely.

Hence the universal centralizer of $\mathrm{GL}_3$ carries two
distinct Lagrangian structures:
$$
\boxed{
\begin{aligned}
\{\mathcal T_c\}_{c\in\mathfrak c_G}
&:
&&
\text{the Toda/Kostant Lagrangian fibration},
\\
\{\mathcal R_{I,a}\}_{I,a}
&:
&&
\text{the stratified relevant-orbit Lagrangian system}.
\end{aligned}}
$$
Their common geometry is encoded by
$$
\boxed{
\mathcal I_I
=
\left\{
(c,a,z):
z\in
\mathcal T_c\cap\mathcal R_{I,a}
\right\},
}
$$
with generic intersection number
$$
\boxed{
\#\left(
\mathcal T_c\cap\mathcal R_{I,a}
\right)
=
|W_G/W_{L_I}|.
}
$$
