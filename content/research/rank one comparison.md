[[2026-08-11]]的问题1

Assume $S_X = 0$ and $P(X)=B$ and $X$ affine homogeneous with no type N roots first (Call it assumption *). $F$ is a number field. Then $X = H \backslash G$ and $X_1$ is $G_X$ Whittaker. We ignore the rationality problem for now.  

We consider twisted Levi variety $X^L_{\alpha, \psi} := X^0P/(U,\psi)$ ($U$ acts freely on $X^0P$), then $X^L_{\alpha, \psi}/(N_L, \psi) \into X/(N,\psi)$ where $P=LU$ with $\Delta_L = supp~ \alpha$, $\alpha \in \Sigma_X$. The orbital integral $\mathcal O_{\gamma, X}(F):= \int_{N_\gamma (\adele) \times N (\adele)} F(\gamma n) \xi(n) dn$ for $\gamma \in X^0P(F)/N(F)$ and $F = p_{G !}(f) \in C^\infty_c (X(F))$ can be rewritten as $\mathcal O_{\gamma, X}(F) = \mathcal O_{\gamma, X^L_\psi}(p_{X!}(F))$ where $p_{X!}(f) = \mathcal F_U(f) = \int_{U(\adele)} F(\gamma u) \xi_U(u)du$ is the pushforward map/Fourier transform induced by $X^0P=X^0L \to X^L_{\alpha, \psi}$. 

# Spherical roots of twisted Levi variety

## Untwisted Levi variety (SV)

$X^L_\Theta$ has the same rank as $X$, and has spherical roots $\Theta$ and $Z(X_\Theta) = \Theta ^\perp \subset X^*(A_X)$. From the untwisted to the twisted case, besides $\Theta$ there are extra spherical roots from Whittaker induction (since $X^L_{\Theta, \psi}$ = )
##  Support of spherical roots

The cuspidal rank one spherical varieties of adjoint type are given in Knop's table in Spherical roots of spherical varieties. Those satisfying our assumption * can only be:

1. $GL_2 \backslash PGL_3$
2. $PGL_2^\Delta \backslash PGL_2 \times PGL_2$
3. $P_{\alpha_2, SO_4} \backslash SO_5$
4. $H_{G_2} \backslash G_2$ where $H_{G_2}=\operatorname{GL}_2^{\mathrm{long}}\ltimes\left(U_{2\alpha_1+\alpha_2}U_{3\alpha_1+\alpha_2}U_{3\alpha_1+2\alpha_2}\right)$

whose spherical roots are all of the form $\alpha = \alpha_1 + \alpha_2$, hence $\alpha^\vee = \alpha_i^\vee|_{X^*(A_X)}$. 

How is Knop's table related to SV's Levi variety? Well, the latter by definition puts back exactly the torus direction that Knop has modded out, i.e. $X^L_\Theta / T_Z \isom Z^L_\Theta$ where $T_Z = \Gm^{\Gamma_Z}$

The problem is that the twisted Levi variety could be non-affine (for example of the form $(P_{\alpha_2, SO_4}, \psi) \backslash SO_5$) and not rank one (for example $GL_2 \backslash GL_3$), also the support of a spherical root could contain the support of some other spherical roots.

To match this classification, the idea is to reduce to rank one adjoint type first, then use some $p$-adic diffeomorphism to go back to $X$ (as CCL or Jacquet did for $SL_2 \times Z_{GL_2} \surj GL_2$ to separate the toric part and tangent part, hopefully)

So reduce to the adjoint type $X^L_\psi \surj X^L_\psi/Z(L)^0$,  


