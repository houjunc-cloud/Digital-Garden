---
title: 02 attention 作为非局部映射与平均场极限
description: softmax attention 作为经验测度上的非局部 Markov 算子；token 数趋于无穷的 Vlasov 极限；与宽度 mean-field 的对照。
tags:
  - scientific-foundation-models
  - transformers
  - mean-field
stage: 🌱 seedling
date: 2026-08-18
---

# 02 attention 作为非局部映射与平均场极限

> 课程 9/8, 9/10：*"Attention as a nonlocal map; mean-field interacting particle systems"*。
>
> 这一篇做两件事：把 Transformer 的前向传播写成一个**测度到测度的流**，以及把这个流的 $n\to\infty$ 极限写成一个 **Vlasov 型 PDE**。定性结论（聚类）留到 [[03 自注意力作为交互粒子系统：聚类定理|03]]。
>
> 前置：[[notes/deep-learning/12 Transformer|DL 12]]（attention 的定义、多头、RoPE，这里不重讲）、[[P1 随机微分方程与 Fokker–Planck#9-mckean-vlasov-与-propagation-of-chaos|P1 §9]]（混沌传播）。

> [!question] 卡住了从哪儿看起
> - 📐 [Geshkovski, Letrouit, Polyanskiy, Rigollet, *A mathematical perspective on Transformers*](https://arxiv.org/abs/2312.10794)，**Bull. AMS 62 (2025) 427–479** — 本篇与 03 的主线，**这是一篇写给数学家的 Transformer 综述，可以当讲义读**
> - 📐 [Rigollet, *The Mean-Field Dynamics of Transformers*](https://arxiv.org/abs/2512.01868)，ICM 2026 — 更新更短，含 long-context 相变
> - [Sander, Ablin, Blondel, Peyré, *Sinkformers*](https://arxiv.org/abs/2110.11773), AISTATS 2022 — 双随机化与梯度流结构，§4 的来源
> - [Castin, Ablin, Peyré, *How smooth is attention?*](https://arxiv.org/abs/2312.14820), ICML 2024 — Lipschitz 常数与适定性

## 1. 从 Transformer 到球面上的 ODE

三个建模步骤，每一步都要说清楚代价。

**(a) 残差连接 $\Rightarrow$ 深度即时间.** Transformer 的每个 block 形如 $x^{(k+1)}=x^{(k)}+\text{（扰动）}$，即前向 Euler。取深度 $\to\infty$ 的连续极限
$$x^{(k+1)}=x^{(k)}+\mathcal{F}(x^{(k)})\ \rightsquigarrow\ \dot x(t)=\mathcal{F}(x(t)),\qquad t=\text{层指标}.$$
**这与 neural ODE 是同一个想法**，代价是假设每层的扰动小（实践中 pre-LN 大致成立）。

**(b) LayerNorm $\Rightarrow$ 约束在球面上.** LayerNorm/RMSNorm 把每个 token 除以自身范数。把可学习的对角缩放设成恒等，token 就活在 $\mathbb{S}^{d-1}$ 上，速度场要投影到切空间：$\mathbf{P}^\perp_x y=y-\langle x,y\rangle x$。

**(c) 只保留 attention.** 丢掉 MLP。**这是最大的一步简化**，但保留了非线性耦合这个本质。

得到 GLPR 的模型：对 $i\in[n]$，
$$\boxed{\ \dot x_i=\mathbf{P}^\perp_{x_i}\Big(\frac{1}{Z_{\beta,i}}\sum_{j=1}^ne^{\beta\langle Qx_i,\,Kx_j\rangle}\,Vx_j\Big),\qquad Z_{\beta,i}=\sum_{k=1}^ne^{\beta\langle Qx_i,\,Kx_k\rangle}.\ }$$

**参数的角色，读一遍就清楚：**

- $Q^\top K$ 只通过双线性型 $\langle Qx,Ky\rangle=x^\top Q^\top Ky$ 进入**权重**，即"谁看谁"。**它是相互作用核的参数。**
- $V$ 只作用在被平均的**取值**上。**它是速度场的线性变换。**
- $\beta>0$ 是**逆温度**：$\beta\to0$ 给 $A_{ij}\to1/n$（均匀平均），$\beta\to\infty$ 给 hardmax（只看最近的）。

> [!note] 与经典交互粒子系统的第一个结构性差别
> 经典模型的核是**给定的** $\phi(|x-y|)$；这里核是 $e^{\beta\langle Qx,Ky\rangle}$，**参数藏在非线性内部**，而且依赖 $\langle x,y\rangle$（角度）而非 $|x-y|$（距离）。
>
> 第二个差别更要命：**softmax 只做行归一化**，于是权重矩阵 $A$ 行随机但**不对称**。经典的 Kuramoto、Cucker–Smale、aggregation 方程的核都是对称的。§4 会说明这个不对称的全部后果。

## 2. 排列等变 $\Rightarrow$ 测度到测度

**观察.** 不带位置编码的 attention 对 token 的置换等变（[[notes/deep-learning/12 Transformer#24-图上的消息传递|DL 12 §2.4]]）。于是动力学只依赖**经验测度**
$$\mu_t^n=\frac1n\sum_{i=1}^n\delta_{x_i(t)} .$$

**这是把 Transformer 看成分析对象的关键一步**：一个 Transformer 不是 $(\mathbb{S}^{d-1})^n\to(\mathbb{S}^{d-1})^n$ 的映射，而是
$$\mathcal{P}(\mathbb{S}^{d-1})\longrightarrow\mathcal{P}(\mathbb{S}^{d-1})$$
的流映射；序列长度 $n$ 只是这个测度被离散成几个原子。**长上下文与短上下文是同一个对象的两个离散化。**

## 3. 非局部算子的视角

把 attention 写成作用在函数上：
$$(\mathcal{A}_\beta f)(x)=\frac{\displaystyle\int e^{\beta\langle Qx,Ky\rangle}f(y)\,\mu(\mathrm{d}y)}{\displaystyle\int e^{\beta\langle Qx,Ky\rangle}\,\mu(\mathrm{d}y)} .$$

**观察 1：$\mathcal{A}_\beta$ 是 Markov 算子.** $\mathcal{A}_\beta\mathbf{1}=\mathbf{1}$，保正性。它就是转移核 $p_\beta(x,\mathrm{d}y)\propto e^{\beta\langle Qx,Ky\rangle}\mu(\mathrm{d}y)$ 的条件期望算子。

**观察 2：$\mathcal{A}_\beta-\mathrm{Id}$ 是非局部 Laplacian.**
$$(\mathcal{A}_\beta-\mathrm{Id})f(x)=\int\big(f(y)-f(x)\big)\,p_\beta(x,\mathrm{d}y).$$
这与非局部扩散、peridynamics 里的算子是同一形式（$\mathcal{L}_\phi u(x)=\int\phi(|y-x|)(u(y)-u(x))\mathrm{d}y$）——**注意这正是 [[13 学习算子中的核：正规算子、FSOI 与 DARTR|Part 6]] 要学的那类算子**。

> [!tip] 一层 attention $+$ 残差 $=$ 非局部热流的一步显式 Euler
> $$x\ \longleftarrow\ x+\big(\mathcal{A}_\beta-\mathrm{Id}\big)[\,\mathrm{id}\,](x).$$
> **于是 over-smoothing（深层 token 表示坍缩成一样）根本不是 bug，是非局部扩散的平衡态。**扩散方程的平衡态是常数；这里的"常数"就是所有 token 相同。
>
> 这个观察把三件看起来不相干的事接到一起：Transformer 的 rank collapse、图神经网络的 over-smoothing、非局部 PDE 的长时间行为。[[03 自注意力作为交互粒子系统：聚类定理|03]] 把它做成定理。

**离散版的定量结果.** [Dong–Cordonnier–Loukas (ICML 2021)](https://arxiv.org/abs/2103.03404)：纯 attention（无 skip、无 MLP）的输出到 rank-1 矩阵的残差以**双指数** $O(\gamma^{3^L})$ 速率衰减。**这是"深度纯 attention 什么也算不了"的精确形式**，也说明 MLP 与残差不是工程细节而是维持表达力的必需品。

## 4. 梯度流结构与 softmax 的不对称

取 $Q=K=V=I_d$，定义两个动力学：

$$\textbf{(SA)}\quad \dot x_i=\mathbf{P}^\perp_{x_i}\Big(\frac{1}{Z_{\beta,i}}\sum_je^{\beta\langle x_i,x_j\rangle}x_j\Big),\qquad
\textbf{(USA)}\quad \dot x_i=\mathbf{P}^\perp_{x_i}\Big(\frac1n\sum_je^{\beta\langle x_i,x_j\rangle}x_j\Big).$$

(USA) 去掉了 softmax 的归一化。定义**相互作用能量**
$$\mathsf{E}_\beta(X)=\frac{1}{2\beta n^2}\sum_{i,j}e^{\beta\langle x_i,x_j\rangle} .$$

> **命题（GLPR §3.2）.** (USA) 是 $\mathsf{E}_\beta$ 在 $(\mathbb{S}^{d-1})^n$（乘积黎曼度量）上的**梯度上升流**：$\dot X=\nabla\mathsf{E}_\beta(X)$，从而 $\frac{\mathrm{d}}{\mathrm{d}t}\mathsf{E}_\beta\ge0$。
>
> **(SA) 不是**（在标准度量下）。但在**状态依赖的加权内积**
> $$\langle (a_i)_i,(b_i)_i\rangle_X=\sum_iZ_{\beta,i}(X)\,\langle a_i,b_i\rangle$$
> 下它是梯度流。

**为什么.** 梯度流要求速度场是某个势的梯度，这要求相互作用核**对称**。softmax 的分母 $Z_{\beta,i}$ 只依赖 $i$，把对称核 $e^{\beta\langle x_i,x_j\rangle}$ 变成非对称的 $A_{ij}$。除以一个只依赖 $i$ 的量恰好可以被吸收进度量的共形变换——所以结构没丢，只是变形了。

**Sinkformers 的对应说法.** [Sander et al. (2022)](https://arxiv.org/abs/2110.11773) 把 softmax（行归一化）换成 **Sinkhorn**（行列交替归一化，得到双随机矩阵）：

| 归一化 | 核 | 连续极限 |
|---|---|---|
| 无 | $k^0=e^{c(x,x')}$ | $F^0(\mu)=\frac12\iint k^0\mathrm{d}\mu\mathrm{d}\mu$ 的 Wasserstein 梯度流 |
| softmax（行） | $k^1=k^0/\int k^0\mathrm{d}\mu$ | **不是** Wasserstein 梯度流 |
| Sinkhorn（双随机） | $k^\infty$ | $F^\infty(\mu)=-\frac12\iint k^\infty\log\frac{k^\infty}{k^0}$ 的 Wasserstein 梯度流 |

并且在小带宽重标度下，Sinkformer 的 PDE 退化成**热方程** $\partial_t\rho=\Delta\rho$，而标准 Transformer 退化成一个**非线性非局部**方程。

> [!note] 数学上该记住的
> **双随机化 $=$ 恢复自伴性 $=$ 恢复变分结构。**这是 Markov 链理论里"细致平衡"那件事在这里的化身：softmax attention 对应一个**不可逆** Markov 生成元，没有平衡态的变分刻画；Sinkhorn 对应可逆的，于是有。
>
> 实践上 softmax 赢了（更便宜、效果不差），但**做分析时 (USA) 或 Sinkhorn 版本要好写得多**——这是 03 里定理为什么常常同时对 (SA) 和 (USA) 陈述的原因。

## 5. 平均场极限：Vlasov 方程

定义测度依赖的速度场
$$\mathcal{X}[\mu](x)=\mathbf{P}^\perp_x\Big(\frac{1}{Z_{\beta,\mu}(x)}\int_{\mathbb{S}^{d-1}}e^{\beta\langle x,y\rangle}\,y\;\mu(\mathrm{d}y)\Big),\qquad Z_{\beta,\mu}(x)=\int e^{\beta\langle x,y\rangle}\mu(\mathrm{d}y),$$
则 $n\to\infty$ 的极限是**连续性（Vlasov）方程**
$$\boxed{\ \partial_t\mu+\operatorname{div}\big(\mathcal{X}[\mu]\,\mu\big)=0\quad\text{on }\R_{\ge0}\times\mathbb{S}^{d-1},\qquad \mu|_{t=0}=\mu_0.\ }$$

**适定性与收敛.** 关键的软事实是：

> $\mu\mapsto\mathcal{X}[\mu]$ 关于 $W_1$ 是 Lipschitz 的。

理由很简单：$x\mapsto e^{\beta\langle x,y\rangle}$ 在紧流形上光滑，分母 $Z_{\beta,\mu}\ge e^{-\beta}>0$ **一致有下界**（因为球面紧），所以商是 Lipschitz 的。于是标准的 **Dobrushin/Neunzert 稳定性估计**给出
$$W_1\big(\mu^n_t,\mu_t\big)\le e^{C|t|}\,W_1\big(\mu^n_0,\mu_0\big),$$
从而：整体弱解存在唯一，且 $n$-粒子系统的经验测度收敛到解（**混沌传播**）。

> [!warning] 这个估计是"软"的，代价在常数里
> 不需要凸性、不需要交换性、不需要任何泛函不等式——**但 $e^{C|t|}$ 里的 $C$ 随 $\beta$ 指数增长**，于是它对长时间行为一无所知。
>
> **这正是难点所在**：$t=O(1)$ 的平均场极限是廉价的，$t\to\infty$ 的行为（聚类、亚稳态）需要完全不同的工具。[[03 自注意力作为交互粒子系统：聚类定理|03]] 全在讲后者。

**$\R^d$ 上（不做球面归一化）的版本**同样适定（GLPR NeurIPS 版 Prop. 6.6；[Castin–Ablin–Carrillo–Peyré 2025](https://arxiv.org/abs/2501.18322) Thm 3.1 把它推广到 softmax / L2 / Sinkhorn / sigmoid / 多头各种速度场，并处理了因果掩码）。

**Lipschitz 常数的定量结果**（[Castin–Ablin–Peyré, ICML 2024](https://arxiv.org/abs/2312.14820)）：在半径 $R$ 的球内，$n$ 个 token 的 attention 的 Lipschitz 常数是 $\Theta(\sqrt n)$（上下界匹配）；在平均场极限下变成 $O(R^2e^{CR^2})$，**与 $n$ 无关但对 $R$ 指数**。

## 6. 两个"平均场"极限的对照

这门课与 [[notes/deep-learning/07 无限宽极限 NTK 与 mean-field|DL 07]] 里的 mean-field 是**完全不同的两个极限**。这张表值得记住：

| | **token 平均场**（本篇） | **宽度平均场**（Chizat–Bach, Mei–Montanari） |
|---|---|---|
| 被平均的"粒子" | **token**（数据/激活） | **神经元参数** |
| 极限测度 | $\mu_t\in\mathcal{P}(\mathbb{S}^{d-1})$，$t=$ **深度** | $\nu_t\in\mathcal{P}(\R^p)$，$t=$ **训练时间** |
| 动力学来自 | **前向推理**（参数冻结） | **梯度下降训练** |
| 速度场对 $\mu$ 的依赖 | 非线性，带分式（softmax 归一化） | $\delta R/\delta\nu$ 对 $\nu$ 仿射 |
| 变分结构 | (USA) 是相互作用能的梯度**上升**流；(SA) 不是标准梯度流 | 总是目标 $R$ 的 Wasserstein 梯度**下降**流，$R$ 在 $\mathcal{P}_2$ 上凸 |
| 典型定理 | 坍缩到 Dirac、亚稳态、相变 | 全局收敛到最优 |
| 极限是好事还是坏事 | **坏事**（表示坍缩），要设法延缓 | **好事**（全局极小），要设法达到 |

> [!tip] 一句话
> **宽度极限研究"训练能不能成功"，token 极限研究"推理时信息怎么被混合"。**前者的凸性来自损失泛函关于 $\nu$ 是二次的；后者没有任何凸性，因为相互作用能是纯吸引型的。
>
> 顺带一提，Transformer 也有宽度极限，但那是 NNGP/NTK（[Hron et al., ICML 2020](https://arxiv.org/abs/2006.10540)），与本篇正交。

## 7. 长上下文：$\beta$ 必须随 $n$ 标度

一个实践上重要、数学上干净的结果。取 $\beta_n=\gamma\log n$，则（[Rigollet, ICM 2026](https://arxiv.org/abs/2512.01868) Thm 7）存在阈值使动力学分三个区：

- $\gamma$ 小：**完全聚类**——所有 token 混成一个，上下文信息全丢。
- $\gamma$ 临界：**稀疏自适应混合**——这是想要的区间。
- $\gamma$ 大：**近似恒等**——attention 退化成不做事。

**这是"attention 的温度必须随上下文长度对数标度"的数学根据**，也解释了实践中 SSMax、YaRN 之类修正为什么必要。相关的多尺度分析见 [Bruno–Pasqualotto–Agazzi](https://arxiv.org/abs/2509.25040)。

## 8. 一页速查

| 对象 | 表达式 / 结论 |
|---|---|
| token ODE | $\dot x_i=\mathbf{P}^\perp_{x_i}\big(Z_{\beta,i}^{-1}\sum_je^{\beta\langle Qx_i,Kx_j\rangle}Vx_j\big)$ |
| 参数角色 | $Q^\top K$ 定核，$V$ 定速度场，$\beta$ 是逆温度 |
| 排列等变 | 动力学只依赖经验测度 $\Rightarrow$ Transformer 是 $\mathcal{P}\to\mathcal{P}$ 的流 |
| 非局部算子 | $\mathcal{A}_\beta$ Markov；$\mathcal{A}_\beta-\mathrm{Id}$ 是非局部 Laplacian |
| over-smoothing | $=$ 非局部扩散的平衡态；离散版 rank collapse 是双指数的 |
| 能量 | $\mathsf{E}_\beta=\frac{1}{2\beta n^2}\sum_{i,j}e^{\beta\langle x_i,x_j\rangle}$；(USA) 是它的梯度上升流 |
| softmax 的代价 | 行归一化破坏对称 $\Rightarrow$ 非标准梯度流；Sinkhorn 双随机化可修复 |
| Vlasov 方程 | $\partial_t\mu+\operatorname{div}(\mathcal{X}[\mu]\mu)=0$ |
| 平均场极限 | Dobrushin：$W_1(\mu^n_t,\mu_t)\le e^{Ct}W_1(\mu^n_0,\mu_0)$；$C$ 随 $\beta$ 指数 |
| 与宽度极限 | 完全不同：那边是训练+凸性，这边是推理+吸引 |
| 长上下文 | $\beta_n\asymp\log n$ 处有相变 |

## 参考

- Geshkovski, Letrouit, Polyanskiy, Rigollet, *A mathematical perspective on Transformers*, Bull. Amer. Math. Soc. **62** (2025) 427–479; [arXiv:2312.10794](https://arxiv.org/abs/2312.10794).
- Rigollet, *The mean-field dynamics of Transformers*, ICM 2026; [arXiv:2512.01868](https://arxiv.org/abs/2512.01868).
- Sander, Ablin, Blondel, Peyré, *Sinkformers: Transformers with doubly stochastic attention*, AISTATS 2022; [arXiv:2110.11773](https://arxiv.org/abs/2110.11773).
- Castin, Ablin, Peyré, *How smooth is attention?*, ICML 2024; [arXiv:2312.14820](https://arxiv.org/abs/2312.14820).
- Castin, Ablin, Carrillo, Peyré, *A unified perspective on the dynamics of deep Transformers*; [arXiv:2501.18322](https://arxiv.org/abs/2501.18322).
- Dong, Cordonnier, Loukas, *Attention is not all you need: pure attention loses rank doubly exponentially with depth*, ICML 2021; [arXiv:2103.03404](https://arxiv.org/abs/2103.03404).
- Wang, Girshick, Gupta, He, *Non-local neural networks*, CVPR 2018; [arXiv:1711.07971](https://arxiv.org/abs/1711.07971). attention $=$ non-local means 的最早陈述。
- Chamberlain et al., *GRAND: Graph neural diffusion*, ICML 2021; [arXiv:2106.10934](https://arxiv.org/abs/2106.10934).
- Dobrushin, *Vlasov equations*, Funct. Anal. Appl. 13 (1979) 115–123.

## Related

- [[index|科学基础模型的数学]]
- [[01 科学基础模型：统计实验、损失与 oracle 基准]]
- [[03 自注意力作为交互粒子系统：聚类定理]]
- [[notes/deep-learning/12 Transformer|DL 12 Transformer]]
- [[notes/deep-learning/07 无限宽极限 NTK 与 mean-field|DL 07 无限宽极限]]
