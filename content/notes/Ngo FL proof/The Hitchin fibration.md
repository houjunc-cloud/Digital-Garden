---
title: The Hitchin fibration
description: "Lecture notes for the talk on the Hitchin fibration (Ngô §4) in the Ngô fundamental lemma seminar (2026-10-30), combining the boards with the paper."
tags:
  - fundamental-lemma
  - hitchin-fibration
  - seminar-notes
stage: 🌱 seedling
date: 2026-10-30
---

# The Hitchin fibration

*Notes on the talk "Hitchin fibration", Ngô fundamental lemma seminar, 30 October 2026. Reference: B. C. Ngô, Le lemme fondamental pour les algèbres de Lie, Publ. Math. IHÉS 111 (2010), chapter 4, with numbering as in [arXiv:0801.0446](https://arxiv.org/abs/0801.0446). The previous talk is [[Affine Springer fibers and their symmetries]].*

**A Hitchin fiber globalizes the affine Springer fiber.** The formal disc becomes a smooth projective curve $X$, and the local characteristic polynomial becomes a section $a$ on $X$. Varying $a$ in a finite-dimensional base lets us study local degenerations in one family. After a local recap (§1), the boards cover the Hitchin map and its symmetries (§§2–3, Ngô §§4.1–4.3) and spectral and cameral curves (§§4–5, Ngô §§4.5–4.7). Figures 1–3 redraw the board diagrams. The dimension formulas, proof sketches and results in §6 use Ngô’s paper.

## 1. The local picture

### 1.1 Notation

Let $k=\mathbb F_q$ and let $X/k$ be smooth, projective and geometrically connected of genus $g$. Put $\bar X=X\otimes_k\bar k$ and $F=k(X)$. At a closed point $v\in|X|$, let $\mathcal O_v$ be the completed local ring, $F_v$ its fraction field and $k_v$ its residue field. The discs are given by
$$
X_v=\operatorname{Spec}\mathcal O_v,\qquad X_v^\bullet=\operatorname{Spec}F_v.
$$
The board writes $X_v^\times$ for the punctured disc. Figure 1(a) of the previous note draws the disc and its closed point.

Let $G/k$ be split reductive with Weyl group $W$ of order prime to $\operatorname{char}k$. We use the Chevalley map and Kostant section
$$
\mathfrak c=\mathfrak t/\!/W,\qquad
\chi:\mathfrak g\longrightarrow\mathfrak c,\qquad
\epsilon:\mathfrak c\longrightarrow\mathfrak g^{\mathrm{reg}},\qquad
\chi\circ\epsilon=\mathrm{id}.
$$
The board writes $\pi$ for the Chevalley map.

### 1.2 The regular orbit

Over an algebraically closed field the regular elements of a Chevalley fiber form one orbit.
$$
\chi^{-1}(a)\cap\mathfrak g^{\mathrm{reg}}\simeq G/J_a,
\qquad J_a=G_{\epsilon(a)}.
$$
Other orbits have smaller dimension. In the plane of Figure 2(b) of the previous note, the two punctured axes are the regular nilpotent locus for $\mathfrak{sl}_2$ and the origin is non-regular.

For $a\in\mathfrak c^\heartsuit(\mathcal O_v)$, the integral elements that are regular on the closed fiber likewise form one orbit over the completed unramified ring.
$$
\chi^{-1}(a)\cap\mathfrak g^{\mathrm{reg}}(\breve{\mathcal O}_v)
\simeq G(\breve{\mathcal O}_v)/J_a(\breve{\mathcal O}_v).
$$
Over $\mathcal O_v$, the regular orbit can split, with the splitting measured by cohomology over $k_v$.

![[../../attachments/hitchin-fibration-fig1-local-orbits.svg]]

*Figure 1. The map from integral, generically regular semisimple elements to their characteristic polynomials.*

The vertical slice over $a$ is partitioned into conjugacy orbits. The blue orbit contains $\epsilon(a)$, and the red orbits have non-regular reduction. In Figure 3 of the previous note each orbit becomes a point after taking the quotient.

### 1.3 Orbital integrals and the affine Springer fiber

For $\gamma\in\mathfrak g(F_v)$ regular semisimple with $\chi(\gamma)=a$, the rational orbit and its integral affine Springer points are given by
$$
\begin{aligned}
\operatorname{Ad}(G(F_v))\gamma &\simeq G(F_v)/G_\gamma(F_v),\\
\mathcal M_{\gamma,v}(k_v)
&=\{gG(\mathcal O_v)\mid\operatorname{Ad}(g^{-1})\gamma\in\mathfrak g(\mathcal O_v)\}.
\end{aligned}
$$
The orbital integral of $\mathbf 1_{\mathfrak g(\mathcal O_v)}$ sums over $G_\gamma(F_v)$-orbits in this fiber with inverse stabilizer volumes. Example 8.2 of the previous note computes the weights. For $\gamma=\gamma_0=\epsilon(a)$ put $\mathcal M_{a,v}=\mathcal M_{\gamma_0,v}$.

The stable orbit $(G/G_\gamma)(F_v)=\chi^{-1}(a)(F_v)$ can contain several rational orbits, indexed by
$$
\ker\bigl[H^1(F_v,G_\gamma)\longrightarrow H^1(F_v,G)\bigr].
$$
The $\kappa$-orbital integral weights these rational orbital integrals by a character (see [[Endoscopy]]).

In the moduli description, a point of $\mathcal M_{a,v}$ is a pair $(E,\phi)$ on the disc with a trivialization $\tau:(E,\phi)|_{X_v^\bullet}\simeq(E_0,\gamma_0)$, also in families (Definition 1.1 of the previous note). The symmetry $\mathcal P_{a,v}$ consists of $J_{a,v}=a^*J$-torsors on the disc trivialized on the punctured disc. Its geometric points and its orbit through the Kostant object are
$$
\mathcal P_{a,v}(\bar k)=J_a(\breve F_v)/J_a(\breve{\mathcal O}_v),
\qquad
\mathcal P_{a,v}\simeq\mathcal M_{a,v}^{\mathrm{reg}}.
$$
Here $J_a(F_v)\simeq G_{\gamma_0}(F_v)$. For a character $\kappa$ of $H^1(k_v,\mathcal P_{a,v})$, also used for its pullback to $H^1(F_v,J_a)$, Ngô 8.2.7 gives
$$
\#\big[\mathcal M_{a,v}/\mathcal P_{a,v}\big](k_v)_\kappa
=\operatorname{vol}\bigl(J_a^0(\mathcal O_v),dt\bigr)\,
\mathbf O^\kappa_{\gamma_0}\bigl(\mathbf 1_{\mathfrak g(\mathcal O_v)},dt\bigr).
$$

## 2. The Hitchin space and base

### 2.1 Twisting by a line bundle

Fix a line bundle $D$ with $\deg D>2g$. Ngô takes $D=(D')^{\otimes 2}$ for the section in §2.3. Twisting the scaling actions by the torsor $D^\times$ gives $\mathfrak g_D$, $\mathfrak t_D$ and $\mathfrak c_D$. The weights on $\mathfrak c$ are the degrees of the basic invariants. For a $G$-torsor $E$ the twisted adjoint bundle is
$$
\operatorname{ad}(E)\otimes D=(E\times^G\mathfrak g)\otimes D.
$$

### 2.2 The Hitchin space

**Definition 2.1** (Hitchin space, Ngô 4.2.1). For a $k$-scheme $S$, the groupoid $\mathcal M(S)$ consists of a $G$-torsor $E$ on $X_S=X\times S$ and a section $\phi\in H^0(X_S,\operatorname{ad}(E)\otimes D)$. Equivalently (Ngô 4.2.2),
$$
(E,\phi)\quad\longleftrightarrow\quad
h_{E,\phi}:X_S\longrightarrow[\mathfrak g_D/G]
\quad\text{over }X.
$$
Locally $\phi$ takes values in $\mathfrak g$, with transitions by conjugation and scaling. For $GL_n$ this is a rank-$n$ vector bundle $V$ and a map $\phi:V\to V\otimes D$.

With $D=K_X$, the invariant pairing and Serre duality identify the Higgs fields with cotangent vectors.
$$
H^1(X,\operatorname{ad}(E))^\vee\simeq H^0(X,\operatorname{ad}(E)\otimes K_X),
\qquad \mathcal M\simeq T^*\mathrm{Bun}_G.
$$
On the stable moduli space Hitchin obtains a completely integrable system with abelian generic fibers. Ngô uses high degree for connected cameral curves and the support theorem’s codimension estimates.

The stacks $\mathrm{Bun}_G$ and $\mathcal M$ are algebraic and locally of finite type. The fiber of $\mathcal M\to\mathrm{Bun}_G$ over $E$ is $H^0(X,\operatorname{ad}(E)\otimes D)$. Ngô §4.1 gives
$$
\mathrm{Bun}_G(k)=
\bigsqcup_{\xi\in\ker^1(F,G)}
\left[G^\xi(F)\backslash\prod_{v\in|X|}'G(F_v)/G(\mathcal O_v)\right].
$$
Here $\ker^1(F,G)$ indexes everywhere locally trivial torsors and $G^\xi$ is the associated inner form. Beauville–Laszlo gluing with the trivial torsor on $X-v$ gives $\mathrm{Gr}_{G,v}\to\mathrm{Bun}_G$.

If $X(k)\ne\varnothing$, a split torus $T$ gives
$$
\begin{aligned}
\mathrm{Bun}_{\mathbb G_m}&\simeq B\mathbb G_m\times\operatorname{Pic}^0(X)\times\mathbb Z,\\
\mathrm{Bun}_T&\simeq BT\times
\bigl(X_*(T)\otimes\operatorname{Pic}^0(X)\bigr)\times X_*(T).
\end{aligned}
$$
The three factors record automorphisms, degree-zero classes and degrees. This is the constant-torus model for the symmetry stack in §3.

### 2.3 The Hitchin map

**Definition 2.2** (Hitchin base and fibration, Ngô 4.2.3). The Chevalley map descends to $[\mathfrak g_D/G]\to\mathfrak c_D$. Composing with $h_{E,\phi}$ gives
$$
\mathcal A=H^0(X,\mathfrak c_D),\qquad
f:\mathcal M\longrightarrow\mathcal A,\quad
(E,\phi)\longmapsto a=\chi(\phi),\qquad
\mathcal M_a=f^{-1}(a).
$$
For split $G$ with invariant degrees $e_1,\dots,e_r$ and root system $\Phi$, Riemann–Roch gives (Ngô 4.4.1)
$$
\mathfrak c_D=\bigoplus_{i=1}^r D^{\otimes e_i},\qquad
\dim\mathcal A=\sum_{i=1}^r(e_i\deg D+1-g)=\frac{|\Phi|}{2}\deg D+r(1-g+\deg D).
$$
For $GL_n$, $e_i=i$, so $a_i\in H^0(X,D^{\otimes i})$. The board first used ordinary functions for the coefficients and corrected this on the spectral-curve board.

The square root $D'$ gives the Kostant–Hitchin section $\epsilon_{D'}:\mathcal A\to\mathcal M^{\mathrm{reg}}$ with $f\circ\epsilon_{D'}=\mathrm{id}$ (Ngô 4.2.4 and 4.3.4). In $SL_2$, the local scaling identity is
$$
\epsilon(a)=\begin{pmatrix}0&a\\1&0\end{pmatrix},
\qquad
\operatorname{Ad}\bigl(\operatorname{diag}(s,s^{-1})\bigr)(t\,\epsilon(a))=\epsilon(t^2a),
\qquad s^2=t.
$$
For $GL_n$, the section works for any $D$. Multiplication by the spectral coordinate on $V=\bigoplus_{i=0}^{n-1}D^{-i}$ gives the companion matrix. Its subdiagonal entries are the identity maps $D^{-i}\to D^{-(i+1)}\otimes D$.

Let $\mathfrak D_{G,D}$ be the twisted discriminant divisor. The generically regular semisimple locus supplies the local data for gluing.
$$
\mathcal A^\heartsuit=\{a\mid a(\bar X)\not\subset\mathfrak D_{G,D}\},\qquad
U_a=a^{-1}(\mathfrak c_D^{\mathrm{rs}})=\bar X\smallsetminus a^{-1}(\mathfrak D_{G,D}).
$$
The set $\mathcal A^\heartsuit$ is open and nonempty. For $a$ in this set, each $v\in\bar X\smallsetminus U_a$ gives local data of the type in §1.

## 3. Symmetries of Hitchin fibers

The regular centralizer $J\to\mathfrak c$ (Ngô 2.1.1, Proposition 1.6 of the previous note) is equivariant for scaling. Pull it back along the twisted characteristic polynomial to obtain the group that acts on the fiber.

**Definition 3.1** (Ngô 4.3.1). For $a\in\mathcal A(S)$ with associated map $h_a:X_S\to[\mathfrak c/\mathbb G_m]$, let $J_a=h_a^*J$ be the pullback of the descended group scheme. It is smooth and commutative. The groupoids
$$
\mathcal P_a(S)=\mathrm{Bun}_{J_a}(X_S)
$$
form a Picard stack $\mathcal P\to\mathcal A$.

Over $U_a$, $J_a$ is a torus twisted by cameral monodromy. It degenerates at the remaining points. The local $\mathcal P_{a,v}$ is an extension of a discrete group by an affine algebraic group of dimension $\delta_v$ (Lemma 4.3 of the previous note). Globally the neutral component can also have an abelian variety, as in the split torus example.

The centralizer homomorphism $\chi^*J\to I$ pulls back to $J_a\to\operatorname{Aut}(E,\phi)$, where $I$ is the centralizer over $\mathfrak g$. Twisting by a $J_a$-torsor $Q$ defines the action (Ngô 4.3.2).
$$
\mathcal P_a\times\mathcal M_a\longrightarrow\mathcal M_a,
\qquad (Q,(E,\phi))\longmapsto Q\times^{J_a}(E,\phi).
$$

**Proposition 3.2** (Ngô 4.3.3). The locus $\mathcal M^{\mathrm{reg}}$ where $\phi(x)$ is regular at every point of the curve is open and is a $\mathcal P$-torsor over $\mathcal A$. The Kostant–Hitchin section gives
$$
\mathcal P_a\xrightarrow{\sim}\mathcal M_a^{\mathrm{reg}},
\qquad Q\longmapsto Q\cdot\epsilon_{D'}(a).
$$
*Proof.* The Kostant section supplies a regular object in each fiber. The gerbe $[\mathfrak g^{\mathrm{reg}}/G]\to\mathfrak c$ is banded by $J$ (Ngô 2.2.1), so the sheaf of isomorphisms between two regular pairs over $a$ is a $J_a$-torsor. This is the same argument as Proposition 1.8 of the previous note. ∎

## 4. Spectral curves for $GL_n$

### 4.1 The eigenvalue cover

For $G=GL_n$, one can study the Higgs field through its eigenvalues. Write $t$ for the tautological section of the pullback of $D$ to $\operatorname{Tot}(D)$.

**Definition 4.1** (spectral curve, Ngô 4.7.1). For $a=(a_1,\dots,a_n)\in\mathcal A(\bar k)$, the spectral curve and its projection are
$$
P_a(t)=t^n+a_1t^{n-1}+\cdots+a_n,\qquad
Y_a=V(P_a)\subset\operatorname{Tot}(D|_{\bar X}),\qquad p:Y_a\longrightarrow\bar X.
$$
The map $p$ is finite flat of degree $n$, with distinct eigenvalues over $U_a$. The board indexed coefficients by powers of $t$, and Ngô uses alternating signs.

![[../../attachments/hitchin-fibration-fig2-spectral-curve.svg]]

*Figure 2. The eigenvalue sheets in $\operatorname{Tot}(D)$ and their projection to the base curve.*

The board drew three sheets over a loop. Here the base is drawn locally, with distinct sheets over $U_a$ and colliding eigenvalues at its boundary. A collision may give a smooth branch point or a node, as in Figure 3.

The condition $a\in\mathcal A^\heartsuit$ says that $Y_a$ is reduced. The board struck out irreducibility for $\deg D>2g$. For $GL_2$, distinct $b,c\in H^0(X,D)$ give
$$
P_a(t)=(t-b)(t-c),\qquad Y_a=\Gamma_b\cup\Gamma_c.
$$
The two graphs give a reduced reducible curve. This factorization comes from the split endoscopic datum $GL_1\times GL_1$.

### 4.2 Rank-one sheaves and the compactified Picard stack

**Proposition 4.2** (Beauville–Narasimhan–Ramanan, Ngô 4.7.1). For $a\in\mathcal A^\heartsuit(\bar k)$,
$$
\mathcal M_a\simeq\overline{\operatorname{Pic}}(Y_a),\qquad
\mathcal M_a^{\mathrm{reg}}\simeq\operatorname{Pic}(Y_a)\simeq\mathcal P_a.
$$
The compactified Picard stack parametrizes torsion-free rank-one sheaves, and $\mathcal P_a$ acts by tensor product.

*Proof.* On a trivialization of $D$, Cayley–Hamilton makes a Higgs bundle into a module over $p_*\mathcal O_{Y_a}=\mathcal O_{\bar X}[t]/(P_a)$ by $t\cdot v=\phi(v)$. Generically $P_a$ is square-free and each eigenvalue has multiplicity one. Thus the associated sheaf $\mathcal F$ has rank one on each component, and torsion-freeness follows from the local freeness of $V$. In reverse,
$$
\mathcal F\longmapsto \bigl(p_*\mathcal F,\;t:p_*\mathcal F\to p_*\mathcal F\otimes D\bigr).
$$
The pushforward is torsion-free on the smooth curve $\bar X$ and hence locally free. At $v$, $\mathcal F$ is a lattice over $B=\breve{\mathcal O}_v[t]/(P_a)$, and $\phi$ is regular exactly when this lattice is free (Lemma 2.2 of the previous note). The regular centralizer consists of units in the spectral algebra, so twisting becomes tensoring by a line bundle. ∎

A rank-one torsion-free sheaf is a line bundle away from the singular points. Its lattices at those points supply the local factors of §6. If $Y_a$ is smooth, it is connected by §5.1 and
$$
\mathcal M_a=\operatorname{Pic}(Y_a),\qquad
\pi_0(\mathcal P_a)\simeq\mathbb Z,\qquad
\mathcal P_a^0\simeq\operatorname{Jac}(Y_a)\times B\mathbb G_m.
$$
For a singular $Y_a$ with normalization $\xi:Y_a^\flat\to Y_a$, the global analogue of (2.1) of the previous note becomes
$$
\begin{gathered}
1\longrightarrow\mathcal R_a\longrightarrow\operatorname{Pic}(Y_a)
\xrightarrow{\xi^*}\operatorname{Pic}(Y_a^\flat)\longrightarrow 1,\\
\delta_a=\dim\mathcal R_a
=\dim H^0(Y_a,\xi_*\mathcal O_{Y_a^\flat}/\mathcal O_{Y_a}).
\end{gathered}
$$
The kernel $\mathcal R_a$ is connected and affine. At a node it records the identification of the line fibers over the two preimages in the normalization. For general $G$, [[Stratifications of the Hitchin base#1. The affine part of the Picard stack|the next talk]] recovers the affine kernel from the Néron model of $J_a$.

Since $Y_a$ has planar singularities, $\operatorname{Pic}(Y_a)$ is dense in $\overline{\operatorname{Pic}}(Y_a)$ by Altman–Iarrobino–Kleiman (Ngô 4.7.4). Using $p_*\mathcal O_{Y_a}=\bigoplus_{i=0}^{n-1}D^{-i}$ as an $\mathcal O_{\bar X}$-module gives
$$
\dim\mathcal P_a=p_a(Y_a)-1=-\chi(\mathcal O_{Y_a})
=n(g-1)+\frac{n(n-1)}2\deg D,
$$
where $p_a(Y_a)$ is the arithmetic genus. This is Ngô 4.4.4 with $r=n$ and $|\Phi|=n(n-1)$.

## 5. Cameral curves

### 5.1 The Weyl cover

The cameral curve records all ordered eigenvalues for $GL_n$. The Weyl quotient gives the uniform construction for general $G$.

**Definition 5.1** (Donagi, Ngô §4.5). For $a\in\mathcal A(\bar k)$, put
$$
\widetilde X_a=\bar X\times_{a,\mathfrak c_D}\mathfrak t_D,
\qquad \pi_a:\widetilde X_a\longrightarrow\bar X.
$$
The cover is finite flat of degree $|W|$ and is a $W$-torsor over $U_a$. For $GL_n$ the projection to the first eigenvalue is the quotient $Y_a=\widetilde X_a/S_{n-1}$.

![[../../attachments/hitchin-fibration-fig3-cameral-cover.svg]]

*Figure 3. (a) The cameral pullback. (b) Transverse intersection with the discriminant. (c) Tangency.*

Panel (a) redraws the board diagram. The local equations in (b) and (c) are $t^2=\varepsilon$ (smooth branching) and $t^2=\varepsilon^2$ (a node).

The cover determines the regular centralizer. Its sections are $W$-equivariant maps $u$ to $T$ with $\alpha(u(x))=1$ at points fixed by the root reflection $s_\alpha$ (Ngô 2.4.7). In particular,
$$
\operatorname{Lie}(J_a)\simeq
\bigl(\pi_{a*}\mathcal O_{\widetilde X_a}\otimes\mathfrak t\bigr)^W
\simeq\mathfrak c_D^\vee\otimes D
$$
by Ngô 4.4.3. The Picard stack $\mathcal P_a$ is thus related to the $W$-equivariant Picard theory of the cameral curve.

If $a\in\mathcal A^\heartsuit$, the cameral curve is reduced because its generic fiber is reduced and $\pi_{a*}\mathcal O_{\widetilde X_a}$ is torsion-free (Ngô 4.5.1). If also $\deg D>2g$, it is connected by Fulton–Hansen connectedness (Ngô 4.5.4).

### 5.2 Transversality and regular fibers

**Definition 5.2** (Ngô §4.6). The open set $\mathcal A^\diamondsuit\subset\mathcal A^\heartsuit$ consists of sections meeting $\mathfrak D_{G,D}$ transversally. They avoid its singular locus, and each intersection has $d_v(a)=1$. This is the local contact of Figure 1(b) of the previous note at each bad point.

**Theorem 5.3** (Ngô 4.6.3, 4.6.6 and 4.6.1).

1. $a\in\mathcal A^\diamondsuit$ if and only if $\widetilde X_a$ is smooth.
2. Over $\mathcal A^\diamondsuit$, $\mathcal M_a=\mathcal M_a^{\mathrm{reg}}$ is a $\mathcal P_a$-torsor. The stack $\mathcal P_a^0$ is the quotient of an abelian variety by a diagonalizable group acting trivially.
3. If $\deg D>2g$, then $\mathcal A^\diamondsuit$ is nonempty.

*Ideas of the proofs.* Along the smooth discriminant, the ramified factor of the completed cameral algebra is
$$
\bar k[[\varepsilon]][t]/(t^2-\varepsilon^{d_v(a)}).
$$
It is smooth for $d_v(a)=1$. At the singular locus, a smooth cameral point would have a tame cyclic stabilizer containing two different root reflections. This is impossible.

For (2), transversality gives one reflection as local monodromy. By Theorem 3.3 and Corollary 3.2 of the previous note,
$$
d_v(a)=c_v(a)=1
\quad\Longrightarrow\quad
\delta_v=\tfrac12(d_v(a)-c_v(a))=0
\quad\Longrightarrow\quad
\mathcal M_{a,v}=\mathcal M_{a,v}^{\mathrm{reg}}.
$$
For $GL_2$ this is $T^2-\pi$ in Example 2.6 of the previous note. For global regularity Ngô cites *Fibration de Hitchin et endoscopie*, Proposition 4.2. For the neutral component, §4.8 uses that the quotient of $J_a$ in its Néron model is finite when $\widetilde X_a$ is smooth.

For (3), $H^0(\bar X,\mathfrak c_D)\twoheadrightarrow\mathfrak c_D\otimes\mathcal O/\mathfrak m_x^2$ gives arbitrary first jets at $x$ (Ngô 4.6.2). Tangency or hitting the singular locus has codimension at least two for fixed $x$, so varying $x$ still gives a proper locus. ∎

Connectedness and smoothness give an irreducible cameral curve over $\mathcal A^\diamondsuit$ (Ngô 4.6.4). For $GL_3$, the spectral curve $t^3=\varepsilon$ is smooth at the triple collision. The cameral equations for eigenvalues $x,y,-x-y$ give $x^2+xy+y^2=0$ after eliminating $\varepsilon$. This has two branches, so smooth spectral curves can occur beyond $\mathcal A^\diamondsuit$.

## 6. Outlook

*Dimensions* (Ngô 4.4.2–4.4.6). The stack $\mathcal P$ is smooth over $\mathcal A^\heartsuit$ because $H^2(\bar X,\operatorname{Lie}(J_a))=0$. Riemann–Roch and §5.1 give
$$
\dim\mathcal P_a=-\chi(\bar X,\operatorname{Lie}J_a)=\tfrac12|\Phi|\deg D+r(g-1),
\qquad \dim(\mathcal P|_{\mathcal A^\heartsuit})=(r+|\Phi|)\deg D.
$$

*Product formula* (Ngô 4.13.1). Put $S_a=\bar X\smallsetminus U_a$. On each punctured disc the [[Affine Springer fibers and their symmetries#1.2 Affine Springer fibers|local framing]] identifies the local pair with the Kostant pair on $U_a$. Gluing and then twisting by the global Picard stack gives
$$
\left(\prod_{v\in S_a}\mathcal M_{a,v}\right)
\times^{\prod_{v\in S_a}\mathcal P_{a,v}}\mathcal P_a
\longrightarrow\mathcal M_a.
$$
The contracted product identifies a change of local framing with the corresponding change of the global twist. The map is an equivalence on geometric points. On the anisotropic locus $\mathcal A^{\mathrm{ani}}$, where $\pi_0(\mathcal P_a)$ is finite, using the reductions of the local factors and groups gives a proper Deligne–Mumford source and a homeomorphism.

*Density* (Ngô 4.14.1–4.14.3). The product formula controls the dimension of the non-regular locus. The total space $f^{-1}(\mathcal A^\heartsuit)$ is smooth over $k$ for $\deg D>2g-2$ (Ngô 4.12.1). The local complete intersection argument then rules out smaller irreducible components. For $a\in\mathcal A^\heartsuit$,
$$
\overline{\mathcal M_a^{\mathrm{reg}}}=\mathcal M_a,\qquad
\dim\mathcal M_a=\dim\mathcal P_a,\qquad
\operatorname{Irr}(\mathcal M_a)\simeq\pi_0(\mathcal P_a).
$$
The affine Springer density result (Proposition 6.1 of the previous note) follows from the global one.

*Counting and endoscopy* (Ngô 4.15 and chapter 8). On the anisotropic locus, point counts decompose into a global volume and local orbital integrals. The support theorem uses the $\delta_a$-strata to control which supports can carry the $\kappa$-parts of the cohomology. Endoscopic comparison uses
$$
\nu:\mathcal A_H\longrightarrow\mathcal A,\qquad a=\nu(a_H),\qquad
\mathcal P_a\longrightarrow\mathcal P_{H,a_H},
$$
globalizing §7 of the previous note. The next talk, [[Stratifications of the Hitchin base]], studies how $\pi_0(\mathcal P_a)$ and $\delta_a$ vary with $a$.

## References

- B. C. Ngô, *Le lemme fondamental pour les algèbres de Lie*, Publ. Math. IHÉS 111 (2010), 1–169. [arXiv:0801.0446](https://arxiv.org/abs/0801.0446)
- B. C. Ngô, *Fibration de Hitchin et endoscopie*, Invent. Math. 164 (2006), 399–453.
- N. Hitchin, *Stable bundles and integrable systems*, Duke Math. J. 54 (1987), 91–114.
- A. Beauville, M. S. Narasimhan, S. Ramanan, *Spectral curves and the generalised theta divisor*, J. reine angew. Math. 398 (1989), 169–179.
- R. Donagi, D. Gaitsgory, *The gerbe of Higgs bundles*, Transform. Groups 7 (2002), 109–153.
- A. Altman, A. Iarrobino, S. Kleiman, *Irreducibility of the compactified Jacobian*, in *Real and complex singularities* (Oslo 1976), 1–12.
- W. Fulton, R. Lazarsfeld, *Connectivity and its applications in algebraic geometry*, Lecture Notes in Math. 862 (1981), 26–92.

Related: [[Affine Springer fibers and their symmetries]] · [[Endoscopy]] · next talk: [[Stratifications of the Hitchin base]]
