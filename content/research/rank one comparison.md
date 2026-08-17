[[Running Logs]]的问题1

Assume $S_X = 0$ and $P(X)=B$ and $X$ affine homogeneous with no type N roots first (Call it assumption \*). $F$ is a number field. Then $X = H \backslash G$ and $X_1$ is $G_X$ Whittaker. We ignore the rationality problem for now.  

We consider twisted Levi variety $X^L_{\alpha, \psi} := X^0P/(U,\psi)$ ($U$ acts freely on $X^0P$), then $X^L_{\alpha, \psi}/(N_L, \psi) \into X/(N,\psi)$ where $P=LU$ with $\Delta_L = supp~ \alpha$, $\alpha \in \Sigma_X$. The orbital integral $\mathcal O_{\gamma, X}(F):= \int_{N_\gamma (\adele) \times N (\adele)} F(\gamma n) \xi(n) dn$ for $\gamma \in X^0P(F)/N(F)$ and $F = p_{G !}(f) \in C^\infty_c (X(F))$ can be rewritten as $\mathcal O_{\gamma, X}(F) = \mathcal O_{\gamma, X^L_\psi}(p_{X!}(F))$ where $p_{X!}(f) = \mathcal F_U(f) = \int_{U(\adele)} F(\gamma u) \xi_U(u)du$ is the pushforward map/Fourier transform induced by $X^0P=X^0L \to X^L_{\alpha, \psi}$. 

# Twisted Levi Variety

We assume $X$ is wavefront to avoid some technical issues.
## Untwisted Levi Variety (SV)

$X^L_\Theta$ has the same rank as $X$, and has spherical roots $\Theta$ and $Z(X_\Theta) = A_{X,\Theta} \subset X^*(A_X)$. From the untwisted to the twisted case, besides $\Theta$ there may be extra spherical roots (simple roots in $supp~\Theta$) from Whittaker induction. ==These new roots are not spherical roots of $X$==. It is worth noting that we only know this space is quasi-affine homogeneous spherical satisfying \*. For example, $X = Sp_2^\diag \times Sp_2 \backslash Sp_2 \times Sp_4$ and one of its Levi variety corresponds to quadruple $(Sp_4,SL_2,(2,1^2),std)$. I don't know how to prove the following but I believe it's true.

>[!Statement]
>$X^L_{\Theta, \psi} = (L \cap (HU,\psi_\Theta)) \backslash L$  comes from a BZSV subquadruple of $X$

If so, then a large part of the comparison can be localized to part of a subcomparison between $X^L_{\Theta, \psi}$ and $L_{X^L_{\Theta, \psi}}$.

^BZSV-subquadruple

With wavefront assumption, $X^L_\Theta / Z(L)^0 = X^L_\Theta / A_{X, \Theta}$ is isogenous to the adjoint-type $L_{ad} = L/Z(L)$-variety $X^{L,ad}_\Theta :=X^L_\Theta / Z(L)$.

Or, consider the rank $|\Theta|$ variety $X^{L,ad}_{\Theta, \psi}$ or its isogeny to avoid the Whittaker problem above; we know $X^*(X^{L,ad}_{\Theta})_\Q = \Q \Theta$, there is no room for other new simple roots to be added, therefore it is not a Whittaker induction. 

In fact, $X^{L,ad}_{\Theta, \psi}$ is not a good notation since the $\psi$ -twisting is not preserved by $Z(L)^0$, that also explains why Whittaker induction is killed.
##  Support of Spherical Roots

The cuspidal rank one spherical varieties of adjoint type are given in Knop's table in Spherical roots of spherical varieties. Those satisfying our assumption \* can only be:

1. $GL_2 \backslash PGL_3$
2. $PGL_2^\Delta \backslash PGL_2 \times PGL_2$
3. $P_{\alpha_2, SO_4} \backslash SO_5$
4. $H_{G_2} \backslash G_2$ where $H_{G_2}=\operatorname{GL}_2^{\mathrm{long}}\ltimes\left(U_{2\alpha_1+\alpha_2}U_{3\alpha_1+\alpha_2}U_{3\alpha_1+2\alpha_2}\right)$
5. (when relaxed to $S_X \neq 0$) $T \backslash PGL_2$

whose spherical roots are all of the form $\alpha = \alpha_1 + \alpha_2$, hence $\alpha^\vee = \alpha_i^\vee|_{X^*(A_X)}$. 

How is Knop's table related to SV's Levi variety? Well, the latter by definition puts back the toric direction that Knop has modded out in Localization of spherical variety, i.e. $X^L_\Theta / T_Z \isom Z^L_\Theta$ where $T_Z = \Gm^{\Gamma_Z} \into A_{X, \Theta}$. 

In particular, when $\Theta = \{\alpha\}$, $X^L_{\alpha, \psi}/Z(X_\alpha)$ has rank one, so it only has one spherical root. It falls into the classification above up to central isogeny. The cuspidal adjoint-type $X^L_{\alpha, \psi} \surj X^{L,ad}_{\alpha, \psi}$ is exactly one of the four above. Hence in this case, the statement above is true.

# Matching of Orbits [[MWZ running problems#^orbit-problem]]

## Matching of L and G

 $X^L_{\Theta, \psi}/(N_L, \psi) \into X/(N,\psi)$ since the stabilizer lies in $N_L$, the problem is from $X^{L,ad}_{\Theta, \psi}/(N_L, \psi)$ to $X^L_{\Theta, \psi}/(N_L,\psi)$.
## Matching of G and G_X

$G_X$ has $2^{\Delta_X}$ - many relevant orbit families (family means all relevant orbits inside one Borel orbit). To have orbit matching, we must 

- compute all relevant orbits of $X$ and show there are $2^{\Delta_X}$ - many of them and they are indexed by $\Delta_X$.

This step is essential: we must study the "most singular part" of $X$, no matter what that is. And the rest should be distributed into all $X^0P_\Theta$.

- show part of the relevant orbits of $X^L_{\alpha, \psi}$ match those of $G_{X,\alpha}$ (the Levi of $G_X$ with simple root $\alpha$), in other words, we ignore the extra Whittaker induced part.

Some new progress: Relate the relevant orbits to families of Lagrangians in the Whittaker reduction of $M$, then it becomes a problem of comparing the Whittaker reduction of $M$ and $M_1$. There are two conceptual approaches:

1. (perfect explanation but assumption not true in many cases) If we believe Venkatesh's principle, assume $M'^\vee = T^*G^\vee \times S_X$ is a $G^\vee \times G_X^\vee$ - Hamiltonian space, then one should have $M//_{Wh} G = M_1//_{Wh} G_X$. By our reinterpretation for [[Mao and Rallis]], we may find an $M'$ that lies in the framework of extended BZSV which should still explain expectation. ^d7befa
2. There is one more improvement
3. universal centralizer + BZSV duality, old way.  ^39b499

## Matching of Distribution



