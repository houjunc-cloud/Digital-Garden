---
title: A 概率与统计不等式手册
description: 把这套笔记里用到的每一条概率统计不等式集中证一遍，并标出它们的依赖关系。
tags:
  - deep-learning
  - probability
  - appendix
stage: 🌿 budding
date: 2026-08-14
---

# 附录 A：概率与统计不等式手册

前面 24 篇里散落着大量不等式：Jensen、Hoeffding、McDiarmid、Pinsker、Cramér–Rao、Talagrand 收缩、Maurey–Barron……这一页把它们集中证一遍。

> [!tip] 集中起来才看得见的事
> **这些不等式的源头只有四个：**
>
> 1. **凸性**（Jensen）→ 几乎所有信息论不等式、Cramér–Rao 的一半、$f$-散度的全部性质；
> 2. **Markov 不等式 + 矩母函数**（Chernoff 方法）→ 全部指数尾界（Hoeffding、Bernstein、Azuma、McDiarmid）；
> 3. **Cauchy–Schwarz / Hilbert 空间几何** → Cramér–Rao、Maurey–Barron、方差分解；
> 4. **对偶**（Fenchel、Kantorovich、Donsker–Varadhan）→ 把"求一个数"变成"对函数取上确界"，于是可优化。
>
> 剩下的都是这四条的组合与技术性加工。记住这个结构比记住任何一条具体的不等式有用。

**记号.** $(\Omega,\mathcal{F},\mathbb{P})$ 为概率空间；$X,Y,Z$ 为随机变量；$P,Q$ 为概率测度；$\log$ 默认自然对数（信息论章节会显式标注 $\log_2$）；$\mathbb{E}$ 无下标时对全部随机性取期望。

---

## A1. 凸性

### A1.1 Jensen 不等式

**命题.** 设 $\varphi$ 凸、$X$ 可积、$\varphi(X)$ 可积，则
$$\varphi\big(\mathbb{E}[X]\big)\ \le\ \mathbb{E}\big[\varphi(X)\big].$$
$\varphi$ 严格凸时等号成立当且仅当 $X$ a.s. 为常数。

*证明.* 凸函数在任一点有支撑超平面：存在 $c$ 使 $\varphi(x)\ge\varphi(\mu)+c(x-\mu)$ 对所有 $x$ 成立，其中 $\mu=\mathbb{E}X$（$c$ 取 $\varphi$ 在 $\mu$ 的任一次梯度）。代入 $x=X$ 取期望，右端的线性项期望为 0。$\square$

**条件版本.** $\varphi(\mathbb{E}[X\mid\mathcal{G}])\le\mathbb{E}[\varphi(X)\mid\mathcal{G}]$ a.s.，证明相同。

> **用在哪**：[[03 信息论]] 的 Gibbs 不等式与熵上界、[[15 变分自编码器]] 的 ELBO、[[20 值函数方法]] 的 $\max$ 过估计偏差、[[04 统计推断]] 的 MLE 相合性。

### A1.2 $\mathbb{E}[\max]\ \ge\ \max\mathbb{E}$

**命题.** $\mathbb{E}\big[\max_{a} X_a\big]\ \ge\ \max_a\mathbb{E}[X_a]$。

*证明.* $x\mapsto\max_a x_a$ 是凸的（有限多个线性函数的上确界），用 A1.1。或者更直接：对每个固定 $a_0$，$\max_a X_a\ge X_{a_0}$，取期望后对 $a_0$ 取最大。$\square$

> **用在哪**：[[20 值函数方法]] §4 的 **Q-learning 过估计偏差**。用含噪的 $\hat Q$ 取 $\max$ 会系统性高估，这正是 Double DQN 要修的。**注意这个偏差与噪声的大小同阶，不是小量。**

### A1.3 Cauchy–Schwarz 与 Hölder

**Cauchy–Schwarz.** $\big|\mathbb{E}[XY]\big|\le\sqrt{\mathbb{E}[X^2]\,\mathbb{E}[Y^2]}$。

*证明.* 对任意 $t\in\R$，$0\le\mathbb{E}[(X-tY)^2]=\mathbb{E}X^2-2t\mathbb{E}[XY]+t^2\mathbb{E}Y^2$。这是关于 $t$ 的非负二次式，判别式 $\le0$。$\square$

**Hölder.** $\frac1p+\frac1q=1$，$p,q>1$：$\mathbb{E}|XY|\le(\mathbb{E}|X|^p)^{1/p}(\mathbb{E}|Y|^q)^{1/q}$。

*证明.* 归一化使两个范数为 1，然后用 **Young 不等式** $ab\le\frac{a^p}{p}+\frac{b^q}{q}$（由 $\log$ 的凹性：$\log(\frac{a^p}{p}+\frac{b^q}{q})\ge\frac1p\log a^p+\frac1q\log b^q=\log(ab)$）逐点放缩再取期望。$\square$

> **用在哪**：[[04 统计推断]] 的 Cramér–Rao 下界、[[13 系统与工程]] 的 MoE 负载均衡（$\sum f_iP_i$ 在均衡时最小）。

### A1.4 Fenchel–Young 与凸共轭

**定义.** $f^*(y):=\sup_x\{\langle x,y\rangle-f(x)\}$。

**Fenchel–Young 不等式.** $\langle x,y\rangle\le f(x)+f^*(y)$，等号当且仅当 $y\in\partial f(x)$。

*证明.* 直接由 $f^*$ 的定义（上确界 $\ge$ 任一取值）。$\square$

> **用在哪**：[[03 信息论]] 的 $f$-散度变分表示 $D_f(P\Vert Q)=\sup_T\{\mathbb{E}_P[T]-\mathbb{E}_Q[f^*(T)]\}$，也就是 $f$-GAN 的一般框架（[[16 生成对抗网络]]）。

### A1.5 log-sum 不等式

**命题.** 对非负数 $a_i,b_i$，
$$\sum_i a_i\log\frac{a_i}{b_i}\ \ge\ \Big(\sum_i a_i\Big)\log\frac{\sum_i a_i}{\sum_i b_i}.$$

*证明.* 令 $B=\sum b_j$，$\lambda_i=b_i/B$（一个概率分布），$t_i=a_i/b_i$。函数 $\varphi(t)=t\log t$ 凸，由 Jensen
$$\sum_i\lambda_i\varphi(t_i)\ \ge\ \varphi\Big(\sum_i\lambda_it_i\Big).$$
左边 $=\frac1B\sum a_i\log\frac{a_i}{b_i}$，右边 $=\varphi(\frac{\sum a_i}{B})$。两边乘 $B$ 即得。$\square$

> 这是 **KL 散度全部基本性质的技术引擎**：非负性、联合凸性、数据处理不等式都可以由它一行推出。

---

## A2. 集中不等式

**这一节的全部内容都是同一个套路（Chernoff 方法）：**
$$\text{控制矩母函数 }\mathbb{E}e^{\lambda X}\ \longrightarrow\ \text{Markov}\ \longrightarrow\ \text{优化 }\lambda\ \longrightarrow\ \text{指数尾界}.$$

### A2.1 Markov 与 Chebyshev

**Markov.** $X\ge0$，则 $\Pr[X\ge t]\le\dfrac{\mathbb{E}X}{t}$。

*证明.* $t\,\mathbf{1}[X\ge t]\le X$ 逐点成立，取期望。$\square$

**Chebyshev.** $\Pr\big[|X-\mathbb{E}X|\ge t\big]\le\dfrac{\mathrm{Var}(X)}{t^2}$。

*证明.* 对 $(X-\mathbb{E}X)^2$ 用 Markov。$\square$

> 只有 $O(1/t^2)$ 的衰减——**太弱**。下面所有工作都是为了把它换成 $e^{-ct^2}$。

### A2.2 Chernoff 方法

**命题.** 对任意 $\lambda>0$，$\Pr[X\ge t]\le e^{-\lambda t}\,\mathbb{E}\big[e^{\lambda X}\big]$，于是
$$\Pr[X\ge t]\ \le\ \inf_{\lambda>0}e^{-\lambda t}\mathbb{E}\big[e^{\lambda X}\big]\ =\ e^{-\Lambda^*(t)},\qquad \Lambda^*(t)=\sup_\lambda\{\lambda t-\log\mathbb{E}e^{\lambda X}\}.$$

*证明.* $\Pr[X\ge t]=\Pr[e^{\lambda X}\ge e^{\lambda t}]\le e^{-\lambda t}\mathbb{E}e^{\lambda X}$（Markov）。$\square$

