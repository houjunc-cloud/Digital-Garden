---
title: 14 算子学习：DeepONet、FNO 与逼近理论
description: 无穷维之间的映射如何被参数化；误差分解与 Kolmogorov 宽度下界；参数复杂性的诅咒与三条逃逸路线；统计侧的率。
tags:
  - scientific-foundation-models
  - operator-learning
  - approximation-theory
stage: 🌱 seedling
date: 2026-08-18
---

# 14 算子学习：DeepONet、FNO 与逼近理论

> 课程 12/1, 12/3 的前半：算子学习。
>
> [[13 学习算子中的核：正规算子、FSOI 与 DARTR|13]] 学的是算子**里**的一个一元核（**逆**问题）。这一篇学的是算子**本身**（**正**问题）：给定 $\{(a_i,\mathcal{G}^\dagger(a_i))\}$，逼近 $\mathcal{G}^\dagger:\mathcal{X}\to\mathcal{Y}$，$\mathcal{X},\mathcal{Y}$ 是函数空间。
>
> **本篇的中心论点**：万有逼近是廉价且总成立的，**率才是全部故事**；而对仅由正则性定义的算子类，率被证明是灾难性的。**唯一的出路是额外结构。**这与 [[13 学习算子中的核：正规算子、FSOI 与 DARTR|13]] 的教训是同一条：**结构决定率。**

