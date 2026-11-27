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

*Notes on the talk “Affine Springer fiber (§3.6–3.11 in Ngô's paper)”, Ngô fundamental lemma seminar, 23 October 2026. Reference: B. C. Ngô, Le lemme fondamental pour les algèbres de Lie, Publ. Math. IHÉS 111 (2010), numbering as in [arXiv:0801.0446](https://arxiv.org/abs/0801.0446).*

The fundamental lemma compares $\kappa$-orbital integrals for $G$ with stable orbital integrals for an endoscopic group $H$. Locally, these are weighted counts of integral structures in a stable conjugacy class. The space of structures is the affine Springer fiber $\mathcal M_a$, and its symmetries form the local Picard group $\mathcal P(J_a)$. **The regular locus is a dense orbit isomorphic to $\mathcal P(J_a)$.**

The boards introduced the fiber and the $GL_n$ calculation through the start of Example 2.5. Figures 1–3 redraw the boards. The paper supplies the regular centralizer recollections, the rest of the examples, and §§3–8. Figure 4 illustrates the node calculation. We start with integral lattices, then pass to dimension, components, and orbital integrals.

## 1. Set-up and recollections

### 1.1 Notation

Let $G$ be split reductive over $k=\mathbb F_q$, with maximal torus $T$, roots $\Phi$, Weyl group $W$, and Lie algebras $\mathfrak g$ and $\mathfrak t$. Assume $p=\mathrm{char}\,k$ does not divide $|W|$. Write

$$
\mathcal O=k[[\pi]],\qquad F=k((\pi)),\qquad
\breve{\mathcal O}=\bar k[[\pi]],\qquad \breve F=\bar k((\pi)).
$$

$$
\mathfrak c=\mathfrak t/\!/W=\mathrm{Spec}\,k[\mathfrak g]^G,\qquad
\chi\colon\mathfrak g\to\mathfrak c,\qquad \epsilon\colon\mathfrak c\to\mathfrak g^{\mathrm{reg}},
\qquad \chi\circ\epsilon=\mathrm{id}.
$$

The Chevalley map $\chi$ gives the characteristic polynomial for $GL_n$, and the Kostant section $\epsilon$ gives its companion matrix. Write $\mathfrak D$ for the discriminant cut out by $\prod_{\alpha\in\Phi}d\alpha$ on $\mathfrak t$ and descended to $\mathfrak c$. We use arcs that are regular semisimple at the generic point:

$$
\mathfrak c^{\mathrm{rs}}=\mathfrak c\smallsetminus\mathfrak D,
\qquad
\mathfrak c^\heartsuit(\mathcal O)=\mathfrak c(\mathcal O)\cap\mathfrak c^{\mathrm{rs}}(F).
$$

### 1.2 Affine Springer fibers

An $S$-point of $[\mathfrak g/G]$ is a $G$-torsor $E$ with a section $\phi$ of $\mathrm{ad}(E)=E\times^G\mathfrak g$. Invariance of $\chi$ defines $[\chi](E,\phi)\in\mathfrak c(S)$. For $GL_n$ this is the characteristic polynomial of a vector bundle endomorphism.

**Definition 1.1** (affine Springer fiber). Fix $\gamma\in\mathfrak g(F)$ regular semisimple and let $E_0$ be the trivial torsor. For a $k$-algebra $R$, put $D_R=\mathrm{Spec}\,R[[\pi]]$ and $D_R^\times=\mathrm{Spec}\,R((\pi))$. The points of $\mathrm{Gr}_\gamma(R)$ are triples $(E,\phi,\iota)$ with $(E,\phi)$ over $D_R$ and

$$
\iota\colon(E,\phi)|_{D_R^\times}\xrightarrow{\sim}(E_0,\gamma)|_{D_R^\times}.
$$

The pair $(E,\iota)$ specifies an integral structure on the trivial torsor over $D_R^\times$. The condition is that $\gamma$ extends to that structure.

**Proposition 1.2** (Ngô 3.2.1). Forgetting $\phi$ gives a closed immersion $\mathrm{Gr}_\gamma\hookrightarrow\mathrm{Gr}_G$. The reduced fiber is a scheme locally of finite type over $k$.

**Lemma 1.3.** For $R$ such that every $G$-torsor over $D_R$ is trivial, in particular $R=\bar k$,

$$
\mathrm{Gr}_\gamma(R)=
\left\{[g]\in G(R((\pi)))/G(R[[\pi]])\;\middle|\;
\mathrm{ad}(g)^{-1}\gamma\in\mathfrak g(R[[\pi]])\right\}.
$$

A trivialization of $E$ identifies $\iota$ with $g$ and $\phi$ with $\mathrm{ad}(g)^{-1}\gamma$. For $GL_n$, the coset corresponds to $L=g\breve{\mathcal O}^{\,n}$, with condition $\gamma L\subseteq L$.

**Definition 1.4.** The regular locus $\mathrm{Gr}_\gamma^{\mathrm{reg}}$ is the open subfunctor where the classifying map of $(E,\phi)$ lands in $[\mathfrak g^{\mathrm{reg}}/G]$. On geometric points, this says

$$
\mathrm{ad}(g)^{-1}\gamma\bmod\pi\in\mathfrak g^{\mathrm{reg}}(\bar k).
$$

**Definition 1.5.** For $a\in\mathfrak c^\heartsuit(\mathcal O)$, set $\gamma_0=\epsilon(a)$ and $(\mathcal M_a,\mathcal M_a^{\mathrm{reg}})=(\mathrm{Gr}_{\gamma_0},\mathrm{Gr}_{\gamma_0}^{\mathrm{reg}})$. The Kostant point $[1]$ belongs to $\mathcal M_a^{\mathrm{reg}}$.

### 1.3 The regular centralizer and the symmetry group

To compare the integral structures, we need a group that acts on every pair with invariant $a$.

**Proposition 1.6** (Ngô 2.1.1). Let $I\to\mathfrak g$ be the centralizer scheme. There is a unique smooth commutative group scheme $J\to\mathfrak c$ with a $G$-equivariant isomorphism $\chi^*J|_{\mathfrak g^{\mathrm{reg}}}\cong I|_{\mathfrak g^{\mathrm{reg}}}$. It extends to a homomorphism $\chi^*J\to I$. One can take $J=\epsilon^*I$.

Two regular elements in the same geometric fiber of $\chi$ are conjugate. Conjugation identifies their centralizers independently of the chosen conjugating element, since the centralizers are commutative. The generic fiber of $J_a=a^*J$ is the torus $G_{\gamma_0}$.

**Definition 1.7** (Ngô §3.3). The group ind-scheme $\mathcal P(J_a)$ parametrizes $J_a$-torsors on the disc trivialized on the punctured disc. In particular,

$$
\mathcal P(J_a)(\bar k)=J_a(\breve F)/J_a(\breve{\mathcal O}).
$$

It acts by twisting $(E,\phi)$ via $J_a\to\mathrm{Aut}(E,\phi)$. On geometric points this is $j\cdot[g]=[jg]$. For $\gamma=\mathrm{ad}(g)^{-1}\gamma_0$, the extension in Proposition 1.6 gives

$$
g^{-1}J_a(\breve{\mathcal O})g\subseteq I_\gamma(\breve{\mathcal O})
\subseteq G(\breve{\mathcal O}),
$$

so $J_a(\breve{\mathcal O})$ fixes $[g]$.

**Proposition 1.8** (Ngô 3.3.1). The Kostant point trivializes the $\mathcal P(J_a)$-torsor $\mathcal M_a^{\mathrm{reg}}$:

$$
\mathcal P(J_a)\xrightarrow{\sim}\mathcal M_a^{\mathrm{reg}},\qquad p\longmapsto p\cdot[1].
$$

*Proof.* The map $[\mathfrak g^{\mathrm{reg}}/G]\to\mathfrak c$ is a $J$-gerbe neutralized by $\epsilon$ (Ngô 2.2.1). The sheaf $\mathrm{Isom}((E_0,\gamma_0),(E,\phi))$ is therefore a $J_a$-torsor, and $\iota$ trivializes it over the punctured disc. This inverts the orbit map. ∎

**Proposition 1.9** (Kazhdan–Lusztig; Ngô 3.4.1). Over $\bar k$, any lift $\Lambda\to\mathcal P(J_a)$ of the maximal free quotient $\Lambda$ of $\pi_0(\mathcal P(J_a))$ acts freely on $(\mathcal M_a)_{\mathrm{red}}$. The quotient $(\mathcal M_a)_{\mathrm{red}}/\Lambda$ is projective.

**Proposition 1.10** (approximation; Ngô 3.5.1). For some $N$, every $a'$ over a finite extension $k'/k$ with $a'\equiv a\bmod\pi^N$ gives

$$
(\mathcal M_{a'},\mathcal P(J_{a'}))\cong
(\mathcal M_a,\mathcal P(J_a))\otimes_k k'
$$

