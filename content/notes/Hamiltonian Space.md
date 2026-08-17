
-(reduction and induction) Hamiltonian reduction and induction are adjoint to each other. There is a shifting trick: $M ///_{\mathcal O_f} G = (M \times \mathcal O_f^-)///_{0}G$. Don't mix Hamiltonian reduction with Whittaker reduction, the former is mod G and the latter is mod N

-(stratification) For a reductive group $G$ and Hamiltonian space $M$, let $\mu: M \to \mathfrak g ^*$ be the moment map. Identify $\mathfrak g^* \isom \mathfrak g$ by the bilinear form, $\mathfrak g$ has a finite stratification: $L$ is a Levi, $\mathcal O \subset L$ is a nilpotent $L$ - orbit. This is the standard parametrization of Jordan decompositions/classes, hence $\mathfrak g = \coprod_{[L,\mathcal O]} D_G(L,\mathcal O)$ where $D_G(L,\mathcal O) = G(\mathfrak {z(l)}^{reg} + \mathcal O) \isom G \times ^{N_G(L,e)}$ with $\mathfrak {z(l)}^{reg} = \{z \in \mathfrak {z(l)}: Z_G(z)^0 = L\}$, correspondingly $M = \coprod_{[L,\mathcal O]} \mu^{-1}(D_G(L,\mathcal O)) \isom \coprod_{[L,\mathcal O]} G \times ^{N_G(L,e)} Z_{L,e}(M)$ where $e$ is a representative of $\mathcal O$ and $N_G(L,e) = N_G(L) \cap Z_G(e)$ which differs from $Z_L(e)$ by a finite group. On the other hand, let $M_1 = M//_{Wh} G \isom \mu^{-1} (S)$ where $S \isom  \mathfrak c_G := \mathfrak g // G$ is the Slodowy slice and $e_L^{reg}$ be a regular nilpotent element, then  $M_{reg}:=\mu^{-1}(\mathfrak g_{reg}^*) \isom (G \times_{\mathfrak c_G} M_1) / J_G \isom \coprod_{[L]} G \times ^{N_G(L,e_L^{reg})} Z_{L,e_L^{reg}}(M)$.

Relation with relevant orbits: Let us be in the BZSV setup and $p:M \to X$ be the projection, then $$\mu_N^{-1}(\xi) = \mu_G^{-1}(f+ \mathfrak n^\perp) = \mu_G^{-1}(f+ \mathfrak b) = \coprod_{\mathcal O \in \text{N-orbits of X}} \Lambda_{\mathcal O, \xi} := \coprod_{\mathcal O}  p^{-1}(\mathcal O) \cap \mu_N^{-1}(\xi)$$
$f + \mathfrak n^\perp \isom N \times S \subset \mathfrak g_{reg}^*$ by conjugation so $\mu_N^{-1}(\xi) \contain \mu_G^{-1}(S) = M//_{Wh} G$ and becomes isomorphic to the latter after modulo $N$. Therefore relevant orbits give us a Lagrangian fibration of $M//_{Wh} G$. On the other hand, the Levi stratification above for $M//_{Wh}G$ is pullback from $S^{[L]} \isom \mathfrak c_G^{[L]}$, a stratification of the Poisson manifold. For example, for $G = GL_3$ $\mathfrak c_G \isom \mathbb A^3$ by extracting coefficients of the characteristic polynomial $p(t)$. The stratification is $$\mathfrak c_G^{[1,1,1]} \coprod \mathfrak c_G^{[2,1]} \coprod \mathfrak c_G^{[3]} = \{\Delta(p) \neq 0\} \coprod \{p(t) = (t-a)^2(t-b)\}_{a \neq b} \coprod \{p(t) = (t-a)^3\}_{a \in \mathbb A^1}$$ ^c4aead