> $\Lambda^*$ 是对数矩母函数的 **Fenchel 共轭**（A1.4）——**大偏差理论的 Cramér 定理就是说这个界在指数阶上是紧的**。这也是 [[05 优化的数学]] 里 Kramers 逃逸时间公式 $\sim e^{2\Delta/(\eta\sigma^2)}$ 的来源。

### A2.3 次高斯变量

**定义.** $X$ 是 $\sigma^2$-**次高斯**的，若 $\mathbb{E}e^{\lambda(X-\mathbb{E}X)}\le e^{\lambda^2\sigma^2/2}$ 对所有 $\lambda\in\R$。

**推论（尾界）.** $\Pr[X-\mathbb{E}X\ge t]\le e^{-t^2/(2\sigma^2)}$。

*证明.* Chernoff 加上定义，取 $\lambda=t/\sigma^2$。$\square$

**推论（最大值界）.** 若 $X_1,\dots,X_N$ 各自 $\sigma^2$-次高斯（**不需要独立**），零均值，则
$$\mathbb{E}\Big[\max_{i\le N}X_i\Big]\ \le\ \sigma\sqrt{2\log N}.$$

*证明.* 对任意 $\lambda>0$，
$$e^{\lambda\,\mathbb{E}\max_iX_i}\ \overset{\text{Jensen}}{\le}\ \mathbb{E}e^{\lambda\max_iX_i}=\mathbb{E}\max_ie^{\lambda X_i}\le\sum_{i}\mathbb{E}e^{\lambda X_i}\le Ne^{\lambda^2\sigma^2/2}.$$
取对数除以 $\lambda$：$\mathbb{E}\max_iX_i\le\frac{\log N}{\lambda}+\frac{\lambda\sigma^2}{2}$，在 $\lambda=\sqrt{2\log N}/\sigma$ 处最优。$\square$

> [!note] $\sqrt{\log N}$ 这个量出现得极其频繁
> 它是 [[01 学习问题的数学表述]] 里 **Massart 有限类引理**（A5.2）的全部内容，也是"有限假设类的泛化间隙是 $\sqrt{\log N/n}$"的来源。**"$N$ 个东西的最大值只比单个大 $\sqrt{\log N}$ 倍"是高维概率里最有用的直觉之一**——它解释了为什么并集界（union bound）在指数多个事件上仍然可用。

### A2.4 Popoviciu 与 Hoeffding 引理

**Popoviciu.** $X\in[a,b]$ 则 $\mathrm{Var}(X)\le\frac{(b-a)^2}{4}$。

*证明.* $\mathrm{Var}(X)=\min_c\mathbb{E}(X-c)^2\le\mathbb{E}\big(X-\tfrac{a+b}{2}\big)^2\le\big(\tfrac{b-a}{2}\big)^2$。$\square$

**Hoeffding 引理.** $X\in[a,b]$ 且 $\mathbb{E}X=0$，则 $X$ 是 $\frac{(b-a)^2}{4}$-次高斯的：
$$\mathbb{E}\big[e^{\lambda X}\big]\ \le\ \exp\Big(\frac{\lambda^2(b-a)^2}{8}\Big).$$

*证明.* 令 $\psi(\lambda)=\log\mathbb{E}e^{\lambda X}$。定义**倾斜测度** $d\mathbb{P}_\lambda=\frac{e^{\lambda X}}{\mathbb{E}e^{\lambda X}}d\mathbb{P}$，直接计算给出
$$\psi'(\lambda)=\mathbb{E}_{\mathbb{P}_\lambda}[X],\qquad \psi''(\lambda)=\mathrm{Var}_{\mathbb{P}_\lambda}(X).$$
在 $\mathbb{P}_\lambda$ 下 $X$ 仍取值于 $[a,b]$，故由 Popoviciu $\psi''\le\frac{(b-a)^2}{4}$。又 $\psi(0)=0$、$\psi'(0)=\mathbb{E}X=0$，Taylor 带余项：
$$\psi(\lambda)=\psi(0)+\lambda\psi'(0)+\tfrac{\lambda^2}{2}\psi''(\xi)\le\frac{\lambda^2(b-a)^2}{8}.\qquad\square$$

### A2.5 Hoeffding 不等式

**定理.** $X_1,\dots,X_n$ 独立，$X_i\in[a_i,b_i]$，$S=\sum_iX_i$。则
$$\Pr\big[S-\mathbb{E}S\ \ge\ t\big]\ \le\ \exp\Big(-\frac{2t^2}{\sum_i(b_i-a_i)^2}\Big).$$

*证明.* 由独立性 $\mathbb{E}e^{\lambda(S-\mathbb{E}S)}=\prod_i\mathbb{E}e^{\lambda(X_i-\mathbb{E}X_i)}\le\exp\big(\frac{\lambda^2}{8}\sum_i(b_i-a_i)^2\big)$（Hoeffding 引理）。即 $S$ 是 $\frac14\sum(b_i-a_i)^2$-次高斯的，用 A2.3 的尾界。$\square$

**特例（同分布、$[0,1]$ 取值）.** $\Pr[|\bar X-\mu|\ge t]\le2e^{-2nt^2}$，即 $\bar X$ 以 $1-\delta$ 概率落在 $\mu\pm\sqrt{\frac{\log(2/\delta)}{2n}}$ 内。

> **用在哪**：[[01 学习问题的数学表述]] 的一致收敛界、[[04 统计推断]] 的 PAC-Bayes 界、以及任何"用样本均值估计期望"的误差分析。

### A2.6 Bernstein 不等式

**定理.** $X_i$ 独立、零均值、$|X_i|\le M$、$\sum_i\mathbb{E}X_i^2=v$。则
$$\Pr\Big[\sum_iX_i\ge t\Big]\ \le\ \exp\Big(-\frac{t^2/2}{v+Mt/3}\Big).$$

*证明梗概.* 关键是对矩母函数的更精细的界：用 $e^x\le1+x+\frac{x^2}{2}\cdot\frac{1}{1-x/3}$（$x<3$）逐项展开，
$$\mathbb{E}e^{\lambda X_i}\le\exp\Big(\frac{\lambda^2\mathbb{E}X_i^2/2}{1-\lambda M/3}\Big),$$
乘起来后 Chernoff 优化 $\lambda$。$\square$

> **为什么值得单列**：Hoeffding 只用范围 $M$，Bernstein 同时用方差 $v$。当 $v\ll M^2$（**低方差但偶有大值**）时 Bernstein 强得多——小 $t$ 时给出 $e^{-t^2/2v}$ 的高斯型尾，大 $t$ 时退化为 $e^{-3t/2M}$ 的指数型尾。**这正是深度学习梯度的典型形态**（大多数样本梯度很小，少数异常样本梯度巨大），也是梯度裁剪有效的统计学解释。

### A2.7 Efron–Stein 方差不等式

**定理.** $X_1,\dots,X_n$ 独立，$f:\prod\mathcal{X}_i\to\R$。设 $X'_i$ 是 $X_i$ 的独立副本，$X^{(i)}=(X_1,\dots,X'_i,\dots,X_n)$。则
$$\mathrm{Var}\big(f(X)\big)\ \le\ \frac12\sum_{i=1}^n\mathbb{E}\Big[\big(f(X)-f(X^{(i)})\big)^2\Big].$$

*证明.* 令 $\mathcal{F}_i=\sigma(X_1,\dots,X_i)$，$\Delta_i=\mathbb{E}[f\mid\mathcal{F}_i]-\mathbb{E}[f\mid\mathcal{F}_{i-1}]$（Doob 鞅差）。则 $f-\mathbb{E}f=\sum_i\Delta_i$，且 $\{\Delta_i\}$ 两两正交（对 $i<j$，$\mathbb{E}[\Delta_i\Delta_j]=\mathbb{E}[\Delta_i\mathbb{E}[\Delta_j\mid\mathcal{F}_i]]=0$），故
$$\mathrm{Var}(f)=\sum_i\mathbb{E}[\Delta_i^2].$$
再对每项用条件 Jensen 与 $X_i,X_i'$ 的可交换性即得。$\square$

> **这是"方差的张量化"**：整体的波动被单坐标扰动的波动之和控制。McDiarmid（A2.9）是它的指数版本。

### A2.8 Azuma–Hoeffding

**定理.** $\{M_k\}$ 是鞅，差 $D_k=M_k-M_{k-1}$ 满足 $|D_k|\le c_k$ a.s.。则
$$\Pr\big[M_n-M_0\ge t\big]\ \le\ \exp\Big(-\frac{t^2}{2\sum_kc_k^2}\Big).$$

