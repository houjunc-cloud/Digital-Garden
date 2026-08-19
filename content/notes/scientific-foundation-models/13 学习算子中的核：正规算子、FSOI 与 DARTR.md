---
title: 13 学习算子中的核：正规算子、FSOI 与 DARTR
description: 非局部算子里学一元核；探索测度与自动再生核；DARTR；最小最大率如何被正规算子的谱决定；attention 作为学到的正则化子。
tags:
  - scientific-foundation-models
  - inverse-problems
  - operator-learning
  - rkhs
stage: 🌱 seedling
date: 2026-08-18
---

# 13 学习算子中的核：正规算子、FSOI 与 DARTR

> 课程 11/19（11/17 停课）：*"Learning kernels in operators"*。
>
> 这是 [[P3 RKHS 与不适定逆问题的正则化|P3]] 的完整应用，也是这门课里技术最成熟的一块——**这条线有完整的可辨识性理论、完整的正则化方法、以及匹配的最小最大率。**
>
> 与 [[04 从轨迹学交互核：变分表述与可辨识性|04]] 的关系：数学结构**完全相同**（一元未知核、线性前向映射、二次损失、紧正规算子），但**结论不同**：交互核的率是经典非参数率，算子核的率被不适定度拖累。这个对比本身是最有教育意义的部分。

