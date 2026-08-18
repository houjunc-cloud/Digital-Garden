---
title: P1 随机微分方程与 Fokker–Planck
description: Itô 积分、生成元与 Kolmogorov 方程、Langevin 与不变测度、时间反演、Girsanov 与轨迹似然、Euler–Maruyama。
tags:
  - scientific-foundation-models
  - stochastic-analysis
  - prerequisites
stage: 🌱 seedling
date: 2026-08-18
---

# P1 随机微分方程与 Fokker–Planck

> 课程 prerequisites 里写 "introductory PDE/SDE"。**PDE 那一半你有，SDE 这一半没有。**这篇是补这一半，但不是一门 SDE 课的替代品——它只讲这门课后面真正要用的东西，且假设你有测度论、泛函分析、鞅论的基础（这些恰好是 SDE 教材最花篇幅铺垫的部分，你可以跳）。
>
> **三个用处，按重要性排：**
> 1. **§7 Girsanov 与轨迹似然** — 这是"从轨迹数据学交互核"这件事为什么是一个**最小二乘问题**的原因。整个 Part 3 建在这上面。
> 2. **§5 Langevin 与不变测度** — 采样、生成模型、以及"数据从哪来"的标准模型。
> 3. **§6 时间反演** — 扩散生成模型的整个构造就是这一条定理。

