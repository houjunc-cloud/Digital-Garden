---
title: Affine Springer fibers and their symmetries
description: "Lecture notes for the talk on Ngô §3.6–3.11 in the Ngô fundamental lemma seminar (2026-10-23), combining the boards with the paper."
tags:
  - fundamental-lemma
  - affine-springer-fibers
  - seminar-notes
stage: 🌱 seedling
date: 2026-10-23
---

# Affine Springer fibers and their symmetries

*Notes on the talk "Affine Springer fiber (§3.6–3.11 in Ngô's paper)", Ngô fundamental lemma seminar, 23 October 2026. Reference: B. C. Ngô, Le lemme fondamental pour les algèbres de Lie, Publ. Math. IHÉS 111 (2010); numbering as in [arXiv:0801.0446](https://arxiv.org/abs/0801.0446).*

The fundamental lemma for Lie algebras compares κ-orbital integrals of the characteristic function of $\mathfrak g(\mathcal O)$ with stable orbital integrals of the characteristic function of $\mathfrak h(\mathcal O)$, where $H$ is an endoscopic group. Following Kazhdan–Lusztig and Goresky–Kottwitz–MacPherson, such orbital integrals can be computed as numbers of points over finite fields of certain spaces, the affine Springer fibers, divided by the action of a group of symmetries. Ngô's proof is about the geometry of these spaces and of their global versions, the Hitchin fibers. This talk covers the local part of that geometry: the affine Springer fiber $\mathcal M_a$ attached to a characteristic polynomial $a$, and its symmetry group $\mathcal P(J_a)$.

The guiding principle of the whole talk is that **$\mathcal M_a$ is a compactification of the group $\mathcal P(J_a)$**. The group acts on $\mathcal M_a$, and on a dense open subset, the regular locus $\mathcal M_a^{\mathrm{reg}}$, it acts simply transitively. Therefore most geometric invariants of $\mathcal M_a$ — its dimension, its irreducible components, and in the end its number of points over finite fields — can be read off from $\mathcal P(J_a)$, which is a much simpler object: an algebraic group extended by a lattice.

We first recall the definitions (§1). Then we work out the case of $GL_n$ (§2), where everything becomes commutative algebra: $\mathcal M_a$ is a space of lattices over a one-dimensional ring $B$, and $\mathcal P(J_a)$ is the local Picard group of $B$. This example already shows all the phenomena of the general theory, which we develop next: the dimension formula (§3), the Néron model (§4), the connected components of $\mathcal P(J_a)$ and their relation with the dual group (§5), the density of the regular locus (§6), and the comparison with endoscopic groups (§7). In §8 we explain how these results enter the proof, and we verify the fundamental lemma by hand in the simplest example.

The boards of the talk covered the set-up and the linear case, up to the beginning of Example 2.5. Everything else — the recollections in §1.3, the remaining parts of §2, and §§3–8 — is written up from Ngô's paper, in the order of his sections 3.7–3.11 and 8.2–8.3.

## 1. Set-up and recollections

### 1.1 Notation

Let $k=\mathbb F_q$, $\mathcal O=k[[\pi]]$ and $F=k((\pi))$. Let $G$ be a split reductive group over $k$, with Lie algebra $\mathfrak g$, a maximal torus $T$ with Lie algebra $\mathfrak t$, roots $\Phi$ and Weyl group $W$. We assume throughout that the characteristic $p$ of $k$ does not divide $|W|$.

Let $\mathfrak c=\mathfrak t/\!/W=\mathrm{Spec}\,k[\mathfrak g]^G$, and let $\chi:\mathfrak g\to\mathfrak c$ be the Chevalley morphism. For $G=GL_n$, $\mathfrak c$ is the space of monic polynomials of degree $n$ and $\chi$ takes a matrix to its characteristic polynomial; in general we still call $\chi(x)$ the characteristic polynomial of $x$. The discriminant divisor $\mathfrak D\subset\mathfrak c$ is defined by $\prod_{\alpha\in\Phi}d\alpha$, and its complement $\mathfrak c^{\mathrm{rs}}$ is the regular semisimple locus. The Kostant section $\epsilon:\mathfrak c\to\mathfrak g^{\mathrm{reg}}$ attaches to every $a$ a regular element $\epsilon(a)$ with $\chi(\epsilon(a))=a$; for $GL_n$ one may take the companion matrix.

The characteristic polynomials we consider are the elements of
$$\mathfrak c^\heartsuit(\mathcal O):=\mathfrak c(\mathcal O)\cap\mathfrak c^{\mathrm{rs}}(F),$$
that is, integral characteristic polynomials which are regular semisimple at the generic point. Since we are interested in geometric properties, we will mostly work over $\bar k$, with
$$\breve{\mathcal O}=\bar k[[\pi]],\qquad\breve F=\bar k((\pi)),$$
and describe the $\bar k$-points of our spaces in terms of $\breve{\mathcal O}$ and $\breve F$.

### 1.2 Affine Springer fibers

For a $k$-scheme $S$, the quotient stack $[\mathfrak g/G]$ has as $S$-points the groupoid of pairs $(E,\phi)$, where $E$ is a $G$-torsor over $S$ and $\phi$ is a section of the adjoint vector bundle $\mathrm{ad}(E)=E\times^G\mathfrak g$. A pair $(E,\phi)$ is an element of $\mathfrak g$ up to conjugacy, twisted by a torsor; for $G=GL_n$ it is simply a vector bundle of rank $n$ together with an endomorphism. Since $\chi$ is $G$-invariant, such a pair still has a characteristic polynomial $[\chi](E,\phi)\in\mathfrak c(S)$. Ngô thinks of $[\mathfrak g/G]$ as a mould: evaluated on the formal disc it gives affine Springer fibers, and evaluated on a projective curve it gives Hitchin fibers.

Let $\gamma\in\mathfrak g(F)$ be regular semisimple, and let $E_0$ denote the trivial $G$-torsor.

**Definition 1.1** (affine Springer fiber). For a $k$-algebra $R$, let $\mathrm{Gr}_\gamma(R)$ be the groupoid of triples $(E,\phi,\iota)$, where $E$ is a $G$-torsor over $\mathrm{Spec}\,R[[\pi]]$, $\phi$ is a global section of $\mathrm{ad}(E)$ over $\mathrm{Spec}\,R[[\pi]]$, and $\iota$ is an isomorphism $(E,\phi)\cong(E_0,\gamma)$ over $\mathrm{Spec}\,R((\pi))$.

Let us unwind this definition. If we forget $\phi$, a pair $(E,\iota)$ is a $G$-torsor on the disc together with a trivialization on the punctured disc, which is precisely a point of the affine Grassmannian $\mathrm{Gr}_G$. One should think of it as a new integral structure on the trivial torsor over the punctured disc. The section $\phi$ is not additional data: over the punctured disc, $\iota$ forces it to be $\gamma$. The only content of the definition is that $\gamma$, viewed in the new integral structure, extends over the closed point of the disc. In other words, **$\mathrm{Gr}_\gamma$ is the space of integral structures that are preserved by $\gamma$.** Extending a given section is a closed condition, which gives the first half of the following proposition.

**Proposition 1.2** (Ngô 3.2.1). The forgetful map $(E,\phi,\iota)\mapsto(E,\iota)$ is a closed immersion
$$\mathrm{Gr}_\gamma\hookrightarrow\mathrm{Gr}_G$$
of the affine Springer fiber into the affine Grassmannian; in particular $\mathrm{Gr}_\gamma$ is an ind-scheme. Moreover, $(\mathrm{Gr}_\gamma)_{\mathrm{red}}$ is a scheme locally of finite type over $k$.

The second statement is a theorem of Kazhdan and Lusztig, which we will not prove. The word "locally" cannot be removed: $\mathrm{Gr}_\gamma$ is finite-dimensional, but in general it has infinitely many irreducible components, which are permuted by a lattice of symmetries (see Proposition 1.9 and Example 2.5).

On points, Definition 1.1 takes the following familiar form.

**Lemma 1.3.** $\mathrm{Gr}_\gamma(R)=\big\{[g]\in G(R((\pi)))/G(R[[\pi]])\ :\ \mathrm{ad}(g)^{-1}(\gamma)\in\mathfrak g(R[[\pi]])\big\}$.

Indeed, if $E$ is trivial, the isomorphism $\iota$ is given by an element $g\in G(R((\pi)))$, well defined up to $G(R[[\pi]])$, and $\phi$ corresponds to $\mathrm{ad}(g)^{-1}\gamma$, which has to be integral. (The argument needs $E$ to be trivial, which holds for instance when $R=\bar k$; for general $R$ the description is only true étale locally on $R$.) For $G=GL_n$, the coset $g\,GL_n(\breve{\mathcal O})$ corresponds to the lattice $L=g\breve{\mathcal O}^n$ in $\breve F^n$, and the condition becomes $\gamma L\subset L$. So **$\mathrm{Gr}_\gamma(\bar k)$ is the set of $\breve{\mathcal O}$-lattices in $\breve F^n$ that are stable under $\gamma$.** This is the description we will use in §2.

Next we single out the points where the integral element $\mathrm{ad}(g)^{-1}\gamma$ is regular.

**Definition 1.4.** $\mathrm{Gr}_\gamma^{\mathrm{reg}}\subset\mathrm{Gr}_\gamma$ is the open subfunctor of those $[g]$ with $\mathrm{ad}(g)^{-1}(\gamma)\in\mathfrak g^{\mathrm{reg}}(R[[\pi]])$.

Since $\gamma$ is already regular at the generic point of the disc, the condition only concerns the closed point: $[g]$ lies in the regular part if and only if $\mathrm{ad}(g)^{-1}(\gamma)\bmod\pi$ is a regular element of $\mathfrak g$. In terms of stacks, a point $(E,\phi,\iota)$ defines a map from the disc to $[\mathfrak g/G]$, and $\mathrm{Gr}^{\mathrm{reg}}_\gamma$ is the locus where this map lands in the open substack $[\mathfrak g^{\mathrm{reg}}/G]$.

Finally, to attach an affine Springer fiber to a characteristic polynomial rather than to an element, we use the Kostant section.

**Definition 1.5.** For $a\in\mathfrak c^\heartsuit(\mathcal O)$, let $\gamma_0=\epsilon(a)\in\mathfrak g(\mathcal O)$, and put $\mathcal M_a:=\mathrm{Gr}_{\gamma_0}$ and $\mathcal M_a^{\mathrm{reg}}:=\mathrm{Gr}^{\mathrm{reg}}_{\gamma_0}$.

The point of the Kostant section is that it provides, uniformly in $a$, an element of the stable class of $a$ which is both integral and regular. As a consequence, the base point $[1]$ of the affine Grassmannian always lies in $\mathcal M_a^{\mathrm{reg}}$.

The aim of the talk is to establish further geometric properties of $\mathcal M_a$. From now on we work over $\bar k$: $a\in\mathfrak c^\heartsuit(\breve{\mathcal O})$, and $\mathcal M_a(\bar k)$ is a set of cosets in $G(\breve F)/G(\breve{\mathcal O})$.

### 1.3 Recollections: the regular centralizer and the symmetry group

The main structure on $\mathcal M_a$ is a large commutative group acting on it. It comes from the regular centralizer.

**Proposition 1.6** (Ngô 2.1.1). Let $I\to\mathfrak g$ be the group scheme of centralizers, $I_x=\{g\in G:\mathrm{ad}(g)x=x\}$. There is a unique smooth commutative group scheme $J\to\mathfrak c$ with a $G$-equivariant isomorphism $\chi^*J|_{\mathfrak g^{\mathrm{reg}}}\cong I|_{\mathfrak g^{\mathrm{reg}}}$. This isomorphism extends to a homomorphism $\chi^*J\to I$ over all of $\mathfrak g$. One can take $J=\epsilon^*I$.

The idea is simple. If $x$ and $x'$ are regular with the same characteristic polynomial, then $x'=\mathrm{ad}(g)x$ for some $g$, and the isomorphism $\mathrm{ad}(g):I_x\to I_{x'}$ does not depend on the choice of $g$, because $I_x$ is commutative. So all regular elements with characteristic polynomial $a$ have canonically the same centralizer $J_a$. The extension $\chi^*J\to I$ says more: $J_a$ maps into the centralizer of every element with characteristic polynomial $a$, regular or not. This is what will allow $J_a$ to act on the whole affine Springer fiber, and not only on its regular part.

For $a\in\mathfrak c^\heartsuit(\mathcal O)$ we write $J_a:=a^*J$. It is a smooth commutative group scheme over $\mathcal O$ whose generic fiber is the torus $G_{\gamma_0}$, the centralizer of $\gamma_0$ over $F$; at the closed point it can degenerate when $a$ meets the discriminant. For $GL_n$, the centralizer of a companion matrix $\gamma_0$ is the unit group of $\mathcal O[\gamma_0]\cong\mathcal O[T]/(P)$, so $J_a=\mathrm{Res}_{B/\mathcal O}\mathbb G_m$ with $B=\mathcal O[T]/(P)$.

**Definition 1.7** (Ngô §3.3). $\mathcal P(J_a)$ is the functor which sends a $k$-algebra $R$ to the group of isomorphism classes of $J_a$-torsors over $\mathrm{Spec}\,R[[\pi]]$ together with a trivialization over $\mathrm{Spec}\,R((\pi))$. It is represented by a group ind-scheme over $k$, and
$$\mathcal P(J_a)(\bar k)=J_a(\breve F)/J_a(\breve{\mathcal O}).$$

Thus $\mathcal P(J_a)$ is the affine Grassmannian of the commutative group scheme $J_a$. It acts on $\mathcal M_a$: we can twist a pair $(E,\phi)$ by a $J_a$-torsor, using the homomorphism $J_a\to\mathrm{Aut}(E,\phi)$ given by Proposition 1.6, and a trivialization over the punctured disc carries over. On $\bar k$-points the action is simply left multiplication: $J_a(\breve F)$ is identified with the centralizer $G_{\gamma_0}(\breve F)$, and it acts by $j\cdot[g]=[jg]$. This descends to the quotient $J_a(\breve F)/J_a(\breve{\mathcal O})$ thanks to the extension $\chi^*J\to I$. Indeed, if $\gamma=\mathrm{ad}(g)^{-1}\gamma_0$ is integral, then $\mathrm{ad}(g)^{-1}$ carries $J_a$ into the centralizer $I_\gamma$ over $\breve{\mathcal O}$, so $J_a(\breve{\mathcal O})\subset g\,G(\breve{\mathcal O})\,g^{-1}$, which means that $J_a(\breve{\mathcal O})$ fixes the point $[g]$.

The basic structural result is that the regular part is a single orbit with trivial stabilizers.

**Proposition 1.8** (Ngô 3.3.1). $\mathcal M_a^{\mathrm{reg}}$ is a principal homogeneous space under $\mathcal P(J_a)$. Since it contains the Kostant point $[1]$, it is a trivial torsor:
$$\mathcal P(J_a)\xrightarrow{\ \sim\ }\mathcal M_a^{\mathrm{reg}},\qquad p\longmapsto p\cdot[1].$$

*Proof.* By Ngô 2.2.1, the morphism $[\mathfrak g^{\mathrm{reg}}/G]\to\mathfrak c$ is a gerbe banded by $J$, and the Kostant section neutralizes it. So a regular pair $(E,\phi)$ over the disc with characteristic polynomial $a$ is locally isomorphic to $(E_0,\gamma_0)$, and the sheaf of isomorphisms $(E_0,\gamma_0)\cong(E,\phi)$ is a $J_a$-torsor. The isomorphism $\iota$ trivializes this torsor over the punctured disc, and the resulting point of $\mathcal P(J_a)$ is the inverse of the map in the statement. On $\bar k$-points one can also argue directly. The regular integral elements with characteristic polynomial $a$ form a single $G(\breve{\mathcal O})$-orbit, so for $[g]\in\mathcal M_a^{\mathrm{reg}}$ we have $\mathrm{ad}(g)^{-1}\gamma_0=\mathrm{ad}(h)^{-1}\gamma_0$ for some $h\in G(\breve{\mathcal O})$. Then $gh^{-1}$ centralizes $\gamma_0$, so $[g]=[gh^{-1}]\in J_a(\breve F)\cdot[1]$. ∎

So $\mathcal M_a$ consists of a copy of the group $\mathcal P(J_a)$ together with a boundary $\mathcal M_a\smallsetminus\mathcal M_a^{\mathrm{reg}}$. We will also use two further results from Ngô §3.4–3.5.

**Proposition 1.9** (Kazhdan–Lusztig; Ngô 3.4.1). Let $\Lambda$ be the maximal free quotient of $\pi_0(\mathcal P(J_a))$, and choose a lift $\Lambda\to\mathcal P(J_a)$. Then $\Lambda$ acts freely on $(\mathcal M_a)_{\mathrm{red}}$, and the quotient $(\mathcal M_a)_{\mathrm{red}}/\Lambda$ is a projective scheme.

**Proposition 1.10** (approximation; Ngô 3.5.1). There is an integer $N$ such that for every $a'$ (defined over any finite extension of $k$) with $a'\equiv a\bmod\pi^N$, the pair $(\mathcal M_{a'},\mathcal P(J_{a'}))$ is isomorphic to $(\mathcal M_a,\mathcal P(J_a))$.

Proposition 1.10 is a geometric form of Harish-Chandra's theorem that regular semisimple orbital integrals are locally constant. The key point of its proof is that $\mathcal M_a$ only depends on the commutative subalgebra $\mathrm{Lie}(I_{\gamma_0})\subset\mathfrak g$, which in turn is determined by the cameral cover of the disc attached to $a$.

The rest of the talk is about two questions: what does the group $\mathcal P(J_a)$ look like, and how small is the boundary? We begin with $GL_n$, where both questions can be answered by hand.

## 2. The linear case

(Ngô §3.6, following Laumon.) In this section $G=GL_n$, and we assume $n<p$. This implies that $p$ does not divide $|W|=n!$, and also that every extension of $\breve F$ of degree at most $n$ is tamely ramified, which we will use in Corollary 2.4.

### 2.1 The ring $B$

A point $a\in\mathfrak c^\heartsuit(\breve{\mathcal O})$ is a monic polynomial
$$P(T)=T^n+a_1T^{n-1}+\dots+a_n\in\breve{\mathcal O}[T]$$
with nonzero discriminant, i.e. separable over $\breve F$, and $\gamma_0=\epsilon(a)$ is its companion matrix. (Ngô writes the coefficients with signs $(-1)^ia_i$, which makes no difference.) Put
$$B:=\breve{\mathcal O}[T]/(P(T)),\qquad E:=B\otimes_{\breve{\mathcal O}}\breve F=\breve F[T]/(P(T)).$$
The ring $B$ is free of rank $n$ as an $\breve{\mathcal O}$-module, and $E$ is a finite étale $\breve F$-algebra of dimension $n$:
$$E\cong E_1\times\dots\times E_s,$$
where each $E_i/\breve F$ is a finite separable field extension, one for each irreducible factor of $P$ over $\breve F$. Since $\bar k$ is algebraically closed, each $E_i$ is totally ramified over $\breve F$, say of degree $n_i$, with $n_1+\dots+n_s=n$.

It helps to keep a geometric picture in mind. $\mathrm{Spec}\,B$ is the germ at $\pi=0$ of the spectral curve $\{P(T)=0\}$ in the $(T,\pi)$-plane. This is a plane curve singularity, and $\mathrm{Spec}\,E$ is the corresponding punctured germ: a disjoint union of $s$ punctured discs, one for each branch of the curve. The companion matrix identifies $\breve F^n$, with $\gamma_0$ acting on it, with $E$, with multiplication by $T$ acting on it; the standard lattice $\breve{\mathcal O}^n$ corresponds to $B$.

### 2.2 The points of $\mathcal M_a$

**Proposition 2.1** (Ngô 3.6.1).
$$\mathcal M_a(\bar k)=\{\breve{\mathcal O}\text{-lattices }L\subset\breve F^{\oplus n}\text{ stable under }\gamma_0\}=\{B\text{-submodules }L\subset E\text{ that are free }\breve{\mathcal O}\text{-modules of rank }n\}.$$

*Proof.* The first equality is Lemma 1.3 for $GL_n$. For the second, transport everything along the identification of $(\breve F^n,\gamma_0)$ with $(E,T)$: a lattice stable under $\gamma_0$ becomes an $\breve{\mathcal O}$-lattice in $E$ stable under multiplication by $T$, i.e. a $B$-submodule of $E$ which is an $\breve{\mathcal O}$-lattice. ∎

Ngô calls these $B$-lattices ("$B$-réseaux"). Up to isomorphism, a $B$-lattice is the same thing as a torsion-free $B$-module of rank one. So $\mathcal M_a$ is a local version of the compactified Jacobian of the spectral curve; this is Laumon's point of view.

Next we identify the regular locus.

**Lemma 2.2.** $\mathcal M_a^{\mathrm{reg}}(\bar k)$ consists of the $B$-lattices $L$ with $L\cong B$ as $B$-modules, i.e. the lattices $L=xB$ with $x\in E^\times$.

*Proof.* By definition, $L$ lies in the regular locus if and only if the endomorphism $T$ of $L/\pi L$ is a regular element of $\mathfrak{gl}_n(\bar k)$. A matrix is regular if and only if it has a cyclic vector, and the characteristic polynomial of $T$ on $L/\pi L$ is $\bar P=P\bmod\pi$. So $L$ is regular if and only if $L/\pi L\cong\bar k[T]/(\bar P)$, i.e. $L/\pi L$ is a cyclic module over $B/\pi B$. By Nakayama's lemma this happens if and only if $L$ is a cyclic $B$-module, $L=Bx$. Finally, a surjection $B\to L$ between free $\breve{\mathcal O}$-modules of the same rank is an isomorphism, so $L$ is cyclic if and only if $L\cong B$. ∎

So the regular locus consists of the locally free modules, and the boundary consists of the torsion-free modules which are not locally free at the singular point, exactly as for compactified Jacobians.

### 2.3 Symmetries

For $GL_n$ we have $J_a=\mathrm{Res}_{B/\breve{\mathcal O}}\mathbb G_m$, so
$$J_a(\breve F)=\big(\breve F[T]/(P(T))\big)^\times=E^\times,\qquad J_a(\breve{\mathcal O})=B^\times,\qquad\text{hence}\qquad\mathcal P(J_a)(\bar k)=E^\times/B^\times,$$
acting on $B$-lattices by multiplication. In this language Proposition 1.8 is evident: $E^\times$ acts transitively on the free lattices $xB$, with stabilizer $B^\times$, so $x\mapsto xB$ is a bijection $E^\times/B^\times\cong\mathcal M_a^{\mathrm{reg}}(\bar k)$. The group $E^\times/B^\times$ is the local Picard group of the singularity, or the generalized Jacobian of the germ.

### 2.4 Digression: what $\mathcal M_a$ parametrizes

Before analysing $E^\times/B^\times$, let us step back and describe, for a general group, what $\mathcal M_a$ and its quotient by the symmetries parametrize. This explains why it is the quotient, and not $\mathcal M_a$ itself, that computes orbital integrals.

An element of $\mathfrak g(\mathcal O)$ is an arc $D\to\mathfrak g$, where $D=\mathrm{Spec}\,\mathcal O$ is the formal disc; similarly, $\mathfrak c(\mathcal O)$ is the set of arcs $D\to\mathfrak c$. The disc has two points: the generic point, with residue field $F$, and the closed point, with residue field $k$. The condition $a\in\mathfrak c^\heartsuit(\mathcal O)$ says that the generic point of the arc $a$ lies in $\mathfrak c^{\mathrm{rs}}$, while the closed point is allowed to lie on the discriminant. If it does not, i.e. if $a$ lies in the smaller set $\mathfrak c^{\mathrm{rs}}(\mathcal O)$, then every integral element with characteristic polynomial $a$ lies in $\mathfrak g^{\mathrm{rs}}(\mathcal O)$, the group scheme $J_a$ is a torus over $\mathcal O$, and $\mathcal M_a=\mathcal M_a^{\mathrm{reg}}\cong\mathcal P(J_a)$ is discrete. All the interesting geometry comes from arcs that touch the discriminant.

The simplest example is $\mathfrak g=\mathfrak{sl}_2$. Here $\mathfrak c=\mathbb A^1$, $\chi(x)=-\det(x)$, and the Kostant section is
$$\epsilon(a)=\begin{pmatrix}0&a\\1&0\end{pmatrix}.$$
The discriminant is $4a$, so $\mathfrak c^\heartsuit(\mathcal O)=\mathcal O\smallsetminus\{0\}$ and $\mathfrak c^{\mathrm{rs}}(\mathcal O)=\mathcal O^\times$; the order of contact of the arc $a$ with the discriminant is $\mathrm{val}(a)$.

Now consider the map
$$\mathcal M_a(\bar k)\longrightarrow\mathfrak g(\breve{\mathcal O})/G(\breve{\mathcal O}),\qquad[g]\longmapsto\big[\mathrm{ad}(g)^{-1}\gamma_0\big],$$
which records the conjugacy class of $\gamma_0$ as seen in the integral structure $[g]\in G(\breve F)/G(\breve{\mathcal O})$. Its image lies in the fiber over $a$ of the map $\mathfrak g(\breve{\mathcal O})/G(\breve{\mathcal O})\to\mathfrak c(\breve{\mathcal O})$, and in fact it is all of that fiber: an integral element $\gamma$ with $\chi(\gamma)=a$ is conjugate to $\gamma_0$ over $\breve F$, because $H^1(\breve F,J_a)=0$ by Steinberg's theorem. Two points $[g]$ and $[g']$ have the same image if and only if $\mathrm{ad}(g')^{-1}\gamma_0=\mathrm{ad}(h)\,\mathrm{ad}(g)^{-1}\gamma_0$ for some $h\in G(\breve{\mathcal O})$, i.e. $g'hg^{-1}$ centralizes $\gamma_0$, i.e. $[g']\in J_a(\breve F)\cdot[g]$. Therefore
$$\mathcal M_a(\bar k)\big/\mathcal P(J_a)(\bar k)\;\cong\;\{\gamma\in\mathfrak g(\breve{\mathcal O}):\chi(\gamma)=a\}\big/G(\breve{\mathcal O}).$$

So the quotient of $\mathcal M_a$ by its symmetries is the set of integral conjugacy classes in the stable class $a$. One can draw $\mathfrak g(\mathcal O)/G(\mathcal O)$ as a region fibered over the line $\mathfrak c(\mathcal O)$, with the Kostant section as a curve inside it. The fiber over $a$ is the set of integral classes with characteristic polynomial $a$. Exactly one of them is regular, namely the class of $\epsilon(a)$: this is Proposition 1.8, read through the bijection above. The non-regular classes correspond to the boundary $\mathcal M_a\smallsetminus\mathcal M_a^{\mathrm{reg}}$ modulo symmetries. For $GL_n$, the quotient is the set of isomorphism classes of torsion-free rank one $B$-modules, and the regular class is the class of $B$.

Over $k$ rather than $\bar k$, this bijection gets twisted by Galois cohomology, and counting $k$-points of the quotient stack $[\mathcal M_a/\mathcal P(J_a)]$ amounts to counting integral elements in a stable conjugacy class, with suitable weights. This is exactly what an orbital integral of $1_{\mathfrak g(\mathcal O)}$ does; we come back to this in §8.

### 2.5 The normalization and the structure of $E^\times/B^\times$

We now analyse the group $E^\times/B^\times$. Let $B^\flat$ be the normalization of $B$ in $E$. Since $E=\prod_iE_i$, the ring $B^\flat=\prod_i\mathcal O_{E_i}$ is the ring of integers of $E$. The inclusions $B^\times\subset(B^\flat)^\times\subset E^\times$ give an exact sequence
$$0\longrightarrow(B^\flat)^\times/B^\times\longrightarrow E^\times/B^\times\longrightarrow E^\times/(B^\flat)^\times\longrightarrow0.\tag{2.1}$$
The quotient on the right is easy to understand: taking the valuations of the components gives $E^\times/(B^\flat)^\times=\prod_iE_i^\times/\mathcal O_{E_i}^\times\cong\mathbb Z^s$. It is a free abelian group of finite rank, with a basis indexed by the branches of the curve. The subgroup on the left is more interesting.

**Lemma 2.3.** $(B^\flat)^\times/B^\times$ is the group of $\bar k$-points of a connected affine algebraic group $\mathcal R_a$ of dimension $\dim_{\bar k}(B^\flat/B)$.

*Proof.* Since $B^\flat$ is finite over $B$ and $B\otimes\breve F=B^\flat\otimes\breve F$, the conductor of $B$ contains a power of $\pi$: there is $N$ with $\pi^NB^\flat\subset B$. Then $1+\pi^NB^\flat\subset B^\times$, and
$$(B^\flat)^\times/B^\times=(B^\flat/\pi^NB^\flat)^\times\big/(B/\pi^NB^\flat)^\times.$$
For a finite-dimensional $\bar k$-algebra $A$, the unit group $A^\times$ is the complement in the affine space $A$ of the hypersurface $\{x:\det(\text{multiplication by }x)=0\}$, hence a connected algebraic group of dimension $\dim_{\bar k}A$. A quotient of a connected group is connected, and our quotient has dimension $\dim_{\bar k}(B^\flat/\pi^NB^\flat)-\dim_{\bar k}(B/\pi^NB^\flat)=\dim_{\bar k}(B^\flat/B)$. ∎

Combining Lemma 2.3 with the exact sequence (2.1) gives a complete description of the symmetry group.

**Corollary 2.4** (Ngô 3.6.2, 3.6.3).
1. The neutral component of $\mathcal P(J_a)$ is $\mathcal R_a=(B^\flat)^\times/B^\times$, and $\pi_0(\mathcal P(J_a))=E^\times/(B^\flat)^\times\cong\mathbb Z^s$ is a free abelian group with a basis indexed by the connected components of $\mathrm{Spec}\,B^\flat$.
2. $\dim\mathcal P(J_a)=\delta(a):=\dim_{\bar k}(B^\flat/B)$, the δ-invariant of Serre of the singularity $\mathrm{Spec}\,B$.
3. (Serre) $\delta(a)=\dfrac{d(a)-c(a)}{2}$, where $d(a)=\mathrm{val}(\mathrm{disc}\,P)$ and $c(a)=n-s$.

*Proof of 3.* The discriminant of an order differs from that of the maximal order by the square of the index: $\mathrm{val}\,\mathrm{disc}(B)=\mathrm{val}\,\mathrm{disc}(B^\flat)+2\,\mathrm{length}(B^\flat/B)$. Here $\mathrm{disc}(B)=\mathrm{disc}(P)$, and $\mathrm{disc}(B^\flat)=\prod_i\mathrm{disc}(\mathcal O_{E_i})$. Each $E_i$ is totally ramified of degree $n_i$, and tamely ramified because $n_i\le n<p$, so its different has valuation $n_i-1$ and $\mathrm{val}\,\mathrm{disc}(\mathcal O_{E_i})=n_i-1$. Summing over $i$ gives $\mathrm{val}\,\mathrm{disc}(B^\flat)=n-s$. ∎

One can say a little more about $\mathcal R_a$. Like any connected commutative affine algebraic group, it is the product of a torus and a unipotent group. If $B$ is local, its unit group is $\bar k^\times\times(1+\mathfrak m_B)$, while $(B^\flat)^\times$ has a torus part $(\bar k^\times)^s$, one factor for each branch; so $\mathcal R_a\cong\mathbb G_m^{s-1}\times U$ with $U$ unipotent. Roughly speaking, the torus part comes from the branches of the singularity and the unipotent part from its "cuspidal" nature. The following examples illustrate both.

### 2.6 Examples

**Example 2.5** (a node). Let $n=2$ and $P(T)=T(T-\pi)$, so that $\gamma_0=\left(\begin{smallmatrix}0&0\\1&\pi\end{smallmatrix}\right)$. The spectral curve is the union of the lines $T=0$ and $T=\pi$, which meet transversally: an ordinary node with two branches. Algebraically,
$$E=\breve F[T]/\big(T(T-\pi)\big)\xrightarrow{\ \sim\ }\breve F\times\breve F,\qquad f\longmapsto\big(f(0),f(\pi)\big).$$
The image of $B$ consists of the pairs $(c_0,c_0+c_1\pi)$, so
$$B=\{(x,y)\in\breve{\mathcal O}^2:\ x\equiv y\bmod\pi\},\qquad B^\flat=\breve{\mathcal O}\times\breve{\mathcal O}.$$
Hence $B^\flat/B\cong\bar k$ and $\delta=1$. This agrees with Serre's formula: $d=\mathrm{val}\big((0-\pi)^2\big)=2$ and $c=2-2=0$.

The symmetry group is easy to write down. The map $(x,y)\mapsto\bar x/\bar y$ identifies $\mathcal R_a=(B^\flat)^\times/B^\times$ with $\mathbb G_m$, and $(x,y)\mapsto(\mathrm{val}\,x,\mathrm{val}\,y)$ identifies $\pi_0(\mathcal P(J_a))=E^\times/(B^\flat)^\times$ with $\mathbb Z^2$.

Now we determine all $B$-lattices $L\subset E=\breve F^2$. The ring $\{x\in E:xL\subset L\}$ is an order containing $B$, and since $B^\flat/B$ is one-dimensional, it is either $B^\flat$ or $B$.

- If it is $B^\flat$, then $L$ is a $B^\flat$-module, so $L=L_{m,n}:=\pi^m\breve{\mathcal O}\oplus\pi^n\breve{\mathcal O}$ for some $(m,n)\in\mathbb Z^2$. These lattices are not regular: $T$ acts on $E$ as $(0,\pi)$, hence by zero on $L_{m,n}/\pi L_{m,n}$.
- If it is $B$, then $L$ is an invertible $B$-module, because $B$ is Gorenstein (it is a complete intersection). Since $B$ is local, $L$ is free, $L=xB$, and it is regular.

Fix $(m,n)$, and consider the lattices $L$ with $\pi L_{m,n}\subset L\subset L_{m,n}$ and $\dim_{\bar k}L_{m,n}/L=1$. They correspond to lines in $L_{m,n}/\pi L_{m,n}\cong\bar k^2$, so they form a projective line
$$C_{m,n}=\big\{L_c:=\pi L_{m,n}+\breve{\mathcal O}\cdot(\pi^m,c\,\pi^n)\ :\ c\in\mathbb P^1\big\}.$$
Each $L_c$ is stable under $T=(0,\pi)$, so it is a $B$-lattice. For $c\in\bar k^\times$ one checks that $L_c=(\pi^m,c\,\pi^n)B$, which is a regular point. The two remaining points are $L_0=L_{m,n+1}$ and $L_\infty=L_{m+1,n}$. Every free lattice can be written as $(\pi^m,c\,\pi^n)B$ after multiplying its generator by a unit of $B$, so we conclude that
$$\mathcal M_a=\bigcup_{(m,n)\in\mathbb Z^2}C_{m,n},$$
where the line $C_{m,n}$ joins the non-regular points $L_{m,n+1}$ and $L_{m+1,n}$. Each non-regular point lies on exactly two lines, $C_{m,n}\cap C_{m+1,n-1}=\{L_{m+1,n}\}$. So for each value of $\mathrm{val}\det=m+n+1$ we get an infinite chain of projective lines:
```
 ... —— L_{m,n+1} ——[ C_{m,n} ]—— L_{m+1,n} ——[ C_{m+1,n-1} ]—— L_{m+2,n-1} —— ...
```
This example already shows everything we will prove in general:
- the dimension of $\mathcal M_a$ is $1=\delta$ (Theorem 3.3);
- the regular locus is the disjoint union of the open orbits $C_{m,n}\smallsetminus\{0,\infty\}\cong\mathbb G_m$, i.e. a copy of $\mathcal P(J_a)\cong\mathbb Z^2\times\mathbb G_m$ (Proposition 1.8), and it is dense (Proposition 6.1);
- the irreducible components $C_{m,n}$ are indexed by $\mathbb Z^2=\pi_0(\mathcal P(J_a))$ (Corollary 6.2);
- the lattice $\Lambda=\mathbb Z^2$, acting by multiplication by $(\pi^i,\pi^j)$, acts freely, and the quotient $\mathcal M_a/\Lambda$ is a single projective line with $0$ and $\infty$ glued together: a nodal rational curve, which is projective (Proposition 1.9).

This is the example treated in Ngô §8.3 ("un cas très simple"), where it is used to check the fundamental lemma by hand. We do the same in Example 8.2.

**Example 2.6** (a smooth point and a cusp). It is instructive to compare with two other germs for $n=2$. In both cases $E=\breve F(\sqrt\pi)$ is a ramified quadratic extension, so $s=1$ and $c=1$.

If $P(T)=T^2-\pi$, the spectral curve is smooth. Then $B=\breve{\mathcal O}[\sqrt\pi]=\mathcal O_E=B^\flat$ and $\delta=0$ (indeed $d=\mathrm{val}(4\pi)=1$). Every $B$-lattice is a fractional ideal $\pi^{m/2}\mathcal O_E$, so $\mathcal M_a=\mathcal M_a^{\mathrm{reg}}\cong E^\times/\mathcal O_E^\times=\mathbb Z$ is discrete.

If $P(T)=T^2-\pi^3$, the curve has a cusp. Then $B=\breve{\mathcal O}[\pi\sqrt\pi]=\breve{\mathcal O}+\pi\mathcal O_E$ and $B^\flat=\mathcal O_E$, with $B^\flat/B\cong\bar k$, so $\delta=1$ (indeed $d=\mathrm{val}(4\pi^3)=3$). This time $\mathcal R_a=\mathcal O_E^\times/B^\times\cong\mathbb G_a$, via $u_0+u_1\sqrt\pi\mapsto\overline{u_1/u_0}$: the symmetry group is unipotent rather than a torus. The regular lattices $\pi^{m/2}(1+c\sqrt\pi)B$, $c\in\bar k$, form an affine line, and as $c\to\infty$ they converge to the single non-regular lattice $\pi^{(m+1)/2}\mathcal O_E$. So $\mathcal M_a$ is a disjoint union of projective lines, indexed by $\mathbb Z$.

To summarize: a node gives a torus and chains of lines, a cusp gives an additive group and isolated lines, and a smooth point gives nothing.

## 3. Dimension

(Ngô §3.7.) We now return to a general group $G$. By Proposition 1.8 the regular locus is a copy of $\mathcal P(J_a)$, so the dimension of $\mathcal M_a$ splits into two questions: how big is $\mathcal P(J_a)$, and is the boundary smaller? The second question was answered by Kazhdan and Lusztig.

**Proposition 3.1** (Kazhdan–Lusztig; Ngô 3.7.1). $\dim\mathcal M_a=\dim\mathcal M_a^{\mathrm{reg}}$. More precisely, the complement $\mathcal M_a\smallsetminus\mathcal M_a^{\mathrm{reg}}$ has strictly smaller dimension than $\mathcal M_a$.

*Sketch of proof.* Consider the affine Springer fiber in the affine flag variety,
$$\mathcal B_a=\{g\in G(\breve F)/\mathrm{Iw}\ :\ \mathrm{ad}(g)^{-1}\gamma_0\in\mathrm{Lie}(\mathrm{Iw})\},$$
where $\mathrm{Iw}$ is an Iwahori subgroup. Kazhdan and Lusztig proved that $\mathcal B_a$ is equidimensional; for classical Springer fibers this is due to Spaltenstein. The projection $\mathcal B_a\to\mathcal M_a$ is finite over $\mathcal M_a^{\mathrm{reg}}$, since a regular element lies in only finitely many Borel subalgebras, while over a non-regular point its fiber is a classical Springer fiber of positive dimension. Equidimensionality then forces the boundary to be smaller. ∎

**Corollary 3.2** (Ngô 3.7.2). If $\dim\mathcal M_a=0$, then $\mathcal M_a=\mathcal M_a^{\mathrm{reg}}$.

The dimension of $\mathcal P(J_a)$ is given by a formula conjectured by Kazhdan and Lusztig and proved by Bezrukavnikov. It involves two invariants of $a$. The first measures how deeply the arc $a$ dips into the discriminant:
$$d(a):=\deg(a^*\mathfrak D)=\mathrm{val}\Big(\prod_{\alpha\in\Phi}\alpha(\gamma_0)\Big).$$
For the second, restrict $a$ to the punctured disc and pull back the étale $W$-cover $\mathfrak t^{\mathrm{rs}}\to\mathfrak c^{\mathrm{rs}}$. This gives a $W$-torsor over $\breve F$, that is, after choosing a base point, a homomorphism $\pi_a:I\to W$ from the inertia group. Since $p\nmid|W|$, it factors through the tame inertia, so its image is cyclic. Put
$$c(a):=\dim\mathfrak t-\dim\mathfrak t^{\pi_a(I)}.$$
This measures how ramified the torus $J_{a,\breve F}$ is.

**Theorem 3.3** (Bezrukavnikov; Ngô §3.7).
$$\dim\mathcal M_a^{\mathrm{reg}}=\dim\mathcal P(J_a)=\frac{d(a)-c(a)}{2}.$$

Ngô writes $\delta_a:=\dim\mathcal P(J_a)$ and calls it the local δ-invariant. The name is justified by the linear case: for $GL_n$ the inertia permutes the roots of $P$, with one orbit for each factor $E_i$, so $c(a)=n-s$, and Theorem 3.3 is exactly Serre's formula (Corollary 2.4). When the torus $J_{a,\breve F}$ is unramified we have $c(a)=0$, and $\delta_a=\sum_{\alpha>0}\mathrm{val}\,\alpha(\gamma_0)$ is the sum of the root valuations. In Example 2.5 there is one positive root, and its valuation is $\mathrm{val}(0-\pi)=1$. We will not prove Theorem 3.3, but the next section gives a second formula for $\delta_a$ which generalizes $\delta=\dim_{\bar k}B^\flat/B$.

## 4. The Néron model

(Ngô §3.8.) In the linear case, the structure of $\mathcal P(J_a)$ came from the normalization $B^\flat$: the units of $B^\flat$ form the bounded part of $E^\times$, and the exact sequence (2.1) split $\mathcal P(J_a)$ into an algebraic group and a lattice. For a general group, the role of $B^\flat$ is played by the Néron model of $J_a$.

**Definition 4.1.** The Néron model $J_a^\flat$ of $J_a$ is the unique smooth group scheme of finite type over $\breve{\mathcal O}$ with generic fiber $J_{a,\breve F}$ which is maximal for this property: every smooth group scheme of finite type over $\breve{\mathcal O}$ with the same generic fiber maps to $J_a^\flat$, compatibly with the identity on generic fibers.

(Bosch, Lütkebohmert and Raynaud also construct a Néron model which is only locally of finite type; Ngô uses the finite type version.) In particular there is a canonical homomorphism $J_a\to J_a^\flat$, and on points
$$J_a(\breve{\mathcal O})\subset J_a^\flat(\breve{\mathcal O})\subset J_a(\breve F),$$
where $J_a^\flat(\breve{\mathcal O})$ is the maximal bounded subgroup of the torus $J_a(\breve F)$. For $GL_n$ we have $J_a^\flat=\mathrm{Res}_{B^\flat/\breve{\mathcal O}}\mathbb G_m$.

The Néron model can be constructed explicitly, by the same recipe as $J$ itself after a normalization. Let $\widetilde X_a=D\times_{a,\mathfrak c}\mathfrak t$ be the cameral cover of the disc attached to $a$. It is finite and flat over $D$, generically étale, and carries an action of $W$. Let $\widetilde X_a^\flat$ be its normalization.

**Proposition 4.2** (Ngô 3.8.2). The Néron model is the group of fixed points of $W$, acting diagonally, on the Weil restriction of the constant torus:
$$J_a^\flat=\Big(\mathrm{Res}_{\widetilde X_a^\flat/D}\big(T\times\widetilde X_a^\flat\big)\Big)^W.$$

Compare this with the Galois description of $J$ due to Donagi and Gaitsgory (Ngô 2.4): over $\mathfrak c^{\mathrm{rs}}$, $J=\big(\mathrm{Res}_{\mathfrak t/\mathfrak c}(T\times\mathfrak t)\big)^W$. Proposition 4.2 says that the Néron model is obtained by the same construction applied to the normalized cameral cover. For $GL_n$ this is the statement that the units of the normalization $B^\flat$ give the Néron model.

Replacing $J_a$ by $J_a^\flat$ in Definition 1.7, we obtain a group ind-scheme $\mathcal P(J_a^\flat)$ and a homomorphism $\mathcal P(J_a)\to\mathcal P(J_a^\flat)$.

**Lemma 4.3** (Ngô 3.8.1). The group $\mathcal P(J_a^\flat)$ is discrete and isomorphic to a free abelian group of finite rank. The homomorphism $\mathcal P(J_a)\to\mathcal P(J_a^\flat)$ is surjective, and its kernel $\mathcal R_a$ is an affine algebraic group of finite type over $\bar k$, with $\mathcal R_a(\bar k)=J_a^\flat(\breve{\mathcal O})/J_a(\breve{\mathcal O})$. Thus there is an exact sequence
$$1\longrightarrow\mathcal R_a\longrightarrow\mathcal P(J_a)\longrightarrow\mathcal P(J_a^\flat)\longrightarrow1.$$

*Proof.* $\mathcal P(J_a^\flat)(\bar k)=J_a(\breve F)/J_a^\flat(\breve{\mathcal O})$ is the quotient of a torus by its maximal bounded subgroup, which is free of finite rank; for a split torus it is the cocharacter lattice. Surjectivity is clear on points. For $N$ large, $J_a(\breve{\mathcal O})$ contains the kernel of the reduction map $J_a^\flat(\breve{\mathcal O})\to J_a^\flat(\breve{\mathcal O}/\pi^N)$. Hence $\mathcal R_a$ is a quotient of the Weil restriction of $J_a^\flat\otimes\breve{\mathcal O}/\pi^N$ from $\breve{\mathcal O}/\pi^N$ to $\bar k$, which is a smooth affine algebraic group of finite type. ∎

This is the general version of Lemma 2.3, and the proof is the same, with the conductor replaced by a power of $\pi$. So $\mathcal P(J_a)$ always looks as in the linear case: an affine algebraic group $\mathcal R_a$, consisting of the symmetries that preserve the integral structure as much as possible, extended by a lattice of translations. By Theorem 3.3 we have $\dim\mathcal R_a=\delta_a$, and the Néron model gives a formula for this number which directly generalizes $\dim_{\bar k}(B^\flat/B)$.

**Corollary 4.4** (Ngô 3.8.3). Write $\widetilde X_a=\mathrm{Spec}\,\widetilde{\mathcal O}$ and $\widetilde X_a^\flat=\mathrm{Spec}\,\widetilde{\mathcal O}^\flat$. Then
$$\delta_a=\dim_{\bar k}\big(\mathfrak t\otimes_{\breve{\mathcal O}}\widetilde{\mathcal O}^\flat/\widetilde{\mathcal O}\big)^W.$$

The other invariant $c(a)$ also has a meaning here: it is the drop of the toric rank of the Néron model, i.e. the rank of $T$ minus the toric rank of the special fiber of $J_a^\flat$. In Example 2.5, $J_a^\flat=\mathbb G_m^2$ has special fiber a torus of rank $2$, and $c=0$. In Example 2.6, the special fiber of $\mathrm{Res}_{\mathcal O_E/\breve{\mathcal O}}\mathbb G_m$ is $(\bar k[\varepsilon]/\varepsilon^2)^\times\cong\mathbb G_m\times\mathbb G_a$, of toric rank $1$, and $c=1$.

## 5. Connected components

(Ngô §3.9.) Next we compute the group of connected components $\pi_0(\mathcal P(J_a))$. In the linear case it was the free group $E^\times/(B^\flat)^\times\cong\mathbb Z^s$. In general two new phenomena appear: $\pi_0$ can have torsion, and it is naturally described in terms of the dual group. This is where the dual group, and with it endoscopy, enters the geometry.

Part of the torsion comes from $J_a$ itself, whose fibers need not be connected. For $GL_n$ they are, because the center of $GL_n$ is connected (Ngô 2.3.1). For $SL_2$, the regular centralizer is $J_a=\{u+vT:u^2-av^2=1\}$ inside $\mathrm{Res}_{B/\breve{\mathcal O}}\mathbb G_m$, with $B=\breve{\mathcal O}[T]/(T^2-a)$. If $\pi\mid a$, its special fiber is $\{u=\pm1\}\cong\mu_2\times\mathbb G_a$, which is disconnected. (Among groups of semisimple rank one, $SL_2$ is the only one with this behavior, Ngô 2.4.7.) In general, let $J_a^0\subset J_a$ be the open subgroup scheme of neutral components. Then $\pi_0(J_{a,v}):=J_a(\breve{\mathcal O})/J_a^0(\breve{\mathcal O})$ is a finite group, and there is an exact sequence
$$1\longrightarrow\pi_0(J_{a,v})\longrightarrow\mathcal P(J_a^0)\longrightarrow\mathcal P(J_a)\longrightarrow1.$$
So $\pi_0(\mathcal P(J_a))$ is the quotient of $\pi_0(\mathcal P(J_a^0))$ by the image of $\pi_0(J_{a,v})$.

The answer is best stated by duality. For a finitely generated abelian group $\Lambda$, write $\Lambda^*=\mathrm{Spec}\,\overline{\mathbb Q}_\ell[\Lambda]$ for the diagonalizable group with character group $\Lambda$. Let $\hat T$ be the dual torus, with its action of $W$, and recall the monodromy $\pi_a:I\to W$ from §3.

**Theorem 5.1** (Ngô §3.9).
1. $\pi_0(\mathcal P(J_a^0))\cong X_*(T)_{\pi_a(I)}$ (coinvariants); dually, $\pi_0(\mathcal P(J_a^0))^*\cong\hat T^{\pi_a(I)}$.
2. $\pi_0(\mathcal P(J_a))^*\cong\hat T(\pi_a(I))$, where $\hat T(\pi_a(I))$ is the subgroup of those $\kappa\in\hat T^{\pi_a(I)}$ such that $\pi_a(I)$ is contained in the Weyl group of $\hat H_\kappa$, the neutral component of the centralizer of $\kappa$ in $\hat G$. Equivalently, $\pi_0(\mathcal P(J_a))=X_*(T)_{\pi_a(I)}/\mathrm{im}\,\pi_0(Z_G)$.

For the first part, one shows that $\pi_0(\mathcal P(J_a^0))=J_a(\breve F)/J_a^{\flat,0}(\breve{\mathcal O})$, where $J_a^{\flat,0}$ is the neutral component of the Néron model, and then uses Kottwitz's computation $A(\breve F)/A^{\flat,0}(\breve{\mathcal O})=X_*(A)_I$, valid for any torus $A$ over $\breve F$. For the second part, Ngô embeds $G$ into a group $G_1$ with connected center (a z-extension). For $G_1$ there is no difference between $J$ and $J^0$, and one shows that $\pi_0(\mathcal P(J_a))$ injects into the corresponding group for $G_1$. Rather than going into the details, let us check the statement in examples.

For $GL_n$, the inertia permutes the $n$ roots of $P$, with one orbit for each factor $E_i$. So $X_*(T)_{\pi_a(I)}=(\mathbb Z^n)_{\pi_a(I)}=\mathbb Z^s$, and since the center is connected, $\pi_0(\mathcal P(J_a))=\mathbb Z^s$, as we found in Corollary 2.4.

For $a=\pi$ in $\mathfrak{sl}_2$ or in $\mathfrak{pgl}_2$, which is a ramified elliptic element with $\delta=0$, we have $\pi_a(I)=W=\{\pm1\}$ and $X_*(T)_W=\mathbb Z/2$ in both cases. For $SL_2$, the center $\mu_2$ maps onto this group, so $\pi_0(\mathcal P(J_a))=0$. This is right: with $E=\breve F(\sqrt\pi)$, the only lattice stable under $\gamma_0$ with the same volume as $\breve{\mathcal O}^2$ is $\mathcal O_E$, so $\mathcal M_a$ is a point. For $PGL_2$ we get $\pi_0(\mathcal P(J_a))=\mathbb Z/2$, and indeed $\mathcal M_a$ consists of the two homothety classes of $\mathcal O_E$ and $\sqrt\pi\,\mathcal O_E$. On the dual side, for $PGL_2$ the group $\hat T^W=\{\pm1\}\subset SL_2(\mathbb C)$ consists of central elements, so both are allowed. For $SL_2$, the element $\kappa=\mathrm{diag}(-1,1)\in PGL_2(\mathbb C)$ has $\hat H_\kappa=\hat T$, whose Weyl group is trivial and does not contain $\pi_a(I)=W$, so $\kappa$ is excluded.

Why should we care? The κ-orbital integrals in the fundamental lemma are weighted by characters κ of $H^1(F,J_a)$, and we will see in §8 that the orbital integral of $1_{\mathfrak g(\mathcal O)}$ vanishes unless κ factors through $\pi_0(\mathcal P(J_a))$. So the κ's that matter locally are the Frobenius-invariant points of $\hat T(\pi_a(I))$: those κ whose endoscopic group $\hat H_\kappa$ contains the monodromy of $a$, or informally, those for which $a$ comes from the endoscopic group. In this way Tate–Nakayama duality acquires a geometric meaning: components of the symmetry group correspond to points of the dual torus. (Compare [[Endoscopy]].)

## 6. Density of the regular orbit

(Ngô §3.10.) We know from Proposition 3.1 that the boundary has smaller dimension than the regular locus. In fact more is true.

**Proposition 6.1** (Ngô 3.10.1). $\mathcal M_a^{\mathrm{reg}}$ is dense in $\mathcal M_a$.

Ngô only sketches the proof of this local statement. It follows from the analogous statement for Hitchin fibers, which he proves in detail, and only the global statement is used in the rest of the paper. Since $\mathcal M_a^{\mathrm{reg}}\cong\mathcal P(J_a)$, we obtain:

**Corollary 6.2** (Ngô 3.10.2). The irreducible components of $\mathcal M_a$ are the closures of the connected components of $\mathcal M_a^{\mathrm{reg}}$. Hence they are in canonical bijection with $\pi_0(\mathcal P(J_a))$.

For $GL_n$, Proposition 6.1 says that every $B$-lattice is a limit of free ones, and Corollary 6.2 says that the irreducible components of $\mathcal M_a$ are indexed by $\mathbb Z^s$. This is a local analogue of a theorem of Altman, Iarrobino, Kleiman and Rego: the compactified Jacobian of an integral curve with planar singularities is irreducible, with the Jacobian as a dense open subset. (Our curve $\mathrm{Spec}\,B$ is planar because $B$ is generated by one element.) In Example 2.5 the components are the lines $C_{m,n}$, indexed by $\mathbb Z^2$.

Since every component is the closure of a translate of $\mathcal R_a$, all components have dimension $\delta_a$, and Corollary 6.2 identifies the top-degree Borel–Moore homology of $\mathcal M_a$ with $\overline{\mathbb Q}_\ell[\pi_0(\mathcal P(J_a))]$, on which $\mathcal P(J_a)$ acts by translations. The global analogue of this statement is how Ngô detects the characters κ in the cohomology of Hitchin fibers.

## 7. Comparison with an endoscopic group

(Ngô §3.11.) Let $H$ be an endoscopic group of $G$ attached to some κ, let $\nu:\mathfrak c_H\to\mathfrak c$ be the corresponding map, and let $a_H\in\mathfrak c_H(\breve{\mathcal O})$ with $a=\nu(a_H)\in\mathfrak c^\heartsuit(\breve{\mathcal O})$. There is no direct relation between the affine Springer fibers $\mathcal M_{H,a_H}$ and $\mathcal M_a$, but there is one between their symmetry groups. By Ngô 2.5.1 there is a homomorphism
$$\mu:J_a\longrightarrow J_{H,a_H}$$
which is an isomorphism over the punctured disc: the two group schemes have the same generic fiber, because $G$ and $H$ share their maximal torus. Hence $J_a(\breve{\mathcal O})\subset J_{H,a_H}(\breve{\mathcal O})$ inside the common torus $J_a(\breve F)$, and we get an exact sequence
$$1\longrightarrow\mathcal R^G_H(a_H)\longrightarrow\mathcal P(J_a)\longrightarrow\mathcal P(J_{H,a_H})\longrightarrow1,\qquad\mathcal R^G_H(a_H)(\bar k)=J_{H,a_H}(\breve{\mathcal O})/J_a(\breve{\mathcal O}).$$
The group $\mathcal R^G_H(a_H)$ measures how much more symmetric the $G$-side is than the $H$-side.

Recall the resultant divisor $\mathfrak R^G_H$ on $\mathfrak c_H$ (Ngô 1.10.2), defined by $\nu^*\mathfrak D_G=\mathfrak D_H+2\mathfrak R^G_H$. On $\mathfrak t$ it is cut out by the product of $d\alpha$ over one root from each pair $\pm\alpha$ of roots of $G$ that are not roots of $H$.

**Lemma 7.1** (Ngô §3.11). $\dim\mathcal R^G_H(a_H)=r^G_H(a_H):=\deg(a_H^*\mathfrak R^G_H)$.

*Proof.* From the exact sequence, $\dim\mathcal R^G_H(a_H)=\delta_a-\delta_{a_H}$. The invariants $c(a)$ and $c(a_H)$ agree, since $J_a$ and $J_{H,a_H}$ have the same generic fiber. So Bezrukavnikov's formula gives
$$\dim\mathcal R^G_H(a_H)=\tfrac12\big(d(a)-d(a_H)\big)=\tfrac12\deg a_H^*\big(\nu^*\mathfrak D_G-\mathfrak D_H\big)=\deg a_H^*\mathfrak R^G_H.$$
(The corresponding display in the arXiv version omits the factor $\tfrac12$; this is a typo.) ∎

The number $r^G_H(a_H)$ is exactly the exponent in the fundamental lemma,
$$\mathbf O^\kappa_a\big(1_{\mathfrak g(\mathcal O)}\big)=q^{\,r^G_H(a_H)}\,\mathbf{SO}_{a_H}\big(1_{\mathfrak h(\mathcal O)}\big),$$
and Lemma 7.1 gives it a geometric meaning: the $G$-side has $r^G_H(a_H)$ more dimensions of symmetry than the $H$-side. Heuristically, one may imagine $[\mathcal M_a/\mathcal P(J_a)]_\kappa$ as fibered over $[\mathcal M_{H,a_H}/\mathcal P(J_{H,a_H})]_{\mathrm{st}}$, with fibers affine spaces of dimension $r^G_H(a_H)$; this would explain the factor $q^r$ in point counts. Ngô does not prove the fundamental lemma this way. The closure of the graph of $\mu$ gives a correspondence between $\mathcal M_a$ and $\mathcal M_{H,a_H}$, but he explicitly does not use it; the identity comes from the global argument.

For $GL_n$, an endoscopic group is a Levi subgroup, say $H=GL_{n_1}\times GL_{n_2}$, and $a_H$ corresponds to a factorization $P=P_1P_2$. Then $B=\breve{\mathcal O}[T]/(P)\subset B_1\times B_2$ with $B_i=\breve{\mathcal O}[T]/(P_i)$, and $\mathcal R^G_H(a_H)=(B_1\times B_2)^\times/B^\times$. Lemma 7.1 becomes the classical fact that $\dim_{\bar k}(B_1\times B_2)/B=\mathrm{val}\,\mathrm{Res}(P_1,P_2)$. In Example 2.5, $P_1=T$ and $P_2=T-\pi$, the resultant is $\pi$, so $r=1$ and $\mathcal R^G_H(a_H)=\mathcal R_a\cong\mathbb G_m$.

## 8. Outlook: counting points

(Ngô §8.2–8.3.) Finally we explain why all this is relevant to orbital integrals. Now we work over $k$: $\mathcal M_a$ and $\mathcal P(J_a)$ are defined over $k$ and carry a Frobenius $\sigma$. An object of the groupoid $[\mathcal M_a/\mathcal P(J_a)](k)$ is a pair $(m,p)$ with $m\in\mathcal M_a(\bar k)$, $p\in\mathcal P(J_a)(\bar k)$ and $p\,\sigma(m)=m$. Its class $\mathrm{cl}(m,p)$ is the σ-conjugacy class of $p$, an element of $H^1(k,\mathcal P(J_a))$. If $J'_a$ is a model of $J_a$ with connected special fiber (for instance $J_a^0$), then Steinberg's theorem over $\breve F$ and Lang's theorem over $k$ give
$$H^1(F,J_a)=H^1\big(k,\mathcal P(J'_a)\big).$$
So the characters κ of $H^1(F,J_a)$, which are the weights in κ-orbital integrals, can be evaluated on these classes, and we define the κ-weighted count
$$\#[\mathcal M_a/\mathcal P(J_a)](k)_\kappa=\sum_x\frac{\langle\mathrm{cl}(x),\kappa\rangle}{\#\mathrm{Aut}(x)},$$
the sum running over the isomorphism classes of objects $x$.

**Proposition 8.1** (Ngô §8.2). For every Haar measure $dt$ on $J_a(F)$,
$$\#[\mathcal M_a/\mathcal P(J_a)](k)_\kappa=\mathrm{vol}\big(J_a^0(\mathcal O),dt\big)\cdot\mathbf O^\kappa_a\big(1_{\mathfrak g(\mathcal O)},dt\big).$$
Moreover, $\mathbf O^\kappa_a(1_{\mathfrak g(\mathcal O)})=0$ if κ does not factor through $H^1(k,\mathcal P(J_a))$.

The proof unwinds the definitions, following Goresky, Kottwitz and MacPherson. The objects with a given class $\xi\in H^1(F,J_a)$ correspond to the integral structures preserved by the element $\gamma_\xi$ of the stable class with invariant ξ, up to the action of $J_a(F)$. These are exactly the terms of the orbital integral of $\gamma_\xi$, and summing over ξ with the weights $\langle\xi,\kappa\rangle$ gives $\mathbf O^\kappa_a$. Thanks to Proposition 1.9 the cohomology of $[\mathcal M_a/\Lambda]$ is finite-dimensional, and there is also a cohomological version: the alternating sum of the traces of Frobenius on the κ-parts of the cohomology of $[\mathcal M_a/\Lambda]$ equals $\mathrm{vol}(J_a^{\flat,0}(\mathcal O),dt)\cdot\mathbf O^\kappa_a(1_{\mathfrak g(\mathcal O)},dt)$.

**Example 8.2** (the fundamental lemma for the node). Let us compute both sides of the fundamental lemma in Example 2.5, now over $k=\mathbb F_q$. So $G=GL_2$, $\gamma_0$ is the companion matrix of $P=T(T-\pi)$, and $H=T=GL_1\times GL_1$ is the diagonal torus, with $a_H=(T,\,T-\pi)$. The torus $J_{a,F}$ is split, so $H^1(F,J_a)=0$ and the κ-orbital integral is just the orbital integral. Normalize $dt$ by $\mathrm{vol}(T(\mathcal O))=1$, and note that $T(\mathcal O)=J_a^\flat(\mathcal O)$. The torus $T(F)=E^\times$ acts on $\mathcal M_a(\mathbb F_q)$ with exactly two orbits: the lattices $L_{m,n}$, with stabilizer $T(\mathcal O)$, and the free lattices $xB$, with stabilizer $B^\times$, a subgroup of index $\#\mathcal R_a(\mathbb F_q)=\#\mathbb G_m(\mathbb F_q)=q-1$ in $T(\mathcal O)$. Hence
$$\mathbf O_{\gamma_0}\big(1_{\mathfrak{gl}_2(\mathcal O)}\big)=\frac{1}{\mathrm{vol}\,T(\mathcal O)}+\frac{1}{\mathrm{vol}\,B^\times}=1+(q-1)=q.$$
On the other side, $\mathbf{SO}_{a_H}(1_{\mathfrak t(\mathcal O)})=1$, since on a torus the orbital integral of $1_{\mathfrak t(\mathcal O)}$ at an integral point is the volume of a point; and $r^G_H(a_H)=\mathrm{val}\,\mathrm{Res}(T,T-\pi)=1$. The fundamental lemma predicts $q=q^1\cdot1$, which is correct.

In the normalization of Proposition 8.1, $\mathrm{vol}(J_a(\mathcal O))=\mathrm{vol}(B^\times)=1$, the same computation reads
$$\#[\mathcal M_a/\mathcal P(J_a)](\mathbb F_q)=1+\frac{1}{q-1}=\frac{q}{q-1}.$$
The regular orbit contributes $1$, since its stabilizer is trivial, and the non-regular orbit contributes $1/\#\mathcal R_a(\mathbb F_q)$, since its stabilizer is $\mathcal R_a\cong\mathbb G_m$.

For $GL_n$ the fundamental lemma is not deep: $H^1(F,J_a)$ is always trivial, endoscopic groups are Levi subgroups, and the identity reduces to parabolic descent, where the factor $q^{r^G_H}$ is $|D^G_H(\gamma_0)|^{-1/2}=q^{\mathrm{val}\,\mathrm{Res}(P_1,P_2)}$. Its real content lies in groups such as $SL_2$, $Sp_{2n}$ or $U_n$, where κ can be nontrivial.

Ngô's §8.3 treats the general case $d(a)=2$, $c(a)=0$, of which Example 2.5 is an instance. There is then a unique pair of roots $\pm\alpha$ with valuation one, $\mathcal R_a$ is the one-dimensional torus $T/\ker\alpha$, and $\mathcal M_a$ is a disjoint union of infinite chains of projective lines: the closure of the $\mathcal R_a$-orbit of $\pi^\lambda U_\alpha(x\pi^{-1})$ adds the two points $\pi^\lambda$ and $\pi^{\lambda-\alpha^\vee}$. (In Example 2.5, $(m+1,n)-(m,n+1)=(1,-1)=\alpha^\vee$.) For κ with $\kappa(\alpha^\vee)\neq1$ one finds
$$\#[\mathcal M_a/\mathcal P(J_a)](k)_\kappa=\frac{q}{\#(T/\ker\alpha)(k)}.$$
Ngô uses computations of this kind to check the stabilization identity over a dense open part of the Hitchin base, where all local singularities are this mild; the support theorem then propagates the identity to the whole base.

Let us end by summarizing how today's results are used in the global argument. The projectivity of $\mathcal M_a/\Lambda$ makes all point counts finite and all cohomology groups finite-dimensional. Approximation allows one to realize any local $a$ inside a global Hitchin fiber, so that local identities can be deduced from global ones. The δ-invariant controls the codimension of the strata of the Hitchin base, which is the key geometric input of the support theorem. The description of $\pi_0(\mathcal P(J_a))$ through the dual torus matches the κ-decomposition of the cohomology of Hitchin fibers with endoscopy. Density identifies the top cohomology with functions on $\pi_0$. And Lemma 7.1 accounts for the factor $q^{r^G_H(a_H)}$.

## References

- B. C. Ngô, *Le lemme fondamental pour les algèbres de Lie*, Publ. Math. IHÉS 111 (2010), 1–169. [arXiv:0801.0446](https://arxiv.org/abs/0801.0446)
- D. Kazhdan, G. Lusztig, *Fixed point varieties on affine flag manifolds*, Israel J. Math. 62 (1988), 129–168.
- R. Bezrukavnikov, *The dimension of the fixed point set on affine flag manifolds*, Math. Res. Lett. 3 (1996), 185–189.
- M. Goresky, R. Kottwitz, R. MacPherson, *Homology of affine Springer fibers in the unramified case*, Duke Math. J. 121 (2004), 509–561.
- G. Laumon, *Fibres de Springer et jacobiennes compactifiées*, in *Algebraic Geometry and Number Theory*, Progr. Math. 253, Birkhäuser (2006), 515–563.
- J.-P. Serre, *Corps locaux*, chap. III.

Related: [[Endoscopy]]