*证明.* 对 $\mathbb{E}[e^{\lambda D_k}\mid\mathcal{F}_{k-1}]$ 用 **条件版的 Hoeffding 引理**（$D_k$ 条件于 $\mathcal{F}_{k-1}$ 时零均值且落在长度 $2c_k$ 的区间内）得 $\le e^{\lambda^2c_k^2/2}$。逐层取条件期望（塔性质）把乘积拆开：
$$\mathbb{E}e^{\lambda(M_n-M_0)}=\mathbb{E}\Big[e^{\lambda(M_{n-1}-M_0)}\,\mathbb{E}[e^{\lambda D_n}\mid\mathcal{F}_{n-1}]\Big]\le e^{\lambda^2c_n^2/2}\,\mathbb{E}e^{\lambda(M_{n-1}-M_0)},$$
归纳后 Chernoff。$\square$

> 注意这里**不需要独立性**，只需要鞅结构。这是它比 Hoeffding 适用面广的原因。

### A2.9 McDiarmid（有界差分不等式）

**定理.** $X_1,\dots,X_n$ 独立，$f$ 满足**有界差分条件**：改动第 $i$ 个坐标至多改变 $f$ 的值 $c_i$，即
$$\sup_{x_1..x_n,\,x_i'}\big|f(x_1,..,x_i,..,x_n)-f(x_1,..,x_i',..,x_n)\big|\ \le\ c_i.$$
则
$$\Pr\big[f(X)-\mathbb{E}f(X)\ \ge\ t\big]\ \le\ \exp\Big(-\frac{2t^2}{\sum_ic_i^2}\Big).$$

*证明.* 取 Doob 鞅 $M_k=\mathbb{E}[f\mid X_1,\dots,X_k]$（$M_0=\mathbb{E}f$，$M_n=f$）。有界差分条件保证鞅差 $D_k=M_k-M_{k-1}$ 落在一个长度 $\le c_k$ 的（依赖 $\mathcal{F}_{k-1}$ 的）区间内，故条件 Hoeffding 引理给 $\mathbb{E}[e^{\lambda D_k}\mid\mathcal{F}_{k-1}]\le e^{\lambda^2c_k^2/8}$。其余同 Azuma。$\square$

> [!tip] 这条是学习理论里最有用的工具
> 它把"函数值的集中"从 $f=$ 求和推广到 **$f=$ 任何对单个样本不敏感的统计量**。[[01 学习问题的数学表述]] §2.1 用它控制 $\sup_{f\in\mathcal{F}}|R(f)-\widehat R_S(f)|$——这个上确界不是求和，Hoeffding 用不上，但它显然满足有界差分（改一个样本只影响 $1/n$ 的经验风险）。
>
> [[01 学习问题的数学表述]] §5 的**算法稳定性**也是同一个思想：$\beta$-均匀稳定 $\Rightarrow$ 泛化，因为稳定就是有界差分。

---

## A3. 信息论不等式

**约定.** 本节 $\log$ 为自然对数（换 $\log_2$ 只差常数）。$D(P\Vert Q):=\mathbb{E}_P[\log\frac{dP}{dQ}]$。

### A3.1 Gibbs 不等式（$D_{\mathrm{KL}}\ge0$）

**命题.** $D(P\Vert Q)\ge0$，等号当且仅当 $P=Q$ a.e.

*证明.* $-D(P\Vert Q)=\mathbb{E}_P\big[\log\frac{dQ}{dP}\big]\le\log\mathbb{E}_P\big[\frac{dQ}{dP}\big]=\log Q(\mathrm{supp}\,P)\le\log1=0$，用 Jensen 与 $\log$ 的严格凹性。等号要求 $\frac{dQ}{dP}$ a.s. 为常数，即 $P=Q$。$\square$

> **用在哪**：无处不在。[[04 统计推断]] 的 MLE 相合性（$D(p_{\theta_0}\Vert p_\theta)$ 在真值处唯一最小）、[[15 变分自编码器]] 的 ELBO 是下界、[[22 RLHF 与推理 RL]] 的 KL 约束目标闭式解。

### A3.2 $f$-散度的非负性与联合凸性

设 $f$ 凸、$f(1)=0$，$D_f(P\Vert Q)=\int f(\frac{dP}{dQ})dQ$。

**非负性.** $D_f(P\Vert Q)\ \ge\ f\big(\int\frac{dP}{dQ}dQ\big)=f(1)=0$（Jensen）。$\square$

**联合凸性.** $(P,Q)\mapsto D_f(P\Vert Q)$ 是联合凸的。

*证明.* 关键是**透视函数**（perspective）$g(p,q):=q\,f(p/q)$ 在 $q>0$ 上联合凸——这是凸分析的标准事实（$g$ 的上图是 $f$ 的上图的锥化）。逐点积分保持凸性。$\square$

### A3.3 数据处理不等式（DPI）

**定理.** 设 $K$ 是 Markov 核（随机映射）。则 $D_f(KP\Vert KQ)\le D_f(P\Vert Q)$。

*证明（KL 情形，用链式法则）.* 设 $X\sim P$、$Y\mid X\sim K$，联合分布记 $P_{XY}$；$Q_{XY}$ 同理（**同一个 $K$**）。KL 的链式法则给出两种分解：
$$D(P_{XY}\Vert Q_{XY})=\underbrace{D(P_X\Vert Q_X)}_{}+\underbrace{\mathbb{E}_{P_X}D(K(\cdot|X)\Vert K(\cdot|X))}_{=0}=D(P_X\Vert Q_X),$$
$$D(P_{XY}\Vert Q_{XY})=D(P_Y\Vert Q_Y)+\underbrace{\mathbb{E}_{P_Y}D(P_{X|Y}\Vert Q_{X|Y})}_{\ge0}\ \ge\ D(P_Y\Vert Q_Y).$$
两式相比即得。一般 $f$-散度的情形用 A1.5 的 log-sum 型论证（或直接对 $f$ 用条件 Jensen）。$\square$

**互信息版本.** 若 $X\to Y\to Z$ 是 Markov 链，则 $I(X;Z)\le I(X;Y)$。

> [!note] 这条定理的哲学
> **"处理数据不能创造信息。"**它是信息论里最像范畴论的一条：$D_f$ 是从"测度对"到 $\R_{\ge0}$ 的一个在 Markov 核作用下单调的函子性量。
>
> **用在哪**：[[03 信息论]]、Pinsker 的证明（A3.4）、[[08 泛化之谜]] 里对信息瓶颈假说的讨论。

### A3.4 Pinsker 不等式

**定理.** $\mathrm{TV}(P,Q)\ \le\ \sqrt{\tfrac12 D(P\Vert Q)}$，其中 $\mathrm{TV}(P,Q)=\sup_A|P(A)-Q(A)|$。

*证明.* **第一步：二元情形。** 设 $p,q\in(0,1)$，定义
$$h(q):=p\log\frac pq+(1-p)\log\frac{1-p}{1-q}-2(p-q)^2 .$$
则 $h(p)=0$，且
$$h'(q)=-\frac pq+\frac{1-p}{1-q}+4(p-q)=\frac{q-p}{q(1-q)}-4(q-p)=(q-p)\Big(\frac{1}{q(1-q)}-4\Big).$$
由于 $q(1-q)\le\frac14$，括号 $\ge0$。故 $q>p$ 时 $h'\ge0$、$q<p$ 时 $h'\le0$：$h$ 在 $q=p$ 取最小值 $0$。于是
$$D\big(\mathrm{Bern}(p)\,\Vert\,\mathrm{Bern}(q)\big)\ \ge\ 2(p-q)^2 .$$

**第二步：一般情形归约到二元。** 取 $A$ 使 $|P(A)-Q(A)|=\mathrm{TV}(P,Q)$（例如 $A=\{\frac{dP}{dQ}>1\}$）。映射 $x\mapsto\mathbf{1}[x\in A]$ 是一个（确定性的）Markov 核，由 DPI（A3.3）
$$D(P\Vert Q)\ \ge\ D\big(\mathrm{Bern}(P(A))\,\Vert\,\mathrm{Bern}(Q(A))\big)\ \ge\ 2\,\mathrm{TV}(P,Q)^2.\qquad\square$$

> **用在哪**：[[21 策略梯度方法]] §4 把 TRPO 的性能差界从 TV 换成 KL（因为 KL 可采样估计而 TV 不能）——**这一步换算就是 Pinsker**。

