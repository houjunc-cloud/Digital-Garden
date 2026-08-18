---
title: P3 RKHS 与不适定逆问题的正则化
description: 紧算子 SVD 与 Picard 判据、谱滤波与源条件、RKHS 与表示定理、正规算子与可辨识函数空间、DARTR、贝叶斯对应。
tags:
  - scientific-foundation-models
  - inverse-problems
  - rkhs
  - prerequisites
stage: 🌱 seedling
date: 2026-08-18
---

# P3 RKHS 与不适定逆问题的正则化

> 这一篇**不在课程的 prerequisites 里**，但它是整门课真正的数学内核，而且是你的泛函分析背景直接变现的地方。
>
> 论点很简单：**这门课里的每一个"学习"问题，剥掉包装之后都是同一个东西——**
> $$\mathcal{A}\phi=f^\delta,\qquad \mathcal{A}\ \text{紧},\quad \|f^\delta-f\|\le\delta .$$
> 学交互核是它（$\mathcal{A}$ 由粒子构型给出）；学算子里的核是它（$\mathcal{A}$ 由输入函数给出）；score matching 是它的一个良态特例；连 in-context learning 都能被写成它（[Lu–Yu 2025](https://arxiv.org/abs/2505.12138) 的论点是：训练好的 transformer 学到的就是**这个问题的正则化算子**）。
>
> 你已经会紧算子谱理论了。这篇要加的只有两样：**噪声怎么进来**，以及**RKHS 为什么是那个"对"的函数空间**。

> [!question] 卡住了从哪儿看起
> - 📐 Engl, Hanke & Neubauer, *Regularization of Inverse Problems*, Kluwer 1996 — §2（紧算子）、§4（谱滤波与源条件）、§5（参数选择）。**确定性部分的标准来源**，写法就是泛函分析
> - 📐 Cucker & Smale, *On the mathematical foundations of learning*, Bull. AMS 39 (2002) 1–49 — 把 RKHS、逼近论、学习理论缝在一起的经典综述，**对纯数学背景最友好的入口**
> - Steinwart & Christmann, *Support Vector Machines*, Springer 2008 — RKHS 与插值空间 $[\mathcal{H}]^s$ 最严格的来源
> - Stuart, *Inverse problems: a Bayesian perspective*, Acta Numerica 19 (2010) 451–559 — §7 贝叶斯对应的来源，无限维上做得干净
> - [Fei Lu 的 publication 页](https://math.jhu.edu/~feilu/publications.html) — DARTR / FSOI / 最小最大率那一串原始论文

## 1. 不适定性

设 $\mathcal{A}:\mathcal{H}_1\to\mathcal{H}_2$ 是 Hilbert 空间之间的**紧**线性算子，奇异系统 $(\sigma_j;u_j,v_j)$：
$$\mathcal{A}u_j=\sigma_ju_j'\ \text{（记 }v_j:=u_j'\text{）},\qquad \mathcal{A}^*v_j=\sigma_ju_j,\qquad \sigma_1\ge\sigma_2\ge\cdots\to0 .$$

**伪逆.** $\mathcal{A}^\dagger f=\sum_j\sigma_j^{-1}\langle f,v_j\rangle u_j$。

> **Picard 判据.** $f\in\mathrm{ran}(\mathcal{A})$ 当且仅当 $f\perp\ker\mathcal{A}^*$ 且 $\displaystyle\sum_j\frac{|\langle f,v_j\rangle|^2}{\sigma_j^2}<\infty$。

**不适定性 = $\sigma_j\to0$。**具体后果：

- $\mathcal{A}^\dagger$ **无界**（$\mathrm{ran}(\mathcal{A})$ 无限维时）。解不连续依赖数据。
- 数据里 $\delta$ 大小的扰动沿 $v_j$ 方向被放大 $\sigma_j^{-1}$ 倍。**高频模式被放大得最狠**，而噪声恰恰在所有模式上均匀分布。
- **离散化不能救。**离散成 $m\times m$ 矩阵后条件数 $\sim\sigma_1/\sigma_m\to\infty$，$m$ 越大越坏。这正是 [[P2 非参数回归与最小最大率#3-投影估计与最小二乘|P2 §3]] 里"$\lambda_{\min}(\widehat A)$ 随 $m$ 衰减"那一句的算子版本。

**三类衰减速度**，决定问题有多难：

| $\sigma_j$ 的衰减 | 名称 | 例子 |
|---|---|---|
| $j^{-a}$（多项式） | 温和不适定 | $a$ 阶积分算子、Radon 变换 |
| $e^{-cj}$（指数） | 严重不适定 | 热方程反演、解析延拓、Laplace 变换 |
| 有限秩后为零 | 不可辨识 | 零空间非平凡 |

> [!note] 统计版本：$\delta$ 从哪来
> 确定性逆问题里 $\delta$ 是"测量误差上界"。统计里 $f^\delta$ 是随机的，$\delta$ 由样本量决定：$\delta\asymp n^{-1/2}$（$\sqrt n$-一致的经验估计）。**把 $\delta=n^{-1/2}$ 代进下面所有的率，就得到 [[P2 非参数回归与最小最大率|P2]] 里的统计率。**两套语言在这一点上完全对上：源条件 $\nu$ ↔ 光滑度 $r$，奇异值衰减 $a$ ↔ 谱衰减 $p$。

## 2. 谱滤波正则化

思路：用一族有界算子逼近 $\mathcal{A}^\dagger$，把 $\sigma^{-1}$ 换成截断版本。

$$\mathcal{R}_\lambda f:=\sum_j q_\lambda(\sigma_j)\,\sigma_j^{-1}\langle f,v_j\rangle\,u_j,$$

$q_\lambda$ 是**滤波函数**，满足 $q_\lambda(\sigma)\to1$（$\lambda\to0$）、$|q_\lambda(\sigma)/\sigma|\le C/\sqrt\lambda$。

| 方法 | $q_\lambda(\sigma)$ | 备注 |
|---|---|---|
| Tikhonov | $\dfrac{\sigma^2}{\sigma^2+\lambda}$ | $=\arg\min\Vert \mathcal{A}\phi-f\Vert ^2+\lambda\Vert \phi\Vert ^2$ |
| 截断 SVD | $\mathbf{1}\{\sigma^2\ge\lambda\}$ | 硬截断 |
| Landweber | $1-(1-\tau\sigma^2)^{k}$，$\lambda=1/k$ | 就是梯度下降，**迭代次数即正则化参数** |
| 共轭梯度 | 非线性 | 实践最快，理论最麻烦 |

> [!tip] "早停就是正则化"不是比喻
> Landweber 迭代 $\phi_{k+1}=\phi_k+\tau\mathcal{A}^*(f-\mathcal{A}\phi_k)$ 就是最小二乘泛函的梯度下降。它的滤波函数说明：**迭代 $k$ 步 ≈ Tikhonov 取 $\lambda=1/k$。**训练早停与 $\ell^2$ 惩罚的等价性（[[notes/deep-learning/05 优化的数学|DL 05]] 里的隐式正则化）在线性情形下就是这一行。

### 源条件与率

光有 $\lambda\to0$ 只能保证收敛，**不能保证任何速度**（这是不适定问题的基本事实：在整个空间上收敛可以任意慢）。要率就必须对真解加光滑性假设：

> **源条件.** $\phi^\dagger=(\mathcal{A}^*\mathcal{A})^{\nu}w$，$\|w\|\le R$，$\nu>0$。

等价说法：$\phi^\dagger$ 的谱系数衰减比 $\sigma_j^{2\nu}$ 快。**这是"真解不能有太多高频"的精确表述**，与 Hölder / Sobolev 光滑性在具体例子里可以对上。

> **定理.** Tikhonov 取 $\lambda\asymp(\delta/R)^{2/(2\nu+1)}$，对 $0<\nu\le1$，
> $$\big\|\phi_\lambda^\delta-\phi^\dagger\big\|\ \lesssim\ R^{\frac{1}{2\nu+1}}\,\delta^{\frac{2\nu}{2\nu+1}} .$$
> 且这在源条件类上是最优的。

**核对**：把 $\delta=n^{-1/2}$ 代入，$\nu=r-\frac12$，就回到 [[P2 非参数回归与最小最大率#8-核岭回归通向-p3-的桥|P2 §8]] 的 $n^{-2r/(2r+p)}$ 形状。

> [!warning] Tikhonov 的饱和
> $\nu>1$ 时上面的率**不再改善**，Tikhonov 卡在 $\delta^{2/3}$。原因看滤波函数就清楚：$1-q_\lambda(\sigma)=\lambda/(\sigma^2+\lambda)$ 对小 $\sigma$ 的逼近阶最多是 $\sigma^2$，再光滑也用不上。
>
> **要突破 $\delta^{2/3}$ 必须换滤波**：截断 SVD、Landweber、共轭梯度都没有饱和。这是"为什么不能一律用 Tikhonov"的技术答案，也是实践中迭代法常常更准的原因。

### 参数选择

- **先验规则**：$\lambda=\lambda(\delta)$，要知道 $\delta$ 和 $\nu$。理论最干净，实践没法用。
- **Morozov 偏差原则**：取最大的 $\lambda$ 使 $\|\mathcal{A}\phi_\lambda^\delta-f^\delta\|\le\tau\delta$。**只需要知道 $\delta$。**（在 Tikhonov 下达到 $\nu\le1/2$ 的最优率。）
- **L-曲线 / GCV**：不需要 $\delta$，理论保证弱。

> [!note] Bakushinskii 否决定理
> **任何完全不用噪声水平 $\delta$ 的参数选择规则，都不可能对所有数据给出最坏情形收敛。**（Bakushinskii 1984）
>
> 这条定理值得记住，因为它解释了统计里的一件事：交叉验证之所以能用，是因为它**隐含地从数据里估了噪声水平**，而不是因为它绕开了这个障碍。

## 3. RKHS：为什么范数的选择不是小事

上面写 $\lambda\|\phi\|^2$ 时，$\|\cdot\|$ 取哪个空间的范数是**自由参数**，而且它决定了正则化偏向什么解。这一节说明"对的选择"长什么样。

**定义.** $\mathcal{H}\subset\R^{\mathcal{X}}$ 是 RKHS，若点求值泛函 $\delta_x:f\mapsto f(x)$ 连续。Riesz 表示给出 $K_x\in\mathcal{H}$ 使 $f(x)=\langle f,K_x\rangle_{\mathcal{H}}$，再生核 $K(x,y)=\langle K_x,K_y\rangle$。

- **Moore–Aronszajn**：正定核 $\leftrightarrow$ RKHS，一一对应。
- **Mercer**：$\mathcal{X}$ 紧、$K$ 连续，则 $K(x,y)=\sum_j\mu_j e_j(x)e_j(y)$，$\{e_j\}$ 是积分算子 $L_K$ 在 $L^2(\rho)$ 上的特征基，且
$$\mathcal{H}=\Big\{f=\sum_jc_je_j:\ \sum_j\frac{c_j^2}{\mu_j}<\infty\Big\},\qquad \|f\|_{\mathcal{H}}^2=\sum_j\frac{c_j^2}{\mu_j}.$$

> [!tip] 一句话理解 RKHS
> **RKHS 范数就是"按 $L_K$ 的谱加权的 $L^2$ 范数"，高频（小 $\mu_j$）被罚得重。**
>
> 于是 $\mathcal{H}=L_K^{1/2}(L^2(\rho))$，插值空间 $[\mathcal{H}]^s:=L_K^{s/2}(L^2(\rho))$ 给出一整个尺度：$s=0$ 是 $L^2$，$s=1$ 是 $\mathcal{H}$，$s=2$ 对应源条件 $\nu=1/2$。**"源条件"和"属于哪个 RKHS 插值空间"是同一件事的两种说法。**

**表示定理.** 对任意增函数 $\Omega$ 与任意损失 $V$，
$$\min_{f\in\mathcal{H}}\ \sum_{i=1}^nV\big(y_i,f(x_i)\big)+\Omega\big(\|f\|_{\mathcal{H}}\big)$$
的极小元形如 $f=\sum_{i=1}^n\alpha_iK(\cdot,x_i)$。**无限维优化被有限维参数化。**证明只是把 $f$ 分解成 $\mathrm{span}\{K_{x_i}\}$ 与其正交补，注意正交补分量不影响损失但增加范数。

## 4. 学习问题的正规算子与可辨识函数空间

现在把上面两节接到这门课的实际问题上。

**统一形式.** 未知量是一个函数 $\phi$（交互核、算子核、score）。观测通过一个**线性**依赖 $\phi$ 的映射产生：
$$R_\phi[u]\quad\text{线性于 }\phi,\qquad \text{数据}=\{(u^{(m)},\,f^{(m)}=R_{\phi^\dagger}[u^{(m)}]+\text{噪声})\}_{m=1}^M .$$

- **交互粒子系统**：$u=$ 粒子构型，$R_\phi[u]_i=\frac1N\sum_j\phi(|x_{ij}|)x_{ij}$，$f=$ 速度/加速度。
- **非局部算子**：$R_\phi[u](x)=\int\phi(|y|)\,g(u(x+y),u(x))\,\mathrm{d}y$。
- **注意力式模型**：$R_\phi[u]=\sum_j\phi(\langle q_i,k_j\rangle)v_j$。

三者的共同点：**$\phi$ 是一元函数，$u$ 是高维的，映射 $\phi\mapsto R_\phi[u]$ 线性。**这正是 [[P2 非参数回归与最小最大率#5-维数诅咒与结构假设|P2 §5]] 那张表里"一维结构"的来源。

**损失是二次的.**
$$\mathcal{E}(\phi)=\frac1M\sum_m\big\|R_\phi[u^{(m)}]-f^{(m)}\big\|^2\ \Longrightarrow\ \mathcal{E}(\phi)=\langle\mathcal{L}\phi,\phi\rangle-2\langle\phi,b\rangle+c,$$
其中 $\mathcal{L}$ 是**正规算子**（$=\mathcal{A}^*\mathcal{A}$ 的角色），非负、自伴、通常紧。

**探索测度.** 定义 $\rho$ 为 $\phi$ 的**自变量**（如成对距离 $r=|x_{ij}|$）在数据中的经验分布。它有两个作用：

1. 提供工作空间 $L^2(\rho)$——**误差只能在 $\rho$ 的支撑上被度量**，这与 [[P1 随机微分方程与 Fokker–Planck#7-girsanov-与轨迹似然这门课的核心工具|P1 §7]] 里 $\rho_T$ 的角色是同一件事；
2. 使 $\mathcal{L}$ 成为 $L^2(\rho)$ 上的积分算子，$\mathcal{L}\phi(r)=\int \bar G(r,s)\phi(s)\,\rho(\mathrm{d}s)$，核 $\bar G$ 由数据显式给出。

> **定义（可辨识函数空间，FSOI）.** $H:=\overline{\mathrm{span}}\{\psi_j:\mathcal{L}\psi_j=\mu_j\psi_j,\ \mu_j>0\}\subset L^2(\rho)$。

> **定义（coercivity 条件）.** 存在 $c_{\mathcal{L}}>0$ 使 $\langle\mathcal{L}\phi,\phi\rangle\ge c_{\mathcal{L}}\|\phi\|^2_{L^2(\rho)}$ 对所有 $\phi\in H$ 成立。

> [!tip] 这两个定义是 Part 3 的全部概念内容
> - **FSOI 回答"能学到什么"**：$\mathcal{L}$ 的零空间上损失完全不变，那些方向的信息数据里根本没有。$\phi^\dagger\notin H$ 的分量是**不可辨识**的，任何算法都拿不到。
> - **coercivity 回答"学得稳不稳"**：它是 $\lambda_{\min}$ 的算子版本，等价于"$\mathcal{L}$ 在 $H$ 上有谱隙"。有它就有唯一性与稳定性估计，没有它误差可以被任意放大。
> - **coercivity 在具体模型里是定理不是假设。**对交换分布下的一阶粒子系统、对某些平均场方程，它被证明成立；对二阶系统与一般情形，它是公开问题的一部分。这是 Fei Lu 一系列工作（Li–Lu、Li–Lu–Maggioni–Tang–Zhang 的可辨识性论文）的主要技术目标。
>
> **注意 $\mathcal{L}$ 紧 $\Rightarrow$ 特征值 $\to0$。**所以即使 coercivity 在 $H$ 上成立，$H$ 上的逆仍然是不适定的——**正则化不可回避**。

## 5. DARTR：让正则化适应数据

回到 §3 的自由参数：惩罚项该用哪个范数？

**问题.** 用 $\|\phi\|_{L^2}$ 或 $\|\phi\|_{H^1}$ 都可以，但结果对**数据的尺度、$\rho$ 的形状、离散化的细度**敏感——同一个问题换个单位或换个网格，正则化参数的最优值会变，估计量的质量也会变。这在数值实验里是真实存在的困扰，不是理论洁癖。

**DARTR 的想法**（[Lu–Lang–An, MSML 2022](https://math.jhu.edu/~feilu/publications.html)）：**不要外生地选范数，让数据自己给出一个 RKHS。**

具体地，取由正规算子的核 $\bar G$（按探索测度 $\rho$ 归一化后）定义的 RKHS $\mathcal{H}_{\bar G}$，惩罚项用 $\lambda\|\phi\|_{\mathcal{H}_{\bar G}}^2$。三个后果：

1. **正则化只作用在 FSOI 上。**因为 $\mathcal{H}_{\bar G}\subset H$，不可辨识的方向自动被排除，而不是靠人工截断。
2. **与数据尺度相容。**$\bar G$ 和 $\rho$ 同时随数据缩放，惩罚项的相对权重不变。
3. **在小噪声极限下有正确的渐近行为**（Lang–Lu 的 small noise analysis）：随 $\delta\to0$，DARTR 的估计量收敛到 $\phi^\dagger$ 在 FSOI 上的投影，且给出收敛率。

> [!note] 与"随便挑个高斯核做 KRR"的区别
> 标准 KRR 里的核 $K$ 是**用户选的超参数**，与问题的算子无关。DARTR 里的核是**问题的正规算子本身**。用 §3 的语言：它把源条件的那个尺度 $[\mathcal{H}]^s$ 直接建在 $\mathcal{A}^*\mathcal{A}$ 上，于是"$\phi^\dagger$ 有多光滑"这件事被自动地用对了度量来衡量。
>
> 代价是 $\mathcal{H}_{\bar G}$ 依赖数据，理论分析要额外处理这个随机性——这是这条线上论文的技术难点，也是"iterative / scalable DARTR"那几篇工作要解决的计算问题（正规算子是稠密的，直接分解代价 $O(m^3)$）。

## 6. 贝叶斯对应

Tikhonov 与高斯先验是同一件事：

$$\underbrace{\min_\phi\ \|\mathcal{A}\phi-f^\delta\|^2_{\Sigma^{-1}}+\lambda\|\phi\|^2_{\mathcal{C}^{-1}}}_{\text{正则化最小二乘}}\quad\Longleftrightarrow\quad\underbrace{\text{MAP of }\ \pi(\phi\mid f^\delta)\ \text{with}\ \phi\sim\mathcal{N}(0,\lambda^{-1}\mathcal{C}),\ \text{噪声}\sim\mathcal{N}(0,\Sigma)}_{\text{贝叶斯}}$$

线性高斯情形下后验也是高斯，均值 $=$ Tikhonov 解，**协方差还免费给了不确定性量化**。

- **先验协方差 $\mathcal{C}$ $\leftrightarrow$ 惩罚范数。**于是 §5 的问题变成"先验从哪来"，DARTR 的答案就是 [Chada–Lang–Lu–Wang (JMLR 2024)](https://math.jhu.edu/~feilu/publications.html) 的 **data-adaptive prior**：取 $\mathcal{C}=\mathcal{L}$。
- **无限维的坑.** 无限维上没有 Lebesgue 测度，"密度"要用 Cameron–Martin 空间和 Radon–Nikodym 导数来写；高斯测度的 Cameron–Martin 空间**恰好是**它协方差算子诱导的 RKHS。Stuart 的 Acta Numerica 综述是这套形式化的标准来源。
- **后验相合性**给出的率与频率派的率一致（在源条件下），但需要先验与真解的光滑度匹配——先验太光滑会**过度收缩**，这是贝叶斯非参数里的经典陷阱。

## 7. 率：学算子里的核

把 §2 的确定性率与 [[P2 非参数回归与最小最大率|P2]] 的统计率合起来，就是这条线目前的前沿结果：

- **交互核**（有限 $N$）：tLSE 达到 $M^{-2\beta/(2\beta+1)}$，且是最小最大最优的（[Wang–Seroussi–Lu 2023](https://arxiv.org/abs/2311.16852)）。**结论是"没有变难"**——动力学的相关性没有恶化率，只是改变了常数与技术工具。
- **算子里的核**：Zhang–Wang–Lu (2025) 给出最小最大率。这里率**会**依赖于正规算子的谱衰减，即依赖于算子有多不适定——与交互核的情形不同，这是"温和不适定 vs 严重不适定"的区别在统计上的体现。
- **注意力式模型的成对交互**：Zucker–Wang–Lu–Seroussi (ICLR 2026)。

> [!tip] 这一节该记住的判断
> **率什么时候是"经典非参数率"，什么时候更差，取决于正规算子的谱。**
>
> - 谱有下界（coercivity 一致成立）$\Rightarrow$ 问题实质上是良态的，拿到 $n^{-2\beta/(2\beta+1)}$。
> - 谱多项式衰减 $\Rightarrow$ 率退化成 $n^{-2\nu/(2\nu+a+1)}$ 类型，指数被不适定度 $a$ 拖累。
> - 谱指数衰减 $\Rightarrow$ 只有对数率 $(\log n)^{-c}$。**这是"再多数据也没用"的精确形式。**
>
> 拿到一个新问题，第一个该问的定量问题就是：**它的正规算子的谱怎么衰减？**

## 8. 往前接

- **[Lu–Yu (2025), *Transformer learns the cross-task prior and regularization for in-context learning*](https://arxiv.org/abs/2505.12138).** 论点：在病态的 in-context 线性回归上，训练好的 transformer 给出的不是最小二乘解，而是**带正则的解**，且正则项的形状由预训练时的**跨任务先验**决定。用本篇的语言：**transformer 在预训练中学到了 §6 里的那个 $\mathcal{C}$。**这把课程的前后两半缝在了一起，也是系列 11 的内容。
- **算子学习**（DeepONet / FNO）：那边是**正问题**的逼近（学 $u\mapsto\mathcal{L}u$），本篇是**逆问题**（学 $\mathcal{L}$ 里的参数）。两者的误差分析共用谱语言。见系列 14。
- **score matching**：是本篇框架下的良态特例——正规算子是恒等（$\mathcal{A}=\mathrm{Id}$），于是不需要正则化，率直接是 P2 的经典率。**这解释了为什么扩散模型的理论比逆问题的理论干净得多。**见系列 07。

## 9. 一页速查

| 概念 | 内容 |
|---|---|
| 不适定 | $\mathcal{A}$ 紧 $\Rightarrow\sigma_j\to0\Rightarrow\mathcal{A}^\dagger$ 无界 |
| Picard 判据 | $f\in\mathrm{ran}\mathcal{A}\iff\sum\sigma_j^{-2}\lvert\langle f,v_j\rangle\rvert^2<\infty$ |
| 谱滤波 | $\mathcal{R}_\lambda=\sum q_\lambda(\sigma_j)\sigma_j^{-1}\langle\cdot,v_j\rangle u_j$ |
| Tikhonov 滤波 | $q_\lambda(\sigma)=\sigma^2/(\sigma^2+\lambda)$ |
| 源条件 | $\phi^\dagger=(\mathcal{A}^*\mathcal{A})^\nu w$ |
| 率 | $\delta^{2\nu/(2\nu+1)}$，Tikhonov 在 $\nu=1$ 饱和 |
| 参数选择 | 偏差原则要 $\delta$；Bakushinskii：不用 $\delta$ 就不可能有最坏情形收敛 |
| RKHS | $\mathcal{H}=L_K^{1/2}L^2(\rho)$，$\Vert f\Vert _{\mathcal{H}}^2=\sum c_j^2/\mu_j$ |
| 表示定理 | 极小元 $=\sum_i\alpha_iK(\cdot,x_i)$ |
| 探索测度 $\rho$ | 由数据决定的工作空间；误差只在其支撑上有意义 |
| FSOI | 正规算子正特征值张成的闭子空间；**能学到的全部** |
| coercivity | $\langle\mathcal{L}\phi,\phi\rangle\ge c\Vert \phi\Vert ^2$ 于 FSOI 上；稳定性的来源 |
| DARTR | 惩罚范数取自正规算子诱导的 RKHS；等价于用 $\mathcal{L}$ 当先验协方差 |
| 贝叶斯对应 | Tikhonov $=$ MAP，先验协方差 $\leftrightarrow$ 惩罚范数 |

## 参考

- Engl, Hanke & Neubauer, *Regularization of Inverse Problems*, Kluwer 1996.
- Cucker & Smale, *On the mathematical foundations of learning*, Bull. Amer. Math. Soc. 39 (2002) 1–49.
- Aronszajn, *Theory of reproducing kernels*, Trans. AMS 68 (1950) 337–404.
- Steinwart & Christmann, *Support Vector Machines*, Springer 2008. §4（RKHS）、附录（插值空间）。
- Stuart, *Inverse problems: a Bayesian perspective*, Acta Numerica 19 (2010) 451–559.
- Bakushinskii, *Remarks on choosing a regularization parameter using the quasi-optimality and ratio criterion*, USSR Comput. Math. Math. Phys. 24 (1984).
- [Lu, Lang & An, *DARTR: Data adaptive RKHS Tikhonov regularization for learning kernels in operators*](https://math.jhu.edu/~feilu/publications.html), MSML (PMLR) 2022.
- [Chada, Lang, Lu & Wang, *A data-adaptive prior for Bayesian learning of kernels in operators*](https://math.jhu.edu/~feilu/publications.html), JMLR 25 (2024).
- [Lang & Lu, *Small noise analysis for Tikhonov and RKHS regularizations*](https://math.jhu.edu/~feilu/publications.html) (2023).
- [Li & Lu, *On the coercivity condition in the learning of interacting particle systems*](https://math.jhu.edu/~feilu/publications.html), Stoch. Dyn. 23 (2023).
- [Wang, Seroussi & Lu, *Optimal minimax rates for learning interaction kernels*](https://arxiv.org/abs/2311.16852) (2023).

## Related

- [[index|科学基础模型的数学]]
- [[P1 随机微分方程与 Fokker–Planck]]
- [[P2 非参数回归与最小最大率]]
- [[notes/deep-learning/05 优化的数学|DL 05 优化的数学]]
- [[notes/deep-learning/04 统计推断|DL 04 统计推断]]
