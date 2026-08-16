[[Functorial Transfer#^Small-Project-Intrepretation-of-Theta-Correspondence-by-BZSV]]

Mao and Rallis consider the comparison of $(G,G,\rho,0)$ and $(H = SL_2,1,0,\iota_{reg})$. In their setup, $(G,H)$ is a dual pair and $G \times H \into G'$ for some special $G'$ (To be concrete, $G$ is of $D_4,E_6,E_7,E_8$ type). 

To fit in "Venkatesh's principle", $G \times H$ acts on $\Tilde{M} = \mathcal O_{min}(G')$ ==(this space is not hyperspherical because it is not affine, its affine closure is singular at the origin. However, it satisfies coisotropicity. In fact, it only fails affineness and neutral grading).== $\Tilde{M} //_{Wh}H = V_{\rho} = M$ and $\Tilde{M}//_{Wh} G:=\Tilde{M}//_{\mathcal O_G} G = T^*(SL_2 , \Psi) = M_1$ where $\mathcal O_G$ is a lifting of $\iota_{reg, SL_2}$, i.e. $\iota'$. In the end, $\Tilde{M}//_{Wh}(G \times H) = \mathcal J (SL_2)$. (All computed in [Hanzer–Savin, *Multiplicity free Weil representations arising from exceptional groups*](https://arxiv.org/abs/2411.01243), IMRN 2025)

 In addition to Venkatesh's principle, quanzation commutes with Whittaker reduction as well (since $(G,H)$ cocentralize each other), i.e. the following draft:
 
 M --Quant--> \Pi
 |                          |
 Wh-red            "Wh-red"
 |                          |
 v                         v
 M//_{Wh} G --Quant-->\Pi_{(N,\psi)}

 Let $V_\rho = T^*Y$ be a polarization. It has a 2-dimension Whittaker reduction, and on the regular locus it is $T^*(Y^\times/U_{\iota'}) \isom T^* \Gm$, hence it has Lagrangian/configuration base $\mathbb A^1$.  For the MWZ distrubution/RTF, the geometric space of $RTF_M$ is this $\mathbb A^1$. One can also interpret the orbital integrals as vectors in $\mathcal S(Y)_{(U_{\iota'},tr)}$. In Mao and Rallis, $Y = \mathcal J \oplus \mathbb A^1$ hence: 

$$
\mathcal S(Y)
\simeq
\int_{a\in F}^{\oplus}
\mathcal S(\mathcal J)\,da.
$$

Since \(N\) fixes \(a\), the Whittaker coinvariant is taken fiberwise:
$$
\mathcal S(Y)_{N,\xi_N}
\simeq
\int_{a\in F}^{\oplus}
\mathcal S(\mathcal J)_{N,\xi_N;\,a}\,da.
$$

For a regular \(a\neq 0\), the relevant \(N\)-orbit is unique, and the fiberwise coinvariant is essentially one-dimensional:
$$
\dim \mathcal S(\mathcal J)_{N,\xi_N;\,a}=1.
$$
 and 
 
 $$
\mathcal S(\mathbb G_m\times \mathcal J)_{N,\xi_N}
\simeq
\mathcal S(\mathbb G_m),
$$
up to the usual choices of measures and normalizations.
 The "Wh-red" of quantization of $V_\rho$ , it is the same space as $(ind^{H}_{U_{\theta}}\psi)_{U_\theta,\psi}$ (see below). It is the same idea of another paper of Mao and Rallis, which suggests to do matching by comparing two Jacquet modules.

 After quantization, the picture becomes:
 
- $\mathcal O_{min}(G') \to \Pi_{G'} = : \Pi$, the corresponding minimal representation. After taking $(N,\psi)$-coinvariants:
- $M_1 \to \Pi_{U_\theta, \psi}= \Omega_{\psi, \rho} = \mathcal S(Y)$ which is the Weil representation attached to the symplectic $G$-space $V_\rho$
- $M \to \Pi_{N_G = U_{\iota'},tr} =ind^{H}_{N = U_\theta}\psi$ which is the Whittaker induction of $SL_2$

We view the orbital integrals of $G$ and $H$ as linear functionals on $\Pi_{U_\theta, \psi}$ and $\Pi_{U_{\iota'},tr}$ both factoring through $Q:=\Pi_{U_\theta, \psi,U_{\iota'},tr}$. So now we are in the setup that we have two families $\{\mathcal O\}, \{\mathcal O_1\} \subset Q^\vee$.

GPT guesses, ignoring the hypersphericality condition, $\mathcal O_{min}(G') \bijection T^*(U_{\iota'^\vee} \backslash G^\vee, \Psi_{\iota'^\vee}) = WI^{G^\vee}_{H^\vee, \iota'^\vee}(T^*H^\vee)$ since it satisfies Venkatesh's principle for both $G$ and $H$ ==(note that Venkatesh's principle more generally is duality commutes with "nilpotent orbit dual" Hamiltonian reduction, in particular principal/regular Whittaker reduction v.s. zero Hamiltonian reduction = symplectic reduction)==, also in the $D_4$ case [S. K. Devalapurkar](https://arxiv.org/pdf/2404.09853 ) checked derived geometric Satake for this duality. This space satisfies all BZSV conditions except hypersphericality. 

The "nilpotent orbit dual" means it is not the duality defined in the literature; [Gan-Wang](https://arxiv.org/pdf/2309.08874) themselves point out that the orbit correspondence arising in some of their generalized-Whittaker dual pairs does **not** always coincide with Barbasch–Vogan duality. ==This might form a counterexample to MWZ conjecture?== ^Possible-Counterexample-1

So above all we have that a singular non-neutral-grading hyperspherical space is dual to a smooth non-hyperspherical space in this case.