### A3.5 Donsker–Varadhan 变分表示

**定理.** $P\ll Q$ 时
$$D(P\Vert Q)\ =\ \sup_{T}\Big\{\mathbb{E}_P[T]-\log\mathbb{E}_Q\big[e^{T}\big]\Big\},$$
上确界取遍使两个期望有限的可测 $T$，在 $T^\star=\log\frac{dP}{dQ}$（差常数）处达到。

*证明.* 对任意可行 $T$，定义 Gibbs 测度 $\frac{dQ_T}{dQ}:=\frac{e^T}{\mathbb{E}_Q e^T}$。直接展开：
$$D(P\Vert Q_T)=\mathbb{E}_P\Big[\log\frac{dP}{dQ}\Big]-\mathbb{E}_P\Big[\log\frac{dQ_T}{dQ}\Big]=D(P\Vert Q)-\mathbb{E}_P[T]+\log\mathbb{E}_Q e^T .$$
由 Gibbs 不等式 $D(P\Vert Q_T)\ge0$，得 $\mathbb{E}_P[T]-\log\mathbb{E}_Qe^T\le D(P\Vert Q)$，且取 $T=\log\frac{dP}{dQ}$ 时 $Q_T=P$、$D(P\Vert Q_T)=0$，等号成立。$\square$

**推论（PAC-Bayes 的引擎）.** 对任意 $\lambda>0$ 与可测 $\phi$，
$$\mathbb{E}_{Q'}[\phi]\ \le\ \frac{1}{\lambda}\Big(D(Q'\Vert P)+\log\mathbb{E}_{P}\big[e^{\lambda\phi}\big]\Big)\qquad\text{对所有 }Q'\ll P .$$

*证明.* 在定理中令 $P\to Q'$、$Q\to P$、$T=\lambda\phi$，移项。$\square$

> [!tip] 为什么这个恒等式在 ML 里到处出现
> 它把 KL（一个数）变成**关于函数的上确界**，于是可以用神经网络参数化 $T$ 并做 SGD。这是 MINE、InfoNCE、$f$-GAN 的共同底座（[[03 信息论]]），也是 [[04 统计推断]] §7 里 **PAC-Bayes 界的唯一非平凡步骤**——上面那个推论加上 Hoeffding 与 Markov 就得到完整的 PAC-Bayes 定理。

### A3.6 熵的基本不等式

设 $X$ 取值于有限集 $\mathcal{X}$。

**(a) 上界.** $H(X)\le\log|\mathcal{X}|$，等号当且仅当均匀。

*证明.* $\log|\mathcal{X}|-H(X)=D(P_X\Vert\mathrm{Unif})\ge0$。$\square$

**(b) 条件降熵.** $H(X\mid Y)\le H(X)$，等号当且仅当独立。

*证明.* $H(X)-H(X\mid Y)=I(X;Y)=D(P_{XY}\Vert P_X\otimes P_Y)\ge0$。$\square$

**(c) 次可加性.** $H(X_1,\dots,X_n)\le\sum_iH(X_i)$。

*证明.* 链式法则 $H(X_{1:n})=\sum_iH(X_i\mid X_{<i})$，逐项用 (b)。$\square$

**(d) 确定性函数不增熵.** $H(g(X))\le H(X)$。

*证明.* $H(X,g(X))=H(X)$（$g(X)$ 由 $X$ 决定），也 $=H(g(X))+H(X\mid g(X))\ge H(g(X))$。$\square$

**(e) Shearer 不等式.** 设 $\mathcal{S}$ 是 $[n]$ 的子集族，每个元素 $i\in[n]$ 至少被 $k$ 个 $S\in\mathcal{S}$ 覆盖。则
$$H(X_{[n]})\ \le\ \frac1k\sum_{S\in\mathcal{S}}H(X_S).$$

*证明.* 对每个 $S=\{i_1<\dots<i_m\}$，用链式法则与"多条件降熵"：
$$H(X_S)=\sum_{j}H(X_{i_j}\mid X_{i_1},..,X_{i_{j-1}})\ \ge\ \sum_{i\in S}H(X_i\mid X_{<i}),$$
（右边条件在 $[n]$ 中所有更小的下标上，条件更多故更小）。对 $S\in\mathcal{S}$ 求和，每个 $i$ 至少被数 $k$ 次：
$$\sum_{S}H(X_S)\ \ge\ k\sum_{i=1}^nH(X_i\mid X_{<i})=k\,H(X_{[n]}).\qquad\square$$

> **用在哪**：[[03 信息论]] §5 的**素数无穷的熵证明**用了 (a)(c)(d)。Shearer 是组合学里"熵方法"的主力（Kahn–Lovász、投影不等式）。

### A3.7 Kraft 不等式

**定理.** 二元前缀码的码长 $\{\ell_x\}_{x\in\mathcal{X}}$ 存在 $\iff\ \sum_x2^{-\ell_x}\le1$。

*证明（必要性）.* 设 $L=\max_x\ell_x$，考虑深度 $L$ 的满二叉树（$2^L$ 个叶子）。长为 $\ell$ 的码字对应深度 $\ell$ 的一个节点，它"占据"了其下方的 $2^{L-\ell}$ 个叶子。前缀无关 $\Rightarrow$ 这些叶子集合两两不交，故 $\sum_x2^{L-\ell_x}\le2^L$。

*（充分性）* 把码长排序，贪心地从左到右分配区间即可构造出前缀码。$\square$

**推论（最优码长）.** 最小化 $\mathbb{E}[\ell]=\sum_xp_x\ell_x$ 受 Kraft 约束，Lagrange 给出 $\ell_x=-\log_2p_x$，最优期望长度 $=H(X)$。用错分布 $q$ 时期望码长为 $H(p)+D(p\Vert q)$（交叉熵）。

> **用在哪**：[[03 信息论]] §4，以及"语言模型的训练损失就是压缩率"这个论断。

### A3.8 Fano 不等式

**定理.** 设 $X\to Y\to\hat X$，$P_e=\Pr[\hat X\ne X]$，$X$ 取值于 $\mathcal{X}$。则
$$H(X\mid Y)\ \le\ h(P_e)+P_e\log(|\mathcal{X}|-1),$$
$h$ 为二元熵函数。

*证明.* 令 $E=\mathbf{1}[\hat X\ne X]$。两种方式展开 $H(E,X\mid \hat X)$：
$$H(E,X\mid\hat X)=\underbrace{H(E\mid\hat X)}_{\le h(P_e)}+\underbrace{H(X\mid E,\hat X)}_{\le P_e\log(|\mathcal{X}|-1)}$$
（第二项：$E=0$ 时 $X=\hat X$ 熵为 0；$E=1$ 时 $X$ 在剩下 $|\mathcal{X}|-1$ 个值中）。另一方面 $H(E,X\mid\hat X)\ge H(X\mid\hat X)\ge H(X\mid Y)$（DPI）。$\square$

> **用在哪**：极小极大下界的标准工具。[[19 MDP 与动态规划]] 里 Lai–Robbins 的赌博机遗憾下界、以及各种"样本复杂度至少是多少"的结论都走这条路（或其近亲 Le Cam 二点法）。**这是唯一一条用来证"做不到"的不等式**，其余全是"做得到"。

---

## A4. 统计不等式

### A4.1 偏差–方差分解（等式）

$$\mathbb{E}\big\Vert\hat\theta-\theta\big\Vert^2=\big\Vert\mathbb{E}\hat\theta-\theta\big\Vert^2+\mathbb{E}\big\Vert\hat\theta-\mathbb{E}\hat\theta\big\Vert^2 .$$

*证明.* 展开平方，交叉项 $\mathbb{E}\langle\hat\theta-\mathbb{E}\hat\theta,\ \mathbb{E}\hat\theta-\theta\rangle=0$。**这就是 $L^2$ 中的勾股定理**：$\mathbb{E}\hat\theta$ 是 $\hat\theta$ 在常数子空间上的正交投影。$\square$

> **用在哪**：[[01 学习问题的数学表述]] §1.1 的逼近/估计分解、[[08 泛化之谜]] 的 double descent（正是这个分解在插值阈值处的失效）。

### A4.2 得分函数的两条恒等式

设 $s_\theta(x)=\nabla_\theta\log p_\theta(x)$，正则条件下（支撑不依赖 $\theta$、可交换微分与积分）：

**(a)** $\mathbb{E}_\theta[s_\theta(X)]=0$。 *证明.* $\int\frac{\nabla p_\theta}{p_\theta}p_\theta=\nabla\int p_\theta=\nabla1=0$。$\square$