> [!question] 卡住了从哪儿看起
> - 📐 [Lanthaler, Mishra, Karniadakis, *Error estimates for DeepONets*](https://arxiv.org/abs/2102.09618), Trans. Math. Appl. 6 (2022) — **§2 的误差分解是这个领域的中心恒等式**
> - 📐 [Lanthaler & Stuart, *The parametric complexity of operator learning*](https://arxiv.org/abs/2306.15924) — §4 的下界，architecture-independent
> - [Kovachki, Lanthaler, Mishra, *On universal approximation and error bounds for FNO*](https://www.jmlr.org/papers/volume22/21-0806/21-0806.pdf), JMLR 22 (2021)
> - [Kovachki et al., *Neural operator: learning maps between function spaces*](https://arxiv.org/abs/2108.08481), JMLR 24 (2023) — 统一框架

## 0. 两个必须分开的问题

$$\textbf{逼近（表达力）}:\ \text{要多少参数才能}\ \lVert\mathcal{G}^\dagger-\mathcal{N}\rVert\le\varepsilon\ ?$$
$$\textbf{统计（样本复杂度）}:\ \text{要多少组}\ (a_i,\mathcal{G}^\dagger(a_i))\ ?$$

**混淆这两者是读这块文献时最常见的错误。**下界分别存在，机制不同。

## 1. 万有逼近

> **定理（Chen & Chen 1995）.** 设 $\sigma$ 连续非多项式，$K_1\subset X$（Banach）紧，$V\subset C(K_1)$ 紧，$K_2\subset\R^{d}$ 紧，$\mathcal{G}:V\to C(K_2)$ 连续（可非线性）。则对任意 $\varepsilon>0$ 存在 $n,p,m$、**传感点** $x_1,\dots,x_m\in K_1$ 与系数，使得
> $$\Big\lvert\mathcal{G}(u)(y)-\sum_{k=1}^{p}\underbrace{\sum_{i=1}^{n}c^k_i\sigma\Big(\sum_{j=1}^m\xi^k_{ij}u(x_j)+\theta^k_i\Big)}_{\text{branch }b_k(u)}\ \underbrace{\sigma(w_k\cdot y+\zeta_k)}_{\text{trunk }t_k(y)}\Big\rvert<\varepsilon$$
> 对所有 $u\in V$、$y\in K_2$ 成立。

**三条结构要点（后面的下界全从这里长出来）：**

1. 输入函数**只通过 $m$ 个点求值**进入 —— 编码器 $\mathcal{E}(u)=(u(x_1),\dots,u(x_m))$。$V$ 紧（等度连续）是这一步合法的原因。
2. 输出是 $p$ 个**固定**函数的**线性组合** —— **线性**重构器。**这个线性性正是后面 Kolmogorov 宽度下界的入口。**
3. 定理纯定性：$n,p,m$ 对 $\varepsilon$ 没有任何控制。

**DeepONet** 就是把这个结构参数化：branch 网 $\boldsymbol b:\R^m\to\R^p$、trunk 网 $\boldsymbol t:\R^{d'}\to\R^p$，
$$\mathcal{N}(u)(y)=\sum_{k=1}^pb_k\big(u(x_1),\dots,u(x_m)\big)\,t_k(y)+b_0 .$$
**trunk 是学出来的基，branch 给系数**：非线性编码器 $+$ 线性解码器。

## 2. 误差分解与下界

Lanthaler–Mishra–Karniadakis 把 DeepONet 写成 $\mathcal{N}=\mathcal{R}\circ\mathcal{A}\circ\mathcal{E}$（重构 $\circ$ 逼近 $\circ$ 编码），并证明：

> **定理（误差分解）.** 对 $\alpha$-Hölder 的 $\mathcal{G}$，
> $$\widehat{\mathcal{E}}\ \le\ \mathrm{Lip}_\alpha(\mathcal{G})\,\mathrm{Lip}(\mathcal{R}\circ\mathcal{P})\,\big(\widehat{\mathcal{E}}_{\mathcal{E}}\big)^{\alpha}\ +\ \mathrm{Lip}(\mathcal{R})\,\widehat{\mathcal{E}}_{\mathcal{A}}\ +\ \widehat{\mathcal{E}}_{\mathcal{R}} ,$$
> 三项分别是**编码误差**（$m$ 个传感器丢掉的信息）、**逼近误差**（有限维 DNN 问题 $\R^m\to\R^p$）、**重构误差**（把输出测度投影到 $\mathrm{span}\{\tau_k\}$ 丢掉的信息）。

**这是本领域的中心恒等式。**它的价值在于把一个无穷维问题拆成三块，每块单独有下界：

> **定理（最优重构）.** 设 $\nu=\mathcal{G}_\#\mu$ 是输出测度，$\Gamma_\nu$ 是它的协方差算子，特征值 $\lambda_1\ge\lambda_2\ge\cdots$。则对**任意**大小为 $p$ 的 trunk 基，
> $$\widehat{\mathcal{E}}_{\mathcal{R}}\ \ge\ \Big(\sum_{k>p}\lambda_k\Big)^{1/2},$$
> 等号在 $\tau_k$ 取 $\Gamma_\nu$ 的前 $p$ 个 PCA 特征函数时达到。

同样地，**编码器**的下界由输入测度协方差 $\Gamma_\mu$ 的谱尾给出（对线性解码器）。

> [!tip] 一句话总结这两个下界
> **算子学习能有多准，被输入/输出测度的协方差谱尾卡死。**这就是 Kolmogorov 宽度的障碍，与架构无关（只要重构是线性的）。
>
> 与 [[13 学习算子中的核：正规算子、FSOI 与 DARTR#5-最小最大率|13 §5]] 对照：那里率由**正规算子**的谱决定，这里由**数据测度**的协方差谱决定。**两者都是"谱衰减 $=$ 难度"，只是谱来自不同的算子。**

> **注（诅咒）.** 逼近一个**一般** Lipschitz 函数 $\R^m\to\R^p$ 到精度 $\varepsilon$ 需要规模 $\gtrsim\varepsilon^{-m/2}$ 的 ReLU 网。而相合性迫使 $m=m(\varepsilon)\to\infty$，于是最坏情形的 DeepONet 规模 $\gtrsim\varepsilon^{-m(\varepsilon)/2}$，**比任何代数率都快**。

**正面结果**：对四类具体问题（非线性受迫 ODE、变系数线性椭圆、Allen–Cahn、标量守恒律），DeepONet **打破**诅咒，规模随 $1/\varepsilon$ 代数增长。

## 3. FNO 与神经算子

**FNO 层**（$v_t:D\to\R^{d_v}$）：
$$v_{t+1}(x)=\sigma\Big(Wv_t(x)+\big(\mathcal{K}(\phi)v_t\big)(x)\Big),\qquad \mathcal{K}(\phi)v_t=\mathcal{F}^{-1}\big(R_\phi\cdot\mathcal{F}v_t\big),$$
$R_\phi$ 是学出的复张量，只保留 $\lvert k\rvert\le k_{\max}$ 的模式，用 FFT 算。

**离散不变性.** 参数活在 Fourier 空间而非网格上 $\Rightarrow$ 同一组参数可用于不同分辨率（zero-shot 超分辨）。

> [!warning] 离散不变性有一个真实的陷阱
> [Bartolucci 等（ReNO, arXiv:2305.19913）](https://arxiv.org/abs/2305.19913) 指出：神经算子的离散化一般会引入**算子混叠**（operator aliasing）——离散映射未必是连续算子的忠实表示。他们形式化了"无混叠"的条件。
>
> 这是**采样定理**在算子层面的化身，值得在讲义里点出来：**"参数在连续空间里"不自动等于"离散实现是相合的"。**

**逼近理论**（Kovachki–Lanthaler–Mishra, JMLR 2021）：

- **万有逼近**：任意连续 $\mathcal{G}:H^s(\mathbb{T}^d)\to H^{s'}(\mathbb{T}^d)$ 在紧集上可被 FNO 一致逼近。
- **一般情形的规模**：**超指数**，本质上 $\mathrm{size}\gtrsim\varepsilon^{-\varepsilon^{-d/s}}$。原因是保留的 Fourier 模式数 $D\sim\varepsilon^{-d/s}$ **本身依赖 $\varepsilon$**，然后还要在 $D$ 维上做 Lipschitz 逼近。
- **Darcy 型椭圆**：$\mathrm{size}\lesssim\varepsilon^{-d/k}\log(1/\varepsilon)$。
- **Navier–Stokes**（$r\ge d/2+2$）：$\mathrm{size}\le C\varepsilon^{-(1+d/r)}$。

**于是"指数还是代数"的答案是：对这些具体 PDE 算子是代数的（甚至近线性），对仅有正则性的算子类是超指数的。**

**PCA-Net**（Bhattacharya–Hosseini–Kovachki–Stuart）：把编码/解码都取成经验 PCA（Karhunen–Loève），中间接一个 DNN。存在性结果，**无收敛率**；后来 Lanthaler 把它的复杂度精确定了下来。

## 4. 参数复杂性的诅咒

> **定理（Lanthaler & Stuart, Thm 2.11）.** 设 $K$ 是无穷维 Banach 空间的紧子集，含一个无穷维超立方 $Q_\alpha$（$\alpha>1$），$r\in\mathbb{N}$。则存在 $r$ 次 Fréchet 可微的泛函与常数 $c,\bar\varepsilon>0$，使得任何达到精度 $\varepsilon\le\bar\varepsilon$ 的逼近的复杂度满足
> $$\mathrm{cmplx}\ \ge\ \exp\!\Big(c\,\varepsilon^{-1/((\alpha+1+\delta)r)}\Big).$$

**即：参数个数指数级（于 $1/\varepsilon$ 的某个幂）。**这是维数诅咒的无穷维版本，**且在所述类里与架构无关**——对 PCA-Net、DeepONet、NOMAD 都成立（非线性重构救不了），对 FNO 的版本是"网络规模或离散参数 $N$ 二者之一必须指数大"。

**同一批工作的正面结果**：对 Hamilton–Jacobi 方程的解算子，基于**特征线法**构造的架构（HJ-Net）**可证明地打破**这个诅咒。

> [!tip] 口号
> **光滑性永远不够，必须利用结构。**
>
> 这句话是本篇与 [[13 学习算子中的核：正规算子、FSOI 与 DARTR|13]]、[[05 学习交互核的最小最大率|05]] 共有的结论，只是在无穷维上说得最极端：**在有限维里，光滑度 $\beta$ 至少给你 $n^{-2\beta/(2\beta+d)}$；在无穷维里，光滑度什么也不给。**

## 5. 三条逃逸路线

**(a) 全纯性 / $\ell^p$-可和的参数依赖.** [Adcock, Dexter, Moraga (NeurIPS 2024)](https://arxiv.org/abs/2406.13928)：对 $(\boldsymbol b,\varepsilon)$-**全纯**算子类（参数 PDE 里仿射系数依赖的标准类，Cohen–DeVore–Schwab 那条线），tanh 网从 $m$ 个样本达到代数率 $m^{1/2-1/p}$（$L^2_\mu$）与 $m^{1-1/p}$（$L^\infty_\mu$），**且有匹配下界，故最优**。

> [!note] 两个诚实的注脚
> 1. 率**与参数维数无关**——全纯性 $+$ $\ell^p$ 可和确实打破诅咒。
> 2. **这不是神经网络的功劳**：多项式/最小二乘方法达到同样的最优率，深度学习只是**追平**。在讲义里值得说破，因为文献里常被含糊过去。

**(b) 低内蕴维数 / 低复杂度结构.** Chen–Wang–Yang（[arXiv:2301.12227](https://arxiv.org/abs/2301.12227)）：在"编码后的算子内蕴维数与离散分辨率无关"与"映射可分解成少输入映射的复合"两个假设下，样本复杂度依赖内蕴维数而非离散维数，于是率不随网格加密而退化。

**(c) 问题特定的结构.** HJ-Net（特征线）、Boullé–Halikias–Townsend（[PNAS 2023](https://arxiv.org/abs/2302.12888)：椭圆算子的 Green 函数有层次低秩结构，随机数值线性代数给出**误差随训练集规模指数收敛**）。**后者是"结构打破诅咒，可证明地、在统计意义上"的最干净例子。**

## 6. 统计侧

逼近之外还有样本复杂度，而且它有独立的下界。

**线性算子的率.** de Hoop–Kovachki–Nelsen–Stuart（[arXiv:2108.12515](https://arxiv.org/abs/2108.12515)）：模型 $y_n=Lx_n+\gamma\xi_n$，$x_n\sim\nu$ 协方差 $\Lambda$，$L$ 未知自伴（可无界）。在对角化情形、$\langle\varphi_j,\Lambda\varphi_j\rangle\asymp j^{-2\alpha}$、先验方差 $\sigma_j^2\asymp j^{-2p}$、真参数在 $\mathcal{H}^s$ 中的假设下，
$$\mathbb{E}\sum_jj^{-2\alpha'}\big\lvert l^\dagger_j-l^{(N)}_j\big\rvert^2\ \le\ C\,N^{-\frac{\alpha'+\min\{p-1/2,\ s\}}{\alpha+p}},$$
并有后验收缩与在某些区间的**匹配下界**。

> [!tip] 这条结果的结构性结论值得记住
> **无界算子比有界/紧算子更难学；输入协方差衰减越快（高频模式激发越弱），率越差。**
>
> 换句话说：**你只能学到数据激发了的那些模式。**这与 [[04 从轨迹学交互核：变分表述与可辨识性#2-变分表述|探索测度]]、[[13 学习算子中的核：正规算子、FSOI 与 DARTR#2-探索测度与正规算子|13 §2]] 是同一句话在第三个场合出现。

**Lipschitz 算子的样本复杂度诅咒.** 在无穷维 Hilbert 空间上取非退化高斯 $\mu$，自适应 $m$-宽度**不能**代数衰减，**无论谱性质如何**（[arXiv:2410.23440](https://arxiv.org/abs/2410.23440)，作者未核实）。这是**信息论**的诅咒，与架构与计算都无关。正面：谱衰减足够快（如双指数）时可以任意接近代数率。

## 7. 全景：诅咒的故事

1. **万有逼近**：DeepONet、FNO、神经算子、PCA-Net 都有，而且基本免费。
2. **仅由正则性定义的类**（$\mathcal{C}^k$、Lipschitz）：**参数复杂度**与**样本复杂度**都有排除任何代数率的下界。
3. **逃逸路线**，全部需要额外结构：
 - 全纯 / $\ell^p$-可和参数依赖（有匹配下界，最优）；
 - 输入/输出协方差谱的快速衰减（LMK 的两个下界精确告诉你是哪条谱尾）；
 - PDE 特有的正则性与光滑效应（Darcy、NS）；
 - 显式解结构（特征线、层次低秩 Green 函数）。

> [!warning] 与 [[13 学习算子中的核：正规算子、FSOI 与 DARTR|13]] 并排看
> **学算子里的一元核**：有完整的最小最大理论，率是代数的，由正规算子的谱决定。
> **学整个算子**：一般情形没有代数率。
>
> **差别就是那个一元结构假设。**这门课的选题逻辑至此完全清楚了：**它挑的正是那些结构强到还有定量理论的问题。**"mathematically transparent models rather than a broad survey" 说的就是这件事。

## 8. 一页速查

| 结论 | 内容 |
|---|---|
| Chen–Chen | 连续非多项式激活 $\Rightarrow$ branch/trunk 万有逼近，纯定性 |
| DeepONet | 非线性编码 $+$ **线性**解码 |
| 误差分解 | 编码 $+$ 逼近 $+$ 重构 |
| 重构下界 | $\ge(\sum_{k>p}\lambda_k)^{1/2}$，$\lambda_k$ 是输出测度协方差谱 |
| 诅咒（DeepONet） | 最坏情形规模 $\gtrsim\varepsilon^{-m(\varepsilon)/2}$ |
| FNO | Fourier 空间参数，离散不变；注意混叠（ReNO） |
| FNO 规模 | 一般超指数；Darcy $\varepsilon^{-d/k}\log\frac1\varepsilon$；NS $\varepsilon^{-(1+d/r)}$ |
| 参数复杂性诅咒 | $\exp(c\varepsilon^{-1/((\alpha+1+\delta)r)})$，架构无关 |
| 逃逸 1 | 全纯 $+$ $\ell^p$：$m^{1/2-1/p}$，最优；**多项式方法同样达到** |
| 逃逸 2 | 协方差谱快速衰减 |
| 逃逸 3 | 问题结构（特征线、层次低秩 Green 函数） |
| 统计侧 | 线性算子有率；Lipschitz 算子有信息论诅咒 |
| 通用教训 | **只能学到数据激发了的模式** |

## 参考

- Chen & Chen, *Universal approximation to nonlinear operators by neural networks*, IEEE Trans. Neural Netw. **6** (1995) 911–917.
- Lu, Jin, Pang, Zhang, Karniadakis, *Learning nonlinear operators via DeepONet*, Nature Mach. Intell. **3** (2021) 218–229; [arXiv:1910.03193](https://arxiv.org/abs/1910.03193).
- [Lanthaler, Mishra, Karniadakis, *Error estimates for DeepONets*](https://arxiv.org/abs/2102.09618), Trans. Math. Appl. **6** (2022) tnac001.
- Li et al., *Fourier neural operator for parametric PDEs*, ICLR 2021; [arXiv:2010.08895](https://arxiv.org/abs/2010.08895).
- [Kovachki, Lanthaler, Mishra, *On universal approximation and error bounds for Fourier neural operators*](https://www.jmlr.org/papers/volume22/21-0806/21-0806.pdf), JMLR **22** (2021).
- [Kovachki et al., *Neural operator: learning maps between function spaces*](https://arxiv.org/abs/2108.08481), JMLR **24** (2023).
- Bhattacharya, Hosseini, Kovachki, Stuart, *Model reduction and neural networks for parametric PDEs*; [arXiv:2005.03180](https://arxiv.org/abs/2005.03180).
- [Lanthaler & Stuart, *The parametric complexity of operator learning*](https://arxiv.org/abs/2306.15924).
- [Lanthaler, *Operator learning with PCA-Net: upper and lower complexity bounds*](https://arxiv.org/abs/2303.16317), JMLR.
- [Adcock, Dexter, Moraga, *Optimal deep learning of holomorphic operators between Banach spaces*](https://arxiv.org/abs/2406.13928), NeurIPS 2024.
- [de Hoop, Kovachki, Nelsen, Stuart, *Convergence rates for learning linear operators from noisy data*](https://arxiv.org/abs/2108.12515), SIAM/ASA JUQ.
- [Boullé, Halikias, Townsend, *Elliptic PDE learning is provably data-efficient*](https://arxiv.org/abs/2302.12888), PNAS **120** (2023).
- [Bartolucci et al., *Representation equivalent neural operators*](https://arxiv.org/abs/2305.19913), NeurIPS 2023.
- Subedi & Tewari, *Operator learning: a statistical perspective*, Annu. Rev. Stat. Appl. **13** (2026). 统计侧的书目脊柱。

## Related

- [[index|科学基础模型的数学]]
- [[13 学习算子中的核：正规算子、FSOI 与 DARTR]]
- [[15 in-context operator learning]]
- [[P2 非参数回归与最小最大率]]
- [[notes/deep-learning/02 神经网络作为函数类|DL 02 神经网络作为函数类]]