with the action. The proof uses the cameral cover to recover $\mathrm{Lie}(I_{\gamma_0})$, which determines the integrality condition. This is a geometric version of local constancy of regular semisimple orbital integrals.

## 2. The linear case

### 2.1 The ring $B$

For $G=GL_n$ and $n<p$, let $a$ correspond to a monic polynomial $P(T)\in\breve{\mathcal O}[T]$ of degree $n$, separable over $\breve F$. Put

$$
B=\breve{\mathcal O}[T]/(P),\qquad
E=B\otimes_{\breve{\mathcal O}}\breve F=\prod_{i=1}^s E_i,\qquad
\sum_{i=1}^s [E_i:\breve F]=n.
$$

The $E_i$ are the field factors of $P$, each totally and tamely ramified. The companion basis identifies $(\breve F^n,\gamma_0,\breve{\mathcal O}^{\,n})$ with $(E,T,B)$. The curve $P(T)=0$ has one branch for each $E_i$.

### 2.2 The points of $\mathcal M_a$

**Proposition 2.1** (Ngô 3.6.1). Via Lemma 1.3 the companion basis gives

$$
\mathcal M_a(\bar k)=
\{L\subset E:\ L \text{ is a }B\text{-submodule and a full }\breve{\mathcal O}\text{-lattice}\}.
$$

