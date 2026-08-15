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
 
 After quantization, the picture becomes:

- $\mathcal O_{min}(G') \to \Pi_{G'} = : \Pi$, the corresponding minimal representation. After taking $(N,\psi)$-coinvariants:
- $M_1 \to \Pi_{U_\theta, \psi}= \Omega_{\psi, \rho}$ which is the Weil representation attached to the symplectic $G$-space $V_\rho$
- $M \to \Pi_{N_G,tr} =ind^{H}_{N}\psi$ which is the Whittaker induction of $SL_2$

Let $V_\rho = T^*Y$ be a polarization, For the MWZ distrubution/RTF, the geometric space of $RTF_M$ is 

GPT guesses, ignoring the hypersphericality condition, $\mathcal O_{min}(G') \bijection T^*(U_{\iota'^\vee} \backslash G^\vee, \Psi_{\iota'^\vee}) = WI^{G^\vee}_{H^\vee, \iota'^\vee}(T^*H^\vee)$ since it satisfies Venkatesh's principle for both $G$ and $H$ ==(note that Venkatesh's principle more precisely is duality commutes with "nilpotent orbit dual" Hamiltonian reduction, in particular principal/regular Whittaker reduction v.s. zero Hamiltonian reduction = symplectic reduction)==, also in the $D_4$ case [S. K. Devalapurkar](https://arxiv.org/pdf/2404.09853 ) checked derived geometric Satake for this duality. This space satisfies all BZSV conditions except hypersphericality. So above all we have singular hyperspherical space is dual to a 