> [!question] 卡住了从哪儿看起
> - [Lu, An, Yu, *Nonparametric learning of kernels in nonlocal operators*](https://arxiv.org/abs/2205.11006), J. Peridyn. Nonlocal Model. 6 (2024) — 设定与 FSOI
> - 📐 [Zhang, Wang, Lu, *Minimax rates for learning kernels in operators*](https://arxiv.org/abs/2502.20368) (2025) — §5 的率，**本篇的定量核心**
> - [Li & Lu, *Automatic reproducing kernel and regularization for learning convolution kernels*](https://arxiv.org/abs/2507.11944) (2025) — §3 的自动核与表示定理
> - [[P3 RKHS 与不适定逆问题的正则化|P3]] — 语言与工具

## 1. 设定

$$f(x)=R_\phi[u](x)+\varepsilon(x),\qquad R_\phi[u](x)=\int_{\mathcal{S}}\phi(s)\,g[u](x,s)\,\mathrm{d}s .$$

**$R_\phi$ 对未知核 $\phi$ 线性，但对 $u$ 可以非线性。**数据是 $M$ 组输入–输出函数对 $\{(u^m,f^m)\}$。

**这一个形式覆盖了一大片：**

| 应用 | $g[u](x,s)$ |
|---|---|
| 非局部扩散 / peridynamics | $u(x+s)-u(x)$（$s$ 是 lag） |
| Fredholm 第一类积分方程 | $u(x-s)$ 或一般核 |
| 平均场方程里的聚集算子 | $\nabla u$ 与 $u$ 的组合 |
| 反卷积 | $u(x-s)$ |
| 梯度流 / 弱形式 | 配测试函数后的分部积分形式 |

**与 [[04 从轨迹学交互核：变分表述与可辨识性|04]] 的对照**：那里 $u$ 是粒子构型、$g$ 是 $x^{ij}$；这里 $u$ 是函数、$g$ 是差分或卷积。**同一个模板。**

## 2. 探索测度与正规算子

损失 $\mathcal{E}(\phi)=\frac1M\sum_m\lVert R_\phi[u^m]-f^m\rVert^2$ 是 $\phi$ 的二次泛函，于是有正规算子
$$\big\langle\mathcal{L}_{\bar G}\phi,\psi\big\rangle_{L^2_\rho}=\mathbb{E}\big[\big\langle R_\phi[u],R_\psi[u]\big\rangle\big],\qquad \mathcal{L}_{\bar G}\phi(r)=\int\bar G(r,s)\,\phi(s)\,\rho(\mathrm{d}s).$$

**探索测度（Li–Lu 的定义）：**
$$\dot\rho(s)=\frac{1}{MZ}\sum_{m=1}^M\int_{\mathcal{X}}\big\lvert g[u^m](x,s)\big\rvert\,\nu(\mathrm{d}x).$$
它记录**数据到底探测了核变量的哪些取值、探测得有多重**。

> [!warning] 一个反直觉但重要的经验事实
> **网格加密会让不适定性变差。**
>
> 加密网格 $\Rightarrow$ 数据更多 $\Rightarrow$ 直觉上应该更好。但正规算子是紧的，加密只是把它的更多小特征值暴露出来：无正则化的估计量随噪声**发散**，而且网格越细发散得越厉害。
>
> **DARTR 型的估计量则随网格加密而收敛。**这是这条线最实用的一条结论，也是"必须在正确的函数空间里正则化"这句话的实验证据。

## 3. 自动再生核与表示定理

[[P3 RKHS 与不适定逆问题的正则化#5-dartr让正则化适应数据|P3 §5]] 说过 DARTR 的想法：不要外生地选惩罚范数，让数据给出一个 RKHS。Li–Lu (2025) 把它做成了一个无超参数的构造。

> **定义（自动再生核）.** 设 $G$ 是损失的二次项（Gram）核。定义
> $$\overline G(s,s'):=\frac{G(s,s')}{\dot\rho(s)\,\dot\rho(s')}\ \mathbf{1}_{\{\dot\rho(s)\dot\rho(s')>0\}} .$$

**没有超参数、没有核的选择：前向算子与数据自己选出了 RKHS。**

> **引理.** $\overline G$ 对称、正、在 $L^2_\rho$ 上紧；其 RKHS **恰是**变分问题有唯一极小元的那个空间。前向算子奇异（如反卷积）时，自动核**自动滤掉不可恢复的方向**。

> **定理（表示定理）.** 虽然极小化是在无穷维空间上，最小范数最小二乘解与 Tikhonov 解都落在**自动基函数**
> $$\xi_{mj}(s)=\mathcal{L}_{\overline G}\Big[\frac{g[u^m](x_j,\cdot)}{\dot\rho(\cdot)}\Big](s)$$
> 张成的有限维空间里，且系数有显式公式。

> [!tip] 这是 [[P3 RKHS 与不适定逆问题的正则化#3-rkhs为什么范数的选择不是小事|P3 §3]] 的表示定理的"逆问题版"
> 标准表示定理里基是 $K(\cdot,x_i)$，$K$ 是**用户选的**。这里基是 $\mathcal{L}_{\overline G}[g/\dot\rho]$，**由前向算子决定**。
>
> 数学上这是同一个论证（把解分解到 span 与其正交补，正交补分量不影响损失但增加范数）；差别全在"哪个内积"。**而选内积就是选先验，这是这门课的中心主题之一。**

**可扩展性.** 正规算子是稠密的，直接分解 $O(m^3)$。Li–Lu 给出 RKHS 里的**共轭梯度 / Golub–Kahan 双对角化**，第 $\ell$ 步迭代等价于系数空间里的一个小稠密系统，配合早停（$=$ [[P3 RKHS 与不适定逆问题的正则化#2-谱滤波正则化|P3 §2]] 里的 Landweber 型正则化，**无饱和**）。

## 4. 贝叶斯对应：data-adaptive prior

由 [[P3 RKHS 与不适定逆问题的正则化#6-贝叶斯对应|P3 §6]]，Tikhonov $=$ MAP，惩罚范数 $\leftrightarrow$ 先验协方差。于是 DARTR 的贝叶斯版本就是取
$$\mathcal{C}=\mathcal{L}_{\bar G}$$
作为先验协方差（Chada–Lang–Lu–Wang, JMLR 2024）。好处是免费拿到后验协方差，即不确定性量化；代价是先验依赖数据，理论分析要处理这个随机性。

## 5. 最小最大率

这是这条线最新的、也是与 [[05 学习交互核的最小最大率|05]] 对照最有意思的部分。

**自适应谱 Sobolev 空间.** 设 $\{(\lambda_k,\psi_k)\}$ 是 $\mathcal{L}_{\bar G}$ 在 $L^2_\rho$ 上的特征对。定义
$$H^\beta_\rho(L):=\Big\{\phi=\sum_k\theta_k\psi_k:\ \sum_k\lambda_k^{-\beta}\theta_k^2\le L^2\Big\}.$$

> [!tip] 这个空间是本篇最该记住的构造
> 它**统一了 Sobolev 空间与 RKHS**：$\beta=0$ 给 $L^2_\rho$，$\beta=1$ 给数据自适应的 RKHS $\mathcal{H}_{\bar G}$。
>
> 而且它**自动扔掉不可辨识的分量**（$\mathcal{L}_{\bar G}$ 的零空间不在里面）。
>
> **光滑度是在前向算子的几何里度量的**——这正是不适定问题里"光滑"应该有的意思，和 [[P3 RKHS 与不适定逆问题的正则化#2-谱滤波正则化|P3 §2]] 的源条件是同一件事。

**估计量：tamed 最小二乘（tLSE）**，与 [[05 学习交互核的最小最大率#3-上界的证明结构|05 §3]] 同一个构造——在"经验正规矩阵的最小特征值太小"的事件上输出 $0$，尾概率用四阶矩条件加 PAC-Bayes 不等式控制，从而**避开对基函数的有界性假设**。

> **定理（Zhang–Wang–Lu 2025）.**
> - **多项式谱衰减** $\lambda_k\asymp k^{-2r}$，$r>1/4$：
> $$\mathrm{MSE}\ \asymp\ M^{-\frac{2\beta r}{2\beta r+2r+1}} .$$
> - **指数谱衰减** $\lambda_k\asymp e^{-rk}$，$r>0$：
> $$\mathrm{MSE}\ \asymp\ M^{-\frac{\beta}{\beta+1}} .$$
> 两者都有**匹配的最小最大下界**。

**怎么读这两条：**

- 多项式区：指数 $\frac{2\beta r}{2\beta r+2r+1}$ **随 $r$ 减小而变差**——谱衰减越慢意味着不适定越严重、学得越慢。$r\to\infty$ 时指数 $\to\frac{\beta}{\beta+1}$，与指数区衔接。
- 指数区：率**只依赖光滑度 $\beta$，不依赖衰减速度 $r$**。这初看奇怪，但合理：一旦谱衰减快到指数，可用的有效维数只随 $\log M$ 增长，速度多快已经不影响主项。

**与良态非参数回归对照**：那里正规算子是恒等，只有 $\beta$ 进入率（[[P2 非参数回归与最小最大率|P2]]）。**这里 $r$ 也进入。这就是"不适定的代价"的精确形式。**

> [!note] 把三条率并排（这门课的中心表格再来一次）
>
> | 问题 | 正规算子的谱 | 率 |
> |---|---|---|
> | 经典非参数回归 | 恒等 | $M^{-\frac{2\beta}{2\beta+1}}$ |
> | [[05 学习交互核的最小最大率\|交互核]] | 一致谱隙（coercivity） | $M^{-\frac{2\beta}{2\beta+1}}$，**同上** |
> | **算子核（本篇）** | $k^{-2r}$ | $M^{-\frac{2\beta r}{2\beta r+2r+1}}$ |
> | 算子核 | $e^{-rk}$ | $M^{-\frac{\beta}{\beta+1}}$ |
> | [[14 算子学习：DeepONet、FNO 与逼近理论\|一般算子学习]] | —— | **无代数率** |
>
> **一条谱线，一个决定因素。**这是这门课的方法论结晶：拿到问题先算正规算子的谱。

## 6. 与交互核的对比：为什么一个不退化、一个退化

两个问题的数学结构完全一样，为什么率不同？

**交互核**：正规算子在 FSOI 上有**一致谱隙**（coercivity 是一个定理），于是问题实质上是良态的，只剩经典非参数的偏差–方差权衡。

**算子核**：正规算子来自积分/卷积，是**平滑算子**，谱必然衰减。$\mathcal{L}_{\bar G}$ 的谱衰减速度由 $g[u]$ 的光滑性决定——$g$ 越光滑（比如卷积核越光滑），谱衰减越快，问题越不适定。

> [!tip] 一句话
> **"信息在数据里被平滑掉了多少"就是谱衰减，就是率的损失。**
>
> 交互粒子系统里，$g[u](x,s)=x^{ij}$ 是**点求值**，不平滑，信息保留；非局部算子里 $g[u](x,s)=u(x+s)-u(x)$ 经过了一次积分，信息被抹掉一层。
>
> 这也给出一条**实验设计原则**：想让核好学，就用**粗糙**的输入函数 $u$（高频成分多），不要用光滑的。这与"探索测度要宽"是同一类建议。

## 7. 注意力作为学到的正则化子

**Nonlocal Attention Operator（NAO）**（[Yu, Liu, Lu, Gao, Jafarzadeh, Silling, NeurIPS 2024](https://arxiv.org/abs/2408.07307)）把 §1–§5 的问题交给一个 attention 架构。

**做法.** 对每个物理系统，把离散化的输入–输出函数对拼成 token $(\mathbf{u}_{1:d};\mathbf{f}_{1:d})\in\R^{2N\times d}$。只保留 query 与 key 投影：
$$\mathrm{Attn}[X;\theta]=\sigma\Big(\tfrac{1}{\sqrt{d_k}}XW^Q(W^K)^\top X^\top\Big)\in\R^{2N\times2N},$$
它扮演的是**学到的交互 / 核映射**，而不是 NLP 意义上的 token 混合器。**物理算子的核是网络的输出**，由该系统的数据生成。

**核心主张.** "给定 $(u,f)$ 对、推断核"这个逆问题是**秩亏 / 不适定**的；NAO 的 attention 机制通过在**多个系统**上一起学，**提供了核的可辨识函数空间**，从而起到自动的、数据驱动的正则化，代替显式的 Tikhonov/DARTR。

> [!warning] 这个主张的地位
> 论文陈述了理论分析，但我没能从可获取的正文里抽出编号的定理陈述。**在讲义里应当把它当作结构性 / 启发性的论证，而不是定理，除非核对了 camera-ready 的附录。**
>
> 不过**概念上的桥是明确的，而且它就是 [[11 ICL 用于逆线性回归：学到的是先验与正则化|11]] 在算子层面的化身**：
>
> | | [[11 ICL 用于逆线性回归：学到的是先验与正则化\|11]]（有限维） | NAO（算子） |
> |---|---|---|
> | 不适定来源 | $n<d$ | 正规算子紧、秩亏 |
> | 显式解法 | 广义 Tikhonov，惩罚 $=\Sigma_w^\dagger$ | DARTR，惩罚 $=\mathcal{L}_{\bar G}^{-1}$ |
> | 学到的解法 | Transformer 从跨任务先验学出惩罚 | attention 从多系统学出 FSOI |
>
> **"跨任务结构提供正则化"这句话，在这门课里出现了三次**（11、13、[[15 in-context operator learning|15]]）。这不是巧合，它是"基础模型"这个概念的数学内容。

## 8. 一页速查

| 概念 | 内容 |
|---|---|
| 模型 | $f=R_\phi[u]+\varepsilon$，$R_\phi[u](x)=\int\phi(s)g[u](x,s)\mathrm{d}s$ |
| 探索测度 | $\dot\rho(s)\propto\frac1M\sum_m\int\lvert g[u^m](x,s)\rvert\nu(\mathrm{d}x)$ |
| 自动再生核 | $\overline G=G/(\dot\rho\dot\rho)$，无超参数 |
| FSOI | $\mathcal{L}_{\bar G}$ 正特征值张成的闭子空间 |
| 网格加密 | 让不适定变差；DARTR 型估计量才收敛 |
| 表示定理 | 解落在自动基 $\mathcal{L}_{\overline G}[g/\dot\rho]$ 的张成里 |
| 可扩展 | RKHS 里的 CG / Golub–Kahan $+$ 早停 |
| 贝叶斯 | 先验协方差取 $\mathcal{L}_{\bar G}$ |
| 自适应谱 Sobolev | $\sum\lambda_k^{-\beta}\theta_k^2\le L^2$；$\beta=0$ 是 $L^2_\rho$，$\beta=1$ 是 RKHS |
| 率（多项式谱） | $M^{-\frac{2\beta r}{2\beta r+2r+1}}$ |
| 率（指数谱） | $M^{-\frac{\beta}{\beta+1}}$，与 $r$ 无关 |
| 为何比交互核差 | 积分/卷积平滑掉信息 $\Rightarrow$ 谱衰减 |
| 实验设计 | 用粗糙的输入函数 |
| NAO | attention 提供 FSOI，隐式正则化；理论地位待核实 |

## 参考

- [Lu, An, Yu, *Nonparametric learning of kernels in nonlocal operators*](https://arxiv.org/abs/2205.11006), J. Peridyn. Nonlocal Model. **6** (2024) 347–370.
- [Lu, Lang, An, *DARTR: Data adaptive RKHS Tikhonov regularization for learning kernels in operators*](https://arxiv.org/abs/2203.03791), MSML 2022 (PMLR 190) 158–172.
- [Chada, Lang, Lu, Wang, *A data-adaptive prior for Bayesian learning of kernels in operators*](https://arxiv.org/abs/2212.14163), JMLR **25** (2024) no. 317.
- [Zhang, Wang, Lu, *Minimax rates for learning kernels in operators*](https://arxiv.org/abs/2502.20368) (2025).
- [Li & Lu, *Automatic reproducing kernel and regularization for learning convolution kernels*](https://arxiv.org/abs/2507.11944) (2025).
- [Li, Feng, Lu, *Scalable iterative data-adaptive RKHS regularization*](https://arxiv.org/abs/2401.00656), SIAM J. Sci. Comput. (2025).
- [Yu, Liu, Lu, Gao, Jafarzadeh, Silling, *Nonlocal attention operator*](https://arxiv.org/abs/2408.07307), NeurIPS 2024.
- Lu & Ou, *An adaptive RKHS regularization for Fredholm integral equations*, Math. Meth. Appl. Sci. **48** (2025) 11124–11140.

## Related

- [[index|科学基础模型的数学]]
- [[P3 RKHS 与不适定逆问题的正则化]]
- [[04 从轨迹学交互核：变分表述与可辨识性]]
- [[05 学习交互核的最小最大率]]
- [[11 ICL 用于逆线性回归：学到的是先验与正则化]]
- [[14 算子学习：DeepONet、FNO 与逼近理论]]
