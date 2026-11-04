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

*Notes on the talk "Hitchin fibration", Ngô fundamental lemma seminar, 30 October 2026. Reference: B. C. Ngô, Le lemme fondamental pour les algèbres de Lie, Publ. Math. IHÉS 111 (2010), chapter 4; numbering as in [arXiv:0801.0446](https://arxiv.org/abs/0801.0446). This is the second talk of the seminar; the first one is written up in [[Affine Springer fibers and their symmetries]].*

In the previous talk we studied affine Springer fibers. These are local objects: they depend on a point $v$ of a curve and on a characteristic polynomial $a$ over the formal disc at $v$. They come with a large commutative group of symmetries, and, roughly speaking, counting their points modulo these symmetries computes the κ-orbital integrals that appear in the fundamental lemma. In this talk we make the picture global, by replacing the formal disc with a smooth projective curve $X$. The pairs $(E,\phi)$ on $X$ are then Higgs bundles, their moduli space $\mathcal M$ maps to the space $\mathcal A$ of global characteristic polynomials, and this map $f:\mathcal M\to\mathcal A$ is the Hitchin fibration. Its fibers $\mathcal M_a$ are called Hitchin fibers.

The guiding principle of the talk is that **a Hitchin fiber is a global affine Springer fiber.** In other words, every ingredient of the local theory has a global counterpart: the pairs $(E,\phi)$, the characteristic polynomial, the regular centralizer $J_a$, the group of symmetries, and also the fact that the regular part is a single orbit of this group. The relation goes in the other direction as well. A Hitchin fiber is, essentially, built from the affine Springer fibers at the finitely many points where $a$ fails to be regular semisimple, glued together with one global group of symmetries; this is the product formula, which we discuss in §6. It is natural to ask what we gain by going global. The main advantage is that the Hitchin fibers come in a family over the finite-dimensional space $\mathcal A$. So we can move $a$ around and use geometry in families, which is not possible for a single affine Springer fiber, and counting points in the whole family gives the geometric side of a trace formula.

Here is the plan. We first recall the local picture, in the form in which the talk used it (§1). Then we define the Hitchin space, the Hitchin base and the Hitchin fibers (§2), and we construct the symmetries of a Hitchin fiber (§3). For $GL_n$ everything can be described quite concretely with spectral curves (§4). For a general group we use cameral curves instead, and they lead to two open sets $\mathcal A^\heartsuit\supset\mathcal A^\diamondsuit$ of the base: over the first one the Hitchin fibers are reasonable, and over the second one they are as simple as possible (§5). Finally, in §6 we explain briefly what comes next in the paper.

A word on sources. The boards of the talk covered Ngô §4.1–4.3 and §4.5–4.7, after a short recap of chapter 3. The dimension formulas (§4.4), the product formula and the density theorem (§4.13–4.14), as well as the sketches of proofs, are written up from the paper. Figures 1–3 redraw the pictures from the boards, with some details added to make them easier to read.

## 1. The local picture, again

Before going global, it is useful to recall the local objects once more. The talk started by recasting them in a slightly different language, and everything later on will be compared with them.

### 1.1 Notation

Let $k=\mathbb F_q$, let $X$ be a smooth projective and geometrically connected curve over $k$ of genus $g$, and put $\bar X=X\otimes_k\bar k$. Let $|X|$ be the set of closed points of $X$. For $v\in|X|$ we write $\mathcal O_v$ for the completed local ring at $v$, $F_v$ for its fraction field and $k_v$ for its residue field, which is a finite extension of $k$. The formal disc at $v$ is $X_v=\mathrm{Spec}\,\mathcal O_v$, and the punctured disc is $X_v^\bullet=\mathrm{Spec}\,F_v$ (on the board it was written $X_v^\times$). The board drew $X_v$ as a small disc with its closed point, just as in Figure 1(a) of the previous note.

As before, $G$ is a split reductive group over $k$ whose Weyl group $W$ has order prime to $p$, $\mathfrak c=\mathfrak t/\!/W$, $\chi:\mathfrak g\to\mathfrak c$ is the Chevalley map (written $\pi$ on the board), and $\epsilon:\mathfrak c\to\mathfrak g^{\mathrm{reg}}$ is the Kostant section.

### 1.2 The regular elements form one orbit

The talk began with a fact over a field, which is worth keeping in mind throughout. Over an algebraically closed field, two regular elements with the same characteristic polynomial are conjugate, so the regular part of a fiber of $\chi$ is a single orbit:
$$\chi_{\mathrm{reg}}^{-1}(a)\cong G/G_{\epsilon(a)},$$
where $G_{\epsilon(a)}$ is the centralizer of the Kostant element $\epsilon(a)$, in other words the regular centralizer $J_a$. The non-regular elements of the fiber, if there are any, form other orbits of smaller dimension. For $\mathfrak{sl}_2$, Figure 2(b) of the previous note shows this on a plane: there, the fiber over $0$ consists of the regular nilpotent elements (the two axes without the origin) together with the single non-regular element $0$.

Essentially the same is true over the disc. Let $a\in\mathfrak c^\heartsuit(\mathcal O_v)$ and $\gamma_0=\epsilon(a)$. Then the integral regular elements with characteristic polynomial $a$ form a single $G(\mathcal O_v)$-orbit:
$$\chi^{-1}(a)\cap\mathfrak g^{\mathrm{reg}}(\mathcal O_v)\cong G_{\gamma_0}\backslash G(\mathcal O_v).$$
(Strictly speaking, this holds over $\breve{\mathcal O}_v$; over $\mathcal O_v$ itself there can be finitely many orbits, and the difference is measured by Galois cohomology of the finite field $k_v$.) The non-regular integral elements with characteristic polynomial $a$ form other $G(\mathcal O_v)$-orbits. Figure 1 is the picture that was drawn on the board.

![[hitchin-fibration-fig1-local-orbits.svg]]

*Figure 1. The integral elements $\mathfrak g(\mathcal O_v)^\heartsuit$ that are regular semisimple over $F_v$, fibered over $\mathfrak c^\heartsuit(\mathcal O_v)$ by the characteristic polynomial. The fiber over $a$ is cut into $G(\mathcal O_v)$-orbits: one regular orbit, which passes through $\epsilon(a)$, and some non-regular ones.*

Let us read the picture from the outside in. The rounded region is the set of integral elements that are regular semisimple at the generic point. It is, roughly, the support of the function $\mathbf 1_{\mathfrak g(\mathcal O_v)}$ whose orbital integrals we are after (restricted to the regular semisimple part). Taking the characteristic polynomial maps the region down to $\mathfrak c^\heartsuit(\mathcal O_v)$. The vertical line is the fiber over $a$, and $G(\mathcal O_v)$ acts on it by conjugation, so the fiber breaks up into orbits. The blue segment is the regular orbit; note that it contains the Kostant element $\gamma_0=\epsilon(a)$, which is how we know that this orbit is never empty. The red segments are the non-regular orbits. It may help to compare with Figure 3 of the previous note, which shows the same fiber after dividing by $G(\mathcal O_v)$, so that each orbit there becomes a single point.

### 1.3 Orbital integrals and the affine Springer fiber

Now let $\gamma\in\mathfrak g(F_v)$ be regular semisimple with characteristic polynomial $a$. The board then wrote down the integral points of its rational orbit,
$$\mathfrak g(\mathcal O_v)\cap\mathrm{ad}(G(F_v))(\gamma)\ \subset\ \mathrm{ad}(G(F_v))(\gamma)\cong G(F_v)/G_\gamma(F_v).$$
The orbital integral of $\mathbf 1_{\mathfrak g(\mathcal O_v)}$ at $\gamma$ is, in a sense, a measure of this set of integral points. After the change of variables $g\mapsto\mathrm{ad}(g)^{-1}\gamma$, it counts the points of the affine Springer fiber
$$\mathcal M_{a,v}(k)=\{g\in G(F_v)/G(\mathcal O_v)\ :\ \mathrm{ad}(g^{-1})\gamma\in\mathfrak g(\mathcal O_v)\}$$
modulo the left action of the centralizer $G_\gamma(F_v)$, where each point is weighted by the inverse volume of its stabilizer (Example 8.2 of the previous note works this out in a simple case). For $\gamma=\gamma_0=\epsilon(a)$ this is exactly the affine Springer fiber that the previous note called $\mathcal M_a$; here we follow the board and write $\mathcal M_{a,v}$, to keep track of the point $v$.

The board also stressed a point that is easy to overlook:
$$(G/G_\gamma)(F_v)\neq G(F_v)/G_\gamma(F_v).$$
The left side is the set of $F_v$-points of the orbit, which is the stable orbit $\chi^{-1}(a)(F_v)$, while the right side is the rational orbit of $\gamma$. In general the stable orbit is a disjoint union of several rational orbits, indexed by $\ker\big(H^1(F_v,G_\gamma)\to H^1(F_v,G)\big)$. This is the reason why κ-orbital integrals appear at all: they are, roughly speaking, the Fourier coefficients of the orbital integrals over the rational orbits inside one stable orbit (compare [[Endoscopy]]).

In the geometric theory, the group $G_\gamma(F_v)$ is replaced by the group $\mathcal P_{a,v}$, which is "related to $G_\gamma$", as the board put it. Let us briefly recall how this works. The affine Springer fiber has a modular description: for a noetherian $k$-scheme $S$, $\mathcal M_{a,v}(S)$ is the groupoid of triples $(E,\phi,\tau)$, where $E$ is a $G$-torsor over $X_v\hat\times S$, $\phi\in H^0(X_v\hat\times S,\mathrm{ad}(E))$, and $\tau$ is an isomorphism $(E,\phi)\cong(E_0,\gamma_0)$ over $X_v^\bullet\hat\times S$ (Definition 1.1 of the previous note). The symmetries come from the regular centralizer. More precisely, $J_{a,v}=a^*J$ is a smooth commutative group scheme over $X_v$ whose generic fiber is a torus over $F_v$, and $\mathcal P_{a,v}$ is the group of $J_{a,v}$-torsors over $X_v\hat\times S$ with a trivialization over $X_v^\bullet\hat\times S$. On $\bar k$-points this is simply $\mathcal P_{a,v}=J_a(\breve F_v)/J_a(\breve{\mathcal O}_v)$, and note that $J_a(F_v)\cong G_{\gamma_0}(F_v)$, which explains the relation with $G_\gamma$. Two results from last time will be used again and again. The first is that the regular part $\mathcal M_{a,v}^{\mathrm{reg}}$ (where $\phi$ is regular) is a $\mathcal P_{a,v}$-torsor (Ngô 3.3.1). The second is the counting formula of Ngô §8.2,
$$\#\big[\mathcal M_{a,v}/\mathcal P_{a,v}\big](k)_\kappa=\mathrm{vol}\cdot\mathbf O^\kappa_{\gamma_0}\big(\mathbf 1_{\mathfrak g(\mathcal O_v)}\big).$$
As we will see, everything below is a global version of these two statements.

## 2. The Hitchin space and the Hitchin base

We now turn to the global objects. The idea is simple: we keep the same kind of data as before, but over the whole curve $X$ instead of the disc $X_v$. The only really new ingredient is a line bundle $D$, which we use to twist the Higgs field.

### 2.1 Twisting by a line bundle

Fix a line bundle $D$ on $X$ with $\deg D>2g$. (Ngô also assumes that $D=D'^{\otimes2}$ is a square; we will see the reason for this in §2.3.) The group $\mathbb G_m$ acts on $\mathfrak g$, $\mathfrak t$ and $\mathfrak c$ by scaling; on $\mathfrak c$ the action has weights given by the degrees of the invariant polynomials. Twisting by the $\mathbb G_m$-torsor $D^\times$ of nonzero vectors in $D$, we obtain vector bundles $\mathfrak g_D$, $\mathfrak t_D$ and $\mathfrak c_D$ over $X$. Concretely, if $E$ is a $G$-torsor on $X$, its adjoint bundle twisted by $D$ is
$$\mathrm{ad}(E)\otimes D=E\times^G\mathfrak g\times^{\mathbb G_m}D^\times.$$
For example, for $G=GL_n$ a $G$-torsor is the same as a vector bundle $V$ of rank $n$, and then $\mathrm{ad}(E)\otimes D=\mathcal Hom(V,V\otimes D)$.

### 2.2 The Hitchin space

**Definition 2.1** (Hitchin space; Ngô 4.2.1). For a $k$-scheme $S$, let $\mathcal M(S)$ be the groupoid of pairs $(E,\phi)$, where $E$ is a $G$-torsor over $X\times S$ and $\phi\in H^0(X\times S,\mathrm{ad}(E)\otimes D)$.

It is worth unwinding this definition slowly. Locally on $X$ we can trivialize $E$ and $D$, and then $\phi$ is nothing but a function with values in $\mathfrak g$. If we change the trivialization of $E$, then $\phi$ gets conjugated, and if we change the trivialization of $D$, it gets scaled. So, intuitively, a pair $(E,\phi)$ is a family of elements of $\mathfrak g$ parametrized by the curve, which is well defined only up to conjugation and scaling. A cleaner way to say the same thing (Ngô 4.2.2) is that it is a map
$$h_{E,\phi}:X\times S\longrightarrow[\mathfrak g_D/G].$$
This is really the global version of what we did last time. There, a pair $(E,\phi)$ on the disc $X_v$ was a map $X_v\to[\mathfrak g/G]$, in other words an "arc" in $[\mathfrak g/G]$, and now the disc is simply replaced by the whole curve. For $G=GL_n$, a point of $\mathcal M$ is a vector bundle $V$ of rank $n$ together with a twisted endomorphism $\phi:V\to V\otimes D$, which is usually called a $D$-twisted Higgs bundle.

The classical case is $D=K_X$, the canonical bundle. In that case $\mathcal M$ is "the" Hitchin space, the space of Higgs bundles, and $\mathcal M\cong T^*\mathrm{Bun}_G$. The reason is the following. The tangent space of $\mathrm{Bun}_G$ at $E$ is $H^1(X,\mathrm{ad}(E))$, and by Serre duality, together with an invariant form $\mathfrak g\cong\mathfrak g^*$ (this is what was written on the board above the isomorphism), its dual is $H^0(X,\mathrm{ad}(E)\otimes K_X)$. Hitchin showed that $f:T^*\mathrm{Bun}_G\to\mathcal A$ is a completely integrable system whose generic fibers are abelian varieties. Ngô instead replaces $K_X$ by a line bundle of large degree. In doing so he loses the symplectic form, but he keeps the overall shape of the fibration, and with $\deg D>2g$ several properties that are needed later become available. For instance, the total space $\mathcal M$ is smooth over $\mathcal A^\heartsuit$ (Ngô 4.12.1), the cameral curves of §5 are connected, and the codimension estimates of the support theorem hold.

The board also recorded two general facts, which we will use without much comment. First, $\mathrm{Bun}_G$ and $\mathcal M$ are algebraic stacks locally of finite type. For $\mathcal M$ this follows from the statement for $\mathrm{Bun}_G$, because forgetting $\phi$ gives a map $\mathcal M\to\mathrm{Bun}_G$ whose fiber over $E$ is the vector space $H^0(X,\mathrm{ad}(E)\otimes D)$ (Ngô 4.2.2). It may also help to recall what $\mathrm{Bun}_G$ looks like on $k$-points. It has the adelic description
$$\mathrm{Bun}_G(k)=\bigsqcup_{\xi\in\ker^1(F,G)}\Big[G^\xi(F)\backslash{\textstyle\prod'_{v\in|X|}}G(F_v)/G(\mathcal O_v)\Big],$$
and gluing a torsor on the disc $X_v$ with the trivial torsor on $X-v$ (Beauville–Laszlo) gives a map from the affine Grassmannian at $v$ to $\mathrm{Bun}_G$ (Ngô §4.1). This is, in a sense, how the local spaces of the last talk sit inside the global ones.

Second, the board discussed the simplest case, $G=\mathbb G_m$. Here $\mathrm{Bun}_G$ is the Picard stack of line bundles on $X$, and if $X$ has a $k$-point, then
$$\mathrm{Bun}_{\mathbb G_m}\cong B\mathbb G_m\times\mathrm{Pic}^0(X)\times\mathbb Z.$$
Each factor has a simple meaning. Every line bundle has automorphism group $\mathbb G_m$, which gives the factor $B\mathbb G_m=\mathrm{pt}/\mathbb G_m$; the degree gives the factor $\mathbb Z$; and the line bundles of degree zero are parametrized by the Jacobian $\mathrm{Pic}^0(X)$, which is an abelian variety. In the same way, for a split torus $T\cong\mathbb G_m^n$ we get
$$\mathrm{Bun}_T\cong BT\times\mathrm{Pic}^0_T(X)\times X_*(T),\qquad \mathrm{Pic}^0_T(X)=X_*(T)\otimes\mathrm{Pic}^0(X).$$
This example will come back soon, because the symmetry group of a Hitchin fiber turns out to be a Picard stack of torsors under a group scheme which is generically a torus. One can think of it as a twisted and degenerate version of $\mathrm{Bun}_T$.

### 2.3 The Hitchin base and the Hitchin fibration

Now that we have the total space, we can define the map to the base. The Chevalley map is invariant under conjugation and compatible with scaling, so it induces a map $[\chi]:[\mathfrak g_D/G]\to\mathfrak c_D$. Composing it with $h_{E,\phi}$, we get a section $a=\chi(\phi)$ of the vector bundle $\mathfrak c_D$ over $X$. In other words, $a$ is simply the characteristic polynomial of $\phi$, which now varies along the curve.

**Definition 2.2** (Hitchin base and Hitchin fibration; Ngô 4.2.3). The Hitchin base is $\mathcal A=H^0(X,\mathfrak c_D)$, the space of sections of $\mathfrak c_D$. The Hitchin fibration is the map
$$f:\mathcal M\longrightarrow\mathcal A,\qquad(E,\phi)\longmapsto\chi(\phi).$$
For $a\in\mathcal A(k)$ or $a\in\mathcal A(\bar k)$, the Hitchin fiber is $\mathcal M_a=f^{-1}(a)$.

Note that the base is a finite-dimensional vector space, since $X$ is projective. For a split group one has $\mathfrak c_D=\bigoplus_iD^{\otimes e_i}$, where $e_1,\dots,e_r$ are the degrees of the basic invariant polynomials. For instance, for $G=GL_n$ the invariants are the coefficients of the characteristic polynomial, so that $e_i=i$ and
$$\mathcal A=\bigoplus_{i=1}^nH^0(X,D^{\otimes i}),\qquad a=(a_1,\dots,a_n),$$
because the $i$-th coefficient of the characteristic polynomial of a $D$-twisted endomorphism is a section of $D^{\otimes i}$. (The board first wrote $\Gamma(X_S,\mathcal O)^n$ here, and the correct version appeared later, on the board about spectral curves.) The dimension of the base can be computed with Riemann–Roch (Ngô 4.4.1): if $\deg D>2g-2$, then
$$\dim\mathcal A=\#\Phi\,\deg(D)/2+r\,(1-g+\deg D),$$
where $r$ is the rank of $G$ and $\Phi$ its set of roots. For $GL_n$ this is just $\sum_{i=1}^n\big(i\deg D+1-g\big)$, as one can also check directly.

The Kostant section also has a global version (Ngô 4.2.4), and this is exactly where the square root $D'$ of $D$ is needed. The point is that the Kostant section is not quite compatible with scaling. For example, for $\mathfrak{sl}_2$, scaling $\epsilon(a)=\left(\begin{smallmatrix}0&a\\1&0\end{smallmatrix}\right)$ by $t$ gives $\left(\begin{smallmatrix}0&ta\\t&0\end{smallmatrix}\right)$, and inside $SL_2$ one can conjugate this element to $\epsilon(t^2a)$, but only by an element like $\mathrm{diag}(t^{1/2},t^{-1/2})$, which involves a square root of $t$. When we globalize, the square root of $t$ becomes the square root $D'$ of $D$. With this choice one obtains the Kostant–Hitchin section
$$\epsilon_{D'}:\mathcal A\longrightarrow\mathcal M,\qquad f\circ\epsilon_{D'}=\mathrm{id},$$
whose values are regular at every point of $X$ (Ngô 4.3.4). It is worth noting that for $GL_n$ no square root is needed: one can take $V=\mathcal O\oplus D^{-1}\oplus\dots\oplus D^{1-n}$ and let $\phi$ be the companion matrix of $a$. Indeed, the entries $1$ below the diagonal are maps $D^{-i}\to D^{-(i+1)}\otimes D$, and the entries in the last column are the coefficients $a_i\in H^0(X,D^{\otimes i})$.

Finally, the board defined the open set of characteristic polynomials that we will mostly work with:
$$\mathcal A^\heartsuit=\{a\ :\ a\text{ is generically regular semisimple}\}=\{a\ :\ a(\bar X)\not\subset\mathfrak D_{G,D}\},$$
where $\mathfrak D_{G,D}\subset\mathfrak c_D$ is the discriminant divisor, twisted by $D$. This set is open in $\mathcal A$, and it is nonempty as soon as $\deg D>2g$ (Ngô §4.5). For $a\in\mathcal A^\heartsuit(\bar k)$, let $U_a=a^{-1}(\mathfrak c_D^{\mathrm{rs}})$. This is a dense open subset of $\bar X$, and its complement is the finite set of points where the section $a$ meets the discriminant. At such a point $v$, the restriction of $a$ to the disc $X_v$ is an element of $\mathfrak c^\heartsuit(\mathcal O_v)$, which is exactly the kind of local data we studied in the previous talk. This is the first concrete link between the global and the local pictures.

## 3. Symmetries of Hitchin fibers

Next we construct the symmetries of a Hitchin fiber. As in the local case, they come from the regular centralizer, and the construction is almost word for word the same.

### 3.1 The group scheme $J_a$ and the Picard stack $\mathcal P_a$

Let $J\to\mathfrak c$ be the regular centralizer (Ngô 2.1.1; Proposition 1.6 of the previous note). Since it is compatible with scaling, it descends to a group scheme over $[\mathfrak c/\mathbb G_m]$.

**Definition 3.1** (Ngô 4.3.1). For $a\in\mathcal A(S)$, let $J_a=a^*J$ be the pullback of $J$ along $h_a:X\times S\to[\mathfrak c/\mathbb G_m]$; it is a smooth commutative group scheme over $X\times S$. Let $\mathcal P_a(S)$ be the Picard groupoid of $J_a$-torsors over $X\times S$. As $a$ varies, these form a Picard stack $\mathcal P\to\mathcal A$.

Again, let us unwind this definition with a few examples. If $J_a$ were the constant group $\mathbb G_m$, then $\mathcal P_a$ would just be $\mathrm{Bun}_{\mathbb G_m}$, the Picard stack of line bundles, and if it were a constant torus $T$, then $\mathcal P_a$ would be $\mathrm{Bun}_T$. In general the situation is a little more complicated. For $a\in\mathcal A^\heartsuit$, the group scheme $J_a$ is a torus over the open set $U_a$, but this torus may be twisted (by the monodromy of $a$, see §5), and moreover $J_a$ degenerates at the finitely many points of $\bar X-U_a$. So, roughly speaking, **$\mathcal P_a$ is a generalized Picard stack**: a twisted and degenerate version of $\mathrm{Bun}_T$. At each point $v\in\bar X-U_a$, the local version of $\mathcal P_a$ is precisely the group $\mathcal P_{a,v}$ of the last talk. There is, however, one important difference with the local case. The local group $\mathcal P_{a,v}$ is an ind-scheme built only from affine pieces: by Lemma 4.3 of the previous note, it is an extension of a discrete group by an affine algebraic group of dimension $\delta_v$. The global $\mathcal P_a$, on the other hand, is a Picard stack whose neutral component usually also contains an abelian variety, much like the Jacobian inside the Picard stack of a curve.

### 3.2 The action on the Hitchin fiber

The action is defined exactly as in the local case (Ngô 4.3.2). The homomorphism $\chi^*J\to I$ (where $I$ denotes the centralizer group scheme over $\mathfrak g$) gives, for every pair $(E,\phi)$ over $a$, a homomorphism
$$J_a\longrightarrow\mathrm{Aut}(E,\phi)=h_{E,\phi}^*I.$$
In other words, $J_a$ acts by automorphisms on every Higgs bundle with characteristic polynomial $a$. Hence we can twist $(E,\phi)$ by any $J_a$-torsor, and this defines an action of $\mathcal P_a$ on $\mathcal M_a$. As $a$ varies, $\mathcal P$ acts on $\mathcal M$ relative to $\mathcal A$. For $GL_n$, as we will see in §4, this action is simply the tensor product of sheaves on the spectral curve.

### 3.3 The regular part is a torsor

Let $\mathcal M^{\mathrm{reg}}\subset\mathcal M$ be the open substack of pairs $(E,\phi)$ such that $h_{E,\phi}$ factors through $[\mathfrak g_D^{\mathrm{reg}}/G]$; in other words, $\phi(x)$ is regular at every point $x$ of the curve.

**Proposition 3.2** (Ngô 4.3.3). $\mathcal M^{\mathrm{reg}}$ is open in $\mathcal M$ and has nonempty fibers over $\mathcal A$. It is a torsor under $\mathcal P$. In particular, for every $a$,
$$\mathcal P_a\xrightarrow{\ \sim\ }\mathcal M_a^{\mathrm{reg}},\qquad p\longmapsto p\cdot\epsilon_{D'}(a).$$

*Sketch of proof.* The fibers are nonempty because the Kostant–Hitchin section $\epsilon_{D'}(a)$ is regular. For the torsor property, the argument is the same as in the local case (Proposition 1.8 of the previous note). The key input is that the stack $[\mathfrak g^{\mathrm{reg}}/G]$ is a gerbe over $\mathfrak c$ banded by $J$ (Ngô 2.2.1). Concretely, this means that two regular pairs with the same characteristic polynomial differ, locally on $X$, by an isomorphism which is unique up to $J_a$, and these local differences glue together to a $J_a$-torsor. ∎

This is the first half of the guiding principle. Just as in the local case, the regular part of a Hitchin fiber is a copy of its symmetry group, so one may think of $\mathcal M_a$ as a kind of compactification of $\mathcal P_a$. The board summarized it as follows: "Again, $\mathcal P_a$ acts on $\mathcal M_a$ and $\mathcal M_a^{\mathrm{reg}}$ is a $\mathcal P_a$-torsor."

## 4. Spectral curves: the case of $GL_n$

For $GL_n$ everything above can be made very concrete, thanks to spectral curves. This is the classical point of view of Hitchin and of Beauville, Narasimhan and Ramanan, and it gives a good intuition for the general case.

### 4.1 The spectral curve

Let $G=GL_n$ and fix $a=(a_1,\dots,a_n)\in\mathcal A^\heartsuit(\bar k)$. Let $\mathrm{Tot}(D)$ be the total space of the line bundle $D$. It is a surface with a projection to $X$, and it carries a tautological section $t$ of the pullback of $D$.

**Definition 4.1** (spectral curve; Ngô 4.7.1). The spectral curve $Y_a\subset\mathrm{Tot}(D)$ is the zero locus of
$$t^n+a_1t^{n-1}+\dots+a_n.$$

(The board wrote the coefficients in the opposite order, $t^n+a_{n-1}t^{n-1}+\dots+a_0$, and Ngô uses the signs $t^n-a_1t^{n-1}+\dots+(-1)^na_n$; these differences do not matter.) The projection $p:Y_a\to\bar X$ is finite and flat of degree $n$. The intuition is the following: if $a=\chi(\phi)$, then the fiber of $p$ over a point $x$ consists of the eigenvalues of $\phi(x)$, counted with multiplicity. Over $U_a$ these $n$ eigenvalues are distinct and $p$ is étale, while over the finitely many points of $\bar X-U_a$ some of them coincide. Figure 2 is the picture that was drawn on the board.

![[hitchin-fibration-fig2-spectral-curve.svg]]

*Figure 2. The spectral curve $Y_a$ inside the total space of $D$, seen as an $n$-sheeted cover of $X$. Over a point $x\in U_a$ it has $n$ points, namely the eigenvalues of $\varphi(x)$. Over the points of $X\smallsetminus U_a$, two sheets meet.*

On the board the curves were drawn as closed loops: three sheets of $Y_a$ stacked inside a box labelled $\mathrm{Tot}(D)$, and the loop $X\supset U_a$ below them. Here, for simplicity, we draw a piece of $X$ as a line. The picture should be taken as schematic, and the local shape of $Y_a$ at the points where sheets meet is explained more carefully in Figure 3. Roughly speaking, in the generic case two sheets meet as at a simple branch point, where $Y_a$ is still smooth. If $a$ is more special, two sheets can also cross each other, and then $Y_a$ acquires a node.

Let us also note that $Y_a$ is reduced if and only if $a\in\mathcal A^\heartsuit$; in fact, for $GL_n$ this is how Ngô describes $\mathcal A^\heartsuit$. The board at first also claimed that $Y_a$ is irreducible when $\deg D>2g$, but this was struck out later, and for a good reason: irreducibility fails whenever the characteristic polynomial factors. For example, for $n=2$ and two different sections $b,c\in H^0(X,D)$, the polynomial $(t-b)(t-c)$ gives a spectral curve which is the union of the graphs of $b$ and $c$. This curve is reduced but reducible, so this $a$ does lie in $\mathcal A^\heartsuit$. Such polynomials come from the Levi subgroup $GL_1\times GL_1$, and this is in fact a first appearance of endoscopy in the global picture, since the endoscopic groups of $GL_n$ are its Levi subgroups. What the condition $\deg D>2g$ does give, as we will see in §5, is that the cameral curve is connected.

### 4.2 Hitchin fibers as compactified Jacobians

**Proposition 4.2** (Beauville–Narasimhan–Ramanan; Ngô 4.7.1). Let $a\in\mathcal A^\heartsuit(\bar k)$. Then $\mathcal M_a$ is the stack $\overline{\mathrm{Pic}}(Y_a)$ of torsion-free $\mathcal O_{Y_a}$-modules of rank one. Under this identification, $\mathcal M_a^{\mathrm{reg}}$ is the open substack $\mathrm{Pic}(Y_a)$ of invertible modules, and $\mathcal P_a=\mathrm{Pic}(Y_a)$ acts by tensor product.

It is instructive to see how the correspondence works, since it is quite elementary. Let $(V,\phi)$ be a Higgs bundle with characteristic polynomial $a$. By the Cayley–Hamilton theorem, $\phi$ satisfies its own characteristic polynomial, so $V$ becomes a module over the algebra
$$p_*\mathcal O_{Y_a}=\mathcal O_X[t]/(t^n+a_1t^{n-1}+\dots+a_n),$$
where $t$ acts by $\phi$. In other words, $V=p_*\mathcal F$ for a coherent sheaf $\mathcal F$ on $Y_a$. Since $V$ is a vector bundle, $\mathcal F$ has no sections supported at points, which means that $\mathcal F$ is torsion-free; and since $V$ has rank $n=\deg p$, the sheaf $\mathcal F$ has rank one. Conversely, a torsion-free sheaf $\mathcal F$ of rank one gives back $V=p_*\mathcal F$, with $\phi$ given by multiplication by $t$. So, in a slogan, **a Higgs bundle is a rank one sheaf on its spectral curve.**

Under this dictionary, $\phi(x)$ is regular if and only if $\mathcal F$ is invertible at the points of $Y_a$ over $x$. This is nothing but Lemma 2.2 of the previous note. Indeed, over the disc at $v$ the spectral curve is $\mathrm{Spec}\,B$, where $B=\breve{\mathcal O}_v[T]/(P)$ is the ring of the last talk and $P$ is the polynomial $a$ restricted to the disc. Over this disc, $\mathcal F$ becomes a $B$-lattice, and we saw last time that a $B$-lattice is regular if and only if it is free. This observation also shows nicely how the local and the global pictures fit together. A torsion-free sheaf on $Y_a$ is glued from an invertible sheaf on the complement of the singular points and a $B$-lattice at each singular point. So, roughly speaking, $\overline{\mathrm{Pic}}(Y_a)$ is built from $\mathrm{Pic}(Y_a)$ and from the affine Springer fibers $\mathcal M_{a,v}$ at the points $v$ lying under the singularities of $Y_a$. This is the product formula of §6 in the case of $GL_n$.

It is useful to look at the two extreme cases. If $Y_a$ is smooth (Ngô 4.7.2), then every torsion-free sheaf is invertible, so $\mathcal M_a=\mathcal M_a^{\mathrm{reg}}=\mathrm{Pic}(Y_a)$. Since $Y_a$ is connected, the degree gives $\pi_0(\mathcal P_a)\cong\mathbb Z$, and the neutral component is the Jacobian of $Y_a$ times $B\mathbb G_m$. In other words, the decomposition of $\mathrm{Bun}_{\mathbb G_m}$ from the board appears again, now for the curve $Y_a$ instead of $X$. If $Y_a$ is singular, let $\xi:Y_a^\flat\to Y_a$ be its normalization (Ngô 4.7.3). Pulling back along $\xi$ gives an exact sequence
$$1\longrightarrow\mathcal R_a\longrightarrow\mathrm{Pic}(Y_a)\longrightarrow\mathrm{Pic}(Y_a^\flat)\longrightarrow1,$$
where $\mathcal R_a$ is a connected affine group of dimension $\delta_a=\dim H^0(Y_a,\xi_*\mathcal O_{Y_a^\flat}/\mathcal O_{Y_a})$, the sum of the local δ-invariants of the singularities. This is the global version of the exact sequence (2.1) of the previous note. Moreover, since $Y_a$ lies on the smooth surface $\mathrm{Tot}(D)$, its singularities are planar, and then a theorem of Altman, Iarrobino and Kleiman shows that $\mathrm{Pic}(Y_a)$ is dense in $\overline{\mathrm{Pic}}(Y_a)$ (Ngô 4.7.4).

As a quick sanity check of these identifications, let us compute a dimension. By adjunction, the spectral curve has genus $g(Y_a)=1+n(g-1)+n(n-1)\deg(D)/2$, so
$$\dim\mathcal P_a=\dim\mathrm{Pic}(Y_a)=g(Y_a)-1=n(n-1)\deg(D)/2+n(g-1).$$
This agrees with the general formula $\dim\mathcal P_a=\#\Phi\deg(D)/2+r(g-1)$ of Ngô 4.4.4, since $\#\Phi=n(n-1)$ and $r=n$.

## 5. Cameral curves and the open set $\mathcal A^\diamondsuit$

We now come back to a general group $G$. The spectral curve used the standard representation of $GL_n$ in an essential way, so we need a replacement, and this replacement is the cameral cover.

### 5.1 The cameral cover

For a general group there is no natural representation to work with, so there is no spectral curve. Instead one uses the cameral cover, which, roughly speaking, records the eigenvalues together with an ordering of them.

**Definition 5.1** (Donagi; Ngô §4.5). For $a\in\mathcal A(\bar k)$, the cameral cover $\pi_a:\widetilde X_a\to\bar X$ is the fiber product
$$\widetilde X_a=\bar X\times_{a,\mathfrak c_D}\mathfrak t_D.$$

The finite flat map $\pi:\mathfrak t_D\to\mathfrak c_D$ is the quotient by $W$, so $\pi_a$ is finite and flat of degree $|W|$, and $W$ acts on $\widetilde X_a$. Moreover, over $\mathfrak c_D^{\mathrm{rs}}$ the map $\pi$ is an étale $W$-torsor. Hence, for $a\in\mathcal A^\heartsuit$, the cameral cover is an étale $W$-cover over the dense open set $U_a\subset X$, as the board said. Figure 3(a) is the diagram that was drawn on the board.

![[hitchin-fibration-fig3-cameral-cover.svg]]

*Figure 3. (a) The cameral cover, a fiber product with an action of $W$. (b) A section $a$ that meets the discriminant transversally: over each intersection point the cameral curve looks like $t^2=\varepsilon$, which is smooth. (c) A section that is tangent to the discriminant: there the cameral curve looks like $t^2=\varepsilon^2$, that is, two branches crossing in a node.*

To get some intuition, let us look at $GL_n$ again. In this case a point of $\widetilde X_a$ over $x\in U_a$ is an ordering of the $n$ eigenvalues of $\phi(x)$. If we forget all eigenvalues except the first one, we get back the spectral curve: $Y_a=\widetilde X_a/S_{n-1}$. So one can think of the cameral curve as a kind of Galois closure of the spectral cover $Y_a\to X$. Its main advantage is that it exists for every $G$, and that the regular centralizer can be read off from it. More precisely, by the theorem of Donagi and Gaitsgory (Ngô 2.4 and 4.8), $J_a$ is essentially the group of $W$-equivariant maps from $\widetilde X_a$ to $T$, and on Lie algebras
$$\mathrm{Lie}(J_a)=\big(\pi_{a*}\mathcal O_{\widetilde X_a}\otimes\mathfrak t\big)^W=\mathfrak c_D^*\otimes D$$
(Ngô 4.4.3). So $\mathcal P_a$ behaves like a $W$-equivariant Picard stack of the cameral curve, a sort of generalized Prym variety. For $GL_n$ it reduces, as it should, to $\mathrm{Pic}(Y_a)$.

The board listed two basic facts about cameral curves (Ngô 4.5.1 and 4.5.4).

1. If $a\in\mathcal A^\heartsuit$, then $\widetilde X_a$ is reduced. Indeed, it is generically a $W$-torsor, hence generically reduced; and since $\pi_a$ is finite and flat, $\pi_{a*}\mathcal O_{\widetilde X_a}$ is torsion-free, so $\widetilde X_a$ has no embedded points.
2. If $\deg D>2g$, then $\widetilde X_a$ is connected. This follows from the connectedness theorem of Fulton and Hansen. Very roughly, one compactifies $\mathfrak c_D$ in a product of projective bundles, and in this compactification $\widetilde X_a$ becomes the preimage of a product of hyperplanes, to which the theorem applies.

### 5.2 The open set $\mathcal A^\diamondsuit$

**Definition 5.2** (Ngô §4.6). Let $\mathcal A^\diamondsuit\subset\mathcal A^\heartsuit$ be the set of $a$ such that the section $a(\bar X)$ meets the discriminant divisor $\mathfrak D_{G,D}$ transversally.

On the board this was phrased as "the locus where the intersections with the discriminant divisor are simple". Note that transversality includes the condition that $a$ avoids the singular locus of the discriminant, which has codimension $2$ in $\mathfrak c_D$; this singular locus is the image of the points of $\mathfrak t$ that lie on two or more root hyperplanes. It may help to view this as the global version of the arcs of the previous note (see Figure 1(b) there): a point of $\mathcal A^\diamondsuit$ is a section all of whose local arcs have order of contact $d_v(a)=1$ with the discriminant. Figure 3(b) shows such a section, while Figure 3(c) shows a section of $\mathcal A^\heartsuit$ which is tangent to the discriminant at one point, and which is therefore not in $\mathcal A^\diamondsuit$.

The talk ended with three facts about this open set. Taken together, they say that over $\mathcal A^\diamondsuit$ the Hitchin fibration is about as nice as one could hope.

**Theorem 5.3** (Ngô 4.6.3, 4.6.6, 4.6.1).
1. A point $a\in\mathcal A(\bar k)$ lies in $\mathcal A^\diamondsuit$ if and only if the cameral curve $\widetilde X_a$ is smooth.
2. If $a\in\mathcal A^\diamondsuit$, then $\mathcal M_a=\mathcal M_a^{\mathrm{reg}}$. Hence $\mathcal M_a$ is a $\mathcal P_a$-torsor, and the neutral component of $\mathcal P_a$ is an abelian stack, that is, the quotient of an abelian variety by the trivial action of a diagonalizable group.
3. If $\deg D>2g$, then $\mathcal A^\diamondsuit$ is nonempty (and open).

*Ideas of the proofs.* For (1), the question is local at a point $v$ where $a$ meets the discriminant. At a smooth point of the discriminant one can reduce to a group of semisimple rank one, and there a direct computation shows that the completed local ring of $\widetilde X_a$ is $\bar k[[\varepsilon]][t]/(t^2-\varepsilon^m)$, where $\varepsilon$ is a uniformizer at $v$ and $m$ is the intersection multiplicity of $a(\bar X)$ with the discriminant. For $m=1$ this ring is smooth, and the point is a simple branch point; for $m=2$ it is a node. These are exactly the two insets of Figure 3. On the other hand, if $a$ meets the singular locus of the discriminant, then $\widetilde X_a$ cannot be smooth there: the stabilizer of the point would have to contain two different reflections, but the local monodromy is cyclic, because it is tame.

For (2), it is perhaps most illuminating to give the local reason. At a point $v$ where $a$ meets the discriminant transversally, we have $d_v(a)=1$, and the local monodromy is a single reflection, so $c_v(a)=1$. By Bezrukavnikov's formula (Theorem 3.3 of the previous note), the local δ-invariant is therefore $\delta_v=(d_v-c_v)/2=0$. So every local affine Springer fiber $\mathcal M_{a,v}$ is zero-dimensional, and hence equal to its regular part (Corollary 3.2 of the previous note). Gluing the local pieces then gives $\mathcal M_a=\mathcal M_a^{\mathrm{reg}}$. For $GL_2$ this is just the smooth example $T^2-\pi$ of Example 2.6 of the previous note: near such a point the spectral curve looks like $t^2=\varepsilon\cdot u$ with $u$ a unit. For the actual proof of (2), Ngô refers to his earlier paper (Fibration de Hitchin et endoscopie, Prop. 4.2).

For (3), the argument is essentially the one used in Bertini's theorem. If $\deg D>2g$, then global sections of $\mathfrak c_D$ can have arbitrary values and first derivatives at any given point; more precisely, the map $H^0(\bar X,\mathfrak c_D)\to\mathfrak c_D\otimes\mathcal O/\mathfrak m_x^2$ is surjective (Ngô 4.6.2). Therefore the sections that are tangent to the discriminant somewhere, or that meet its singular locus, form a subset of $\mathcal A$ of positive codimension, and a general section lies in $\mathcal A^\diamondsuit$. ∎

Combining (1) with connectedness, we also get that if $\deg D>2g$ and $a\in\mathcal A^\diamondsuit$, then $\widetilde X_a$ is irreducible, since it is connected and smooth (Ngô 4.6.4). So over $\mathcal A^\diamondsuit$ the Hitchin fibration is as simple as possible: every fiber is a torsor under a group whose neutral component is an abelian stack. This is the analogue, in Ngô's setting, of Hitchin's statement that the generic fibers are abelian varieties.

Let us end this section with a remark on spectral versus cameral curves, since the two notions can easily be confused. For $GL_n$, the open set where $\mathcal M_a=\mathcal M_a^{\mathrm{reg}}$ is the set where $Y_a$ is smooth, and it is actually larger than $\mathcal A^\diamondsuit$. For example, if three eigenvalues meet as in $t^3=\varepsilon$, then the spectral curve is smooth at that point. However, the section $a$ passes through the singular locus of the discriminant, and indeed the cameral curve is singular there: locally it consists of two smooth branches meeting at a point. So $\mathcal A^\diamondsuit$ is not exactly the locus where Hitchin fibers are torsors. Rather, it is a convenient open set, defined uniformly for every group, on which everything is as simple as possible.

## 6. Outlook: what comes next in the paper

The talk stopped here. For orientation, let us list the main results in the rest of Ngô's chapter 4; most of them are global analogues of the local results from the previous talk.

*Dimensions* (Ngô 4.4.2–4.4.6). The Picard stack $\mathcal P$ is smooth over $\mathcal A^\heartsuit$. The reason is that the obstructions to deforming torsors under a smooth group scheme lie in an $H^2$, and this group vanishes on a curve. For $a\in\mathcal A^\heartsuit$ one has
$$\dim\mathcal P_a=\#\Phi\,\deg(D)/2+r(g-1),$$
and adding $\dim\mathcal A$ gives $\dim\mathcal P=(r+\#\Phi)\deg D$. By the density theorem below, $\mathcal M_a$ and $\mathcal M$ have the same dimensions.

*The product formula* (Ngô 4.13.1). This is the precise form of the guiding principle stated in the introduction. For $a$ in the open set $\mathcal A^{\mathrm{ani}}$ where $\pi_0(\mathcal P_a)$ is finite, gluing with the Kostant section gives a homeomorphism
$$\prod_{v\in\bar X-U_a}\mathcal M_{a,v}\times^{\prod_v\mathcal P_{a,v}}\mathcal P_a\ \longrightarrow\ \mathcal M_a.$$
In words, a Hitchin fiber is a twisted product of the affine Springer fibers at the bad points, together with the global symmetry group. In particular, when all local factors are points, as happens for $a\in\mathcal A^\diamondsuit$, we recover $\mathcal M_a=\mathcal M_a^{\mathrm{reg}}$.

*Density* (Ngô 4.14.1). For $a\in\mathcal A^\heartsuit$, the regular part $\mathcal M_a^{\mathrm{reg}}$ is dense in $\mathcal M_a$. The proof combines two ingredients: the product formula, which shows that the complement has smaller dimension, and the smoothness of $\mathcal M$, which shows that the fibers are local complete intersections and therefore cannot have small irreducible components. As a consequence, the irreducible components of $\mathcal M_a$ correspond to $\pi_0(\mathcal P_a)$. Interestingly, the local density result of the previous talk (Proposition 6.1 there) is deduced from this global statement, and not the other way around.

*Counting points* (Ngô ch. 8). Finally, here is how all of this is used. Counting the points of the Hitchin fibers over $\mathbb F_q$, and using the product formula, one expresses $\#\mathcal M_a(\mathbb F_q)$ as a global volume times a product of local orbital integrals. Summing over $a$ then gives the geometric side of the trace formula for the Lie algebra. The stabilization rests on decomposing the cohomology of $\mathcal M$ according to the characters κ of $\pi_0(\mathcal P_a)$, and on the support theorem, in which the δ-invariants control the codimensions of the strata of $\mathcal A$. The comparison with endoscopic groups goes through a map $\nu:\mathcal A_H\to\mathcal A$ and a homomorphism $\mathcal P_a\to\mathcal P_{H,a_H}$ (Ngô 4.15), which is the global version of §7 of the previous note.

## References

- B. C. Ngô, *Le lemme fondamental pour les algèbres de Lie*, Publ. Math. IHÉS 111 (2010), 1–169. [arXiv:0801.0446](https://arxiv.org/abs/0801.0446)
- B. C. Ngô, *Fibration de Hitchin et endoscopie*, Invent. Math. 164 (2006), 399–453.
- N. Hitchin, *Stable bundles and integrable systems*, Duke Math. J. 54 (1987), 91–114.
- A. Beauville, M. S. Narasimhan, S. Ramanan, *Spectral curves and the generalised theta divisor*, J. reine angew. Math. 398 (1989), 169–179.
- R. Donagi, D. Gaitsgory, *The gerbe of Higgs bundles*, Transform. Groups 7 (2002), 109–153.
- A. Altman, A. Iarrobino, S. Kleiman, *Irreducibility of the compactified Jacobian*, in *Real and complex singularities* (Oslo 1976), 1–12.
- W. Fulton, R. Lazarsfeld, *Connectivity and its applications in algebraic geometry*, Lecture Notes in Math. 862 (1981), 26–92.

Related: [[Affine Springer fibers and their symmetries]] · [[Endoscopy]]