-(GPT's suggestion: unfolding space, related to [[rank one comparison + matching#^d7befa]]) $\tilde{M}:=G_X \times^{J_X} T^*X = \frac{Wh_{G_X} \times_{\mathfrak c_X^*} T^*X}{J_X}$ is a $G \times G_X$ - Hamiltonian space. It is called unfold because it is the inverse operation to taking $G_X$ - Whittaker-Kostant section. More precisely, (over the regular locus) for $m \in \tilde{M}$ lying over $s = \kappa(a) \in S_{G_X}$ the $G_X$-orbit of the moment value is $G_X \cdot s \isom G_X/Z_{G_X}(s) = G_X/(J_X)_a$. $\tilde{M}//_{Wh}G_X \isom T^*X$. On the other hand,

>[!"conjecture"]
When $S_X = 0$ and $\iota'^\vee= 0$,  $T^*X//_{Wh}G \isom J_X$. Thus $\tilde{M} //_{Wh} G \isom M_1 = T^*(G_X, \Psi) =:Wh_{G_X} \isom G_X \times S_{G_X}$ where $S_{G_X}$ is the Slodowy slice for $G_X$.

Remark: I don't think this is actually a conjecture because one can in fact prove it case by case. However, a conceptual proof is worthy. The conjecture is somehow circular, we actually want $\tilde{M} //_{Wh} G \isom M_1 \implies T^*X//_{Wh} G \isom J_X$ and it should be simpler, not the converse. This is softly solved by Venkatesh's principle [[rank one comparison + matching#^9cda03]].

Proof: 
The proof holds birationally

$T^*X = G \times ^H V$ where $V = \mathfrak h^\perp$. Let $\chi_X:V \to \mathfrak c_X$ be the quotient map, then $\mathfrak c_X = T^*X//G = V//H$  $W_X := T^*X//_{Wh}G \isom T^*X \times_{\mathfrak g^*} S_G$. 

The first observation is the fiberwise identification: we
compute the fibers of $\pi: W_X \to \mathfrak c_X$. Let $\iota: \mathfrak c_X \to \mathfrak c_G$ and $\kappa_G :\mathfrak c_G \to S_G \subset \mathfrak g_{reg}^*$. For $c \in \mathfrak c_X$, put $s_c:= \kappa_G(\iota(c))$, then $W_{X,c}=\{[g,\eta] \in G \times ^H \mathfrak h^\perp| \chi_X(\eta) = c, Ad^*(g)(\eta) = s_c\}$. Denote $R_c:= H\backslash (V \cap G \cdot s_c)$ (R stands for representatives). Now fix an $H$ - orbit and choose $\eta \in V \cap G \cdot s_c$ and $g_\eta$ such that $Ad^*(g_\eta)(\eta) = s_c$ (a point in the fiber). Any other g such that $Ad^*(g)(\eta) = s_c$ is of the form $g = z g_{\eta}$ for $z \in Z_G(s_c)$, hence $$W_{X,c,[\eta]}:=\{[g,\eta'] \in W_{X,c}| \eta' \in H \eta \} \isom Z_G(s_c)/(g_{\eta}Z_H(\eta)g_{eta}^{-1}) \isom Z_G(\eta)/Z_H(\eta)$$
To compare it with $J_X$. [Hameister-Luo-Morrissey](https://arxiv.org/pdf/2409.15691) construct an exact sequence:

$$1 \to J_{rel} \to J_G|_{\mathfrak c_X} \to J_X \to 1 $$

and on the relative-regular locus $\chi_X^*J_{rel} \isom I_{H}|_{V_{reg}}$ where $I_H$ is the universal centralizer of $H$ - action on $V$. Hence for an H-regular $\eta$, $J_{rel,c} = Z_H(\eta)$ and $J_{G,c} = Z_G(\eta)$ so $J_{X,c} \isom Z_G(\eta)/Z_H(\eta)$. Combining the two, we have $W_{X,c} = \coprod_{[\eta] \in R_c} W_{X,c,[\eta]}$ with $W_{X,c,[\eta]} \isom J_{X,c}$ for regular $\eta$.

>[Hameister-Luo-Morrissey](https://arxiv.org/pdf/2409.15691)
>$X$ is tempered iff $(\mathfrak h^\perp)_{H-reg} \subset \mathfrak g_{reg}^*$

To recover $J_X$,  $(\mathfrak h^\perp)_{H-reg} \subset \mathfrak g_{reg}^* \cap \mathfrak h^\perp$ from the lemma above only . So birationally $R_c = H \backslash \mathfrak h^\perp_{H-reg} \cap \chi_X^{-1}(c)$ and $R_c = H \backslash \mathfrak h^\perp_{H-reg} \cap \chi_X^{-1}(c)$. Denote by $R_X:= \mathfrak h^\perp_{H-reg} // H$ the regular quotient, we also need to assume $R_X \to \mathfrak c_X$ is an isomorphism