Let $F$ be a local field. In one word, endoscopy is a Fourier decomposition of a rational conjugacy class in a stable conjugacy class.

# Stabilization

We absorb the volume term into the definition of $\mathcal O_\gamma$

When we study the classical (R)TF of $H = G^\Delta \into G \times G$ (this $H$ is not the one later and will not be used later; it's just for expressing the setup), the (strongly) regular semisimple (elliptic) elements $\gamma \in G(F)$ are good for convergence reasons. It has centralizer a maximal torus $T = G_\gamma$, $[\gamma]_{st}$ is the stable orbit of $\gamma$ which is indexed by $A_\gamma:=\ker(H^1(F,T) \to H^1(F,G))$, say $a \bijection \gamma_a$. Define a signed orbital integral (something formal) first $$\mathcal O^\kappa_\gamma(f):= \sum_{a \in A_\gamma} <a,\kappa> \mathcal O_{\gamma_a}(f)$$ then $\mathcal{SO}_\gamma^G = \mathcal O_{\gamma}^{1}$. By Fourier inversion $O_{\gamma_a}(f) = \mathcal O_{\gamma} = \frac{1}{|A_\gamma|}\sum_{\kappa \in A_\gamma^\vee} <\gamma,\kappa^{-1}> \mathcal O_{\gamma}^\kappa$

So on $G$ the stable orbital integral is $\mathcal{SO}^G_{\gamma} = \sum_{[\gamma] \in [\gamma]_{st}} \mathcal O_{\gamma} = \frac{1}{|A_\gamma|}\sum_{\kappa \in A_\gamma^\vee} <\gamma,\kappa> \mathcal O_{\gamma}^\kappa$. The second equality is Fourier inversion. This step is called pre-stabilization.

The stabilization is a reinterpretation: $$\sum_{\kappa} <\gamma,\kappa> \mathcal O_{\gamma}^\kappa(f) = \sum_{H \in \mathcal{E}(G)} \iota(G,H) \mathcal{SO}_H(f^H)$$ where $\kappa \bijection s$ and $H^\vee = Z_{G^\vee}(s)^\circ$. We may assume $H^1(F,G) = 0$ since one can use stacky viewpoint to avoid this. 