Such a $B$-lattice is a rank-one torsion-free module with a generic trivialization. This is the local model of a compactified Jacobian.

**Lemma 2.2.** $\mathcal M_a^{\mathrm{reg}}(\bar k)=\{xB:x\in E^\times\}$.

*Proof.* Regularity of $T$ on $L/\pi L$ is equivalent to the existence of a cyclic vector, so

$$
L\in\mathcal M_a^{\mathrm{reg}}(\bar k)
\quad\Longleftrightarrow\quad
L/\pi L\cong\bar k[T]/(P\bmod\pi)
\quad\Longleftrightarrow\quad L\cong B.
$$

The last step is Nakayama's lemma and equality of the $\breve{\mathcal O}$-ranks. A generator of $L$ must be a unit of $E$. ∎

### 2.3 Symmetries

The companion matrix has commutant $B$, so $J_a=\mathrm{Res}_{B/\breve{\mathcal O}}\mathbb G_m$. On points, Proposition 1.8 is

$$
\mathcal P(J_a)(\bar k)=E^\times/B^\times\xrightarrow{\sim}\mathcal M_a^{\mathrm{reg}}(\bar k),\qquad x\longmapsto xB.
$$

### 2.4 Integral conjugacy classes

Let $D=\mathrm{Spec}\,\mathcal O$. An arc $a\colon D\to\mathfrak c$ can meet $\mathfrak D$ at the closed point. When it misses $\mathfrak D$, $J_a$ is a torus over $\mathcal O$ and $\mathcal M_a=\mathcal M_a^{\mathrm{reg}}\cong\mathcal P(J_a)$ is topologically discrete.

![[affine-springer-fig1-disc-arcs.svg]]

*Figure 1. (a) The closed and generic points of the formal disc. (b) Arcs in the space of quadratic polynomials.*

In (a), the center represents $\pi=0$ and the punctured disc represents $\mathrm{Spec}\,F$. In (b), the red parabola is $a_1^2=4a_2$ for $P=T^2+a_1T+a_2$. An arc entirely in the parabola fails generic regular semisimplicity. A transverse arc gives $d(a)=1$, whereas $P=T(T-\pi)$ gives $d(a)=2$.

For $\mathfrak{sl}_2$ the map and section take the form

$$
\chi=-\det,\qquad
\chi\begin{pmatrix}0&y\\z&0\end{pmatrix}=yz,\qquad
\epsilon(a)=\begin{pmatrix}0&a\\1&0\end{pmatrix},\qquad d(a)=\mathrm{val}(4a).
$$

![[affine-springer-fig2-kostant-sl2.svg]]

*Figure 2. (a) The Chevalley map and the Kostant section for $\mathfrak{sl}_2$. (b) Their restriction to the plane of off-diagonal matrices.*

In (b), $z=1$ meets every hyperbola $yz=a$. Over $a=0$, it meets the vertical axis at a regular nilpotent. When $a=\pi^2$, $\epsilon(a)$ reduces to this point while $\pi\left(\begin{smallmatrix}0&1\\1&0\end{smallmatrix}\right)$ reduces to the origin.

The map $[g]\mapsto[\mathrm{ad}(g)^{-1}\gamma_0]$ gives

$$
\mathcal M_a(\bar k)/\mathcal P(J_a)(\bar k)
\xrightarrow{\sim}
\{\gamma\in\mathfrak g(\breve{\mathcal O}):\chi(\gamma)=a\}/G(\breve{\mathcal O}).
$$

Steinberg's theorem gives $H^1(\breve F,J_a)=0$, hence surjectivity. Two cosets have conjugate images precisely when $g'hg^{-1}\in J_a(\breve F)$ for some $h\in G(\breve{\mathcal O})$.

![[affine-springer-fig3-fiber-over-a.svg]]

*Figure 3. Integral conjugacy classes over $a$ and their preimages in $\mathcal M_a$.*

