In Jacquet-Lai-Rallis, they mentioned a second trace-formula identity $$\sum_{\epsilon} \int_{H_\epsilon} \int_{H} K_\epsilon(h_\epsilon,h) dh_\epsilon dh = \int_{G'}K'(g',g') \Theta'(g') dg'$$ where $G = Res_F^E GL_2, G'=GL_{2,F}$, $E/F$ is a quadratic extension, $H_\epsilon \subset G$ is some nonsplit unitary group and $H \subset G$ is the split unitary group, $c(s) = |D_E|^{1/2}|D_F|^{-1}L(s, \mathbb 1_F)$. This formula is obtained from taking residue at $s=1$ of $$L(s,\eta) \sum_{\epsilon} \int_{H_\epsilon} \int_H K_\epsilon(h_\epsilon,h) E(h,s)dh_\epsilon dh = c(s) \int_{G'} K'(g',g') E'(g',s) \eta(\det g') dg'$$
We admit these statements first. On the other hand, they said $s \to \infty$ this identity should become $H_\epislon \backslash G / H \xrightarrow{s \to \infty} H_\epsilon \backslash G / (N, \theta)$ comparing with $G'//G' \xrightarrow{s \to \infty} (N',\theta') \backslash G' / (N',\theta')$

## The Jacquet-Zagier kernel pairing <K,E>
### Eisenstein series
For a parabolic $P=MN \subset G$, the Eisenstein operator $$Eis_P:Autom(M) \xrightarrow{\text{parabolic induction}} Ind_P^G(s) \to Autom(G)$$ is $\varphi \mapsto f_{\varphi,s} \mapsto E(g,f_{\varphi,s}) = \sum_{\gamma \in P(F) \backslash G(F)} f_{\varphi,s}(\gamma g)$
and the constant term
$$CT_P(F)(m):= \int_{[N]}F(nm)dn$$ are adjoint (we consider spherical section $f_s$ so that $K$-action is trivial)$$<F,Eis_P(f_s)>_{[G]} = <CT_P (F), f_s>_{[M]}$$ i.e. via Iwasawa decomposition, one can understand $Eis_P(f_s)$ as an integral kernel = constant term + Mellin transform (RHS viewed as a function of $s$). Note that the point here is not the automorphic input $\varphi$ on $M$, but the section $f_s$. 

In particular, JLR pairs the usual diagonal kernel $F(g) = K(g,g)$ with the Eisenstein series constructed from the section $f_{\Phi,s}$, where $\Phi \in \mathcal S(\mathbb A^n)$ (Rankin-Selberg: $GL_n$ right action on $\mathbb A^n$). From this point of view, denote $P_n$ be the mirabolic of $GL_n$ = stabilizer of the open orbit of $GL_n$. Consider $P_n\backslash GL_n = \mathbb A^n \backslash \{0\}$, let $r_\Phi(g):= \Phi(e_n g)$ be the function on $P_n \backslash GL_n$ and $Q = P_n Z_n$ where $Z_n \isom \Gm$, there is a $\Gm$-bundle $q: P_n \backslash GL_n \to Q \backslash GL_n$, then Mellin transform =  $f_{\Phi,s}:= |\det(g)|^s\int_{\mathbb A^\times} \Phi (e_nzg)|z|^{ns} \eta(z) d^\times z$ is a normalized section. Therefore, the Eisenstein process above becomes $\Phi \mapsto r_{\Phi} \mapsto f_{\Phi,s}$.

The adjoint formula is then $$CT_{Q}(\phi \overline{\phi'})=W_{\phi}(g) \overline{W_{\phi'}(g)}$$using Plancherel $K_{cusp} = \sum_{\pi,\phi} \pi(f)\phi(g) \overline{\phi(g)}$ + Whittaker expansion $\phi(g) = \sum_{\gamma \in N_{n-1}(F) \backslash GL_{n-1}(F)} W_{\phi}(\begin{pmatrix} \gamma & 0 \\ 0 & 1 \end{pmatrix} g)$. By successive diagonal unipotent unfolding (Rankin-Selberg method, unfolding $Q(F) \backslash G(\adele) \to P_{n}(F) \backslash G(\adele) \xrightarrow{\text{successive Fourier expansion}} \backslash N(\adele) \backslash G(\adele)$) we obtain the spectral expansion $$\int_{N(\mathbb A) \backslash GL_n(\mathbb A)} W_{\phi}(g) \overline{W_{\phi'}(g)} \Phi(e_ng)|\det(g)|^s dg$$

## Back to JRL

The RHS of JRL identity is Jacquet-Zagier, whose spectral expansion is summation of $L(s,\pi' \tensor \eta \tensor \tilde{\pi'})$, while the LHS has spectral expansion summation of $L(s,\pi,Asai)$. 
### $s \to 1$

### $s \to \infty$
#### Mellin parameter $s \to \infty$ sees geometry boundary
For example, if we look at the $GL_2$ case, we write Fourier expansion $f(z) = \sum_{n \ge 1} a_n e(nz)$