**(b) 信息等式.** $I(\theta):=\mathbb{E}[s_\theta s_\theta^\top]=-\mathbb{E}[\nabla^2\log p_\theta]$。 *证明.* 对 (a) 再求一次导，用 $\nabla^2\log p=\frac{\nabla^2p}{p}-ss^\top$。$\square$

### A4.3 Cramér–Rao 下界

**定理.** $\hat\theta$ 无偏（$\mathbb{E}_\theta\hat\theta=\theta$），正则条件成立。则（标量情形）
$$\mathrm{Var}_\theta(\hat\theta)\ \ge\ \frac{1}{n\,I(\theta)} .$$

*证明.* 对 $\mathbb{E}_\theta[\hat\theta]=\theta$ 关于 $\theta$ 求导并交换微分与积分：
$$1=\int\hat\theta(x)\,\nabla_\theta p_\theta(x)\,dx=\mathbb{E}\big[\hat\theta\cdot s_\theta\big]\overset{\text{(A4.2a)}}{=}\mathrm{Cov}\big(\hat\theta,\ s_\theta\big).$$
Cauchy–Schwarz（A1.3）：
$$1=\mathrm{Cov}(\hat\theta,s_\theta)^2/1\ \le\ \mathrm{Var}(\hat\theta)\cdot\mathrm{Var}(s_\theta)=\mathrm{Var}(\hat\theta)\cdot nI(\theta).\qquad\square$$

> [!warning] 正则条件不是形式主义
> 支撑集必须不依赖 $\theta$。反例：$\mathrm{Unif}[0,\theta]$ 的 $\hat\theta=\frac{n+1}{n}\max X_i$ 无偏且方差 $O(n^{-2})$，**远快于 CR 界的 $O(n^{-1})$**。见 [[04 统计推断]] §3。

### A4.4 KL 的局部二次形式

**命题.** $D(P_\theta\Vert P_{\theta+d})=\tfrac12 d^\top I(\theta)d+O(\Vert d\Vert^3)$。

*证明.* $D(P_\theta\Vert P_{\theta+d})=-\mathbb{E}_\theta[\log p_{\theta+d}-\log p_\theta]$。对 $\log p_{\theta+d}$ 在 $\theta$ 处 Taylor 展开到二阶，一阶项的期望由 A4.2(a) 为 0，二阶项由 A4.2(b) 给 $-\frac12d^\top\mathbb{E}[\nabla^2\log p_\theta]d=\frac12d^\top I(\theta)d$。$\square$

> **用在哪**：Fisher 度量与自然梯度（[[04 统计推断]] §6）、TRPO 的二阶近似（[[21 策略梯度方法]] §5）、Adam 作为对角 Fisher 预条件（[[05 优化的数学]] §5.1）。

### A4.5 重要性采样的二阶矩

**命题.** 设 $w=\frac{dP}{dQ}$，则 $\mathbb{E}_Q[w^2]=1+\chi^2(P\Vert Q)$，故
$$\mathrm{Var}_Q\big(w\,f\big)\ \le\ \mathbb{E}_Q[w^2f^2]\ \le\ \Vert f\Vert_\infty^2\big(1+\chi^2(P\Vert Q)\big).$$

*证明.* $\mathbb{E}_Q[w^2]=\int\frac{p^2}{q}=\int\frac{(p-q)^2}{q}+2\int p-\int q=\chi^2(P\Vert Q)+1$。$\square$

> [!note] 离策略 RL 的困难在这里有了定量形式
> 重要性采样的方差由 $\chi^2$ 散度控制，而 **$\chi^2$ 可以是无穷**（当 $P$ 的尾比 $Q$ 重）。这就是 [[19 MDP 与动态规划]] §4 说的"$d^\pi/d^\mu$ 可以无界"，也是 [[21 策略梯度方法]] 里 PPO 必须裁剪重要性比 $\rho_t$ 的根本原因——**裁剪就是强行把 $\chi^2$ 变有限**。

---

## A5. 学习理论不等式

### A5.1 并集界与对称化

**并集界.** $\Pr[\bigcup_iA_i]\le\sum_i\Pr[A_i]$。（可数可加性 + 单调性。）

**对称化不等式.** 设 $\mathcal{G}$ 为函数类，$S,S'$ 为独立同分布样本，$\sigma_i$ 为 Rademacher 变量。则
$$\mathbb{E}_S\Big[\sup_{g\in\mathcal{G}}\big(\mathbb{E}[g]-\widehat{\mathbb{E}}_S[g]\big)\Big]\ \le\ 2\,\mathfrak{R}_n(\mathcal{G}),\qquad \mathfrak{R}_n(\mathcal{G})=\mathbb{E}_{S,\sigma}\Big[\sup_{g}\frac1n\sum_i\sigma_ig(z_i)\Big].$$

*证明.* 引入幽灵样本 $S'$：
$$\mathbb{E}_S\sup_g\big(\mathbb{E}g-\widehat{\mathbb{E}}_Sg\big)=\mathbb{E}_S\sup_g\ \mathbb{E}_{S'}\big[\widehat{\mathbb{E}}_{S'}g-\widehat{\mathbb{E}}_Sg\big]\ \overset{\text{Jensen}}{\le}\ \mathbb{E}_{S,S'}\sup_g\big(\widehat{\mathbb{E}}_{S'}g-\widehat{\mathbb{E}}_Sg\big).$$
右边 $=\mathbb{E}_{S,S'}\sup_g\frac1n\sum_i\big(g(z_i')-g(z_i)\big)$。由于 $(z_i,z_i')$ 可交换，把第 $i$ 项乘以 $\sigma_i$ 不改变联合分布，故
$$=\mathbb{E}_{S,S',\sigma}\sup_g\frac1n\sum_i\sigma_i\big(g(z_i')-g(z_i)\big)\ \le\ 2\mathfrak{R}_n(\mathcal{G}).\qquad\square$$

> **交换 $\sup$ 与 $\mathbb{E}$ 是唯一用到不等号的地方**（Jensen）；引入 $\sigma_i$ 那步是**恒等**的。这个结构值得记住。

### A5.2 Massart 有限类引理

**引理.** 设 $\mathcal{A}\subset\R^n$ 有限，$|\mathcal{A}|=N$，$\sup_{a\in\mathcal{A}}\Vert a\Vert_2\le R$。则
$$\mathbb{E}_\sigma\Big[\max_{a\in\mathcal{A}}\frac1n\langle\sigma,a\rangle\Big]\ \le\ \frac{R\sqrt{2\log N}}{n}.$$

*证明.* 对固定 $a$，$\langle\sigma,a\rangle=\sum_i\sigma_ia_i$ 是独立零均值有界变量之和，由 Hoeffding 引理是 $\Vert a\Vert_2^2\le R^2$-次高斯的。直接用 A2.3 的最大值界。$\square$

**推论（VC 情形）.** 对二值函数类，$\Vert a\Vert_2\le\sqrt n$，$N\le\Pi_{\mathcal{F}}(n)$（增长函数），故
$$\widehat{\mathfrak{R}}_S(\mathcal{F})\ \le\ \sqrt{\frac{2\log\Pi_{\mathcal{F}}(n)}{n}}.$$

### A5.3 Sauer–Shelah 引理

**引理.** 若 $\mathrm{VC}(\mathcal{F})=d$，则 $\Pi_{\mathcal{F}}(n)\le\sum_{i=0}^d\binom ni\le\big(\tfrac{en}{d}\big)^d$。

*证明（对 $n+d$ 归纳）.* $n\le d$ 或 $d=0$ 时平凡。设 $\mathcal{F}$ 限制在 $\{x_1,\dots,x_n\}$ 上得到集合族 $\mathcal{A}\subset\{0,1\}^n$。令
$$\mathcal{A}_0=\{a\in\{0,1\}^{n-1}:\ (a,0)\in\mathcal{A}\ \text{或}\ (a,1)\in\mathcal{A}\},\qquad \mathcal{A}_1=\{a:\ (a,0)\in\mathcal{A}\ \text{且}\ (a,1)\in\mathcal{A}\}.$$
则 $|\mathcal{A}|=|\mathcal{A}_0|+|\mathcal{A}_1|$。$\mathcal{A}_0$ 的 VC 维 $\le d$；而 $\mathcal{A}_1$ 若打散一个大小 $d$ 的集合，则 $\mathcal{A}$ 打散它加上 $x_n$（大小 $d+1$），矛盾——故 $\mathrm{VC}(\mathcal{A}_1)\le d-1$。归纳假设给
$$|\mathcal{A}|\le\sum_{i=0}^{d}\binom{n-1}i+\sum_{i=0}^{d-1}\binom{n-1}i=\sum_{i=0}^d\binom ni,$$
最后一步用 Pascal 恒等式。第二个不等号由 $\big(\frac dn\big)^d\sum_{i\le d}\binom ni\le\sum_i\binom ni(\frac dn)^i\le(1+\frac dn)^n\le e^d$。$\square$