On the right, the Kostant section selects the unique regular class in each vertical fiber. On the left, its preimage is the open orbit $\mathcal M_a^{\mathrm{reg}}$. For $GL_n$, the fiber on the right consists of isomorphism classes of $B$-lattices. For the node below these are $B$ and $B^\flat$. Over $k$, Frobenius descent turns this orbit picture into a weighted count (§8).

### 2.5 Normalization

Normalize $B$ in $E$ to get $B^\flat=\prod_i\mathcal O_{E_i}$. The component valuations give

$$
0\longrightarrow(B^\flat)^\times/B^\times
\longrightarrow E^\times/B^\times
\longrightarrow\mathbb Z^s\longrightarrow0.\tag{2.1}
$$

**Lemma 2.3.** $(B^\flat)^\times/B^\times$ is the group of geometric points of a connected affine algebraic group $\mathcal R_a$ of dimension $\dim_{\bar k}(B^\flat/B)$.

*Proof.* Choose $N$ so $\pi^N B^\flat$ is in the conductor. Dividing numerator and denominator by $1+\pi^N B^\flat$ reduces to the unit groups of finite-dimensional $\bar k$-algebras. Each unit group is open in the underlying affine space, so it is connected and has the dimension of that algebra. Subtracting the dimensions gives $\dim_{\bar k}(B^\flat/B)$. ∎

**Corollary 2.4** (Ngô 3.6.2–3.6.3). The group $\mathcal R_a$ is the neutral component of $\mathcal P(J_a)$, with $\pi_0(\mathcal P(J_a))\cong\mathbb Z^s$. Serre's formula for the local $\delta$-invariant is

$$
\delta_a=\dim\mathcal P(J_a)=\dim_{\bar k}(B^\flat/B)
=\frac{d(a)-c(a)}2,qquad
d(a)=\mathrm{val}(\mathrm{disc}\,P),\qquad c(a)=n-s.
$$

*Proof of the dimension formula.* The discriminant of $B$ differs from that of $B^\flat$ by the square of the index. Each tame totally ramified factor contributes $[E_i:\breve F]-1$, so

$$
d(a)=\mathrm{val}\,\mathrm{disc}(B^\flat)+2\dim_{\bar k}(B^\flat/B)
=\sum_i([E_i:\breve F]-1)+2\delta_a.
$$

∎

For local $B$, the reductions of the units give the torus $\mathbb G_m^s/\mathbb G_m\cong\mathbb G_m^{s-1}$ in $\mathcal R_a$. The remaining factor is unipotent.

### 2.6 Examples

**Example 2.5** (a node). For $P=T(T-\pi)$, evaluation at $0,\pi$ identifies $E$ with $\breve F^2$ and gives

$$
B=\{(x,y)\in\breve{\mathcal O}^2:x\equiv y\bmod\pi\},\qquad
B^\flat=\breve{\mathcal O}^2,\qquad
(d,c,\delta)=(2,0,1).
$$

The symmetry group has component lattice $\mathbb Z^2$ and $\mathcal R_a\cong\mathbb G_m$ via $(x,y)\mapsto\bar x/\bar y$.

For a $B$-lattice $L$, its saturation $B^\flat L$ is some $L_{m,n}=\pi^m\breve{\mathcal O}\oplus\pi^n\breve{\mathcal O}$. Since $\pi B^\flat\subset B$, we have $\pi L_{m,n}\subseteq L\subseteq L_{m,n}$. The image of $L$ modulo $\pi L_{m,n}$ projects onto both coordinate lines. The full plane gives $L_{m,n}$, where $T=(0,\pi)$ acts by zero modulo $\pi$. A line with both projections nonzero gives the free lattice $(\pi^m,c\pi^n)B$. Allowing every line in the plane gives the component

$$
C_{m,n}=\big\{\pi L_{m,n}+\breve{\mathcal O}(\pi^m,c\pi^n):c\in\mathbb P^1\big\},\qquad
c=0\longmapsto L_{m,n+1},\qquad c=\infty\longmapsto L_{m+1,n}.
$$

At $c=\infty$ the line is generated by the second basis vector. The intersection $C_{m,n}\cap C_{m+1,n-1}$ is the point $L_{m+1,n}$.

![[affine-springer-fig4-node-chains.svg]]

*Figure 4. (a) Projective lines at two values of $\mathrm{val}\det=m+n+1$. (b) The quotient by $\Lambda=\mathbb Z^2$.*

Each blue open line is a $\mathbb G_m$-orbit. Its endpoints are the two red non-regular lattices. Multiplication by $(\pi,\pi^{-1})$ moves along a chain and $(\pi,1)$ moves between chains. In the quotient one line remains and its two endpoints are identified. Example 8.2 counts these two orbits over $k$.

