[[2026-08-11]]的问题1

Assume $S_X = 0$ and $P(X)=B$ and $X$ affine homogeneous with no type N roots first (Call it assumption \*). $F$ is a number field. Then $X = H \backslash G$ and $X_1$ is $G_X$ Whittaker. We ignore the rationality problem for now.  

We consider twisted Levi variety $X^L_{\alpha, \psi} := X^0P/(U,\psi)$ ($U$ acts freely on $X^0P$), then $X^L_{\alpha, \psi}/(N_L, \psi) \into X/(N,\psi)$ where $P=LU$ with $\Delta_L = supp~ \alpha$, $\alpha \in \Sigma_X$. The orbital integral $\mathcal O_{\gamma, X}(F):= \int_{N_\gamma (\adele) \times N (\adele)} F(\gamma n) \xi(n) dn$ for $\gamma \in X^0P(F)/N(F)$ and $F = p_{G !}(f) \in C^\infty_c (X(F))$ can be rewritten as $\mathcal O_{\gamma, X}(F) = \mathcal O_{\gamma, X^L_\psi}(p_{X!}(F))$ where $p_{X!}(f) = \mathcal F_U(f) = \int_{U(\adele)} F(\gamma u) \xi_U(u)du$ is the pushforward map/Fourier transform induced by $X^0P=X^0L \to X^L_{\alpha, \psi}$. 

# Twisted Levi Variety

We assume $X$ is wavefront to avoid some technical issues.
## Untwisted Levi Variety (SV)

$X^L_\Theta$ has the same rank as $X$, and has spherical roots $\Theta$ and $Z(X_\Theta) = A_{X,\Theta} \subset X^*(A_X)$. From the untwisted to the twisted case, besides $\Theta$ there may be extra spherical roots (simple roots in $supp~\Theta$) from Whittaker induction. ==These new roots are not spherical roots of $X$==. It is worth noting that we only know this space is quasi-affine homogeneous spherical satisfying \*. For example, $X = Sp_2^\diag \times Sp_2 \backslash Sp_2 \times Sp_4$ and one of its Levi variety corresponds to quadruple $(Sp_4,SL_2,(2,1^2),std)$. I don't know how to prove the following but I believe it's true.

>[!Statement]
>$X^L_{\Theta, \psi} = (L \cap (HU,\psi_\Theta)) \backslash L$  comes from a BZSV subquadruple of $X$

If so, then a large part of the comparison can be localized to a subcomparison between $X^L_{\Theta, \psi}$ and $L_{X^L_{\Theta, \psi}}$, but its meaning is still unclear since the extra Whittaker induced spherical roots will obstruct the identification of $L_{X^L_{\Theta, \psi}}$ with some part of $G_X$ (again the example $X = Sp_2^\diag \times Sp_2 \backslash Sp_2 \times Sp_4$).

^BZSV-subquadruple

With wavefront assumption, $X^L_\Theta / Z(L)^0 = X^L_\Theta / A_{X, \Theta}$ is isogenous to the adjoint-type $L_{ad} = L/Z(L)$-variety $X^L_\Theta / Z(L)$.
##  Support of Spherical Roots

The cuspidal rank one spherical varieties of adjoint type are given in Knop's table in Spherical roots of spherical varieties. Those satisfying our assumption \* can only be:

1. $GL_2 \backslash PGL_3$
2. $PGL_2^\Delta \backslash PGL_2 \times PGL_2$
3. $P_{\alpha_2, SO_4} \backslash SO_5$
4. $H_{G_2} \backslash G_2$ where $H_{G_2}=\operatorname{GL}_2^{\mathrm{long}}\ltimes\left(U_{2\alpha_1+\alpha_2}U_{3\alpha_1+\alpha_2}U_{3\alpha_1+2\alpha_2}\right)$

whose spherical roots are all of the form $\alpha = \alpha_1 + \alpha_2$, hence $\alpha^\vee = \alpha_i^\vee|_{X^*(A_X)}$. 

How is Knop's table related to SV's Levi variety? Well, the latter by definition puts back the toric direction that Knop has modded out in Localization of spherical variety, i.e. $X^L_\Theta / T_Z \isom Z^L_\Theta$ where $T_Z = \Gm^{\Gamma_Z} \into A_{X, \Theta}$. 

In particular, when $\Theta = \{\alpha\}$, $X^L_{\alpha, \psi}/Z(X_\alpha)$ has rank one, so it only has one spherical root. It falls into the classification above up to central isogeny, with twisted unipotent. The cuspidal adjoint-type $X^L_{\alpha, \psi} \surj X^L_{\alpha, \psi}/Z(L)$ is exactly one of the four above. Hence in this case, the statement above is true.

# Matching of Orbits

## Matching of L and G

 $X^L_{\Theta, \psi}/(N_L, \psi) \into X/(N,\psi)$ since stabilizer lies in $N_L$, so identification of localization is fine.
## Matching of G and G_X

$G_X$ has $2^{\Delta_X}$ -many relevant orbit families. To have orbit matching, we must compute all relevant orbits of $X$, and show relevant orbits of $X^L_{\Theta, \psi}$

## Matching of Periods