> **这是纯组合的**，与概率无关。它把"无限的函数类"约化成"多项式多的行为模式"，从而让 A5.2 可用。**多项式 vs 指数的二分（$\Pi_\mathcal{F}(n)$ 要么 $\le n^d$ 要么 $=2^n$）是这个理论最漂亮的地方。**

### A5.4 Talagrand 收缩引理

**引理.** 设 $\phi_i:\R\to\R$ 是 $L$-Lipschitz 且 $\phi_i(0)=0$。则
$$\mathbb{E}_\sigma\Big[\sup_{f\in\mathcal{F}}\sum_i\sigma_i\phi_i(f_i)\Big]\ \le\ L\cdot\mathbb{E}_\sigma\Big[\sup_{f\in\mathcal{F}}\sum_i\sigma_if_i\Big].$$

*证明梗概（逐坐标归纳）.* 只需处理一个坐标。对 $\sigma_n$ 取期望：
$$\tfrac12\sup_{f}\Big[A(f)+\phi_n(f_n)\Big]+\tfrac12\sup_{g}\Big[A(g)-\phi_n(g_n)\Big]=\tfrac12\sup_{f,g}\Big[A(f)+A(g)+\phi_n(f_n)-\phi_n(g_n)\Big],$$
其中 $A(f)=\sum_{i<n}\sigma_i\phi_i(f_i)$。由 Lipschitz 性 $\phi_n(f_n)-\phi_n(g_n)\le L|f_n-g_n|$，而 $|f_n-g_n|$ 可写成 $\pm(f_n-g_n)$ 之一（按对称性两种情形都被 $\sup_{f,g}$ 覆盖），于是上式 $\le\frac12\sup_{f,g}[A(f)+A(g)+L(f_n-g_n)]$，恰是把 $\phi_n$ 换成 $L\cdot\mathrm{id}$ 后的结果。对 $n-1,\dots,1$ 重复。$\square$

> **用在哪**：[[01 学习问题的数学表述]] §2.1。它让我们只需计算**假设类本身**的 Rademacher 复杂度，而不必管损失函数——$\widehat{\mathfrak{R}}_S(\ell\circ\mathcal{F})\le L\,\widehat{\mathfrak{R}}_S(\mathcal{F})$。

### A5.5 Dudley 熵积分

**定理.** 设 $\mathcal{F}$ 在 $L_2(P_n)$ 中的 $\varepsilon$-覆盖数为 $N(\varepsilon,\mathcal{F},L_2(P_n))$。则
$$\widehat{\mathfrak{R}}_S(\mathcal{F})\ \le\ \inf_{\alpha>0}\left(4\alpha+\frac{12}{\sqrt n}\int_\alpha^{\infty}\sqrt{\log N(\varepsilon,\mathcal{F},L_2(P_n))}\ d\varepsilon\right).$$

*证明梗概（chaining）.* 取尺度序列 $\varepsilon_k=2^{-k}$ 与相应的覆盖网 $\mathcal{N}_k$。把任一 $f$ 沿逐级细化的网展开成望远镜和 $f=\pi_0(f)+\sum_k(\pi_k(f)-\pi_{k-1}(f))$，每一级的增量个数 $\le|\mathcal{N}_k||\mathcal{N}_{k-1}|$ 而范数 $\le3\varepsilon_k$。对每一级用 Massart（A5.2），再对 $k$ 求和，得到 $\sum_k\varepsilon_k\sqrt{\log N(\varepsilon_k)}$，即熵积分的 Riemann 和。$\square$

> **链式法（chaining）是从"一个尺度"升级到"所有尺度"的技术**，把 Massart 的 $\sqrt{\log N}$ 换成对 $\varepsilon$ 的积分。这是 empirical process theory 的核心技术，Talagrand 的 generic chaining 是它的最终形式。

### A5.6 一致收敛界（组装）

**定理.** $\mathcal{G}$ 取值于 $[0,B]$。以至少 $1-\delta$ 概率，对所有 $g\in\mathcal{G}$：
$$\mathbb{E}[g]\ \le\ \widehat{\mathbb{E}}_S[g]+2\widehat{\mathfrak{R}}_S(\mathcal{G})+3B\sqrt{\frac{\log(2/\delta)}{2n}}.$$

*证明.* 令 $\Phi(S)=\sup_g(\mathbb{E}g-\widehat{\mathbb{E}}_Sg)$。改动一个样本至多改变 $\Phi$ 为 $B/n$，由 **McDiarmid**（A2.9）$\Phi\le\mathbb{E}\Phi+B\sqrt{\frac{\log(2/\delta)}{2n}}$ 以概率 $1-\delta/2$。由**对称化**（A5.1）$\mathbb{E}\Phi\le2\mathfrak{R}_n(\mathcal{G})$。再用一次 McDiarmid 把 $\mathfrak{R}_n$ 换成经验的 $\widehat{\mathfrak{R}}_S$（以概率 $1-\delta/2$），并集界收尾。$\square$

> **这就是 [[01 学习问题的数学表述]] §2.1 那条定理的完整装配图**：McDiarmid（集中）+ 对称化（去掉未知分布）+ Massart/Dudley（算复杂度）。

### A5.7 PAC-Bayes 界

**定理.** 固定与数据无关的先验 $P$。以至少 $1-\delta$ 概率，对**所有**后验 $Q$ 同时成立：
$$\mathbb{E}_{f\sim Q}[R(f)]\ \le\ \mathbb{E}_{f\sim Q}[\widehat R_S(f)]+\sqrt{\frac{D(Q\Vert P)+\log\frac{2\sqrt n}{\delta}}{2n}}.$$

*证明梗概.* 令 $\Delta(f)=R(f)-\widehat R_S(f)$。由 **Donsker–Varadhan 推论**（A3.5），对任意 $\lambda>0$ 与所有 $Q$：
$$\lambda\,\mathbb{E}_Q[\Delta]\ \le\ D(Q\Vert P)+\log\ \mathbb{E}_{f\sim P}\big[e^{\lambda\Delta(f)}\big].$$
关键在于 **$P$ 与数据独立**，故可交换 $\mathbb{E}_S$ 与 $\mathbb{E}_P$：对每个固定 $f$，由 Hoeffding，$\mathbb{E}_S[e^{\lambda\Delta(f)}]\le e^{\lambda^2/(8n)}$。于是 $\mathbb{E}_S\mathbb{E}_P[e^{\lambda\Delta}]\le e^{\lambda^2/(8n)}$，Markov 给出高概率界，最后对 $\lambda$ 优化。$\square$

> [!tip] 为什么这条界在深度学习里是最有希望的
> 它**完全不依赖假设类的复杂度**（无 VC 维、无参数计数），只依赖 $D(Q\Vert P)$——即"训练找到的解相对于先验有多少信息量"。这把 [[03 信息论]] 的 MDL 直觉变成了定理：**能被短描述的假设泛化得好**。这也是 [[08 泛化之谜]] 记分板上唯一给出过非平凡数值界的路线。

---

## A6. 概率距离之间的比较

设 $p,q$ 为密度（相对某公共测度）。定义
$$\mathrm{TV}=\tfrac12\!\int|p-q|,\qquad H^2=\!\int(\sqrt p-\sqrt q)^2=2(1-\mathrm{BC}),\qquad \mathrm{BC}=\!\int\!\sqrt{pq}.$$

### A6.1 Hellinger 与 TV

**命题.** $\tfrac12H^2\ \le\ \mathrm{TV}\ \le\ H\sqrt{1-\tfrac{H^2}{4}}\ \le\ H$。

*证明.* 左式：$|p-q|=|\sqrt p-\sqrt q|\,(\sqrt p+\sqrt q)\ge(\sqrt p-\sqrt q)^2$，积分并乘 $\frac12$。
右式：Cauchy–Schwarz，
$$2\,\mathrm{TV}=\int|\sqrt p-\sqrt q|(\sqrt p+\sqrt q)\le\Big(\!\int(\sqrt p-\sqrt q)^2\Big)^{1/2}\Big(\!\int(\sqrt p+\sqrt q)^2\Big)^{1/2}=H\sqrt{4-H^2}.\qquad\square$$