**Example 2.6** (a smooth point and a cusp). Put $u=\sqrt\pi$, so $E=\breve F(u)$ and $B^\flat=\breve{\mathcal O}[u]$ in both cases:

$$
\begin{aligned}
P=T^2-\pi&\colon & B&=B^\flat, & \delta_a&=(1-1)/2=0,\\
P=T^2-\pi^3&\colon & B&=\breve{\mathcal O}+\pi B^\flat, & \delta_a&=(3-1)/2=1.
\end{aligned}
$$

In the smooth case all lattices are $u^mB^\flat$, so the reduced fiber is discrete. In the cusp case, the map $u_0+u_1u\mapsto\overline{u_1/u_0}$ identifies $(B^\flat)^\times/B^\times$ with $\mathbb G_a$. Fixing $M=u^mB^\flat$, the projective line of lattices between $\pi M$ and $M$ of colength one has regular points $u^m(1+cu)B$, $c\in\bar k$. The remaining point gives $u^{m+1}B^\flat$. Indeed, these regular points are exactly the residue lines generating $M$ over $B^\flat$, and the full residue plane gives a lattice $M$ that occurs as an endpoint of the preceding component. Thus the reduced fiber is a disjoint union of projective lines indexed by $m\in\mathbb Z$.

## 3. Dimension

**Proposition 3.1** (Kazhdan–Lusztig; Ngô 3.7.1).

$$
\dim\big(\mathcal M_a\smallsetminus\mathcal M_a^{\mathrm{reg}}\big)
<\dim\mathcal M_a=\dim\mathcal M_a^{\mathrm{reg}}.
$$

*Sketch of proof.* For an Iwahori subgroup $\mathrm{Iw}\subset G(\breve{\mathcal O})$, the affine flag Springer fiber $\mathcal B_a$ is equidimensional by Kazhdan–Lusztig. In the map

$$
\mathcal B_a=
\{[g]\in G(\breve F)/\mathrm{Iw}:\mathrm{ad}(g)^{-1}\gamma_0\in\mathrm{Lie}(\mathrm{Iw})\}
\longrightarrow\mathcal M_a,
$$

the fibers are classical Springer fibers of the reductions of $\mathrm{ad}(g)^{-1}\gamma_0$. They are finite over $\mathcal M_a^{\mathrm{reg}}$ and positive-dimensional over the boundary. ∎

**Corollary 3.2** (Ngô 3.7.2). If $\dim\mathcal M_a=0$, then $\mathcal M_a=\mathcal M_a^{\mathrm{reg}}$.

The discriminant gives the contact order $d(a)$. Pulling back $\mathfrak t^{\mathrm{rs}}\to\mathfrak c^{\mathrm{rs}}$ to $\mathrm{Spec}\,\breve F$ gives a $W$-torsor with inertia action $\pi_a\colon I\to W$. Its image is tame and cyclic since $p\nmid|W|$. For a lift $\widetilde a\in\mathfrak t(\breve F^{\mathrm{sep}})$ of the generic point,

$$
d(a)=\deg(a^*\mathfrak D)=\sum_{\alpha\in\Phi}\mathrm{val}\big(d\alpha(\widetilde a)\big),
\qquad c(a)=\dim\mathfrak t-\dim\mathfrak t^{\pi_a(I)}.
$$

**Theorem 3.3** (Bezrukavnikov; Ngô 3.7.5).

$$
\delta_a:=\dim\mathcal P(J_a)=\dim\mathcal M_a^{\mathrm{reg}}=\frac{d(a)-c(a)}2.
$$

For $GL_n$, inertia permutes the roots with $s$ orbits, giving $c(a)=n-s$. If the torus $J_{a,\breve F}$ is unramified, then $c(a)=0$ and $\delta_a=\sum_{\alpha>0}\mathrm{val}(d\alpha(\widetilde a))$.

## 4. The Néron model

The normalization $B^\flat$ in §2 is the linear case of a construction for any $J_a$.

**Definition 4.1.** The finite-type Néron model $J_a^\flat$ is the smooth finite-type group scheme over $\breve{\mathcal O}$ extending $J_{a,\breve F}$ such that every other smooth finite-type group model maps uniquely to it, inducing the identity on the generic fiber. Its integral points form the maximal bounded subgroup:

$$
J_a(\breve{\mathcal O})\subseteq J_a^\flat(\breve{\mathcal O})\subseteq J_a(\breve F).
$$

For $GL_n$, $J_a^\flat=\mathrm{Res}_{B^\flat/\breve{\mathcal O}}\mathbb G_m$.

Let $\breve D=\mathrm{Spec}\,\breve{\mathcal O}$. The cameral cover $\widetilde X_a=\breve D\times_{a,\mathfrak c}\mathfrak t$ is finite flat, generically étale, and carries a $W$-action. Let $\widetilde X_a^\flat$ be its normalization.

