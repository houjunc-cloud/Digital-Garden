---
title: Geometric stabilization
description: "Lecture notes for the talk on geometric stabilization in the Ngô fundamental lemma seminar (2026-11-20), combining the boards with the paper."
tags:
  - fundamental-lemma
  - endoscopy
  - seminar-notes
stage: 🌱 seedling
date: 2026-11-20
---

# Geometric stabilization

*Notes on the Ngô fundamental lemma seminar, 20 November 2026. Reference: B. C. Ngô, Le lemme fondamental pour les algèbres de Lie, Publ. Math. IHÉS 111 (2010), ch. 6; numbering as in [arXiv:0801.0446](https://arxiv.org/abs/0801.0446). We use the marked base and component groups from [[Stratifications of the Hitchin base]].*

**A character of the Picard component group selects the stable cohomology of endoscopic Hitchin fibrations.** The boards pass from properness to the character decomposition, describe the endoscopic loci by monodromy, then state stabilization. Ngô supplies the shift, the Tate twist and the arithmetic formulation.

## 1. The anisotropic open

Keep the standing assumptions on $G,X,D$ and let $\ell\ne\operatorname{char}k$. Recall that $f:\mathcal M\to\mathcal A$ sends a $D$-twisted Higgs pair to its characteristic section. The Picard stack $\mathcal P$ acts on $\mathcal M$ over $\mathcal A$.

**Definition 1.1** (Anisotropic locus; Ngô 6.1.1). For $a\in\mathcal A^\heartsuit(\bar k)$, the equivalent conditions are
$$
a\in\mathcal A^{\mathrm{ani}}
\quad\Longleftrightarrow\quad \pi_0(\mathcal P_a)\text{ is finite}
\quad\Longleftrightarrow\quad (X_*)^{W_{\widetilde a}}=0.
$$
The second equivalence follows from the finite kernel of $(X_*)_{W_{\widetilde a}}\twoheadrightarrow\pi_0(\mathcal P_a)$. Monodromy can only grow under generization, so $\mathcal A^{\mathrm{ani}}$ is open. It contains $\mathcal A^\diamondsuit$ if the center of $G_{\bar X}$ has no split subtorus of positive dimension.

**Proposition 1.2** (Ngô 6.1.2–6.1.5). Over $\mathcal A^{\mathrm{ani}}$, the automorphism groups of Higgs pairs are finite and reduced. Both $\mathcal M^{\mathrm{ani}}$ and $\mathcal P^{\mathrm{ani}}$ are smooth separated Deligne–Mumford stacks of finite type over $k$, and
$$
f^{\mathrm{ani}}:\mathcal M^{\mathrm{ani}}\longrightarrow\mathcal A^{\mathrm{ani}}
\qquad\text{is proper}.
$$
The regular centralizer bounds the automorphism group by $T^{W_{\widetilde a}}$. Anisotropy rules out compatible proper parabolic reductions, so the Higgs pairs are stable and Faltings's valuative criterion applies. The board marks $f^\heartsuit$ as smooth. Ngô proves smoothness of its source and flatness of $f^\heartsuit$ (4.12.1, 4.14.4).

![[../attachments/geometric-stabilization-fig1-anisotropic-locus.svg]]

*Figure 1. Picard actions on the nested opens and the marked anisotropic base.*

Restriction to the anisotropic open gives a proper map. Pullback to the marked base gives a fixed lattice acting through a sheaf of finite groups.

## 2. The character decomposition

Write $\Lambda=\overline{\mathbb Q}_\ell$. Properness and smoothness of the source give purity. Geometrically, the decomposition theorem gives
$$
Rf^{\mathrm{ani}}_*\Lambda\simeq
\bigoplus_n{}^pH^n(Rf^{\mathrm{ani}}_*\Lambda)[-n],
\qquad {}^pH^n(Rf^{\mathrm{ani}}_*\Lambda)\text{ pure of weight }n.
$$
Proper base change and the trace formula recover the weighted count at a rational point $a$:
$$
\begin{aligned}
\#\mathcal M_a(k)
&=\operatorname{Tr}(\operatorname{Frob}_a,(Rf^{\mathrm{ani}}_*\Lambda)_{\bar a})\\
&=\sum_i(-1)^i\operatorname{Tr}(\operatorname{Frob}_a,H^i(\mathcal M_{\bar a},\Lambda)).
\end{aligned}
$$

Pull back to $\widetilde{\mathcal A}^{\mathrm{ani}}=\widetilde{\mathcal A}\times_{\mathcal A}\mathcal A^{\mathrm{ani}}$. By the homotopy lemma, the Picard action on perverse cohomology factors through $\pi_0(\widetilde{\mathcal P}^{\mathrm{ani}})$. The marking gives a surjection from $X_*$ to this sheaf, so each $\kappa\in\widehat T$ specifies an eigensummand.

**Proposition 2.1** (Ngô 6.2.3–6.2.6). Put $K_G^n={}^pH^n(R\widetilde f^{\mathrm{ani}}_*\Lambda)$. Then
$$
\begin{aligned}
K_G^n&=\bigoplus_{\kappa\in\kappa^{\mathrm{ani}}}K_{G,\kappa}^n,
\qquad |\kappa^{\mathrm{ani}}|<\infty,\\
\widetilde{\mathcal A}_\kappa
&=\coprod_{\kappa\in\widehat T(I_0,W_0)}\widetilde{\mathcal A}_{(I_0,W_0)},\\
\operatorname{Supp}K_{G,\kappa}^n
&\subseteq\widetilde{\mathcal A}_\kappa\cap\widetilde{\mathcal A}^{\mathrm{ani}}.
\end{aligned}
$$
Here $\kappa^{\mathrm{ani}}$ is the union of the finite character groups of the anisotropic strata. The locus $\widetilde{\mathcal A}_\kappa$ is closed because the character condition is preserved by specialization. Away from it, the component group action cannot have the character $\kappa$.

## 3. The endoscopic loci

**Definition 3.1** (Pointed endoscopic datum; Ngô 1.8.1–1.8.2). Let $\widehat H=Z_{\widehat G}(\kappa)^\circ$ and $C_\kappa=\pi_0((\widehat G\rtimes\operatorname{Out}(G))_\kappa)$. With the chosen point in the outer-twisting torsor, a datum $\xi=(\kappa,\rho_\kappa^\bullet)$ is a lift
$$
\pi_1(\bar X,\infty)\xrightarrow{\rho_\kappa^\bullet} C_\kappa
\longrightarrow\operatorname{Out}(G)
$$
of the geometric outer monodromy. The projection to $\operatorname{Out}(H)$ twists the split group dual to $\widehat H$. The board uses the component group inside $\widehat G$ in its shorthand. For a quasi-split twist the lift uses the extended centralizer above.

Let $X_{\rho_\kappa}\to\bar X$ be the pointed $C_\kappa$-torsor. Over this common torsor, let $Y=X_{\rho_\kappa}\times_{\bar X}\mathfrak t_D$ with the Cartan split on the torsor. Ngô 1.9.1 gives compatible actions and the maps
$$
\begin{aligned}
W_H\rtimes C_\kappa &\hookrightarrow W\rtimes C_\kappa,\\
Y/(W_H\rtimes C_\kappa)&\xrightarrow{\nu}\;Y/(W\rtimes C_\kappa),\\
\mathfrak c_{H,D}&\xrightarrow{\nu}\;\mathfrak c_D,\qquad
\mathcal A_H\xrightarrow{\nu}\;\mathcal A.
\end{aligned}
$$
The common torsor allows the marked cameral cover for $H$ to map to the one for $G$. In $\widetilde{\mathcal A}_H$ we require that the image of $a_H(\infty)$ be $G$-regular semisimple.

![[../attachments/geometric-stabilization-fig2-endoscopic-reduction.svg]]

*Figure 2. The board diagrams for the quotient map and transfer of the cameral marking.*

The upper map uses a smaller Weyl group on the same twisted Cartan. Taking sections and transferring the mark gives $\widetilde\nu_\xi:\widetilde{\mathcal A}_H\to\widetilde{\mathcal A}$.

**Proposition 3.2** (Ngô 6.3.4–6.3.7). Each $\widetilde\nu_\xi$ is a closed immersion, and over $\bar k$
$$
\widetilde{\mathcal A}_\kappa
=\coprod_{\xi=(\kappa,\rho_\kappa^\bullet)}
\widetilde\nu_\xi(\widetilde{\mathcal A}_{H_\xi}).
$$

*Sketch of proof.* For fixed $\xi$, a lift exists precisely when the pointed monodromy of the cameral torsor over $U_a$ after the common twist lands in $W_H\rtimes C_\kappa$. In the quotient by this subgroup, the component through the mark then has degree one over $U_a$. Its section extends over $\bar X$ by finiteness and normality. The mark gives uniqueness. The map is already finite and unramified, which gives the closed immersion.

Conversely, choose a common finite quotient $\Theta$ through which all the lifts of the outer monodromy for this $\kappa$ factor. If $\widetilde a\in\widetilde{\mathcal A}_\kappa$, its monodromy fixes $\kappa$ and its inertia lies in $W_H$. The unique datum giving the lift is recovered from
$$
\pi_1(\bar X,\infty)\longrightarrow W_{\widetilde a}/I_{\widetilde a}
\longrightarrow (W\rtimes\operatorname{Out}(G))_\kappa/W_H
\simeq C_\kappa .
$$
For the datum so obtained, $W_{\widetilde a}$ lands in the preimage of its graph under the quotient by $W_H$, hence satisfies the lift criterion. The recovered datum is unique, so the images are disjoint. ∎

**Example 3.3** ($SL_2$). Take $\kappa=-1\in\widehat T$ for $\widehat G=PGL_2$. The Weyl involution fixes $\kappa$, and $\widehat H$ is a torus, so $W_H=1$. A nontrivial unramified double cover given by $L^{\otimes2}\simeq\mathcal O_{\bar X}$ gives an anisotropic norm-one torus $H$. For $s\in H^0(\bar X,D\otimes L)$ with simple zeros, the endoscopic image is $a=s^2$. Its cameral normalization is the double cover, with $W_{\widetilde a}=\mathbb Z/2$ and $I_{\widetilde a}=1$. The local crossings give $\delta_a=\deg D$, and both characters of $\mathbb Z/2$ occur in the component group dual. The corresponding endoscopic image has codimension $\deg D$.

## 4. Geometric stabilization

For a datum defined over $k$ with compatible rational markings, write $i_\xi=\widetilde\nu_\xi$ on the anisotropic open. On the marked domain, the $H$-anisotropic open is the inverse image of $\widetilde{\mathcal A}^{\mathrm{ani}}$, since $J_{H,a_H}$ and $J_a$ have the same generic torus. Set $K_{H,\mathrm{st}}^n={}^pH^n(R\widetilde f_{H,*}^{\mathrm{ani}}\Lambda)_1$, the summand fixed by the Picard component group for $H$.

**Theorem 4.1** (Ngô 6.4.3). The codimension of the endoscopic base is
$$
r_\xi=r_H^G(D)=\tfrac12\bigl(|\Phi|-|\Phi_H|\bigr)\deg D.
$$
After semisimplification over $k$, geometric stabilization identifies graded perverse sheaves on that base:
$$
\left(i_\xi^* K_{G,\kappa}^{n+2r_\xi}(r_\xi)\right)^{\mathrm{ss}}
\simeq (K_{H,\mathrm{st}}^n)^{\mathrm{ss}}.
$$
The shift lowers the $G$ grading by $2r_\xi$ and the Tate twist lowers the weight by $2r_\xi$. This is the shift $[2r_\xi](r_\xi)$ on the $G$ side of 6.4.3. Over $\bar k$ the perverse sheaves are already semisimple, and pushing forward gives the formula drawn on the board:
$$
K_{G,\kappa}^n\simeq
\bigoplus_{\xi=(\kappa,\rho_\kappa^\bullet)}
i_{\xi,*}K_{H_\xi,\mathrm{st}}^{n-2r_\xi}(-r_\xi).
$$
The board leaves the shift brackets unfinished. In the opening display of arXiv §8.5, the $H$ index $n+2r_\xi$ should read $n-2r_\xi$ with the twist $(-r_\xi)$, as required by the weight $n$ and the shift in 6.4.3.

## 5. Outlook

The support theorem controls the extension from a dense open of each endoscopic base. The product formula expresses the Frobenius trace on a Hitchin fiber as a product of local weighted counts. Comparing those traces yields the local orbital-integral comparison of [[Endoscopy]], and the local fundamental lemma then gives stabilization on the full anisotropic open (Ngô §§8.4–8.7).

## References

- B. C. Ngô, *Le lemme fondamental pour les algèbres de Lie*, Publ. Math. IHÉS 111 (2010), 1–169. [arXiv:0801.0446](https://arxiv.org/abs/0801.0446) · [Published version](https://www.numdam.org/item/10.1007/s10240-010-0026-7.pdf)

Related: [[Endoscopy]] · previous talk: [[Stratifications of the Hitchin base]]