### A6.2 Hellinger 与 KL

**命题.** $H^2(p,q)\ \le\ D(p\Vert q)$。

*证明.*
$$D(p\Vert q)=\int p\log\frac pq=-2\int p\log\sqrt{\frac qp}\ \overset{\text{Jensen}}{\ge}\ -2\log\int p\sqrt{\frac qp}=-2\log\mathrm{BC}\ \overset{\log x\le x-1}{\ge}\ 2(1-\mathrm{BC})=H^2.\ \square$$

**推论.** 连起来得到 $\mathrm{TV}^2\le H^2\le D$——比 Pinsker 的 $\mathrm{TV}^2\le D/2$ 弱一个常数，但 Hellinger 有**张量化**的好处：$H^2(P^{\otimes n},Q^{\otimes n})=2\big(1-(1-\tfrac{H^2}{2})^n\big)$，而 TV 没有这样干净的形式。

### A6.3 Wasserstein 距离的性质

$$W_p(\mu,\nu)=\Big(\inf_{\gamma\in\Pi(\mu,\nu)}\int\Vert x-y\Vert^p\,d\gamma\Big)^{1/p}.$$

**(a) 尺度性.** $W_p(aX+b,\,aY+b)=|a|\,W_p(X,Y)$。 *证明.* 仿射变换把耦合双射地映到耦合，代价按 $|a|^p$ 缩放。$\square$

**(b) 凸性.** $W_p^p$ 关于两个变元联合凸。 *证明.* 耦合集合 $\Pi$ 对凸组合封闭，且目标关于 $\gamma$ 线性；取 $\inf$ 保持凸性。$\square$

**(c) Kantorovich–Rubinstein 对偶.**
$$W_1(\mu,\nu)=\sup_{\mathrm{Lip}(f)\le1}\Big\{\mathbb{E}_\mu[f]-\mathbb{E}_\nu[f]\Big\}.$$

*证明梗概.* 原问题是无穷维线性规划：$\inf_\gamma\langle c,\gamma\rangle$ 受边缘约束，$c(x,y)=\Vert x-y\Vert$。其 Lagrange 对偶是 $\sup_{f,g}\{\mathbb{E}_\mu f+\mathbb{E}_\nu g\}$ 受 $f(x)+g(y)\le c(x,y)$。当 $c$ 是度量时，最优解可取 $g=-f$ 且 $f$ 为 1-Lipschitz（$c$-变换的自反性）。强对偶由 Fenchel–Rockafellar 保证（$c$ 连续、空间 Polish）。$\square$

> [!note] (a)(b) 恰好是 [[20 值函数方法]] §5 里 distributional Bellman 算子压缩性证明的全部内容
> $$\bar d_p(\mathcal{T}^\pi Z_1,\mathcal{T}^\pi Z_2)\le\gamma\,\bar d_p(Z_1,Z_2)$$
> 因为 $\mathcal{T}^\pi$ 做的正是"乘 $\gamma$ 再平移"（用 (a)）加上"对 $s',a'$ 取混合"（用 (b)）。
>
> (c) 则是 [[16 生成对抗网络]] §4 里 WGAN 的全部理论依据。

### A6.4 为什么 $W$ 在支撑不交时仍有意义

**例.** $P=\delta_0$，$Q_\epsilon=\delta_\epsilon$ 于 $\R$ 上：
$$W_1(P,Q_\epsilon)=\epsilon\ \ (\text{连续，}\ \partial_\epsilon=1),\qquad D_{\mathrm{JS}}(P\Vert Q_\epsilon)=\log2\ \ \forall\epsilon\ne0\ (\text{梯度}=0).$$

*证明.* $W_1$：唯一的耦合是 $\delta_{(0,\epsilon)}$，代价 $\epsilon$。JS：支撑不交时 $m=\frac{P+Q}{2}$ 使 $\frac{dP}{dm}=2$ 于 $\{0\}$、$\frac{dQ}{dm}=2$ 于 $\{\epsilon\}$，代入定义得 $\log2$。$\square$

> **这个两行的例子就是 WGAN 存在的全部理由。**见 [[14 生成建模的统一视角]] §3 与 [[16 生成对抗网络]] §3。

---

## A7. 高维几何

### A7.1 Maurey–Barron 引理

**引理.** 设 $\mathcal{H}$ 是 Hilbert 空间，$G\subset\mathcal{H}$ 满足 $\sup_{h\in G}\Vert h\Vert\le B$，$g\in\overline{\mathrm{conv}}(G)$。则对每个 $m$，存在 $h_1,\dots,h_m\in G$ 使
$$\Big\Vert g-\frac1m\sum_{j=1}^mh_j\Big\Vert^2\ \le\ \frac{B^2}{m}.$$

*证明（概率方法）.* 由 $g\in\overline{\mathrm{conv}}(G)$，存在 $G$ 上的概率测度 $\mu$ 使 $g=\mathbb{E}_{h\sim\mu}[h]$。取 $h_1,\dots,h_m\overset{\text{iid}}\sim\mu$，$\bar h=\frac1m\sum h_j$。则
$$\mathbb{E}\big\Vert g-\bar h\big\Vert^2=\frac{1}{m}\,\mathbb{E}\big\Vert h-g\big\Vert^2\le\frac{1}{m}\mathbb{E}\Vert h\Vert^2\le\frac{B^2}{m},$$
第一步是独立同分布向量均值的方差公式，第二步用 $\mathbb{E}\Vert h-\mathbb{E}h\Vert^2\le\mathbb{E}\Vert h\Vert^2$。期望 $\le B^2/m$ $\Rightarrow$ 存在一个实现 $\le B^2/m$。$\square$

> [!tip] 这条引理就是 Barron 定理
> [[02 神经网络作为函数类]] §2.2：把目标函数写成脊函数的积分表示（即 $g\in\overline{\mathrm{conv}}(G)$，$G$ = 脊函数集合），Maurey–Barron 立刻给出宽度 $m$ 的网络逼近误差 $O(1/m)$，**且与维数 $d$ 无关**。
>
> **一句话总结：神经网络是脊函数的 Monte Carlo 积分，宽度是采样数，$1/m$ 是方差率。**这个视角在 [[07 无限宽极限 NTK 与 mean-field]] 的 mean-field 极限里变成主角。

### A7.2 高斯范数集中（薄球壳）

**命题.** $Z\sim\mathcal{N}(0,I_d)$。则对 $t>0$（Laurent–Massart）
$$\Pr\Big[\big\Vert Z\big\Vert^2\ge d+2\sqrt{dt}+2t\Big]\le e^{-t},\qquad \Pr\Big[\Vert Z\Vert^2\le d-2\sqrt{dt}\Big]\le e^{-t}.$$
于是 $\Vert Z\Vert=\sqrt d\,(1+O_P(d^{-1/2}))$。

*证明梗概.* $\Vert Z\Vert^2\sim\chi^2_d$，其对数矩母函数 $\log\mathbb{E}e^{\lambda(\chi^2_d-d)}=-\frac d2\log(1-2\lambda)-\lambda d$，对 $\lambda<1/2$ 用 $-\log(1-u)-u\le\frac{u^2}{2(1-u)}$ 放缩后 Chernoff。$\square$

> [!note] 这解释了 MAP 解码为什么是错的
> $d$ 维标准高斯的**众数在原点**，但**样本几乎全部落在半径 $\sqrt d$ 的薄球壳上**——原点附近的概率质量趋于 0。"最可能的单点"与"典型样本"在高维中完全脱节。
>
> 这正是 [[03 信息论]] 的 **AEP / 典型集**的几何版本，也是 [[11 序列模型与状态空间]] §4 与 [[18 大语言模型]] §5 说的"开放式生成必须采样而非取 $\arg\max$"的严格依据：$\arg\max_yp(y)$ 不在典型集里，所以 beam search 会产生退化的重复文本。

### A7.3 Johnson–Lindenstrauss 与近似正交

**JL 引理.** 给定 $\R^D$ 中的 $n$ 个点与 $\epsilon\in(0,1)$，取 $d=O(\epsilon^{-2}\log n)$ 与随机矩阵 $A\in\R^{d\times D}$（元素 iid $\mathcal{N}(0,1/d)$）。则以高概率，对所有点对
$$(1-\epsilon)\Vert x_i-x_j\Vert^2\ \le\ \Vert Ax_i-Ax_j\Vert^2\ \le\ (1+\epsilon)\Vert x_i-x_j\Vert^2 .$$