**Proposition 4.2** (Ngô 3.8.2). With diagonal $W$-action,

$$
J_a^\flat=\left(\mathrm{Res}_{\widetilde X_a^\flat/\breve D}(T\times_k\widetilde X_a^\flat)\right)^W.
$$

This is the description of the generic torus by cameral descent applied to the normalized cover.

**Lemma 4.3** (Ngô 3.8.1). There is an exact sequence

$$
1\longrightarrow\mathcal R_a\longrightarrow\mathcal P(J_a)
\longrightarrow\mathcal P(J_a^\flat)\longrightarrow1,
\qquad
\mathcal R_a(\bar k)=J_a^\flat(\breve{\mathcal O})/J_a(\breve{\mathcal O}).
$$

Here $\mathcal R_a$ is an affine algebraic group of finite type and $\mathcal P(J_a^\flat)$ is topologically a free abelian group of finite rank.

*Proof.* The right-hand term on geometric points is the generic torus modulo its maximal bounded subgroup. For large $N$, the kernel of reduction of $J_a^\flat(\breve{\mathcal O})$ modulo $\pi^N$ lies in $J_a(\breve{\mathcal O})$. The quotient defining $\mathcal R_a$ thus comes from a finite jet group. ∎

**Corollary 4.4** (Ngô 3.8.3). Write $\widetilde X_a=\mathrm{Spec}\,\widetilde{\mathcal O}$ and $\widetilde X_a^\flat=\mathrm{Spec}\,\widetilde{\mathcal O}^\flat$. Then

$$
\delta_a=\dim\mathcal R_a=
\dim_{\bar k}\left(\mathfrak t\otimes_k(\widetilde{\mathcal O}^\flat/\widetilde{\mathcal O})\right)^W.
$$

The other invariant is $c(a)=\mathrm{rk}\,T-\mathrm{rk}_{\mathrm{tor}}(J_a^\flat\times_{\breve D}\mathrm{Spec}\,\bar k)$. For the node of Example 2.5 the special fiber is $\mathbb G_m^2$. For Example 2.6 it is $(\bar k[u]/u^2)^\times\cong\mathbb G_m\times\mathbb G_a$.

## 5. Connected components

Let $J_a^0$ be the model with neutral fibers. Smoothness identifies $J_a(\breve{\mathcal O})/J_a^0(\breve{\mathcal O})$ with the group of geometric components $\pi_0(J_{a,v})$ of the special fiber. We have

$$
1\longrightarrow\pi_0(J_{a,v})\longrightarrow\mathcal P(J_a^0)
\longrightarrow\mathcal P(J_a)\longrightarrow1.
$$

For instance, for $SL_2$ the norm-one equation is $u^2-av^2=1$. If $\pi\mid a$, the special fiber is $\mu_2\times\mathbb G_a$.

Write $\Lambda^*=\mathrm{Spec}\,\overline{\mathbb Q}_\ell[\Lambda]$ for the diagonalizable group with character group $\Lambda$. Let $W_a=\pi_a(I)$ and $\widehat H_\kappa=Z_{\widehat G}(\kappa)^0$ for $\kappa\in\widehat T$.

**Theorem 5.1** (Ngô 3.9.2).

$$
\begin{aligned}
\pi_0(\mathcal P(J_a^0))&\cong X_*(T)_{W_a},
& \pi_0(\mathcal P(J_a^0))^*&\cong\widehat T^{W_a},\\
\pi_0(\mathcal P(J_a))^*&\cong
\{\kappa\in\widehat T^{W_a}:W_a\subseteq W(\widehat H_\kappa,\widehat T)\}.
\end{aligned}
$$

The first identity uses $\pi_0(\mathcal P(J_a^0))=J_a(\breve F)/J_a^{\flat,0}(\breve{\mathcal O})$ and Kottwitz's torus formula. For the second, Ngô embeds $G$ in a group with connected center and takes the image on inertia coinvariants. Since $\pi_0(Z_G)\to\pi_0(J_{a,v})$ is surjective (Ngô 2.3.2), the exact sequence also gives

$$
\pi_0(\mathcal P(J_a))=X_*(T)_{W_a}/\mathrm{im}(\pi_0(Z_G)).
$$

For $GL_n$, $X_*(T)_{W_a}=\mathbb Z^s$ and $J_a$ has connected fibers. For $a=\pi$ in $SL_2$ and $PGL_2$, $W_a=W$ acts by inversion, giving $X_*(T)_W=\mathbb Z/2$. On the $SL_2$ side the class of the nontrivial element of $\mu_2$ kills this quotient, and the sole volume-zero stable lattice is $\mathcal O_E$. On the $PGL_2$ side the two components are represented by the homothety classes of $\mathcal O_E$ and $\sqrt\pi\,\mathcal O_E$.

