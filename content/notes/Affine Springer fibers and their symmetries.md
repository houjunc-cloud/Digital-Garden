---
title: Affine Springer fibers and their symmetries
description: "Talk notes, Ngô fundamental lemma seminar, 2026-10-23. Boards checked against Ngô §3.6–3.11 — regular centralizer, the symmetry group P(J_a), the regular orbit, GL_n via lattices, δ-invariant, Néron model, π_0, density, endoscopic comparison."
tags:
  - fundamental-lemma
  - affine-springer-fibers
  - seminar-notes
stage: 🌱 seedling
date: 2026-10-23
---

# Affine Springer fibers and their symmetries

An affine Springer fiber $\mathcal M_a$ is best thought of as a **partial compactification of its own symmetry group**. A commutative group ind-scheme $\mathcal P(J_a)$ acts on $\mathcal M_a$, simply transitively on a dense open piece $\mathcal M_a^{\mathrm{reg}}$. So the dimension of $\mathcal M_a$, its irreducible components, and (over $\mathbb F_q$) the orbital integrals it encodes are all controlled by $\mathcal P(J_a)$. Ngô says it himself (2.2.2): $[\mathfrak g/G]$ is "une sorte de compactification du champ de Picard $\mathbf BJ$". For $GL_n$ the whole story is commutative algebra of the order $B=\breve{\mathcal O}[T]/(P)$ inside the étale algebra $E=B\otimes\breve F$:

- points of $\mathcal M_a$ = $B$-lattices in $E$;
- regular points = free $B$-modules;
- $\mathcal P(J_a)=E^\times/B^\times$;
- $\dim\mathcal M_a=\dim_{\bar k}B^\flat/B$, Serre's δ-invariant;
- irreducible components ↔ $\mathbb Z^{s}$, one $\mathbb Z$ for each field factor of $E$.