*证明.* 对固定的 $u$，$\Vert Au\Vert^2/\Vert u\Vert^2\sim\chi^2_d/d$，由 A7.2 偏离 $1$ 超过 $\epsilon$ 的概率 $\le2e^{-cd\epsilon^2}$。对 $\binom n2$ 个点对用并集界，取 $d\ge C\epsilon^{-2}\log n$ 使总失败概率 $<1$。$\square$

**近似正交的容量.** 在 $\R^d$ 中可以放下 $N=e^{c\,d\,\epsilon^2}$ 个单位向量，两两内积绝对值 $\le\epsilon$。

*证明.* 取 $N$ 个 iid 均匀单位向量。两个独立单位向量的内积满足 $\Pr[|\langle u,v\rangle|>\epsilon]\le2e^{-d\epsilon^2/2}$（球面测度集中）。并集界要求 $\binom N2\cdot2e^{-d\epsilon^2/2}<1$。$\square$

> [!tip] 这条解释了 superposition
> [[12 Transformer]] §4.3：网络在 $d$ 维残差流里存储**远多于 $d$ 个**特征，靠的正是"高维空间中可以放指数多个近似正交的方向"。于是单个神经元对应多个不相关概念（polysemanticity），而稀疏自编码器（SAE）想做的就是把这个过完备字典解出来——**那是压缩感知问题**。

---

## A8. 依赖关系与索引

### A8.1 依赖图

```
                    Jensen (A1.1)
                   /      |      \
        Gibbs (A3.1)   log-sum   熵的界 (A3.6)
             |          (A1.5)        |
             |         /     \        |
    DV 表示 (A3.5)  DPI (A3.3)     Shearer (A3.6e)
          |            |
   PAC-Bayes (A5.7) Pinsker (A3.4) ──→ TRPO 界 (笔记 21)
                                    
                    Markov (A2.1)
                        |
                  Chernoff (A2.2)
                   /         \
        Hoeffding 引理     大偏差 / Kramers (笔记 05)
          (A2.4)
          /     \
  Hoeffding    Azuma (A2.8)          Efron–Stein (A2.7)
   (A2.5)          |                   （方差版本）
      |       McDiarmid (A2.9)
      |            |
      └──── 一致收敛界 (A5.6) ←── 对称化 (A5.1)
                   ↑                    ↑
            Massart (A5.2)         Talagrand 收缩 (A5.4)
                   ↑
            Sauer–Shelah (A5.3) / Dudley (A5.5)

     Cauchy–Schwarz (A1.3) ──→ Cramér–Rao (A4.3)
                           └──→ Maurey–Barron (A7.1) ──→ Barron 定理 (笔记 02)
```

### A8.2 索引：每条用在哪

| 不等式 | 出现的笔记 |
|---|---|
| Jensen (A1.1) | [[03 信息论]]、[[04 统计推断]]、[[15 变分自编码器]]、[[20 值函数方法]] |
| $\mathbb{E}\max\ge\max\mathbb{E}$ (A1.2) | [[20 值函数方法]]（Double DQN） |
| Cauchy–Schwarz (A1.3) | [[04 统计推断]]（Cramér–Rao）、[[13 系统与工程]]（MoE 均衡） |
| Fenchel–Young (A1.4) | [[03 信息论]]、[[16 生成对抗网络]]（$f$-GAN） |
| Chernoff (A2.2) | [[05 优化的数学]]（Kramers 逃逸时间） |
| 次高斯最大值 (A2.3) | [[01 学习问题的数学表述]] |
| Hoeffding (A2.5) | [[01 学习问题的数学表述]]、[[04 统计推断]] |
| Bernstein (A2.6) | [[05 优化的数学]]（梯度裁剪的动机） |
| McDiarmid (A2.9) | [[01 学习问题的数学表述]]（一致收敛、稳定性） |
| Gibbs (A3.1) | [[03 信息论]]、[[04 统计推断]]、[[15 变分自编码器]]、[[22 RLHF 与推理 RL]] |
| DPI (A3.3) | [[03 信息论]]、[[08 泛化之谜]]（信息瓶颈） |
| Pinsker (A3.4) | [[03 信息论]]、[[21 策略梯度方法]]（TRPO 换 KL） |
| Donsker–Varadhan (A3.5) | [[03 信息论]]（MINE/InfoNCE）、[[04 统计推断]]（PAC-Bayes） |
| 熵的界与 Shearer (A3.6) | [[03 信息论]]（素数无穷证明） |
| Kraft (A3.7) | [[03 信息论]]（最优码长 = 熵） |
| Fano (A3.8) | [[19 MDP 与动态规划]]（赌博机下界） |
| 偏差–方差 (A4.1) | [[01 学习问题的数学表述]]、[[08 泛化之谜]] |
| Cramér–Rao (A4.3) | [[04 统计推断]] |
| KL 的 Fisher 二次形式 (A4.4) | [[04 统计推断]]、[[05 优化的数学]]、[[21 策略梯度方法]] |
| 重要性采样方差 (A4.5) | [[19 MDP 与动态规划]]、[[21 策略梯度方法]]（PPO 裁剪） |
| 对称化 (A5.1) | [[01 学习问题的数学表述]] |
| Massart / Sauer–Shelah / Dudley (A5.2–5.5) | [[01 学习问题的数学表述]] |
| Talagrand 收缩 (A5.4) | [[01 学习问题的数学表述]] |
| PAC-Bayes (A5.7) | [[04 统计推断]]、[[08 泛化之谜]] |
| Hellinger 链 (A6.1–6.2) | [[14 生成建模的统一视角]] |
| $W_p$ 性质 (A6.3) | [[20 值函数方法]]（distributional RL 压缩性） |
| Kantorovich–Rubinstein (A6.3c) | [[16 生成对抗网络]]（WGAN） |
| 支撑不交的例子 (A6.4) | [[14 生成建模的统一视角]]、[[16 生成对抗网络]] |
| Maurey–Barron (A7.1) | [[02 神经网络作为函数类]]（Barron 定理） |
| 高斯薄球壳 (A7.2) | [[03 信息论]](AEP)、[[11 序列模型与状态空间]]、[[18 大语言模型]]（采样 vs MAP） |
| JL / 近似正交 (A7.3) | [[12 Transformer]]（superposition） |

## 参考

- [Boucheron, Lugosi, Massart, *Concentration Inequalities: A Nonasymptotic Theory of Independence*](https://www.hse.ru/data/2016/11/24/1113029206/Concentration%20inequalities.pdf) (OUP 2013). **A2 节的标准参考**，写法极其清楚，对数学家是最合适的一本。
- [Vershynin, *High-Dimensional Probability*](https://www.math.uci.edu/~rvershyn/papers/HDP-book/HDP-book.html) (CUP 2018). 免费草稿在线。次高斯、链式法、随机矩阵，A2/A5/A7 的现代写法。
- [Wainwright, *High-Dimensional Statistics: A Non-Asymptotic Viewpoint*](https://www.cambridge.org/core/books/highdimensional-statistics/8A91ECEEC38F46DAB53E9FF8757C7A4E) (CUP 2019). 统计与学习理论的接口。
- [Polyanskiy & Wu, *Information Theory: From Coding to Learning*](https://people.lids.mit.edu/yp/homepage/data/itbook-export.pdf) (CUP). **A3 与 A6 的最佳来源**，$f$-散度与各种距离的比较写得最全。
- [Shalev-Shwartz & Ben-David, *Understanding Machine Learning*](https://www.cs.huji.ac.il/~shais/UnderstandingMachineLearning/) (2014). A5 的入口，Sauer–Shelah 与 Rademacher 的证明。
- [van Handel, *Probability in High Dimension*](https://web.math.princeton.edu/~rvan/APC550.pdf) (Princeton 讲义). 集中不等式与链式法的深入处理，**数学系风格**。
- [Peyré & Cuturi, *Computational Optimal Transport*](https://optimaltransport.github.io/). A6.3 的对偶理论与算法。
- [Telgarsky, *Deep Learning Theory*](https://mjt.cs.illinois.edu/dlt/). Maurey–Barron 与逼近论部分。

## Related

- [[index|深度学习（为纯数学研究者重写）]]
- [[00 外部资源地图]]
- [[01 学习问题的数学表述]]
- [[03 信息论]]
- [[04 统计推断]]