Dually, the element of order two in $\widehat T^W$ is central in the dual of $PGL_2$, whereas its centralizer in the dual of $SL_2$ has neutral component $\widehat T$ with trivial Weyl group. Thus the monodromy condition in Theorem 5.1 selects the endoscopic characters that can enter the orbital integral (§8 and [[Endoscopy]]).

## 6. Density of the regular orbit

**Proposition 6.1** (Ngô 3.10.1). $\mathcal M_a^{\mathrm{reg}}$ is dense in $\mathcal M_a$. Ngô deduces this from the global density result for Hitchin fibers.

**Corollary 6.2** (Ngô 3.10.2). The irreducible components are the closures of the connected components of $\mathcal M_a^{\mathrm{reg}}$. Together with Proposition 1.8 this gives

$$
\mathrm{Irr}(\mathcal M_a)\cong\pi_0(\mathcal P(J_a)),\qquad
H_{2\delta_a}^{\mathrm{BM}}(\mathcal M_a,\overline{\mathbb Q}_\ell)(-\delta_a)
\cong\overline{\mathbb Q}_\ell[\pi_0(\mathcal P(J_a))].
$$

The local Picard group acts by translation on these component classes. For $GL_n$, every $B$-lattice is a limit of free lattices, as in the planar compactified Jacobian. At the node each component is a line $C_{m,n}$.

## 7. Comparison with an endoscopic group

Let $H$ be endoscopic for $G$, with $\nu\colon\mathfrak c_H\to\mathfrak c$, and let $a=\nu(a_H)\in\mathfrak c^\heartsuit(\breve{\mathcal O})$. Ngô 2.5.1 gives $J_a\to J_{H,a_H}$, an isomorphism on the generic fiber. Thus

$$
1\longrightarrow\mathcal R_H^G(a_H)\longrightarrow\mathcal P(J_a)
\longrightarrow\mathcal P(J_{H,a_H})\longrightarrow1,
\qquad
\mathcal R_H^G(a_H)(\bar k)=J_{H,a_H}(\breve{\mathcal O})/J_a(\breve{\mathcal O}).
$$

The resultant divisor $\mathfrak R_H^G$ satisfies $\nu^*\mathfrak D_G=\mathfrak D_H+2\mathfrak R_H^G$ (Ngô 1.10.3). Its pullback to $\mathfrak t$ is defined by one root differential from each pair $\pm\alpha$ in $\Phi_G\smallsetminus\Phi_H$.

**Lemma 7.1** (Ngô 3.11.2). $\dim\mathcal R_H^G(a_H)=r_H^G(a_H):=\deg(a_H^*\mathfrak R_H^G)$.

*Proof.* The generic torus is the same, hence $c(a)=c(a_H)$. Theorem 3.3 gives

$$
\dim\mathcal R_H^G(a_H)=\delta_a-\delta_{a_H}
=\tfrac12\big(d(a)-d(a_H)\big)=\deg(a_H^*\mathfrak R_H^G).
$$

The display in the arXiv proof drops the factor $\tfrac12$. ∎

The lemma gives the exponent of the transfer factor in

$$
\mathbf O_a^\kappa(1_{\mathfrak g(\mathcal O)})=
q^{r_H^G(a_H)}\mathbf{SO}_{a_H}(1_{\mathfrak h(\mathcal O)}).
$$

The closure of the graph of the map on Picard groups gives a correspondence of affine Springer fibers. Ngô proves the transfer identity by passing to Hitchin fibers.

For the Levi $H=GL_{n_1}\times GL_{n_2}$, write $P=P_1P_2$ and $B_i=\breve{\mathcal O}[T]/(P_i)$. Then

$$
\mathcal R_H^G(a_H)(\bar k)=(B_1\times B_2)^\times/B^\times,
\qquad
r_H^G(a_H)=\dim_{\bar k}((B_1\times B_2)/B)=\mathrm{val}\,\mathrm{Res}(P_1,P_2).
$$

For $P_1=T$ and $P_2=T-\pi$, the resultant has valuation one and the kernel is $\mathbb G_m$.

## 8. Outlook: counting points

Work over $k$ and write $P_a=\mathcal P(J_a)$ and $\sigma$ for Frobenius. An object $x=(m,p)$ of $[\mathcal M_a/P_a](k)$ satisfies $p\sigma(m)=m$. Its class $\mathrm{cl}(x)$ in $H^1(k,P_a)$ is represented by $p$. The weighted mass is

