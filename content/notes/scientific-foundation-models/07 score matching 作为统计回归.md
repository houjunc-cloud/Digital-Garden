---
title: 07 score matching 作为统计回归
description: Hyvärinen 恒等式的真实正则性条件、Vincent 的去噪恒等式、score 估计的最小最大率，以及"为什么它是良态的"。
tags:
  - scientific-foundation-models
  - generative-models
  - nonparametric-statistics
stage: 🌱 seedling
date: 2026-08-18
---

# 07 score matching 作为统计回归

> 课程 10/6, 10/8：*"Score matching as statistical regression"*。
>
> 标题就是全部论点：**估计 score 不是什么新问题，它是一个非参数回归问题**，于是 [[P2 非参数回归与最小最大率|P2]] 的全套工具直接适用，包括最小最大下界。
>
> 但这个论点有一个微妙之处值得整节课：**Hyvärinen 原始的 score matching 不是回归，而且它的正则性条件在真实数据上不成立。是 Vincent 的去噪版本把它变成了回归。**这一步不是技术改良，是问题性质的改变。
>
> 前置：[[notes/deep-learning/17 扩散模型与 flow matching|DL 17]]（构造）、[[P1 随机微分方程与 Fokker–Planck#6-时间反演|P1 §6]]（时间反演）、[[P2 非参数回归与最小最大率|P2]]。这里只讲**率与良态性**，构造不重复。

> [!question] 卡住了从哪儿看起
> - Hyvärinen, *Estimation of non-normalized statistical models by score matching*, JMLR **6** (2005) 695–709 — 原始恒等式，**连脚注 1 一起读**
> - Vincent, *A connection between score matching and denoising autoencoders*, Neural Comput. **23** (2011) 1661–1674
> - 📐 [Wibisono, Wu, Yang, *Optimal score estimation via empirical Bayes smoothing*](https://proceedings.mlr.press/v247/wibisono24a/wibisono24a.pdf), COLT 2024 — **本篇的率**
> - 📐 [Sriperumbudur, Fukumizu, Gretton, Hyvärinen, Kumar, *Density estimation in infinite dimensional exponential families*](https://arxiv.org/abs/1312.3516), JMLR 18 (2017) — §6 的对照，RKHS 里 score matching 是**真正的不适定逆问题**

## 1. Hyvärinen 恒等式与它的真实代价

**目标.** 估计 $s^\star=\nabla\log p$，损失取 **Fisher 散度**
$$J(s)=\tfrac12\int p(x)\,\big\lVert s(x)-\nabla\log p(x)\big\rVert^2\,\mathrm{d}x .$$
问题：$\nabla\log p$ 未知，$J$ 不可计算。

> **定理（Hyvärinen 2005）.** 在适当正则性下，
> $$J(s)=\int p(x)\sum_{i=1}^d\Big[\partial_is_i(x)+\tfrac12 s_i(x)^2\Big]\mathrm{d}x+\text{const}.$$

右边**只用到 $p$ 的样本**，可以做经验版本。证明就是展开平方，交叉项分部积分：
$$-\int p\,s_i\,\partial_i\log p=-\int s_i\,\partial_ip\ \overset{\text{IBP}}{=}\ +\int p\,\partial_is_i .$$

**原文的条件**（脚注 1）是：$p$ 可微；$\mathbb{E}\lVert s\rVert^2,\mathbb{E}\lVert s^\star\rVert^2<\infty$；$p(x)s(x)\to0$ 当 $\lVert x\rVert\to\infty$。

> [!warning] 第三条在 $d\ge2$ 时不够
> 令 $F:=p\,s$。分部积分要的是 $\int_{\R^d}\operatorname{div}F=0$。在 $B_R$ 上用散度定理，边界通量是
> $$\int_{\partial B_R}\langle F,\nu\rangle\,\mathrm{d}S\ \lesssim\ R^{d-1}\sup_{\lVert x\rVert=R}\lVert F(x)\rVert .$$
> **逐点趋于 $0$ 完全不够**——需要 $\lVert F(x)\rVert=o(\lVert x\rVert^{1-d})$ 沿某列 $R_k\uparrow\infty$，或者干脆要求 $F\in W^{1,1}(\R^d;\R^d)$。
>
> 还有两条同样重要：
> - $p$ 必须**严格为正**且局部绝对连续（否则 $\nabla\log p$ 无定义，$p\,\partial_i\log p=\partial_ip$ 这一步无意义）；
> - **紧支撑是致命的**。若 $\mathrm{supp}\,p=\overline\Omega$ 且 $p$ 在 $\partial\Omega$ 处不高阶消失，边界项 $\int_{\partial\Omega}p\langle s,\nu\rangle\mathrm{d}S$ 存活，**定理是假的**。

**于是**：真实数据（图像、分子构型）通常支撑在低维流形上，$\nabla\log p$ **根本不存在**。Hyvärinen 的恒等式在那里没有意义。这不是保守的技术条件，是真正的障碍。

**第二个问题：经验版本退化.** $\sum_i\partial_is_i$ 对 $s$ 是**线性**的，只有 $n$ 个点约束它，于是在丰富的函数类上经验目标**无下界**。这就是为什么 Hyvärinen 式 score matching 只用于参数化的能量模型。

## 2. Vincent 的去噪恒等式：问题性质的改变

取一个光滑核 $q_\sigma(\tilde x\mid x)=\mathcal{N}(\tilde x;x,\sigma^2I)$，$q_\sigma(\tilde x)=\int q_\sigma(\tilde x\mid x)p(x)\mathrm{d}x$。

> **定理（Vincent 2011）.**
> $$\arg\min_s\ \mathbb{E}_{\tilde x\sim q_\sigma}\tfrac12\big\lVert s(\tilde x)-\nabla\log q_\sigma(\tilde x)\big\rVert^2\ =\ \arg\min_s\ \mathbb{E}_{x\sim p,\ \tilde x\sim q_\sigma(\cdot\mid x)}\tfrac12\big\lVert s(\tilde x)-\nabla_{\tilde x}\log q_\sigma(\tilde x\mid x)\big\rVert^2,$$
> 两边相差一个与 $s$ 无关的常数。高斯核下 $\nabla_{\tilde x}\log q_\sigma(\tilde x\mid x)=-(\tilde x-x)/\sigma^2$。

**证明（完整，只有交叉项要算）：**
$$\mathbb{E}_{q_\sigma}\big\langle s(\tilde x),\nabla\log q_\sigma(\tilde x)\big\rangle=\int\big\langle s(\tilde x),\nabla_{\tilde x}q_\sigma(\tilde x)\big\rangle\mathrm{d}\tilde x=\iint p(x)q_\sigma(\tilde x\mid x)\big\langle s(\tilde x),\nabla_{\tilde x}\log q_\sigma(\tilde x\mid x)\big\rangle\mathrm{d}x\,\mathrm{d}\tilde x .$$
用的只是"微分与积分交换"（高斯核下自动成立）与 Fubini。

> [!tip] 这一步为什么是本质的
> **没有分部积分。**于是 §1 的全部边界/衰减病态被**磨光核抹掉了**：恒等式对**任意** $p$ 成立——紧支撑的、流形上的、奇异的、甚至经验测度 $\widehat p_n$。
>
> 这正是扩散模型能在图像上训练而 Hyvärinen score matching 不能的原因。**光滑不是数值技巧，是把一个病态问题变成良态问题的正则化。**

## 3. 于是它是回归

对 VP 过程 $x_t=a_tx_0+\sigma_t\varepsilon$（$a_t=e^{-t}$，$\sigma_t^2=1-e^{-2t}$），去噪 score matching **就是**平方损失回归：

$$\min_s\ \mathbb{E}\big\lVert s(X_t)-Y_t\big\rVert^2,\qquad \text{协变量 } X_t,\quad \text{响应 } Y_t=-\frac{X_t-a_tX_0}{\sigma_t^2}=-\frac{\varepsilon}{\sigma_t} .$$

三条推论，全都是后面理论的支柱：

**(a) 贝叶斯预测器 $=$ 真 score，超额风险 $=$ Fisher 散度，精确相等。**
$$s^\star(x)=\mathbb{E}[Y_t\mid X_t=x]=\frac{a_t\,\mathbb{E}[X_0\mid X_t=x]-x}{\sigma_t^2}=\nabla\log q_t(x)\qquad\text{(Tweedie 公式)},$$
$$\mathbb{E}\lVert s(X_t)-Y_t\rVert^2-\mathbb{E}\lVert s^\star(X_t)-Y_t\rVert^2=\mathbb{E}_{q_t}\big\lVert s-\nabla\log q_t\big\rVert^2 .$$

> **这是一个等距，不是不等式。**训练损失的超额部分**就是** [[08 从 score 到样本：采样误差与最优率|08]] 里每条采样定理中的 $\varepsilon_{\text{score}}^2$。统计与分析在这一行接上。

**(b) 异方差.** $\mathrm{Var}(Y_t\mid X_t=x)=\sigma_t^{-4}a_t^2\operatorname{tr}\mathrm{Cov}(X_0\mid X_t=x)$，$t\downarrow0$ 时爆炸。这是三件实践的分析来源：损失的时间加权 $\lambda(t)$、**early stopping**（在 $t_0>0$ 停）、以及 $\epsilon$-参数化（$s_\theta=-\epsilon_\theta/\sigma_t$）。

**(c) ERM 退化（记忆化）.** 无约束地极小化**经验** DSM 风险，最优解是
$$\widehat s_t=\nabla\log\big(\widehat p_n*\mathcal{N}(0,\sigma_t^2I)\big),$$
其反向过程**精确复现训练样本**。

> [!warning] 相合性不是目标函数的性质
> 上面这条说明：**DSM 的一致性完全来自假设类或正则化，不来自损失。**生成模型"会不会背下训练集"因此是一个统计问题（一致收敛），不是一个损失设计问题。
>
> 这与 [[04 从轨迹学交互核：变分表述与可辨识性|04]] 里的情况形成有趣对照：那里的病根是**算子不适定**（正规算子紧），这里的病根是**类太大**（无一致大数律）。两种"需要正则化"的理由完全不同，不要混为一谈。

**切片 score matching**（Song–Garg–Shi–Ermon, UAI 2019）用随机方向替代 $\operatorname{tr}\nabla s$，把 $O(d)$ 次反传降到 $O(1)$。但它**继承了 §1 的分部积分条件**，没有修好那个病——只解决了计算问题。

## 4. 最小最大率

现在可以问 [[P2 非参数回归与最小最大率|P2]] 的问题：估 score 有多难？

> **定理（Wibisono–Wu–Yang, COLT 2024）.** 设 $\mathcal{P}_{\alpha,L}$ 是 $\R^d$ 上 $\alpha$-次高斯、全支撑、score $L$-Lipschitz 的分布类，损失 $\lVert\widehat s-s^\star\rVert^2_{L^2(\rho^\star)}$。则**正则化核密度 score 估计量**
> $$\widehat s^\varepsilon_h(x)=\frac{\nabla\widehat\rho_h(x)}{\max(\widehat\rho_h(x),\varepsilon)},\qquad \widehat\rho_h=\tfrac1n\sum_i\mathcal{N}(X_i,hI_d),$$
> 满足 $\mathbb{E}\lVert\widehat s^\varepsilon_h-s^\star\rVert^2_{L^2(\rho^\star)}\lesssim d\,\alpha^2L^2(\log n)^{\frac{d}{d+4}}n^{-\frac{2}{d+4}}$；对 $\beta$-Hölder score（$0<\beta\le1$）为 $n^{-\frac{2\beta}{d+2\beta+2}}$。
>
> **并且有匹配的下界**：$\inf_{\widehat s}\sup_{\mathcal{P}_{\alpha,L}}\mathbb{E}\,\ell\ \gtrsim\ c(d,\alpha)\,n^{-2/(d+4)}$。

**指数的账.** $\frac{2\beta}{d+2\beta+2}$ 恰是在 $\R^d$ 上估计密度的**一阶导数**的最小最大率（$n^{-2\beta/(2\beta+d+2)}$，比估密度本身多损失 2）。于是：

> **估 score 与估 $\nabla p$ 一样难——一个多项式率的问题。**

> [!tip] 这一句是本篇的核心判断
> 与它相邻的问题是**反卷积**：从 $p_0*\mathcal{N}(0,tI)$ 恢复 $p_0$。那是**严重不适定**的，率只有对数级。
>
> 高斯磨光让反卷积变难，却让 **score 估计变容易**：磨光后的测度的 score 是数据的一个光滑、非退化的泛函。**这是"score 估计是良态的"最干净的形式化。**
>
> 注意这与 [[P3 RKHS 与不适定逆问题的正则化|P3]] 的整套机器形成对照：那里正规算子紧、要源条件、有饱和、要选正则化参数。**这里正规算子是恒等，什么都不需要。**这就是为什么扩散模型的理论比逆问题的理论干净得多。

**$t\downarrow0$ 处的退化.** [Zhang–Yin–Liang–Liu, ICML 2024](https://arxiv.org/abs/2402.15602) 在**仅次高斯**（无密度下界、无紧支撑）下给出
$$\mathbb{E}\int\lVert\widehat s_t-s_t\rVert^2p_t\ \lesssim\ \mathrm{polylog}(n)\;n^{-1}\,t^{-\frac{d+2}{2}}\big(t^{d/2}+\sigma_0^d\big).$$
$t^{-(d+2)/2}$ 把"小 $t$ 更难"量化了，**并且直接给出最优的 early stopping 时刻**：把它与总误差平衡即得 $t_0\asymp n^{-2/(2\beta+d)}$。

## 5. 与"RKHS 里的 score matching"的对照

值得单独一节，因为它说明"良态"不是 score 这个对象的性质，而是**去噪**这个操作的性质。

**Sriperumbudur 等（JMLR 2017）**在无穷维指数族 $p_f\propto e^fp_0$（$f\in\mathcal{H}$ 是 RKHS）里做 Hyvärinen score matching。Fisher 散度是 $\mathcal{H}$ 上的二次泛函，取 Fréchet 导数为零给出**线性算子方程**
$$Cf=-\xi,\qquad C=\mathbb{E}\Big[\sum_i\partial_ik(\cdot,X)\otimes\partial_ik(\cdot,X)\Big].$$
$C$ 正、自伴、**Hilbert–Schmidt（紧）** $\Rightarrow$ $C^{-1}$ 无界 $\Rightarrow$ **Hadamard 意义下不适定**。他们的估计量正是 Tikhonov 正则化
$$f_{\lambda,n}=-(\widehat C+\lambda I)^{-1}\widehat\xi,$$
在源条件 $f_0\in\mathcal{R}(C^\beta)$ 下给出率，且**在 $\beta=1$ 处饱和**（$\mathcal{H}$-范数下卡在 $n^{-1/4}$，Fisher 散度下卡在 $n^{-2/3}$）。

> [!note] 这是 [[P3 RKHS 与不适定逆问题的正则化|P3]] 的教科书式实例
> 紧算子、源条件、Tikhonov、饱和——**一个不落**。
>
> 于是这门课里出现了同一个统计量的两种命运：
>
> | | Hyvärinen SM（RKHS 里） | Denoising SM（固定 $t>0$） |
> |---|---|---|
> | 正规算子 | 紧，$C^{-1}$ 无界 | 恒等 |
> | 适定性 | 不适定 | 良态 |
> | 需要正则化 | 是（Tikhonov，有饱和） | 只需限制假设类 |
> | 率 | $n^{-\min\{1/4,\ \beta/(2\beta+2)\}}$（$\mathcal{H}$ 范数） | $n^{-2\beta/(d+2\beta+2)}$，最小最大最优 |
>
> **区别不在 score，在有没有磨光。**

## 6. Fisher 散度的盲点与它如何被修复

单一噪声水平的 Fisher 散度有一个结构性缺陷：**它看不见模态之间的相对质量。**

把质量 $\frac12\pm\eta$ 放在两个相距很远的凸包上：两个分布的 score **几乎处处相同**（每个凸包内部的 $\nabla\log p$ 不依赖该凸包的总质量），但 TV 距离是 $2\eta$。**Fisher 散度小 $\ne$ 分布接近。**

**精确的刻画是等周常数.** Fisher 散度是一个 Dirichlet 形式，而 Poincaré / 对数 Sobolev 不等式恰是"Dirichlet 形式控制方差 / 相对熵"的陈述：
$$\mathrm{Var}_q(g)\le C_{\mathrm{P}}(q)\,\mathbb{E}_q\lVert\nabla g\rVert^2,\qquad \mathrm{KL}(p\Vert q)\le\tfrac{C_{\mathrm{LSI}}(q)}{2}\,\mathcal{I}(p\Vert q).$$
所以 $C_{\mathrm{P}},C_{\mathrm{LSI}}$ **就是**映射"score 误差 $\mapsto$ 分布误差"的连续模。多模态且势垒高的分布，这些常数指数大。这是 [Koehler–Heckett–Risteski (ICLR 2023)](https://arxiv.org/abs/2210.00726) 的内容：score matching 相对 MLE 的渐近效率由等周常数控制。

> [!tip] 扩散模型正是修这个的
> 反向 SDE 的分析（[[08 从 score 到样本：采样误差与最优率|08]]）**从不假设 $q_0$ 满足任何泛函不等式**。它用的不是**一个** Fisher 散度，而是沿 OU 半群的**一整族** $\{\mathcal{I}_t\}_{t\in[t_0,T]}$，Girsanov 把 $\int_{t_0}^T\varepsilon^2_{\text{score}}(t)\mathrm{d}t$ 直接换成路径测度的 KL。唯一用到的泛函不等式是**高斯的 LSI**（用在 $t=T$ 的初始化上）。
>
> **多尺度 score matching 是单尺度病态问题的预条件子。**这是为什么可以把对数凹性、等周、单峰性等假设全部丢掉。

## 7. 一页速查

| 结论 | 内容 |
|---|---|
| Hyvärinen 恒等式 | $J(s)=\mathbb{E}[\operatorname{div}s+\frac12\lVert s\rVert^2]+c$；要 $ps\in W^{1,1}$，**紧支撑时假** |
| Vincent 恒等式 | 去噪版本，**无分部积分**，对任意 $p$ 成立 |
| 回归形式 | 协变量 $X_t$，响应 $-(X_t-a_tX_0)/\sigma_t^2$ |
| Tweedie | $\nabla\log q_t(x)=(a_t\mathbb{E}[X_0\mid X_t=x]-x)/\sigma_t^2$ |
| 超额风险 | $=$ Fisher 散度，**精确相等** |
| 异方差 | $\mathrm{Var}(Y_t\mid X_t)\sim\sigma_t^{-4}$；给出加权与 early stopping |
| ERM 退化 | 经验最优解 $=$ 记忆训练集；相合性来自假设类 |
| 最小最大率 | $n^{-2\beta/(d+2\beta+2)}$，$=$ 估 $\nabla p$ 的率，有匹配下界 |
| 小 $t$ | 常数发散 $t^{-(d+2)/2}$ |
| 良态 vs 不适定 | DSM 良态（正规算子 $=$ 恒等）；RKHS 里的 Hyvärinen SM 不适定（紧算子，有饱和） |
| Fisher 散度的盲点 | 看不见模态相对质量；连续模 $=$ 等周常数 |
| 修法 | 多尺度 $+$ Girsanov，见 08 |

## 参考

- Hyvärinen, *Estimation of non-normalized statistical models by score matching*, JMLR **6** (2005) 695–709.
- Vincent, *A connection between score matching and denoising autoencoders*, Neural Comput. **23** (2011) 1661–1674.
- Song, Garg, Shi, Ermon, *Sliced score matching*, UAI 2019; [arXiv:1905.07088](https://arxiv.org/abs/1905.07088).
- [Wibisono, Wu, Yang, *Optimal score estimation via empirical Bayes smoothing*](https://proceedings.mlr.press/v247/wibisono24a/wibisono24a.pdf), COLT 2024; [arXiv:2402.07747](https://arxiv.org/abs/2402.07747).
- Zhang, Yin, Liang, Liu, *Minimax optimality of score-based diffusion models: beyond the density lower bound assumptions*, ICML 2024; [arXiv:2402.15602](https://arxiv.org/abs/2402.15602).
- [Sriperumbudur, Fukumizu, Gretton, Hyvärinen, Kumar, *Density estimation in infinite dimensional exponential families*](https://arxiv.org/abs/1312.3516), JMLR **18** (2017) 1–59.
- Koehler, Heckett, Risteski, *Statistical efficiency of score matching: the view from isoperimetry*, ICLR 2023; [arXiv:2210.00726](https://arxiv.org/abs/2210.00726).
- Gu, Zhai, Zhang, Liu, Susskind, *On memorization in diffusion models*; [arXiv:2310.02664](https://arxiv.org/abs/2310.02664).

## Related

- [[index|科学基础模型的数学]]
- [[08 从 score 到样本：采样误差与最优率]]
- [[P2 非参数回归与最小最大率]]
- [[P3 RKHS 与不适定逆问题的正则化]]
- [[notes/deep-learning/17 扩散模型与 flow matching|DL 17 扩散模型与 flow matching]]