> [!info] Source
> Ngô fundamental lemma learning seminar, Fri 2026-10-23. Title on the board: *Affine Springer fiber (§3.6–3.11 in Ngô's paper)*. Five board photos, taken 15:19–15:51, in Drive › Talks from others › Ngo Fundamental Lemma; full transcription in the appendix at the end.
> The photos stop in the middle of §3.6 (the $GL_n$ case). Sections 4–7 below fill in §3.7–3.11 from the paper, so the note covers the whole advertised range.
> Paper: Ngô Bảo Châu, *Le lemme fondamental pour les algèbres de Lie*, Publ. Math. IHÉS 111 (2010), [arXiv:0801.0446](https://arxiv.org/abs/0801.0446). Section and statement numbers follow the arXiv source.

---

## 0. The whole picture

### 0.1 Where this talk sits in Ngô's proof

The fundamental lemma (Ngô, Thm 1.11.1) is the identity

$$\mathbf O^{\kappa}_{a}\big(1_{\mathfrak g(\mathcal O)}\big)=q^{\,r^G_H(a_H)}\;\mathbf{SO}_{a_H}\big(1_{\mathfrak h(\mathcal O)}\big),\qquad r^G_H(a_H)=\deg\big(a_H^*\mathfrak R^G_H\big).$$

Ngô's route has three layers.

1. **Orbital integrals are point counts** (Kazhdan–Lusztig; Goresky–Kottwitz–MacPherson; Ngô §8.2). The κ-orbital integral is the κ-weighted number of $k$-points of the quotient stack $[\mathcal M_a/\mathcal P(J_a)]$.
2. **Local geometry — this talk, Ngô §3.** The structure of $\mathcal M_a$ and of its symmetry group $\mathcal P(J_a)$: the regular orbit; dimension $=\delta_a$; components $=\pi_0(\mathcal P(J_a))$, whose dual sits inside the dual torus $\hat T$ (this is where the κ's live); and the comparison with an endoscopic group $H$, whose missing dimension of symmetry is exactly $r^G_H(a_H)$.
3. **Globalize (Ngô §4–§7).** A Hitchin fiber modulo its symmetries is a product of the local quotients $[\mathcal M_v(a)/\mathcal P_v(J_a)]$ (product formula, Ngô 4.13.1). The local δ-invariants control the dimensions of strata of the Hitchin base, which is what the support theorem needs. The support theorem gives a global identity, and the local fundamental lemma is extracted from it.

So chapter 3 is the local toolbox. Every structural fact about $\mathcal M_a$ proved there is used either in the point count (§8) or in the global dimension estimates.

### 0.2 Dictionary

| | general $G$ | $GL_n$ |
|---|---|---|
| $\mathcal M_a(\bar k)$ | $\{g\in G(\breve F)/G(\breve{\mathcal O}) : \mathrm{ad}(g)^{-1}\gamma_0\in\mathfrak g(\breve{\mathcal O})\}$ | $B$-lattices in $E$ |
| $\mathcal M_a^{\mathrm{reg}}$ | $\mathrm{ad}(g)^{-1}\gamma_0$ regular mod $\pi$ | free $B$-modules $xB$ |
| $J_a$ | centralizer of the Kostant element $\gamma_0=\epsilon(a)$ | $\mathrm{Res}_{B/\breve{\mathcal O}}\mathbb G_m$ |
| $\mathcal P(J_a)(\bar k)$ | $J_a(\breve F)/J_a(\breve{\mathcal O})$ | $E^\times/B^\times$ |
| Néron model $J_a^\flat$ | maximal smooth finite-type model of $J_{a,\breve F}$ | $\mathrm{Res}_{B^\flat/\breve{\mathcal O}}\mathbb G_m$ |
| affine part $\mathcal R_a$ | $J_a^\flat(\breve{\mathcal O})/J_a(\breve{\mathcal O})$ | $(B^\flat)^\times/B^\times$ |
| lattice part | $J_a(\breve F)/J_a^\flat(\breve{\mathcal O})$ | $E^\times/(B^\flat)^\times\cong\mathbb Z^s$ |
| $\delta_a=\dim\mathcal M_a$ | $\dim\mathcal R_a=\tfrac12\big(d(a)-c(a)\big)$ | $\dim_{\bar k}B^\flat/B$ |
| $\pi_0(\mathcal P(J_a))$ | dual to $\hat T(\pi_a(I))\subset\hat T$ | $\mathbb Z^s$ |
| irreducible components of $\mathcal M_a$ | $\leftrightarrow\pi_0(\mathcal P(J_a))$ | $\leftrightarrow\mathbb Z^s$ |
| $\mathcal M_a(\bar k)/\mathcal P(J_a)(\bar k)$ | $G(\breve{\mathcal O})$-classes of integral $\gamma$ with $\chi(\gamma)=a$ | isomorphism classes of $B$-lattices |

---

## 1. Set-up and recap

**Notation (board 15:42).** $k=\mathbb F_q$, $\mathcal O=k[[\pi]]$, $F=k((\pi))$; over $\bar k$: $\breve{\mathcal O}=\bar k[[\pi]]$, $\breve F=\bar k((\pi))$. $G$ is a split reductive group over $k$ with $p=\mathrm{char}\,k\nmid|W|$. $\chi:\mathfrak g\to\mathfrak c=\mathfrak t/\!/W$ is the Chevalley map ("characteristic polynomial"), $\epsilon:\mathfrak c\to\mathfrak g^{\mathrm{reg}}$ the Kostant section, $\mathfrak D\subset\mathfrak c$ the discriminant divisor, $\mathfrak c^{\mathrm{rs}}=\mathfrak c\smallsetminus\mathfrak D$, and

$$\mathfrak c^\heartsuit(\mathcal O)=\mathfrak c(\mathcal O)\cap\mathfrak c^{\mathrm{rs}}(F).$$

### 1.1 The stack $[\mathfrak g/G]$ (board 15:19, "Rmk")

$[\mathfrak g/G](S)$ is the groupoid of pairs $(E,\phi)$: a $G$-torsor $E$ on $S$ and a section $\phi$ of the adjoint bundle $\mathrm{ad}(E)=E\times^G\mathfrak g$ (board 15:42 margin: "adjoint vector bundle ⟷ a section φ"). Think of a point as "an element of $\mathfrak g$ up to conjugacy, allowed to be twisted by a torsor". For $GL_n$ it is a rank-$n$ vector bundle with an endomorphism. Ngô (2.2.2) calls $[\mathfrak g/G]$ a *moule*. Evaluate it on the formal disc and you get affine Springer fibers; evaluate it on a projective curve (twisted by a line bundle $D$) and you get Hitchin fibers.

### 1.2 The affine Springer fiber (board 15:42; Ngô §3.2)

> [!note] Definition (modular description)
> Let $\gamma\in\mathfrak g(F)$ be regular semisimple. For a $k$-algebra $R$, $\mathrm{Gr}_\gamma(R)$ is the groupoid of triples $(E,\phi,\iota)$: $E$ a $G$-torsor over $R[[\pi]]$, $\phi$ a global section of $\mathrm{ad}(E)$, and $\iota:(E,\phi)\cong(E_0,\gamma)$ an isomorphism over $R((\pi))$, where $E_0$ is the trivial torsor.

How to read it. The pair $(E,\iota)$ alone is a point of the affine Grassmannian $\mathrm{Gr}_G$: a $G$-bundle on the disc identified with the trivial one on the punctured disc, i.e. a new integral structure. The extra condition says that $\gamma$, which a priori lives only on the punctured disc, extends over the closed point in this new integral structure. So

> **$\mathrm{Gr}_\gamma$ = the integral structures preserved by $\gamma$.**

Since $\phi$ is determined by $\iota$ (it is $\gamma$ transported), $\phi$ is a condition, not extra data:

**Prop (Ngô 3.2.1; board 15:19).** $(E,\phi,\iota)\mapsto(E,\iota)$ is a closed immersion $\mathrm{Gr}_\gamma\hookrightarrow\mathrm{Gr}_G$. Moreover $(\mathrm{Gr}_\gamma)_{\mathrm{red}}$ is a scheme locally of finite type over $k$ (Kazhdan–Lusztig).

The word "locally" matters. $\mathrm{Gr}_\gamma$ is finite-dimensional, but usually it has infinitely many irreducible components, permuted by a lattice of symmetries. Modulo that lattice it is projective (Ngô 3.4.1). It is of finite type exactly when the torus $J_{a,\breve F}$ of §2 is anisotropic.

**Lemma (points; board 15:19).**

$$\mathrm{Gr}_\gamma(R)=\big\{[g]\in G(R((\pi)))/G(R[[\pi]])\ :\ \mathrm{ad}(g)^{-1}\gamma\in\mathfrak g(R[[\pi]])\big\}.$$

As written this holds for $R=\bar k$. For general $R$ one has to work étale-locally on $R$, because a $G$-torsor over $R[[\pi]]$ need not be trivial. For $GL_n$, $[g]\leftrightarrow L=g\,\breve{\mathcal O}^n$ and the condition is $\gamma L\subset L$.

**Def (board 15:19).** $\mathrm{Gr}^{\mathrm{reg}}_\gamma\subset\mathrm{Gr}_\gamma$ is the open subfunctor where $\mathrm{ad}(g)^{-1}\gamma\in\mathfrak g^{\mathrm{reg}}(R[[\pi]])$. Since $\gamma$ is already regular at the generic point, this only asks that **$\mathrm{ad}(g)^{-1}\gamma \bmod \pi$ be regular**. Board 15:42 (lower right) says the same thing with stacks: there is a map $\mathrm{Gr}_\gamma\to[\mathfrak g/G]$, and the regular part is the preimage of the open substack $[\mathfrak g^{\mathrm{reg}}/G]$. This is Ngô's definition of $\mathcal M^{\mathrm{reg}}_v(a)$ in §3.3.

**Def (board 15:19).** For $a\in\mathfrak c^\heartsuit(\mathcal O)$, put $\mathcal M_a:=\mathrm{Gr}_{\gamma_0}$ with $\gamma_0=\epsilon(a)$. The Kostant section gives a base point in every stable class, and this base point is integral and regular. So $\mathcal M_a$ depends only on $a$, and the base point $[1]$ always lies in $\mathcal M_a^{\mathrm{reg}}$.

**Today (board 15:19):** geometric properties of $\mathcal M_a$ after passing to $\bar k$, i.e. $a\in\mathfrak c^\heartsuit(\breve{\mathcal O})$.

### 1.3 Arcs, $\mathfrak{sl}_2$, and what $\mathcal M_a$ parametrizes (board 15:41, bottom)

- **Arcs.** $\mathfrak g(\mathcal O)$ = maps $D\to\mathfrak g$ and $\mathfrak c(\mathcal O)$ = maps $D\to\mathfrak c$, where $D=\mathrm{Spec}\,\mathcal O$ is the disc, with a generic point ($F$) and a closed point ($k$) — the oval drawn on the board. $a\in\mathfrak c^\heartsuit(\mathcal O)$ means the generic point of the arc misses the discriminant $\mathfrak D$; the closed point may lie on it. If the whole arc misses $\mathfrak D$, i.e. $a\in\mathfrak c^{\mathrm{rs}}(\mathcal O)\subsetneq\mathfrak c^\heartsuit(\mathcal O)$, then every integral element over $a$ is regular semisimple mod $\pi$ and $\mathcal M_a$ is discrete. All the geometry comes from the arc touching $\mathfrak D$; the order of contact is $d(a)$ (§4).
- **$\mathfrak{sl}_2$.** $\mathfrak c=\mathbb A^1$, $\chi(x)=-\det x$, $\epsilon(a)=\left(\begin{smallmatrix}0&a\\1&0\end{smallmatrix}\right)$, discriminant $4a$. So $\mathfrak c^\heartsuit(\mathcal O)=\mathcal O\smallsetminus\{0\}$ and $d(a)=\mathrm{val}(a)$.
- **The map to integral conjugacy classes.** $\mathcal M_a(\bar k)\to\mathfrak g(\breve{\mathcal O})/G(\breve{\mathcal O})$, $[g]\mapsto[\mathrm{ad}(g)^{-1}\gamma_0]$, lands in the fiber over $a$. Two points have the same image iff $g'\in J_a(\breve F)\,g\,G(\breve{\mathcal O})$. Every integral $\gamma$ with $\chi(\gamma)=a$ is hit, because $H^1(\breve F,J_a)=0$ (Steinberg). Hence

$$\mathcal M_a(\bar k)\big/\mathcal P(J_a)(\bar k)\;\cong\;\{\gamma\in\mathfrak g(\breve{\mathcal O}):\chi(\gamma)=a\}\big/G(\breve{\mathcal O}).$$

The picture on the board: a hatched region ($\mathfrak g(\mathcal O)/G(\mathcal O)$) fibred over a line ($\mathfrak c(\mathcal O)$), a curve through it (the Kostant section), and the fiber over $a$ marked by a dashed line. In that fiber $\epsilon(a)$ is the unique regular class. The other classes are the boundary $\mathcal M_a\smallsetminus\mathcal M^{\mathrm{reg}}_a$ modulo symmetries. This is why the quotient $[\mathcal M_a/\mathcal P(J_a)]$, and not $\mathcal M_a$ itself, computes orbital integrals (§8).

---

## 2. Symmetries — the core definitions

### 2.1 The regular centralizer $J$ (Ngô 2.1.1)

> [!note] Definition
> There is a unique smooth commutative group scheme $J\to\mathfrak c$ with a $G$-equivariant isomorphism $\chi^*J|_{\mathfrak g^{\mathrm{reg}}}\cong I|_{\mathfrak g^{\mathrm{reg}}}$, where $I\to\mathfrak g$ is the group scheme of centralizers. It extends to a homomorphism $\chi^*J\to I$ over all of $\mathfrak g$. Concretely $J=\epsilon^*I$. For $a\in\mathfrak c^\heartsuit(\mathcal O)$ put $J_a:=a^*J$: a smooth commutative group scheme over $\mathcal O$ whose generic fiber is the torus $G_{\gamma_0,F}$.

How to think about it:

- Centralizers of regular elements with the same characteristic polynomial are canonically isomorphic: they are commutative, so the identification by conjugation does not depend on the conjugating element. $J_a$ is "the" centralizer attached to $a$.
- The extension $\chi^*J\to I$ says that $J_a$ acts on **every** element with characteristic polynomial $a$, the non-regular ones included. This is what makes $J_a$ a symmetry of the whole affine Springer fiber, boundary included.
- Over $\mathfrak c^{\mathrm{rs}}$, $J$ is the torus $(\pi_*T)^W$ for the cameral cover $\pi:\mathfrak t\to\mathfrak c$ (Donagi–Gaitsgory; Ngô 2.4). Over $\mathfrak D$ it degenerates: unipotent parts appear and fibers can become disconnected.

Examples:

- $GL_n$: the centralizer of a companion matrix is the unit group of $\mathcal O[\gamma_0]$, so $J_a=\mathrm{Res}_{B/\mathcal O}\mathbb G_m$ with $B=\mathcal O[T]/(P_a)$. Its fibers are connected (connected center, Ngô 2.3.1).
- $SL_2$: $J_a=\{u+vT:\ u^2-av^2=1\}\subset\mathrm{Res}_{B/\mathcal O}\mathbb G_m$, with $B=\mathcal O[T]/(T^2-a)$. If $\pi\mid a$, the special fiber is $\{u=\pm1\}\cong\mu_2\times\mathbb G_a$, which is disconnected. Among groups of semisimple rank one, only $SL_2$ (times a torus) does this (Ngô 2.4.7). It is the source of torsion in $\pi_0$ (§5).

### 2.2 The symmetry group $\mathcal P(J_a)$ (Ngô §3.3)

> [!note] Definition
> $\mathcal P(J_a)(S)$ = $J_a$-torsors on $D\hat\times S$ with a trivialization over the punctured disc. It is a group ind-scheme over $k$ — "the affine Grassmannian of the commutative group $J_a$" — with
> $$\mathcal P(J_a)(\bar k)=J_a(\breve F)/J_a(\breve{\mathcal O}).$$
> If $J_a$ has connected fibers, also $\mathcal P(J_a)(k)=J_a(F)/J_a(\mathcal O)$.

**Action.** Twist $(E,\phi)$ by a $J_a$-torsor, using $J_a\to\mathrm{Aut}(E,\phi)$. On points, $J_a(\breve F)\cong G_{\gamma_0}(\breve F)$ acts by left multiplication, $j\cdot[g]=[jg]$. This descends to $J_a(\breve F)/J_a(\breve{\mathcal O})$ because of the extension $\chi^*J\to I$: if $\gamma=\mathrm{ad}(g)^{-1}\gamma_0$ is integral, then $\mathrm{ad}(g)^{-1}$ maps $J_a$ into $I_\gamma$ over $\breve{\mathcal O}$, so $J_a(\breve{\mathcal O})\subset g\,G(\breve{\mathcal O})\,g^{-1}$.

Analogy: a torus acting on a toric variety. For $GL_n$ it is literally the local Jacobian acting on the local compactified Jacobian (§3).

### 2.3 The regular locus is a trivial torsor (Ngô Lemme 3.3.1)

> [!important] Lemma
> $\mathcal M_a^{\mathrm{reg}}$ is a principal homogeneous space under $\mathcal P(J_a)$, trivialized by the Kostant point:
> $$\mathcal P(J_a)\xrightarrow{\ \sim\ }\mathcal M_a^{\mathrm{reg}},\qquad p\mapsto p\cdot[1].$$

Why. Ngô Prop 2.2.1 says $[\mathfrak g^{\mathrm{reg}}/G]\to\mathfrak c$ is a gerbe banded by $J$, neutralized by $\epsilon$. So a regular pair $(E,\phi)$ on the disc with characteristic polynomial $a$ is locally isomorphic to the Kostant pair $(E_0,\gamma_0)$; the sheaf of such isomorphisms is a $J_a$-torsor; and $\iota$ trivializes it on the punctured disc. That is exactly a point of $\mathcal P(J_a)$. On $\bar k$-points: regular integral elements over $a$ form a single $G(\breve{\mathcal O})$-orbit, so $\mathrm{ad}(g)^{-1}\gamma_0=\mathrm{ad}(h)^{-1}\gamma_0$ with $h\in G(\breve{\mathcal O})$, hence $gh^{-1}\in G_{\gamma_0}(\breve F)=J_a(\breve F)$.

Consequence: $\mathcal M_a$ = (a copy of the group $\mathcal P(J_a)$) ∪ (a boundary). The rest of the chapter is "the structure of $\mathcal P(J_a)$" plus "the boundary is small" (§4, §6).

---

## 3. The case of $GL_n$ (Ngô §3.6; boards 15:28, 15:41, 15:51)

The board assumes $n<p$. This gives $p\nmid|W|=n!$ (Ngô's standing hypothesis), and it makes every extension of $\breve F$ of degree $\le n$ tamely ramified, which is used in Serre's formula (§3.5).

### 3.1 Dictionary

- $a\in\mathfrak c^\heartsuit(\breve{\mathcal O})\leftrightarrow P(T)=T^n+a_1T^{n-1}+\dots+a_n\in\breve{\mathcal O}[T]$, separable over $\breve F$. (Ngô writes the coefficients as $(-1)^ia_i$; same thing.) $\gamma_0=\epsilon(a)$ is the companion matrix.
- $B:=\breve{\mathcal O}[T]/(P)$, free of rank $n$ over $\breve{\mathcal O}$.
- $E:=B\otimes_{\breve{\mathcal O}}\breve F\cong E_1\times\dots\times E_s$, one field $E_i/\breve F$ for each irreducible factor of $P$ over $\breve F$. Each $E_i$ is totally (and tamely) ramified, since $\bar k$ is algebraically closed.
- The companion matrix identifies $(\breve F^n,\gamma_0)$ with $(E,\ \text{multiplication by }T)$, and $(\breve{\mathcal O}^n,\gamma_0)$ with $(B,T)$.

Geometric meaning: $\mathrm{Spec}\,B$ is the germ of the **spectral curve** $\{P(T)=0\}$ in the $(T,\pi)$-plane, a plane curve singularity. $\mathrm{Spec}\,E$ is its punctured version: a disjoint union of $s$ punctured discs, one for each branch.

### 3.2 Points are $B$-lattices (Ngô 3.6.1; board 15:28)

$$\mathcal M_a(\bar k)=\{\breve{\mathcal O}\text{-lattices }L\subset\breve F^{\,n}\ \text{with}\ \gamma_0L\subset L\}=\{B\text{-submodules }L\subset E\ \text{that are }\breve{\mathcal O}\text{-free of rank }n\}.$$

Ngô calls these *$B$-réseaux*. In Laumon's point of view, $\mathcal M_a$ is the local compactified Jacobian of the singular germ $\mathrm{Spec}\,B$: it parametrizes torsion-free rank-one $B$-modules together with an embedding into $E$.

### 3.3 The regular part (board 15:28, Lemma and proof)

**Lemma.** $\mathcal M_a^{\mathrm{reg}}(\bar k)=\{L\in\mathcal M_a(\bar k): L\cong B\}$, i.e. the lattices $L=xB$ with $x\in E^\times$.

*Proof (board).* $L\in\mathcal M_a^{\mathrm{reg}}$
⟺ $T$ acting on $L/\pi L$ is a regular element of $\mathfrak{gl}_n(\bar k)$
⟺ $L/\pi L\cong\bar k[T]/(\bar P)$ (a matrix is regular iff it has a cyclic vector, and the characteristic polynomial of $T$ on $L/\pi L$ is $\bar P$)
⟺ $L$ is a cyclic $B$-module (Nakayama)
⟺ $L\cong B$ (a surjection $B\twoheadrightarrow L$ between free $\breve{\mathcal O}$-modules of the same rank is an isomorphism). ∎

So "regular" = "locally free", and the non-regular points are the modules that fail to be locally free at the singular point: the boundary of the compactified Jacobian.

### 3.4 Symmetries (boards 15:41, 15:51)

$$J_a(\breve F)=(\breve F[T]/P)^\times=E^\times,\qquad J_a(\breve{\mathcal O})=B^\times,\qquad \mathcal P(J_a)(\bar k)=E^\times/B^\times,$$

acting on lattices by multiplication. The torsor statement 2.3 is now transparent: $E^\times/B^\times\to\{xB\}$, $x\mapsto xB$, is a bijection. $E^\times/B^\times$ is the local Picard group (generalized Jacobian) of the germ.

### 3.5 Normalization, δ and $\pi_0$ (Ngô 3.6.2–3.6.3; board 15:51)

Let $B^\flat$ be the normalization of $B$ in $E$, i.e. the ring of integers $\prod_i\mathcal O_{E_i}$. Then

$$0\to(B^\flat)^\times/B^\times\to E^\times/B^\times\to E^\times/(B^\flat)^\times\to0,\qquad E^\times/(B^\flat)^\times=\bigoplus_{i=1}^s E_i^\times/\mathcal O_{E_i}^\times\ \overset{\mathrm{val}}{\cong}\ \mathbb Z^s.$$

The right-hand term is "finite free" (free of finite rank), as annotated on the board.

**Lemma (board 15:51).** $(B^\flat)^\times/B^\times$ is "connected".

Meaning: it is the group of $\bar k$-points of a connected affine algebraic group $\mathcal R_a$; hence the quotation marks.

*Proof.* Choose $N$ with $\pi^NB^\flat\subset B$ (the conductor is open). Then
$$(B^\flat)^\times/B^\times=(B^\flat/\pi^NB^\flat)^\times\big/(B/\pi^NB^\flat)^\times.$$
For a finite-dimensional $\bar k$-algebra $A$, $A^\times$ is the complement of the hypersurface $\{\det(\text{multiplication})=0\}$ in the affine space $A$, so it is a connected algebraic group of dimension $\dim A$. A quotient of a connected group is connected, and its dimension is $\dim B^\flat/\pi^NB^\flat-\dim B/\pi^NB^\flat=\dim_{\bar k}B^\flat/B$. ∎

**Consequences.**

- The neutral component of $\mathcal P(J_a)$ is $\mathcal R_a=(B^\flat)^\times/B^\times$, and $\pi_0(\mathcal P(J_a))=E^\times/(B^\flat)^\times\cong\mathbb Z^s$. It is free, with a basis indexed by the branches (the connected components of $\mathrm{Spec}\,B^\flat$).
- $\dim\mathcal P(J_a)=\delta_a:=\dim_{\bar k}B^\flat/B$, **Serre's δ-invariant** of the curve singularity.
- Serre's formula: $\delta_a=\tfrac12\big(d(a)-c(a)\big)$ with $d(a)=\mathrm{val}\,\mathrm{disc}(P)$ and $c(a)=n-s$. Reason: $\mathrm{val}\,\mathrm{disc}(B)=\mathrm{val}\,\mathrm{disc}(B^\flat)+2\,\mathrm{length}(B^\flat/B)$, and for a tame totally ramified $E_i$ one has $\mathrm{val}\,\mathrm{disc}(\mathcal O_{E_i})=[E_i:\breve F]-1$; summing gives $n-s$. This is where $n<p$ is used.
- Inside $\mathcal R_a$: if $B$ is local, $\mathcal R_a\cong\mathbb G_m^{\,s-1}\times(\text{unipotent})$. The torus comes from the branches, the unipotent part from the "cuspidal" part of the singularity. In general replace $s-1$ by $s-\#\{\text{maximal ideals of }B\}$.

### 3.6 The board's example, worked out: $P(T)=T(T-\pi)$

The board only started this: $E=\breve F[T]/T(T-\pi)\cong\breve F\times\breve F$, $f\mapsto(f(0),f(\pi))$. Here is the rest.

**The rings.** $B=\{(x,y)\in\breve{\mathcal O}^2 : x\equiv y\bmod\pi\}$ (the image of $c_0+c_1T\mapsto(c_0,\,c_0+c_1\pi)$), $B^\flat=\breve{\mathcal O}\times\breve{\mathcal O}$, and $B^\flat/B\cong\bar k$, so $\delta=1$. Serre's formula agrees: $d=\mathrm{val}(\pi^2)=2$, $c=2-2=0$, $\delta=(2-0)/2=1$.

**The group.** $\mathcal R_a=(B^\flat)^\times/B^\times\xrightarrow{\sim}\mathbb G_m$, $(x,y)\mapsto\bar x/\bar y$. And $\pi_0=E^\times/(B^\flat)^\times\cong\mathbb Z^2$, $(x,y)\mapsto(\mathrm{val}\,x,\mathrm{val}\,y)$.

**The lattices.** Since $\dim B^\flat/B=1$, the only rings between $B$ and $B^\flat$ are $B$ and $B^\flat$. So a $B$-lattice $L$ has one of two endomorphism rings:

- $\mathrm{End}(L)=B^\flat$: then $L=L_{m,n}:=\pi^m\breve{\mathcal O}\oplus\pi^n\breve{\mathcal O}$. These are the **non-regular** points: $T=(0,\pi)$ acts by $0$ on $L/\pi L$.
- $\mathrm{End}(L)=B$: then $L$ is free, because $B$ is a local Gorenstein ring (it is monogenic). So $L=xB$, a **regular** point.

Fix $(m,n)$. The lattices of colength one between $\pi^{m+1}\breve{\mathcal O}\oplus\pi^{n+1}\breve{\mathcal O}$ and $L_{m,n}$ correspond to lines in $\bar k^2$, so they form a $\mathbb P^1$:

$$C_{m,n}=\big\{\,L_c=\pi^{m+1}\breve{\mathcal O}\oplus\pi^{n+1}\breve{\mathcal O}+\breve{\mathcal O}\cdot(\pi^m,c\,\pi^n)\ :\ c\in\mathbb P^1\,\big\}.$$

All of them are $B$-stable. For $c\in\bar k^\times$, $L_c=(\pi^m,c\,\pi^n)B$ is regular, and these points form one $\mathcal R_a=\mathbb G_m$-orbit. The two limits are $L_0=L_{m,n+1}$ and $L_\infty=L_{m+1,n}$. Every regular lattice is of the form $(\pi^m,c\,\pi^n)B$, so

$$\mathcal M_a=\bigcup_{(m,n)\in\mathbb Z^2}C_{m,n},\qquad C_{m,n}\cap C_{m+1,n-1}=\{L_{m+1,n}\}.$$

For each value $N=m+n+1$ of $\mathrm{val}\det$ this is an infinite chain of $\mathbb P^1$'s:

```
 ... ——●——( C_{m,n} )——●——( C_{m+1,n-1} )——●—— ...
   L_{m,n+1}        L_{m+1,n}            L_{m+2,n-1}
```

**Checks against the general theory.**

- $\dim\mathcal M_a=1=\delta$ (§4).
- $\mathcal M_a^{\mathrm{reg}}=\bigsqcup\mathbb G_m\cong\mathbb Z^2\times\mathbb G_m=\mathcal P(J_a)$ (Lemma 3.3.1). It is dense, and the components $C_{m,n}$ are indexed by $\mathbb Z^2=\pi_0$ (Cor 3.10.2).
- $\Lambda=\mathbb Z^2$, acting through multiplication by $(\pi^i,\pi^j)$, acts freely. $\mathcal M_a/\Lambda$ is one $\mathbb P^1$ with $0$ and $\infty$ glued: a nodal rational curve, which is projective (Prop 3.4.1).
- This is exactly Ngô §8.3 "Un cas très simple" ($d=2$, $c=0$). There, the closure of each orbit $O_\lambda$ has boundary $\{\pi^\lambda,\pi^{\lambda-\alpha^\vee}\}$. Here $(m+1,n)-(m,n+1)=(1,-1)=\alpha^\vee$, and $\mathcal R_a$ is Ngô's $A_{\pm\alpha}=T/\ker\alpha$.

**The fundamental lemma in this example.** Work over $\mathbb F_q$ and normalize the Haar measure by $\mathrm{vol}(T(\mathcal O))=1$, where $T$ is the diagonal torus ($=J_a^\flat$). $T(F)$ acts on $\mathcal M_a(\mathbb F_q)$ with two orbits:

- the lattices $L_{m,n}$, with stabilizer $T(\mathcal O)$;
- the free lattices, with stabilizer $B^\times$, of index $\#\mathcal R_a(\mathbb F_q)=q-1$ in $T(\mathcal O)$.

Hence

$$\mathbf O_{\gamma_0}\big(1_{\mathfrak{gl}_2(\mathcal O)}\big)=\frac{1}{1}+\frac{1}{1/(q-1)}=q.$$

On the endoscopic side, $H=T=GL_1\times GL_1$, $a_H=(T,\ T-\pi)$, $\mathbf{SO}_{a_H}(1_{\mathfrak t(\mathcal O)})=1$, and $r^G_H(a_H)=\mathrm{val}\,\mathrm{Res}(T,T-\pi)=1$. The fundamental lemma reads $q=q^1\cdot 1$ ✓.

In Ngô's normalization ($\mathrm{vol}(J_a(\mathcal O))=1$, §8.2) the same computation reads
$$\#[\mathcal M_a/\mathcal P(J_a)](\mathbb F_q)=1+\frac{1}{q-1}=\frac{q}{\#\mathcal R_a(\mathbb F_q)},$$
which is the formula of his §8.3.

(For $GL_n$, $H^1(F,J_a)=0$ and $H$ is a Levi, so the fundamental lemma is just parabolic descent: $|D^G_M(\gamma)|^{-1/2}=q^{\mathrm{val}\,\mathrm{Res}(P_1,P_2)}$. It has real content only when κ is non-trivial on $H^1(F,J_a)$, e.g. elliptic endoscopy for $SL_2$.)

### 3.7 Two more $GL_2$ germs, for contrast

| $P(T)$ | singularity | $B\subset B^\flat$ | $\mathcal R_a$ | $\delta=\tfrac{d-c}{2}$ | $\mathcal M_a$ |
|---|---|---|---|---|---|
| $T(T-\pi)$ | node, 2 branches | $\{x\equiv y\}\subset\breve{\mathcal O}^2$ | $\mathbb G_m$ | $\tfrac{2-0}{2}=1$ | disjoint union over $\mathbb Z$ of infinite chains of $\mathbb P^1$ |
| $T^2-\pi$ | smooth, ramified | $B=B^\flat=\mathcal O_E$ | trivial | $\tfrac{1-1}{2}=0$ | $\mathbb Z$ (discrete) |
| $T^2-\pi^3$ | cusp, 1 branch | $\breve{\mathcal O}+\pi\mathcal O_E\subset\mathcal O_E$ | $\mathbb G_a$ | $\tfrac{3-1}{2}=1$ | disjoint union over $\mathbb Z$ of $\mathbb P^1$'s |

Here $E=\breve F(\sqrt\pi)$ in the last two rows. For the cusp, $\mathcal O_E^\times/B^\times\cong\mathbb G_a$ via $u_0+u_1\sqrt\pi\mapsto\overline{u_1/u_0}$. The orbit $\{\pi^{m/2}(1+c\sqrt\pi)B : c\in\bar k\}$ is an $\mathbb A^1$, and its closure adds one point, $\pi^{(m+1)/2}\mathcal O_E$ (the limit as $c\to\infty$).

So the node gives a torus and chains, the cusp gives $\mathbb G_a$ and disjoint $\mathbb P^1$'s, and the smooth germ gives nothing (Cor 3.7.2: $\dim 0\Rightarrow\mathcal M_a=\mathcal M_a^{\mathrm{reg}}$).

---

## 4. Dimension and the Néron model (Ngô §3.7–3.8; not on the photographed boards)

### 4.1 Dimension (§3.7)

- Kazhdan–Lusztig: $\dim\mathcal M_a=\dim\mathcal M_a^{\mathrm{reg}}$.
- **Prop 3.7.1.** The complement $\mathcal M_a\smallsetminus\mathcal M_a^{\mathrm{reg}}$ has strictly smaller dimension.
  Idea: the Iwahori version $\mathcal B_a=\{g\in G(\breve F)/\mathrm{Iw} : \mathrm{ad}(g)^{-1}\gamma_0\in\mathrm{Lie}\,\mathrm{Iw}\}$ is equidimensional (Kazhdan–Lusztig; Spaltenstein for classical Springer fibers). The map $\mathcal B_a\to\mathcal M_a$ is finite over $\mathcal M_a^{\mathrm{reg}}$ and has positive-dimensional fibers over the complement.
- **Cor 3.7.2.** If $\dim\mathcal M_a=0$, then $\mathcal M_a=\mathcal M_a^{\mathrm{reg}}$.
- **Bezrukavnikov's formula** (conjectured by Kazhdan–Lusztig; Ngô §3.7):
$$\dim\mathcal M_a^{\mathrm{reg}}=\dim\mathcal P(J_a)=\frac{d(a)-c(a)}{2},\qquad d(a)=\deg a^*\mathfrak D=\mathrm{val}\prod_{\alpha\in\Phi}\alpha(\gamma_0),\quad c(a)=\dim\mathfrak t-\dim\mathfrak t^{\pi_a(I)}.$$
  Here $\pi_a:I\to W$ is the monodromy of the cameral cover $a^*(\mathfrak t\to\mathfrak c)$ over the punctured disc, with $I$ the inertia group. It is tame because $p\nmid|W|$, so its image is cyclic. Ngô calls $\delta_a:=\dim\mathcal P(J_a)$ the **local δ-invariant**.

How to read it: $d(a)$ measures how deeply the arc $a$ dips into the discriminant (the sum of root valuations), and $c(a)$ measures how ramified the torus $J_{a,\breve F}$ is. In the unramified case, $\delta_a=\sum_{\alpha>0}\mathrm{val}\,\alpha(\gamma_0)$. For $GL_n$ this is Serre's formula (§3.5).

### 4.2 The Néron model (§3.8) — core definition

> [!note] Definition
> $J_a^\flat$ is the finite-type Néron model of the torus $J_{a,\breve F}$ (Bosch–Lütkebohmert–Raynaud): the unique smooth finite-type group scheme over $\breve{\mathcal O}$ with this generic fiber which is maximal, meaning every smooth finite-type model maps to it. Its $\breve{\mathcal O}$-points are the maximal bounded subgroup of $J_a(\breve F)$:
> $$J_a(\breve{\mathcal O})\subset J_a^\flat(\breve{\mathcal O})\subset J_a(\breve F).$$

**Prop 3.8.2 (explicit form).** Normalize the cameral cover: $\widetilde X_a^\flat=\mathrm{Spec}\,\widetilde{\mathcal O}^\flat$. Then $J_a^\flat=\big(\mathrm{Res}_{\widetilde X_a^\flat/D}(T\times\widetilde X_a^\flat)\big)^W$, i.e. the Donagi–Gaitsgory recipe applied to the normalized cover. For $GL_n$ this is "normalize $B$": $J_a^\flat=\mathrm{Res}_{B^\flat/\breve{\mathcal O}}\mathbb G_m$.

**Lemma 3.8.1 (dévissage).**

$$1\to\mathcal R_a\to\mathcal P(J_a)\to\mathcal P(J_a^\flat)\to 1.$$

Here $\mathcal P(J_a^\flat)(\bar k)=J_a(\breve F)/J_a^\flat(\breve{\mathcal O})$ is discrete and free abelian of finite rank. $\mathcal R_a(\bar k)=J_a^\flat(\breve{\mathcal O})/J_a(\breve{\mathcal O})$ is an affine algebraic group of finite type: a quotient of the Weil restriction of $J_a^\flat\otimes\breve{\mathcal O}/\pi^N$ for $N\gg0$.

So **$\mathcal P(J_a)$ = (an affine algebraic group $\mathcal R_a$ of dimension $\delta_a$) extended by (a lattice)**. $\mathcal R_a$ consists of the symmetries that move things only "infinitesimally"; the lattice consists of the translations by $\pi^\lambda$. This is the general version of the $GL_n$ exact sequence on board 15:51.

**Cor 3.8.3.** $\delta_a=\dim_{\bar k}\big(\mathfrak t\otimes\widetilde{\mathcal O}^\flat/\widetilde{\mathcal O}\big)^W$: the $W$-invariant part of the δ-invariant of the cameral cover. For $GL_n$ it is $\dim B^\flat/B$. Also, $c(a)$ is the drop in toric rank of $J_a^\flat$: its generic rank $r$ minus the toric rank of its special fiber.

---

## 5. Connected components (Ngô §3.9)

Two steps.

1. **Neutral components.** Let $J_a^0\subset J_a$ be the neutral component. Then $\pi_0(J_{a,v})=J_a(\breve{\mathcal O})/J_a^0(\breve{\mathcal O})$ is finite, and $1\to\pi_0(J_{a,v})\to\mathcal P(J^0_a)\to\mathcal P(J_a)\to 1$.
2. **The computation (Prop in §3.9).** Write $\Lambda^*:=\mathrm{Spec}\,\overline{\mathbb Q}_\ell[\Lambda]$ for the diagonalizable group with character group $\Lambda$. Then
$$\pi_0(\mathcal P(J_a^0))=X_*(T)_{\pi_a(I)},\qquad\text{dually}\qquad \pi_0(\mathcal P(J_a^0))^*=\hat T^{\pi_a(I)},$$
$$\pi_0(\mathcal P(J_a))^*=\hat T(\pi_a(I)):=\big\{\kappa\in\hat T^{\pi_a(I)}\ :\ \pi_a(I)\subset W(\hat H_\kappa)\big\},$$
  where $\hat H_\kappa$ is the neutral component of the centralizer of κ in $\hat G$. Equivalently, $\pi_0(\mathcal P(J_a))=X_*(T)_{\pi_a(I)}/\mathrm{im}\,\pi_0(Z_G)$; Ngô identifies $\pi_0(T^{\pi_a(I)})$ with the torsion of $X_*(T)_{\pi_a(I)}$.
  Ingredients: Kottwitz's computation $J_a(\breve F)/J_a^{\flat,0}(\breve{\mathcal O})=X_*(T)_{\pi_a(I)}$, and a z-extension $G\hookrightarrow G_1$ with connected center to pass from $J_a^0$ to $J_a$.

**Why this is the heart of the matter.** κ-orbital integrals are weighted by characters κ of $H^1(F,J_a)$. Ngô §8.2 shows that $\mathbf O^\kappa_a(1_{\mathfrak g(\mathcal O)})=0$ unless κ factors through $H^1(k,\mathcal P(J_a))$, which is built from $\pi_0(\mathcal P(J_a))$. So the only κ's that matter locally are the (Frobenius-fixed) points of $\hat T(\pi_a(I))$: exactly those κ whose endoscopic group $\hat H_\kappa$ contains the monodromy of $a$, i.e. for which $a$ comes from $\mathfrak c_H$. Tate–Nakayama duality appears geometrically as

> **components of the symmetry group ↔ points of the dual torus.**

Compare [[Endoscopy]].

**Checks.**

- $GL_n$: $I$ permutes the $n$ roots of $P$, with orbits ↔ the factors $E_i$. So $X_*(T)_{\pi_a(I)}=(\mathbb Z^n)_I=\mathbb Z^s$; the center is connected, so $\pi_0=\mathbb Z^s$ ✓, matching 3.6.2.
- $a=\pi$ for $SL_2$ versus $PGL_2$ (ramified, elliptic, $\delta=0$): $\pi_a(I)=W$ and $X_*(T)_W=\mathbb Z/2$ in both cases.
  - $SL_2$: $\pi_0(Z_G)=\mu_2$ kills it, so $\pi_0=0$. Indeed the only $\gamma_0$-stable lattice with trivial determinant is $\mathcal O_E$, so $\mathcal M_a$ is a point.
  - $PGL_2$: $\pi_0=\mathbb Z/2$. Indeed $\mathcal M_a=\{\mathcal O_E,\ \sqrt\pi\,\mathcal O_E\}$ up to scalars: two points.
  - Dual side: for $PGL_2$, $\hat T^W=\{\pm1\}\subset SL_2(\mathbb C)$, both central, so both are allowed ✓. For $SL_2$, $\kappa=\mathrm{diag}(-1,1)\in PGL_2(\mathbb C)$ has $\hat H_\kappa=\hat T$ and $W(\hat H_\kappa)=1\not\supset W$, so it is excluded ✓.

---

## 6. Density of the regular orbit (Ngô §3.10)

**Prop 3.10.1.** $\mathcal M_a^{\mathrm{reg}}$ is dense in $\mathcal M_a$. Ngô only sketches the local proof; it follows from the global statement for Hitchin fibers, which is what the rest of the paper uses.

**Cor 3.10.2.** The irreducible components of $\mathcal M_a$ are in canonical bijection with $\pi_0(\mathcal P(J_a))$: they are the closures of the components of $\mathcal P(J_a)\cong\mathcal M_a^{\mathrm{reg}}$.

For $GL_n$ this says that every $B$-lattice is a limit of free ones. It is a local cousin of the irreducibility of compactified Jacobians of curves with planar singularities (Altman–Iarrobino–Kleiman, Rego); $\mathrm{Spec}\,B$ is planar because $B$ is generated by one element. In the board example, the components are the $C_{m,n}$, indexed by $\mathbb Z^2$ ✓.

---

## 7. Comparison with an endoscopic group (Ngô §3.11)

Let $H$ be an endoscopic group and $a_H\in\mathfrak c_H(\breve{\mathcal O})\mapsto a\in\mathfrak c^\heartsuit(\breve{\mathcal O})$. There is no map between $\mathcal M_{H,a_H}$ and $\mathcal M_a$, but the symmetry groups compare. $\mu:J_a\to J_{H,a_H}$ is an isomorphism over the punctured disc (Ngô 2.5.1), whence

$$1\to\mathcal R^G_H(a_H)\to\mathcal P(J_a)\to\mathcal P(J_{H,a_H})\to 1,\qquad \mathcal R^G_H(a_H)(\bar k)=J_{H,a_H}(\breve{\mathcal O})/J_a(\breve{\mathcal O}).$$

**Lemma (§3.11).** $\dim\mathcal R^G_H(a_H)=r^G_H(a_H)=\deg a_H^*\mathfrak R^G_H$.

*Proof.* $\dim\mathcal R^G_H=\delta_a-\delta_{a_H}$. Also $c(a)=c(a_H)$, since the generic tori agree. Bezrukavnikov's formula together with $\nu^*\mathfrak D_G=\mathfrak D_H+2\mathfrak R^G_H$ gives $\tfrac12(d_G-d_H)=r^G_H$. (The arXiv text drops the $\tfrac12$ in an intermediate formula; it is a harmless typo.)

This is the geometric origin of the factor $q^{r^G_H(a_H)}$ in the fundamental lemma: **the $G$-side has $r$ more dimensions of symmetry than the $H$-side.** Heuristically, $[\mathcal M_a/\mathcal P(J_a)]_\kappa$ "should look like" a bundle with $r$-dimensional fibers over $[\mathcal M_{H,a_H}/\mathcal P(J_{H,a_H})]_{\mathrm{st}}$, so the point counts differ by $q^r$. Ngô does **not** prove the fundamental lemma this way. The closure of the graph of μ gives a correspondence between the two fibers, which he explicitly says he does not use; the identity comes from the global argument.

$GL_n$ illustration: $H=GL_{n_1}\times GL_{n_2}$, $P=P_1P_2$, $B\subset B_1\times B_2$. Then $\mathcal R^G_H=(B_1\times B_2)^\times/B^\times$, of dimension $\dim_{\bar k}(B_1\times B_2)/B=\mathrm{val}\,\mathrm{Res}(P_1,P_2)$ (classical). In the board example, $\mathrm{Res}(T,T-\pi)=\pi$, so $r=1$ and $\mathcal R^G_H=\mathcal R_a=\mathbb G_m$.

---

## 8. How the local results are used later

**Counting (Prop in Ngô §8.2).** For any Haar measure $dt$ on $J_a(F)$,

$$\#[\mathcal M_a/\mathcal P(J_a)](k)_\kappa=\mathrm{vol}\big(J_a^0(\mathcal O),dt\big)\;\mathbf O^\kappa_a\big(1_{\mathfrak g(\mathcal O)},dt\big),$$

and $\mathbf O^\kappa_a(1_{\mathfrak g(\mathcal O)})=0$ if κ does not factor through $H^1(k,\mathcal P(J_a))$. The key input is $H^1(F,J_a)=H^1(k,\mathcal P(J'_a))$ for a model $J'_a$ with connected special fiber (Steinberg over $\breve F$, Lang over $k$). There is also a cohomological version, using a free $\Lambda$ as in 3.4.1:

$$\sum_n(-1)^n\,\mathrm{tr}\big(\sigma,\ H^n([\mathcal M_a/\Lambda])_\kappa\big)=\mathrm{vol}\big(J_a^{\flat,0}(\mathcal O),dt\big)\;\mathbf O^\kappa_a\big(1_{\mathfrak g(\mathcal O)},dt\big).$$

**Which local fact feeds what.**

| local fact | used for |
|---|---|
| $\mathcal M_a/\Lambda$ projective (3.4.1) | point counts are finite and cohomology is finite-dimensional |
| approximation (3.5.1) | orbital integrals are locally constant in $a$; any local $a$ occurs in a global Hitchin fiber |
| $\dim=\delta_a$ (3.7) | δ-stratification of the Hitchin base; codimension estimates for the support theorem |
| Néron model and $\pi_0$ (3.8–3.9) | the κ-decomposition of cohomology matches endoscopy (Tate–Nakayama) |
| density (3.10) | components ↔ $\pi_0$, so top-degree homology is $\overline{\mathbb Q}_\ell[\pi_0(\mathcal P(J_a))]$; the global version is how κ-parts are detected |
| $\dim\mathcal R^G_H=r$ (3.11) | the factor $q^r$ and the dimension matching between $G$ and $H$ |
| $d=2$, $c=0$ chain of $\mathbb P^1$'s (8.3) | the fundamental lemma computed by hand on an open part of the Hitchin base |

(Prop 3.5.1, *approximation*, which the talk did not cover: there is $N$ such that $a'\equiv a\bmod\pi^N$ implies $(\mathcal M_{a'},\mathcal P(J_{a'}))\cong(\mathcal M_a,\mathcal P(J_a))$. It is a geometric form of Harish-Chandra's local constancy of orbital integrals. The key point is that $\mathcal M_a$ only depends on the commutative subalgebra $\mathrm{Lie}(I_{\gamma_0})\subset\mathfrak g$, which in turn only depends on the cameral cover.)

---

## 9. Board ↔ paper

| board | content | Ngô |
|---|---|---|
| 15:42, top | title, set-up, modular definition of $\mathrm{Gr}_\gamma$ | §3.1–3.2 (Déf 3.2.2 with $D$ trivial) |
| 15:19 | $[\mathfrak g/G]$; closed immersion; locally of finite type; points; $\mathrm{Gr}^{\mathrm{reg}}_\gamma$; $\mathcal M_a=\mathrm{Gr}_{\epsilon(a)}$ | Prop 3.2.1; definition of $\mathcal M^{\mathrm{reg}}$ in §3.3 |
| 15:42, bottom right | $\mathrm{Gr}_\gamma\to[\mathfrak g/G]$; regular part = preimage of $[\mathfrak g^{\mathrm{reg}}/G]$ | §3.3 |
| 15:28 | $GL_n$: $B$, $E=\prod E_i$, lattices, $\mathcal M^{\mathrm{reg}}$ = free modules | 3.6.1 |
| 15:41, bottom | $J_a(\breve F)=E^\times$, $J_a(\breve{\mathcal O})=B^\times$, $\mathcal P=E^\times/B^\times$; arcs; $\mathfrak{sl}_2$; $\mathcal M_a\to\mathfrak g(\mathcal O)/G(\mathcal O)$ | 3.6.1, §3.3; the counting idea of §8.2 |
| 15:51, top | $B^\flat$; exact sequence; connectedness; example $T(T-\pi)$ | 3.6.2–3.6.3; the example is §8.3 |

---

## Appendix — board transcriptions

Transcribed from the five photos, in chronological order. Brackets are my additions.

### 15:19 — recap board (IMG_20261023_151925)

- **Rmk.** $[\mathfrak g/G](S)=$ such pairs $(E,\phi)$.
- **Prop.** $(E,\phi,\iota)\mapsto(E,\iota)$ gives a closed immersion $\mathrm{Gr}_\gamma\hookrightarrow\mathrm{Gr}_G$ [labels: $\mathrm{Gr}_\gamma$ = "affine Springer fiber", $\mathrm{Gr}_G$ = "affine grassmannian"]. Moreover, $(\mathrm{Gr}_\gamma)_{\mathrm{red}}$ is a scheme, loc. of finite type over $k$.
- **Lemma.** $\mathrm{Gr}_\gamma(R)=\{[g]\in G(R((\pi)))/G(R[[\pi]])\mid \mathrm{ad}(g)^{-1}(\gamma)\in\mathfrak g(R[[\pi]])\}$.
- **Def.** $\mathrm{Gr}^{\mathrm{reg}}_\gamma\subseteq\mathrm{Gr}_\gamma$ is the open subfunctor of $[g]$ with $\mathrm{ad}(g)^{-1}(\gamma)\in\mathfrak g^{\mathrm{reg}}(R[[\pi]])$.
- For $a\in\mathfrak c^\heartsuit(\mathcal O)=\mathfrak c(\mathcal O)\cap\mathfrak c^{\mathrm{rs}}(F)$, set $\mathcal M_a=\mathrm{Gr}_{\gamma_0}$ where $\gamma_0=\epsilon(a)$.
- **Today:** further geometric properties of $\mathcal M_a$. ($\breve{\mathcal O}=\bar k[[\pi]]$, $\breve F=\bar k((\pi))$, $a\in\mathfrak c^\heartsuit(\breve{\mathcal O})$.)

### 15:28 — Case of $GL_n$ (IMG_20261023_152859)

- **§ Case of $GL_n$.** Assume $n<p$.
- $a\in\mathfrak c^\heartsuit(\breve{\mathcal O})\leftrightarrow P(T)=T^n+a_1T^{n-1}+\dots+a_n$, $\gamma_0=\epsilon(a)$ = companion matrix.
- $B:=\breve{\mathcal O}[T]/(P(T))$, $E:=B\otimes_{\breve{\mathcal O}}\breve F\cong E_1\times\dots\times E_s$, with $E_i/\breve F$ finite separable.
- $\mathcal M_a(\bar k)=\{\breve{\mathcal O}\text{-lattices }\mathcal L\text{ in }(\breve F)^{\oplus n}\text{, stable under }\gamma_0\}$ [with $(\breve F)^{\oplus n}\cong B\otimes_{\breve{\mathcal O}}\breve F$ written underneath] $=\{B\text{-modules }\mathcal L\subseteq B\otimes_{\breve{\mathcal O}}\breve F\text{ which are }\breve{\mathcal O}\text{-free}\}$.
- **Lemma.** $\mathcal M_a^{\mathrm{reg}}(\bar k)=\{\ \text{(same)}\ \text{ s.t. }\mathcal L\cong B\}$.
- **Proof** [right panel]. By def, $\mathcal L\in\mathcal M_a^{\mathrm{reg}}(\bar k)$ ⟺ the endomorphism $T:\mathcal L/\pi\to\mathcal L/\pi$ belongs to $\mathfrak g^{\mathrm{reg}}(\bar k)$ ⟺ $\mathcal L/\pi\cong\bar k[T]/(P(T))$ ⟺ $\mathcal L\cong B$.

### 15:41 — lower board (IMG_20261023_154118; the upper board is the 15:28 board)

- Left column:
  - $J_a(\breve F)=\big(\breve F[T]/(P(T))\big)^\times=E^\times$
  - $J_a(\breve{\mathcal O})=B^\times$
  - So $\mathcal P(J_a)(\bar k)=E^\times/B^\times$ [$\mathcal P(J_a)$ underlined].
  - Let: $\mathfrak g(\mathcal O)$: $D\to\mathfrak g$; $\mathfrak c(\mathcal O)$: $D\to\mathfrak c$ [$D=\mathrm{Spec}\,\mathcal O$ written under $D$]. [Drawing: the disc as an oval, generic point "$F$", closed point "$k$".]
- Middle column: $\mathfrak g=\mathfrak{sl}_2$, $\mathfrak c=\mathbb A^1$. Diagram: $\mathfrak g(\mathcal O)\ni\gamma_0$ (circled) over $\mathfrak c(\mathcal O)\ni a$, with $\epsilon$ as a curved arrow going up. Also $\mathfrak g\to\mathfrak c$.
- Right column: $G(F)/G(\mathcal O)$ (circled). $\mathcal M_a(k)\to\mathfrak g(\mathcal O)/G(\mathcal O)\ni[\gamma]$. [Drawing: a hatched region over a horizontal base line, a curve through it, a dashed vertical line marking the fiber over a point.] $\mathfrak g^{\mathrm{rs}}(\mathcal O)\subset\cdots$ [rest unclear]; $\mathfrak c^{\mathrm{rs}}(\mathcal O)\subset\mathfrak c^\heartsuit$.

### 15:42 — title board (IMG_20261023_154219; the lower board is the 15:19 board)

- **Affine Springer fiber** (§3.6–3.11 in Ngô's paper)
- **Set-up:** $k=\mathbb F_q$ base field; $\mathcal O=\mathbb F_q[[\pi]]$, $F=\mathbb F_q((\pi))$; $G$: split reductive group$/k$.
- **Modular description of affine Springer fiber.** Let $\gamma\in\mathfrak g(F)$ be a regular semi-simple element.
- **Def.** For each $k$-alg $R$, $\mathrm{Gr}_\gamma(R)$ = groupoid of triples $(E,\phi,\iota)$, where $E$ is a $G$-torsor over $R[[\pi]]$, $\phi$ is a global section of $\mathrm{ad}(E)$, and $\iota$ is an isomorphism $(E,\phi)\cong(E_0,\gamma)$ over $R((\pi))$.
- Margin: $\mathrm{ad}(E)=E\times^G\mathfrak g\to\mathrm{Spec}(R[[\pi]])$; "adjoint vector bundle ⟷ a section φ".
- Added to the recap board, lower right: $\mathrm{Gr}_\gamma\to[\mathfrak g/G]$, with "$\cup$" underneath. [The rest is cut off in the photo, presumably $\mathrm{Gr}^{\mathrm{reg}}_\gamma\to[\mathfrak g^{\mathrm{reg}}/G]$.]

### 15:51 — upper board (IMG_20261023_155147; the lower board is the 15:28 board)

[Apparently the 15:41 lower board moved up, with its middle and right parts erased and rewritten.]

- Left:
  - $J_a(\breve F)=\big(\breve F[T]/(P(T))\big)^\times=E^\times$; $J_a(\breve{\mathcal O})=B^\times$; so $\mathcal P(J_a)(\bar k)=E^\times/B^\times$.
  - $B^\flat$ = normalization of $B$ in $E$ = ring of integers in $E$.
- Right:
  - Have $0\to(B^\flat)^\times/B^\times\to E^\times/B^\times\to E^\times/(B^\flat)^\times\to0$ [the last term annotated "finite free"].
  - **Lemma.** $(B^\flat)^\times/B^\times$ is 'connected'.
  - **Ex.** $P(T)=T(T-\pi)\in\mathcal O[T]$; $E=\breve F[T]/T(T-\pi)\cong\breve F\times\breve F$, $f\mapsto(f(0),f(\pi))$.

---

## Related

- [[Endoscopy]] — the κ's of §5 are the Fourier side of the stable class.