$$
\#[\mathcal M_a/P_a](k)_\kappa
=\sum_{[x]}\frac{\langle\mathrm{cl}(x),\kappa\rangle}{\#\mathrm{Aut}(x)}.
$$

For a model $J'_a\to J_a$ inducing an isomorphism on the generic fiber and having connected fibers, Steinberg and Lang identify $H^1(F,J_a)$ with $H^1(k,\mathcal P(J'_a))$. Taking $J'_a=J_a^0$ gives the map

$$
H^1(F,J_a)\cong H^1(k,\mathcal P(J_a^0))\longrightarrow H^1(k,P_a).
$$

**Proposition 8.1** (Ngô 8.2.5, 8.2.7). If $\kappa$ is a character of $H^1(k,P_a)$, pull it back to $H^1(F,J_a)$. For any Haar measure $dt$ on $J_a(F)$,

$$
\#[\mathcal M_a/P_a](k)_\kappa
=\mathrm{vol}(J_a^0(\mathcal O),dt)\,\mathbf O^\kappa_a(1_{\mathfrak g(\mathcal O)},dt).
$$

A character of $H^1(F,J_a)$ that does not descend to $H^1(k,P_a)$ has zero orbital integral. The proof groups the integral structures by the rational conjugacy class in the stable class, then weights them by stabilizer volumes.

For a suitable Frobenius-stable lattice $\Lambda\subset\mathcal P(J_a^0)$, the cohomological version is (Ngô 8.2.10)

$$
\sum_i(-1)^i\mathrm{Tr}\big(\sigma,H^i(\mathcal M_a/\Lambda)_\kappa\big)
=\mathrm{vol}(J_a^{\flat,0}(\mathcal O),dt)\,\mathbf O_a^\kappa(1_{\mathfrak g(\mathcal O)},dt).
$$

**Example 8.2** (the fundamental lemma for the node). Return to $P=T(T-\pi)$ over $k$. Here $J_{a,F}=T_F$ is split, $H^1(F,J_a)=0$, and $H=T=GL_1\times GL_1$. The two $T(F)$-orbits are represented by the normalization lattice and the free $B$-lattice. Their stabilizers are $T(\mathcal O)$ and $B^\times$, with $B$ now defined over $\mathcal O$. Reduction of the ratio of units gives $[T(\mathcal O):B^\times]=q-1$. Normalize $\mathrm{vol}(T(\mathcal O))=1$. Then

$$
\mathbf O_{\gamma_0}(1_{\mathfrak{gl}_2(\mathcal O)})
=1+(q-1)=q=q^1\,\mathbf{SO}_{a_H}(1_{\mathfrak t(\mathcal O)}).
$$

The stable torus integral is $1$ and the resultant has valuation one. Equivalently, the regular orbit has trivial stabilizer in $P_a$ and the boundary stabilizer is $\mathbb G_m$, so the quotient mass is $1+(q-1)^{-1}=q/(q-1)$. For $GL_n$ the general identity reduces to parabolic descent, with the same resultant factor.

Ngô §8.3 treats $d(a)=2$, $c(a)=0$ for any $G$. A single pair of roots $\pm\alpha$ has positive valuation. Over $\bar k$, the orbit of $\pi^\lambda U_\alpha(x\pi^{-1})$ for $x\ne0$ closes to a line with endpoints $\pi^\lambda$ and $\pi^{\lambda-\alpha^\vee}$. For $A=T/\ker\alpha$ and a Frobenius-invariant finite-order $\kappa$ with $\kappa(\alpha^\vee)\ne1$, Ngô 8.3.8 gives

$$
\#[\mathcal M_a/P_a](k)_\kappa=\frac{q}{\#A(k)}.
$$

On the Hitchin base, these local calculations supply identities on a dense open set. Approximation and the product formula connect local and global fibers. The $\delta$-invariant bounds the strata in the support argument, and the component group determines which endoscopic characters occur. The global geometry is the subject of [[The Hitchin fibration]].

## References

- B. C. Ngô, *Le lemme fondamental pour les algèbres de Lie*, Publ. Math. IHÉS 111 (2010), 1–169. [arXiv:0801.0446](https://arxiv.org/abs/0801.0446)
- D. Kazhdan, G. Lusztig, *Fixed point varieties on affine flag manifolds*, Israel J. Math. 62 (1988), 129–168.
- R. Bezrukavnikov, *The dimension of the fixed point set on affine flag manifolds*, Math. Res. Lett. 3 (1996), 185–189.
- M. Goresky, R. Kottwitz, R. MacPherson, *Homology of affine Springer fibers in the unramified case*, Duke Math. J. 121 (2004), 509–561.
- G. Laumon, *Fibres de Springer et jacobiennes compactifiées*, in *Algebraic Geometry and Number Theory*, Progr. Math. 253, Birkhäuser (2006), 515–563.
- J.-P. Serre, *Corps locaux*, chap. III.

Related: [[Endoscopy]] · next talk: [[The Hitchin fibration]]
