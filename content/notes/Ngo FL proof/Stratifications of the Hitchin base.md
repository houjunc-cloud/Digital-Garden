---
title: Stratifications of the Hitchin base
description: "Lecture notes for the talk on stratifications of the Hitchin base in the Ngô fundamental lemma seminar (2026-11-13), combining the boards with the paper."
tags:
  - fundamental-lemma
  - hitchin-fibration
  - seminar-notes
stage: 🌱 seedling
date: 2026-11-13
---

# Stratifications of the Hitchin base

*Notes on the Ngô fundamental lemma seminar, 13 November 2026. Reference: B. C. Ngô, Le lemme fondamental pour les algèbres de Lie, Publ. Math. IHÉS 111 (2010), §§4.8–4.10 and ch. 5; numbering as in [arXiv:0801.0446](https://arxiv.org/abs/0801.0446). We continue [[The Hitchin fibration]].*

**The normalization map measures the affine defect. Monodromy on the normalization determines the Picard component group.** The boards start with the Néron model and monodromy, then stratify the marked base and return to dimensions and gluing. Ngô supplies the precise stratification and specialization statements.

## 1. The affine part of the Picard stack

Let $G$ be quasi-split over the curve $X/k$ of genus $g$, with split root system $\Phi$ and Weyl group $W$. Assume $k$ is finite, $\operatorname{char}k\nmid |W|$, and the twisting line bundle $D$ has degree $>2g$ and a square root $D'$. For a geometric point $a\in\mathcal A^\heartsuit$, set $U_a=a^{-1}(\mathfrak c_D^{\mathrm{rs}})$ and normalize the cameral curve by $\widetilde X_a^\flat\to\widetilde X_a$.

**Proposition 1.1** (Néron model; Ngô 4.8.1–4.8.2, 4.10.1). Let $J_a^0$ be the fiberwise identity component of $J_a$ and $J_a^\flat$ its finite-type Néron model. All three models agree over $U_a$. Their stacks of torsors on $\bar X$ fit into
$$
\begin{aligned}
J_a^0 &\longrightarrow J_a \longrightarrow J_a^\flat,
& \mathcal P'_a &\twoheadrightarrow\mathcal P_a
\twoheadrightarrow\mathcal P_a^\flat,\\
J_a^\flat|_{\bar X_v} &=(J_{a,v})^\flat\quad(v\notin U_a),
& R_a&=\ker(\mathcal P_a\to\mathcal P_a^\flat)=\prod_{v\notin U_a}R_v(a).
\end{aligned}
$$
Here $\bar X_v$ is the completed disc, $\mathcal P'_a\to\mathcal P_a$ has finite kernel, and $(\mathcal P_a^\flat)^0$ is an abelian stack. For split $G$, $J_a^\flat$ is the $W$-fixed part of the Weil restriction of $T$ along $\pi_a^\flat:\widetilde X_a^\flat\to\bar X$. For quasi-split $G$, use the diagonal action after an étale splitting cover.

A point of $R_a$ is a $J_a$-torsor with a trivialization of its induced $J_a^\flat$-torsor. The quotient sheaf $J_a^\flat/J_a$ is supported on $\bar X-U_a$. Each local factor is $R_v(a)=\ker[\mathcal P(J_{a,v})\to\mathcal P((J_{a,v})^\flat)]$.

**Proposition 1.2** (Defect; Ngô 4.9.1–4.9.3). Let $d_v=\operatorname{ord}_v(a^*\mathfrak D_{G,D})$ and let $c_v$ be the drop in torus rank of $J_a^\flat$ at $v$. Then
$$
\begin{aligned}
\delta_a&=\dim R_a=\sum_{v\notin U_a}\delta_v(a),\\
2\delta_a&=\sum_{v\notin U_a}(d_v-c_v)=|\Phi|\deg D-\sum_{v\notin U_a}c_v.
\end{aligned}
$$
The local terms are the defects from [[Affine Springer fibers and their symmetries]]. Equivalently, with $\pi_a:\widetilde X_a\to\bar X$,
$$
\delta_a=h^0\!\left(\bar X,\left[\mathfrak t\otimes
  \bigl((\pi_a^\flat)_*\mathcal O_{\widetilde X_a^\flat}/
         (\pi_a)_*\mathcal O_{\widetilde X_a}\bigr)\right]^W\right).
$$
Here $\mathfrak t$ and the action of $W$ are understood with the quasi-split descent on $\bar X$.

![[hitchin-base-stratifications-fig1-normalization.svg]]

*Figure 1. Normalization and local Picard defects.*

For an irreducible nodal spectral curve of $GL_n$, a line bundle on the normalization descends once we identify its two fibers above each node. Each identification gives one gluing parameter in $\mathbb G_m$. This is the simplest model for the local factors of $R_a$.

## 2. A marking and two monodromy groups

For $GL_n$, marking is like numbering the eigenvalues at a regular point. Loops then give permutations of a specific set of labels, so we can compare monodromy subgroups as $a$ varies.

**Definition 2.1** (Marked Hitchin base; Ngô 5.5.1–5.5.2). Fix $\infty\in X(\bar k)$ and set
$$
\begin{aligned}
\mathcal A^\infty&=\{a:a(\infty)\in\mathfrak c_D^{\mathrm{rs}}\},\\
\widetilde{\mathcal A}&=\{(a,\widetilde\infty):a\in\mathcal A^\infty,\
                  \widetilde\infty\in\widetilde X_a|_\infty\}.
\end{aligned}
$$
The forgetful map is a finite étale $W_\infty$-torsor. Evaluation at $\infty$ is surjective, so its pullback of $\mathfrak t_{D,\infty}^{\mathrm{rs}}\to\mathfrak c_{D,\infty}^{\mathrm{rs}}$ has smooth, geometrically irreducible total space.

Choose a pointed connected étale splitting torsor $\rho:\bar X_\rho\to\bar X$ with group $\Theta$. For $\widetilde a=(a,\widetilde\infty)$ let $m_{\widetilde a}:\pi_1(U_a,\infty)\to W\rtimes\Theta$ classify the pointed torsor $\widetilde X_{\rho,a}|_{U_a}$, where $\widetilde X_{\rho,a}=\widetilde X_a\times_{\bar X}\bar X_\rho$. Put
$$
\begin{aligned}
W_{\widetilde a}&=\operatorname{im}(m_{\widetilde a}),\\
I_{\widetilde a}&=m_{\widetilde a}\!\left(\ker[\pi_1(U_a,\infty)\to\pi_1(\bar X,\infty)]\right).
\end{aligned}
$$
On the normalization of $\widetilde X_{\rho,a}$, $W_{\widetilde a}$ preserves the component through the mark and $I_{\widetilde a}$ is generated by the inertia groups on it. In particular, $I_{\widetilde a}\triangleleft W_{\widetilde a}$ and $I_{\widetilde a}\subset W$.

**Proposition 2.2** (Picard component groups; Ngô 4.10.2). Write $X_*=X_*(T)$ and $\widehat T=\operatorname{Hom}(X_*,\overline{\mathbb Q}_\ell^\times)$. The superscript $(-)^*$ denotes duality between finitely generated abelian groups and diagonalizable groups. Then
$$
\begin{aligned}
\pi_0(\mathcal P'_a)&=(X_*)_{W_{\widetilde a}},\\
\pi_0(\mathcal P_a)^*&=\widehat T(I_{\widetilde a},W_{\widetilde a}),\\
\widehat T(I_0,W_0)&=\{\kappa\in\widehat T^{W_0}:I_0\subset W_{H_\kappa}\},
\qquad\widehat H_\kappa=Z_{\widehat G}(\kappa)^\circ.
\end{aligned}
$$
The coinvariants impose the monodromy relations. Passing to $\mathcal P_a$ adds the local relations from $\pi_0(J_{a,v})$, which on characters give the inertia condition.

![[hitchin-base-stratifications-fig2-monodromy.svg]]

*Figure 2. The cameral marking, monodromy and inertia.*

The mark identifies the regular centralizer at $\infty$ with $T$. The fundamental groups of the punctured and complete curve distinguish monodromy from inertia.

## 3. Simultaneous normalization

As an irreducible nodal curve smooths, its normalization has lower genus than the nearby smooth fibers. We stratify the base so that the normalizations fit into smooth families and their invariants can be followed together.

**Definition 3.1** (Ngô 5.1.1). For a proper flat family of reduced curves $y:Y\to S$, a simultaneous normalization is a proper birational map $\xi:Y^\flat\to Y$ that is an isomorphism over a fiberwise dense open, with $Y^\flat\to S$ proper and smooth. Thus $\xi$ normalizes each geometric fiber, and $y_*(\xi_*\mathcal O_{Y^\flat}/\mathcal O_Y)$ is locally free on $S$ (Ngô 5.1.2).

**Theorem 3.2** (Ngô 5.2.1, 5.2.3–5.2.5). For $a\in\mathcal A^\heartsuit(S)$, let $\mathcal B(S)$ classify triples $(a,\widetilde X_a^\flat,\xi)$ with $\xi$ a $W$-equivariant simultaneous normalization and $\widetilde X_a^\flat\to X\times S$ finite flat and generically a $W$-torsor on each fiber. This functor is represented by a finite-type scheme. The images of its reduced connected components $\mathcal B_\psi$ over $\bar k$ give
$$
\mathcal A^\heartsuit_{\bar k}=\coprod_{\psi\in\Psi}\mathcal A_\psi,\qquad
\mathcal B_\psi\longrightarrow\mathcal A_\psi
\quad\text{finite, surjective and radicial}.
$$
Any reduced connected base with a simultaneous normalization maps into one stratum. The largest stratum is $\mathcal A^\diamondsuit_{\bar k}$.

*Sketch of proof.* Uniqueness of normalization gives a bijection on geometric points. Chevalley's theorem gives constructible images. Zariski's main theorem and specialization give the locally closed strata and their finite radicial covers. The board pulls back $\mathcal B$ to $\widetilde{\mathcal A}$ and uses Noetherian induction to refine the pieces to smooth strata. Over $\mathcal A^\diamondsuit$ the cameral curves are already smooth. ∎

## 4. Defect and monodromy strata

**Proposition 4.1** (Ngô §§5.3, 5.5–5.6). Pull the normalization strata back to $\widetilde{\mathcal A}$ and take connected components $\widetilde{\mathcal A}_{\widetilde\psi}$. Both $\delta$ and $(I,W)$ are constant on each. Write $\psi'\leq\psi$ when $\mathcal A_{\psi'}\subset\overline{\mathcal A_\psi}$, and use the corresponding order upstairs. Specialization gives
$$
\delta(\psi')\geq\delta(\psi),\qquad
I_{\widetilde\psi'}\subset I_{\widetilde\psi},\qquad
W_{\widetilde\psi'}\subset W_{\widetilde\psi}.
$$
The board calls both maps order-preserving. With Ngô's closure order, $\delta$ is order-reversing. The largest stratum has $\delta=0$ and $(I,W_0)=(W,W\rtimes\Theta)$. Grouping by either invariant gives
$$
\begin{aligned}
\mathcal A_d&=\{\delta_a=d\}=\{\delta_a\ge d\}\setminus\{\delta_a\ge d+1\},\\
\widetilde{\mathcal A}_{(I_0,W_0)}
&=\coprod_{(I_{\widetilde\psi},W_{\widetilde\psi})=(I_0,W_0)}
\widetilde{\mathcal A}_{\widetilde\psi}.
\end{aligned}
$$
The $\delta\ge d$ loci are closed in $\mathcal A^\heartsuit$, and $(I,W)\leq(I_0,W_0)$ defines a closed subset of $\widetilde{\mathcal A}$. The monodromy stratification descends to $\mathcal A^\heartsuit_{\bar k}$ by taking $W$-conjugacy classes. The types with $(X_*)^{W_0}=0$ form $\widetilde{\mathcal A}^{\mathrm{ani}}$, the pullback of the locus where $\pi_0(\mathcal P_a)$ is finite.

**Proposition 4.2** (Component sheaves; Ngô 5.7.1–5.7.4). The stalk of $\pi_0(\mathcal P)$ at $a$ is $\pi_0(\mathcal P_a)$, and likewise for $\mathcal P'$. Marking gives surjections of étale sheaves on $\widetilde{\mathcal A}$
$$
X_*\times\widetilde{\mathcal A}\ \twoheadrightarrow\
\pi_0(\widetilde{\mathcal P}')\ \twoheadrightarrow\ \pi_0(\widetilde{\mathcal P}).
$$
On a small étale open $V$ of type $(I_0,W_0)$, the stratum of that type is the unique nonempty closed stratum of $V$. Ngô computes
$$
\begin{aligned}
\Gamma(V,\pi_0(\widetilde{\mathcal P}'))&=(X_*)_{W_0},\\
\Gamma(V,\pi_0(\widetilde{\mathcal P}))&=\widehat T(I_0,W_0)^*.
\end{aligned}
$$
Here $\widetilde{\mathcal P}'$ and $\widetilde{\mathcal P}$ are pullbacks to the marked base. The small opens form an étale basis. Restriction to a smaller open with a larger monodromy pair is dual to the reverse inclusion of character groups. Over $\mathcal A^\diamondsuit_{\bar k}$ the component group is constant with value $(Z(\widehat G)^\Theta)^*$ (Ngô 5.7.5).

![[hitchin-base-stratifications-fig3-etale-neighborhood.svg]]

*Figure 3. The board sketch of a marked stratum and the normalization over it.*

The smooth normalized fibers live over the finite radicial cover of the stratum. The small étale neighborhood lies in the marked base.

**Example 4.3** ($SL_2$). Write the cameral equation as $t^2=a$. A simple zero of $a$ has $(d_v,c_v)=(1,1)$ and $\delta_v=0$. For $a=s^2$ with $s\in H^0(\bar X,D)$ having simple zeros, the normalization separates the two graphs $t=\pm s$. Thus $W_{\widetilde a}=I_{\widetilde a}=1$ and $\pi_0(\mathcal P_a)\simeq\mathbb Z$. Each crossing has $(d_v,c_v)=(2,0)$, so $\delta_a=\deg D$.

## 5. Dimensions and the product formula

The boards return to the dimension calculation in [[The Hitchin fibration]]. If $e_i$ are the invariant degrees and $r=\operatorname{rk}G$, then $\sum_i e_i=r+|\Phi|/2$. After pullback to a splitting cover,
$$
\mathfrak c_D\simeq\bigoplus_i D^{\otimes e_i},\qquad
F_a:=\operatorname{Lie}J_a\simeq\bigoplus_iD^{\otimes(1-e_i)}.
$$
Rigidify $J_a$-torsors at $\infty\in U_a$. Čech cocycles over the dual numbers give tangent space $H^1(\bar X,F_a(-\infty))$. Since $H^0(\bar X,F_a(-\infty))=0$, the evaluation sequence is
$$
0\to H^0(\bar X,F_a)\to F_a|_\infty
\to H^1(\bar X,F_a(-\infty))\to H^1(\bar X,F_a)\to 0.
$$
The Picard stack is the quotient of the framed space by $J_{a,\infty}$. Since $H^1(\bar X,\mathfrak c_D)=0$ for the chosen degree, Riemann–Roch gives both dimension formulas (Ngô §4.4).
$$
\begin{aligned}
\dim\mathcal P_a&=h^1(F_a(-\infty))-r=-\chi(F_a)
=\tfrac12|\Phi|\deg D+r(g-1),\\
\dim\mathcal A&=h^0(\mathfrak c_D)=\tfrac12|\Phi|\deg D+r(1-g+\deg D).
\end{aligned}
$$
The base dimension depends only on the split root datum, $g$ and $\deg D$.

The Kostant section uses the torsor $(D')^\times\times^{\mathbb G_m,\,2\rho^\vee}G$. Glue each local Higgs pair, framed on the punctured disc by the Kostant pair, to that pair on $U_a$. Twisting by the global Picard stack gives
$$
\prod_{v\notin U_a}\mathcal M_{a,v}\ \times^{\prod_{v\notin U_a}\mathcal P_{a,v}}\ \mathcal P_a
\longrightarrow \mathcal M_a.
$$
This is an equivalence on geometric points over $\mathcal A^\heartsuit$ and a homeomorphism in the reduced formulation over $\mathcal A^{\mathrm{ani}}$ (Ngô 4.13.1). Density of $\mathcal M_a^{\mathrm{reg}}$ gives $\dim\mathcal M_a=\dim\mathcal P_a$ and identifies the irreducible components via the Kostant section. Over $\mathcal A^\heartsuit$, $f$ is flat with geometrically reduced fibers (Ngô 4.14.1–4.14.4).

## 6. Outlook

In the support theorem, $\delta_a$ supplies a dimension to compare with the codimension of a locus. The monodromy pair tells us which characters of the Picard component group can occur there. On the anisotropic open these character groups are finite, and the next talk uses them to split the Hitchin direct image. See [[Geometric stabilization]].

## References

- B. C. Ngô, *Le lemme fondamental pour les algèbres de Lie*, Publ. Math. IHÉS 111 (2010), 1–169. [arXiv:0801.0446](https://arxiv.org/abs/0801.0446)

Related: [[Endoscopy]] · previous talk: [[The Hitchin fibration]] · next talk: [[Geometric stabilization]]