> [!question] 卡住了从哪儿看起
> - 📐 [Evans, *An Introduction to Stochastic Differential Equations*](https://math.berkeley.edu/~evans/SDE.course.pdf) — 80 页，PDE 人写给 PDE 人的，**先读这本**
> - 📐 Le Gall, *Brownian Motion, Martingales, and Stochastic Calculus* (GTM 274) — 测度论体例，最接近你熟悉的阅读体验，严格性最高
> - Øksendal, *Stochastic Differential Equations* §3–8 — 标准入口，例子多，证明有时略
> - Pavliotis, *Stochastic Processes and Applications* — **Fokker–Planck、遍历性、谱理论那一块比前两本都好**，且面向应用
> - [Särkkä & Solin, *Applied SDEs*](https://users.aalto.fi/~asolin/sde-book/sde-book.pdf) — 数值与滤波部分，免费

## 1. 为什么这门课需要 SDE

三处：

**(a) 数据的生成模型。**这门课研究的"科学基础模型"要学的对象，几乎都是某个随机动力系统的**漂移项**。典型形式是随机交互粒子系统
$$\mathrm{d}X_t^i=\frac{1}{N}\sum_{j\ne i}\phi(|X_t^j-X_t^i|)\,(X_t^j-X_t^i)\,\mathrm{d}t+\sigma\,\mathrm{d}B_t^i,\qquad i=1,\dots,N,$$
未知量是径向核 $\phi:\R_+\to\R$。观测是轨迹。**这是一个回归问题，但设计点不是 i.i.d. 的，而是一条 SDE 的路径。**

**(b) 生成模型。**扩散模型是一对 SDE（前向加噪、反向去噪），见 [[notes/deep-learning/17 扩散模型与 flow matching|DL 17]]。这门课的 Part 4 要问的是率，率的推导要用到 §5 的泛函不等式。

**(c) 平均场极限。**$N\to\infty$ 时粒子系统收敛到一个非线性 PDE（McKean–Vlasov / Vlasov–Fokker–Planck）。而 attention 在 token 数 $\to\infty$ 时也收敛到同类型方程——这是这门课把 Transformer 和粒子系统摆在一起的理由。

## 2. 布朗运动

**定义.** $\R^d$ 上的标准布朗运动是过程 $B=(B_t)_{t\ge0}$，满足 $B_0=0$、独立增量、$B_t-B_s\sim\mathcal{N}(0,(t-s)I_d)$、轨道连续 a.s.

**存在性.** Lévy–Ciesielski 构造：取 $[0,1]$ 上的 Haar 基 $\{h_n\}$，Schauder 函数 $s_n(t)=\int_0^t h_n$，令 $B_t=\sum_n \xi_n s_n(t)$，$\xi_n$ i.i.d. $\mathcal{N}(0,1)$。级数在 $C[0,1]$ 中 a.s. 一致收敛（Borel–Cantelli + $\max|\xi_n|$ 的增长）。这是**唯一需要动手的存在性证明**，之后一切都是从它推的。

**路径正则性.**
- $B\in C^{\alpha}$ a.s. 对任意 $\alpha<1/2$（Kolmogorov–Chentsov），且 $\alpha=1/2$ 失败。
- a.s. 处处不可微（Paley–Wiener–Zygmund）。
- **二次变差**：对 $[0,t]$ 的加细划分 $\Pi_n$（$|\Pi_n|\to0$），$\sum_k|B_{t_{k+1}}-B_{t_k}|^2\to t$ 依概率（且在 $L^2$ 中）。

> [!note] 二次变差是整个 Itô 演算的全部内容
> 经典微积分里 $\mathrm{d}f=f'\mathrm{d}x$ 成立，是因为 $(\mathrm{d}x)^2=o(\mathrm{d}x)$。这里 $(\mathrm{d}B)^2=\mathrm{d}t$ **不是**高阶小量，于是 Taylor 展开必须保留二阶项。**Itô 公式就是"保留了二阶项的链式法则"，此外没有别的内容。**
>
> 同一件事的 PDE 说法：正因为二阶项不消失，随机过程的期望才满足**二阶**抛物方程而不是一阶输运方程。

## 3. Itô 积分

固定流 $(\mathcal{F}_t)$（通常取 $B$ 的自然流的增广）。设 $H$ 是 progressively measurable 且 $\mathbb{E}\int_0^T|H_s|^2\mathrm{d}s<\infty$，记这个空间为 $\mathcal{L}^2_T$。

**构造.** 对简单过程 $H=\sum_k H_{t_k}\mathbf{1}_{(t_k,t_{k+1}]}$ 定义 $\int_0^T H\,\mathrm{d}B=\sum_k H_{t_k}(B_{t_{k+1}}-B_{t_k})$，**取值点必须是左端点**（这是 Itô 与 Stratonovich 的分歧处）。则

$$\boxed{\ \mathbb{E}\Big[\Big(\int_0^T H_s\,\mathrm{d}B_s\Big)^2\Big]=\mathbb{E}\int_0^T |H_s|^2\,\mathrm{d}s\ }\qquad\text{（Itô 等距）}$$

简单过程在 $\mathcal{L}^2_T$ 中稠密，于是等距把定义唯一延拓到全空间。**这是一个 Hilbert 空间的等距延拓，没有任何别的技巧**——你的泛函分析背景在这里是直接可用的。

**性质.** $t\mapsto\int_0^t H\,\mathrm{d}B$ 是连续 $L^2$ 鞅，二次变差 $\int_0^t|H_s|^2\mathrm{d}s$。通过局部化（停时）可以放宽到 $\int_0^T|H|^2\mathrm{d}s<\infty$ a.s.，此时得到**局部**鞅——这个区别在后面（Girsanov 的可积性条件）会变成真问题，不是形式上的。

> [!warning] 左端点取值不是约定，是选择
> 取中点得到 Stratonovich 积分 $\int H\circ\mathrm{d}B$，它满足**经典**链式法则但**不是**鞅。转换公式：$\int H\circ\mathrm{d}B=\int H\,\mathrm{d}B+\frac12\langle H,B\rangle_t$。
>
> 统计上必须用 Itô：左端点取值使 $\mathbb{E}[H_{t_k}(B_{t_{k+1}}-B_{t_k})|\mathcal{F}_{t_k}]=0$，即**噪声项与前一时刻的观测正交**。§7 的最小二乘结构就来自这个正交性。

## 4. Itô 公式与 SDE

**Itô 公式.** 若 $\mathrm{d}X_t=b_t\,\mathrm{d}t+\sigma_t\,\mathrm{d}B_t$（$X$ 取值 $\R^d$，$\sigma_t\in\R^{d\times m}$），$f\in C^{1,2}$，则
$$\mathrm{d}f(t,X_t)=\Big(\partial_tf+b_t\cdot\nabla f+\tfrac12\operatorname{tr}\big(a_t\nabla^2f\big)\Big)(t,X_t)\,\mathrm{d}t+\nabla f(t,X_t)^\top\sigma_t\,\mathrm{d}B_t,$$
其中 $a_t:=\sigma_t\sigma_t^\top$（扩散矩阵）。

**SDE.** 考虑
$$\mathrm{d}X_t=b(X_t)\,\mathrm{d}t+\sigma(X_t)\,\mathrm{d}B_t,\qquad X_0=x.$$

> **定理（强解的存在唯一性）.** 若 $b,\sigma$ 全局 Lipschitz 且线性增长，则对每个 $x$ 存在唯一的连续适应强解，且 $\mathbb{E}\sup_{t\le T}|X_t|^2\le C_T(1+|x|^2)$。

证明就是 Banach 不动点：Picard 迭代 $X^{(n+1)}=x+\int b(X^{(n)})+\int\sigma(X^{(n)})\mathrm{d}B$，用 Itô 等距 + Doob 极大不等式 + Gronwall 得到压缩。**和 ODE 的 Picard–Lindelöf 逐字对应，唯一新东西是用 Itô 等距控制随机积分。**

**局部 Lipschitz 的代价.** 只有局部 Lipschitz 时解可能爆炸。避免爆炸的标准条件是 Lyapunov 型的：存在 $V\ge0$，$V(x)\to\infty$，使 $\mathcal{L}V\le CV$（$\mathcal{L}$ 见下节）。**这在粒子系统里是真问题**：交互核 $\phi$ 在 $r\to0$ 处奇异（如 Coulomb、Biot–Savart）时，全局 Lipschitz 直接失效，可辨识性的讨论也要相应修改。

## 5. 生成元、Kolmogorov 方程、不变测度

### 5.1 生成元

$$\mathcal{L}f:=b\cdot\nabla f+\tfrac12\operatorname{tr}(a\nabla^2 f),\qquad a=\sigma\sigma^\top.$$

由 Itô 公式，$f(X_t)-\int_0^t\mathcal{L}f(X_s)\mathrm{d}s$ 是局部鞅。这就是**鞅问题**（Stroock–Varadhan）的出发点：把"$X$ 是这个 SDE 的解"改述成"对一族测试函数，某个泛函是鞅"。好处是它只依赖 $\mathcal{L}$，不依赖 $B$ 的具体实现，于是弱解与唯一性可以在测度层面讨论。

### 5.2 后向方程与 Feynman–Kac

令 $u(t,x):=\mathbb{E}[f(X_T)\mid X_t=x]$。则
$$\partial_tu+\mathcal{L}u=0\ \text{ on }[0,T),\qquad u(T,\cdot)=f.$$
带位势的版本（Feynman–Kac）：$u(t,x)=\mathbb{E}\big[e^{-\int_t^TV(X_s)\mathrm{d}s}f(X_T)\mid X_t=x\big]$ 解 $\partial_tu+\mathcal{L}u=Vu$。

**读法**：这是"概率表示 ⟷ 抛物 PDE"的字典。你熟悉右边，SDE 给的是左边。

### 5.3 前向方程（Fokker–Planck）

设 $\rho_t$ 是 $X_t$ 的密度。对偶 $\int(\mathcal{L}f)\rho=\int f(\mathcal{L}^*\rho)$ 给出

$$\boxed{\ \partial_t\rho=\mathcal{L}^*\rho=-\nabla\cdot(b\rho)+\tfrac12\sum_{i,j}\partial_i\partial_j(a_{ij}\rho)\ }$$

**$\mathcal{L}^*$ 就是 $\mathcal{L}$ 在 $L^2(\mathrm{d}x)$ 里的形式伴随。**这一步纯粹是分部积分，不涉及概率。

### 5.4 Langevin 与 Gibbs 测度

取 $b=-\nabla U$，$\sigma=\sqrt{2\beta^{-1}}I$：
$$\mathrm{d}X_t=-\nabla U(X_t)\,\mathrm{d}t+\sqrt{2\beta^{-1}}\,\mathrm{d}B_t.$$
Fokker–Planck 变成
$$\partial_t\rho=\nabla\cdot\big(\rho\nabla U+\beta^{-1}\nabla\rho\big)=\nabla\cdot\Big(\rho\,\nabla\big(U+\beta^{-1}\log\rho\big)\Big).$$
右端在 $\rho=\pi:=Z^{-1}e^{-\beta U}$ 处为零：**Gibbs 测度是不变测度**（可逆的，满足细致平衡）。

**收敛速度.** 令 $\beta=1$。相对熵 $\mathrm{KL}(\rho_t\|\pi)$ 满足 de Bruijn 恒等式
$$\frac{\mathrm{d}}{\mathrm{d}t}\mathrm{KL}(\rho_t\|\pi)=-I(\rho_t\|\pi):=-\int\rho_t\Big|\nabla\log\frac{\rho_t}{\pi}\Big|^2.$$
若 $\pi$ 满足常数 $\lambda$ 的**对数 Sobolev 不等式** $I(\rho\|\pi)\ge2\lambda\,\mathrm{KL}(\rho\|\pi)$，则
$$\mathrm{KL}(\rho_t\|\pi)\le e^{-2\lambda t}\,\mathrm{KL}(\rho_0\|\pi).$$
**Bakry–Émery**：$U$ 是 $\alpha$-强凸 $\Rightarrow$ LSI 成立且 $\lambda\ge\alpha$。

> [!tip] 这三行是 Part 4 的全部技术基础
> 扩散模型的收敛分析就是：前向过程用 LSI 保证 $\rho_T\approx$ 高斯；反向过程的误差用 Girsanov + 数据处理不等式控制成 score 的 $L^2$ 误差。于是**"生成得好不好"完全归结为"score 估计得准不准"**，而后者是一个非参数回归问题（[[P2 非参数回归与最小最大率]]）。

**梯度流结构.** Fokker–Planck 是自由能 $\mathcal{F}(\rho)=\int U\rho+\beta^{-1}\int\rho\log\rho$ 在 Wasserstein-2 度量下的梯度流（Jordan–Kinderlehrer–Otto）。这与 [[notes/deep-learning/07 无限宽极限 NTK 与 mean-field|DL 07]] 里两层网络的 mean-field 极限是**同一个数学对象**，只是那里的"粒子"是神经元。

## 6. 时间反演

> **定理（Anderson 1982；Haussmann–Pardoux 1986）.** 设 $\mathrm{d}X_t=b(t,X_t)\mathrm{d}t+g(t)\,\mathrm{d}B_t$ 在 $[0,T]$ 上，$X_t$ 有密度 $p_t$，满足适当正则性。令 $Y_s:=X_{T-s}$。则 $Y$ 是弱意义下的扩散过程，
> $$\mathrm{d}Y_s=\big[-b(T-s,Y_s)+g(T-s)^2\nabla\log p_{T-s}(Y_s)\big]\mathrm{d}s+g(T-s)\,\mathrm{d}\bar B_s.$$

**唯一的新对象是 $\nabla\log p_t$，即 score。**其余都是符号翻转。

这条定理是扩散生成模型的**全部内容**：前向取一个把任意分布推向 $\mathcal{N}(0,I)$ 的简单 SDE（OU），反向就自动是一个从噪声生成数据的 SDE，只要你知道 score。于是"学生成模型" $=$ "估计 $\nabla\log p_t$"，而这是**回归**——正是大纲里 `Score matching as statistical regression` 那一格的意思。构造细节见 [[notes/deep-learning/17 扩散模型与 flow matching|DL 17]]，这里只需记住定理形状。

## 7. Girsanov 与轨迹似然：这门课的核心工具

### 7.1 定理

> **定理（Girsanov）.** 在 $[0,T]$ 上考虑 $\mathrm{d}X_t=b(X_t)\mathrm{d}t+\mathrm{d}B_t$，$X_0=x$。设 Novikov 条件 $\mathbb{E}\exp\big(\frac12\int_0^T|b(X_s)|^2\mathrm{d}s\big)<\infty$。记 $\mathbb{P}_b$ 为该解在路径空间 $C([0,T];\R^d)$ 上诱导的测度，$\mathbb{P}_0$ 为布朗运动的。则 $\mathbb{P}_b\sim\mathbb{P}_0$ 且
> $$\frac{\mathrm{d}\mathbb{P}_b}{\mathrm{d}\mathbb{P}_0}(X)=\exp\Big(\int_0^Tb(X_s)\cdot\mathrm{d}X_s-\frac12\int_0^T|b(X_s)|^2\,\mathrm{d}s\Big).$$

**这就是"一条轨迹的似然函数"。**注意漂移项进入似然的方式是**二次**的——这是接下来一切的原因。

### 7.2 从似然到最小二乘

设真漂移是 $b^*$，我们在某个函数类里找 $b$。负对数似然（丢掉与 $b$ 无关的项）：
$$-\ell_T(b)=\frac12\int_0^T|b(X_s)|^2\mathrm{d}s-\int_0^Tb(X_s)\cdot\mathrm{d}X_s.$$
代入 $\mathrm{d}X_s=b^*(X_s)\mathrm{d}s+\mathrm{d}B_s$ 并取期望，随机积分项期望为零（$b$ 有界时是真鞅），于是

$$\mathbb{E}\big[-\ell_T(b)\big]=\frac{T}{2}\big\|b-b^*\big\|_{L^2(\rho_T)}^2-\frac12\mathbb{E}\int_0^T|b^*|^2,\qquad \rho_T:=\frac1T\int_0^T\mathrm{Law}(X_s)\,\mathrm{d}s.$$

> [!tip] 记住这个式子
> **极大似然 $\equiv$ 在时间平均占据测度 $\rho_T$ 下的 $L^2$ 最小二乘。**
>
> 三个推论，全都是 Part 3 的内容：
> 1. **误差在哪个范数下衡量由动力学自己决定**，不是我们选的。$\rho_T$ 是系统"访问过"的区域；系统没去过的地方，数据说不出任何话。
> 2. **可辨识性 = $\rho_T$ 的支撑 + 参数化的单射性。**若把 $b$ 参数化为 $b_\phi$（如 $b_\phi(x)=\frac1N\sum_j\phi(|x_{ij}|)x_{ij}$），则 $\phi\mapsto b_\phi$ 必须在 $L^2(\rho_T)$ 上有下界——这就是 **coercivity 条件**。
> 3. **这是一个第一类算子方程。**最小化上式的正规方程是 $\mathcal{A}\phi=f$，$\mathcal{A}$ 通常是紧的 $\Rightarrow$ 不适定 $\Rightarrow$ 必须正则化。见 [[P3 RKHS 与不适定逆问题的正则化]]。

### 7.3 离散观测

实际数据是 $\{X_{t_k}\}$，$t_k=k\Delta$。把上式离散化，得到可计算的经验损失
$$\mathcal{E}_M(b)=\frac{1}{M}\sum_{k}\Big|\frac{X_{t_{k+1}}-X_{t_k}}{\Delta}-b(X_{t_k})\Big|^2\Delta .$$
这**就是**一个非参数回归的经验风险，响应变量是差商。两个偏差要分开记账：
- **统计误差** $O(M^{-2\beta/(2\beta+1)})$（见 [[P2 非参数回归与最小最大率]]）；
- **离散化偏差** $O(\Delta^{?})$，由数值格式的**弱**阶决定（下一节）。

## 8. 数值方法

**Euler–Maruyama.** $\widehat X_{k+1}=\widehat X_k+b(\widehat X_k)\Delta+\sigma(\widehat X_k)\,\Delta B_k$，$\Delta B_k\sim\mathcal{N}(0,\Delta I)$。

| 收敛类型 | 定义 | EM 的阶 | 用在哪 |
|---|---|---|---|
| 强 | $\mathbb{E}\sup_{k}\lvert X_{t_k}-\widehat X_k\rvert\lesssim\Delta^{p}$ | $p=1/2$ | 需要逐轨道逼近（耦合、方差缩减） |
| 弱 | $\lvert\mathbb{E}f(X_T)-\mathbb{E}f(\widehat X_T)\rvert\lesssim\Delta^{q}$ | $q=1$ | 采样、期望、**统计估计的偏差** |

强阶只有 $1/2$ 的原因：Itô–Taylor 展开的下一项 $\frac12\sigma\sigma'((\Delta B)^2-\Delta)$ 均值为零但方差是 $O(\Delta^2)$。补上它就是 **Milstein 格式**，强阶 $1$。

> [!note] 为什么统计里只关心弱阶
> 估计量是数据的**泛函**，不是轨道本身。$\rho_T$、经验损失、矩，全是期望型的量，误差由弱阶控制。**这解释了一个常见困惑：明明 EM 的强阶只有 $1/2$，为什么用 EM 数据估出来的核仍然是 $O(\Delta)$ 偏差。**
>
> 反过来，如果 $\Delta$ 大到离散化偏差压过统计误差，估计量会收敛到一个**错的**极限——这是 Fei Lu 一系列 "inference-based schemes adaptive to large time-stepping"（ISALT / NySALT）工作的出发点：与其减小 $\Delta$，不如直接把有效方程在大步长下重新估一遍。

## 9. McKean–Vlasov 与 propagation of chaos

$N$ 粒子交换系统
$$\mathrm{d}X^i_t=-\frac1N\sum_{j=1}^NK(X^i_t-X^j_t)\,\mathrm{d}t+\sqrt2\,\mathrm{d}B^i_t$$
的 $N\to\infty$ 极限是**非线性** SDE
$$\mathrm{d}\bar X_t=-(K*\mu_t)(\bar X_t)\,\mathrm{d}t+\sqrt2\,\mathrm{d}\bar B_t,\qquad \mu_t=\mathrm{Law}(\bar X_t),$$
对应 PDE $\partial_t\mu=\nabla\cdot\big((K*\mu)\mu\big)+\Delta\mu$（McKean–Vlasov / 聚集–扩散方程）。

> **定理（Sznitman 的同步耦合）.** $K$ Lipschitz、初值 i.i.d.，则 $\displaystyle\mathbb{E}\sup_{t\le T}|X^i_t-\bar X^i_t|^2\le \frac{C(T)}{N}$，从而经验测度 $\mu^N_t\to\mu_t$，且任意 $k$ 个粒子渐近独立（**混沌传播**）。

证明是耦合 + Gronwall，用同一族布朗运动驱动两个系统。$C(T)$ 一般指数依赖 $T$；一致时间的版本需要凸性或小 Lipschitz 常数。

**为什么这门课要它.** 三件事同时用到：
1. **粒子系统的学习问题**在 $N$ 大时可以改成学**平均场方程**里的核（Lang–Lu），可辨识性的讨论完全变样——平均场里信息更少，可辨识函数空间更小。
2. **attention** 在 token 数 $\to\infty$ 时也落到这个框架：$\mathrm{softmax}$ 让"核"依赖于经验测度，得到一个非线性输运方程。见系列 02、03。
3. 混沌传播说明 $N$ 大时**粒子之间的相关性是 $O(1/N)$ 的**——这正是"用一条 $N$ 粒子轨迹当作 $N$ 个近独立样本"这件事能成立的理由，也是 §7 那个最小二乘的样本量为什么是 $M\cdot N$ 而不是 $M$。

## 10. 一页速查

| 对象 | 公式 | 出现在 |
|---|---|---|
| 生成元 | $\mathcal{L}=b\cdot\nabla+\frac12\operatorname{tr}(a\nabla^2)$ | 全篇 |
| 后向方程 | $\partial_tu+\mathcal{L}u=0$ | Feynman–Kac、控制 |
| Fokker–Planck | $\partial_t\rho=-\nabla\cdot(b\rho)+\frac12\partial_i\partial_j(a_{ij}\rho)$ | 不变测度、平均场 |
| Langevin 不变测度 | $\pi\propto e^{-\beta U}$ | 采样、生成模型 |
| LSI $\Rightarrow$ 指数收敛 | $\mathrm{KL}(\rho_t\Vert\pi)\le e^{-2\lambda t}\mathrm{KL}(\rho_0\Vert\pi)$ | Part 4 的率 |
| 时间反演 | 漂移加 $g^2\nabla\log p_t$ | 扩散模型 |
| 轨迹似然 | $\exp\big(\int b\cdot\mathrm{d}X-\frac12\int\lvert b\rvert^2\big)$ | **Part 3 的最小二乘** |
| 混沌传播 | $\mathbb{E}\sup\lvert X^i-\bar X^i\rvert^2\lesssim1/N$ | 平均场极限 |

## 参考

- Evans, *An Introduction to Stochastic Differential Equations*, AMS 2013.
- Le Gall, *Brownian Motion, Martingales, and Stochastic Calculus*, GTM 274, Springer 2016.
- Øksendal, *Stochastic Differential Equations: An Introduction with Applications*, 6th ed.
- Pavliotis, *Stochastic Processes and Applications*, Springer 2014.
- Karatzas & Shreve, *Brownian Motion and Stochastic Calculus* — Girsanov 与鞅表示的标准参考。
- Anderson, *Reverse-time diffusion equation models*, Stoch. Proc. Appl. 12 (1982) 313–326.
- Haussmann & Pardoux, *Time reversal of diffusions*, Ann. Probab. 14 (1986) 1188–1205.
- Sznitman, *Topics in propagation of chaos*, École d'Été de Saint-Flour XIX, LNM 1464.
- Kloeden & Platen, *Numerical Solution of Stochastic Differential Equations* — 强/弱阶的标准来源。
- Jordan, Kinderlehrer & Otto, *The variational formulation of the Fokker–Planck equation*, SIAM J. Math. Anal. 29 (1998) 1–17.

## Related

- [[index|科学基础模型的数学]]
- [[P2 非参数回归与最小最大率]]
- [[P3 RKHS 与不适定逆问题的正则化]]
- [[notes/deep-learning/17 扩散模型与 flow matching|DL 17 扩散模型与 flow matching]]
- [[notes/deep-learning/07 无限宽极限 NTK 与 mean-field|DL 07 无限宽极限]]
