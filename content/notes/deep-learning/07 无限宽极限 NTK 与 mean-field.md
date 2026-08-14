---
title: 07 无限宽极限 NTK 与 mean-field
description: 高斯过程极限、NTK 定理、lazy vs rich regime、Wasserstein 梯度流。
tags:
  - deep-learning
  - theory
stage: 🌿 budding
date: 2026-08-14
---

# 07 无限宽极限 NTK 与 mean-field

> **原课完全没有这一块。**这是 2018 年以后深度学习理论的核心，也是对数学家最友好的部分——它把神经网络训练变成了可以严格分析的对象（核方法 / 测度上的梯度流 / PDE）。理解它，就理解了当前理论能说什么、不能说什么。
>
> 前置：[[06 初始化归一化与训练动力学]] 的方差分析、[[05 优化的数学]] 的梯度流。

> [!question] 卡住了从哪儿看起
> - [Bartlett, Montanari, Rakhlin, *Deep learning: a statistical viewpoint*](https://arxiv.org/abs/2103.09177) — **首选综述**，NTK 与后续发展串在一起
> - [Jacot, Gabriel, Hongler, *Neural Tangent Kernel*](https://arxiv.org/abs/1806.07572) — 原始论文，比想象中好读
> - [Roberts, Yaida, Hanin, *Principles of Deep Learning Theory*](https://arxiv.org/abs/2106.10165) — $1/n$ 展开的有效场论版本
> - Ambrosio–Gigli–Savaré, *Gradient Flows in Metric Spaces* — mean-field 那一节的工具书（Wasserstein 梯度流）
> - 全部资源见 [[00 外部资源地图]]

## 1. 高斯过程极限（训练前）

考虑单隐层网络
$$f_\theta(x)=\frac{1}{\sqrt m}\sum_{i=1}^m a_i\,h(w_i\cdot x),\qquad a_i\sim\mathcal{N}(0,\sigma_a^2),\ w_i\sim\mathcal{N}(0,\sigma_w^2 I/d).$$

**命题.** $m\to\infty$ 时，$f_\theta$ 依分布收敛到均值 0 的**高斯过程**，协方差核
$$K^{(1)}(x,x')=\sigma_a^2\,\mathbb{E}_{w}\big[h(w\cdot x)h(w\cdot x')\big].$$

*证明.* 对任意有限点集 $x_1,\dots,x_k$，$(f(x_1),\dots,f(x_k))$ 是 $m$ 个 i.i.d. 随机向量的 $1/\sqrt m$ 倍和，直接用多元 CLT。$\square$

**深层版本（Lee et al. 2018; Matthews et al. 2018）.** 逐层取极限，核满足递推
$$K^{(\ell+1)}(x,x')=\sigma_w^2\,\mathbb{E}_{(u,v)\sim\mathcal{N}(0,\Lambda^{(\ell)})}\big[h(u)h(v)\big]+\sigma_b^2,\qquad \Lambda^{(\ell)}=\begin{pmatrix}K^{(\ell)}(x,x)&K^{(\ell)}(x,x')\\ K^{(\ell)}(x,x')&K^{(\ell)}(x',x')\end{pmatrix}.$$

**对 ReLU 有闭式**（Cho–Saul 弧余弦核）：令 $\theta=\arccos\frac{K(x,x')}{\sqrt{K(x,x)K(x',x')}}$，
$$\mathbb{E}[\mathrm{ReLU}(u)\mathrm{ReLU}(v)]=\frac{\sqrt{K(x,x)K(x',x')}}{2\pi}\big(\sin\theta+(\pi-\theta)\cos\theta\big).$$

> 这个递推**就是** [[06 初始化归一化与训练动力学#11-混沌边缘|混沌边缘]]的相关性映射。同一个数学，两种包装。

## 2. 神经正切核（训练中）

高斯过程只描述初始化。训练呢？

**设定.** 梯度流 $\dot\theta_t=-\nabla_\theta L(\theta_t)$，$L=\frac12\sum_i(f_{\theta}(x_i)-y_i)^2$。链式法则给出**函数空间**的演化：
$$\dot f_{\theta_t}(x)=\langle\nabla_\theta f_{\theta_t}(x),\dot\theta_t\rangle=-\sum_i \Theta_t(x,x_i)\big(f_{\theta_t}(x_i)-y_i\big),$$
其中
$$\boxed{\Theta_t(x,x'):=\big\langle\nabla_\theta f_{\theta_t}(x),\ \nabla_\theta f_{\theta_t}(x')\big\rangle}$$
是 **神经正切核（Neural Tangent Kernel）**。

**定理（Jacot–Gabriel–Hongler 2018）.** 在 NTK 参数化下（每层乘 $1/\sqrt{n_\ell}$），当所有隐藏层宽度 $\to\infty$：

1. **初始化时** $\Theta_0$ 依概率收敛到一个**确定性**核 $\Theta_\infty$（不依赖随机初始化）；
2. **训练中** $\Theta_t$ 保持常数：$\sup_{t\le T}\|\Theta_t-\Theta_\infty\|\to 0$。

**推论.** 函数演化变成**线性 ODE**：
$$\dot f_t=-\Theta_\infty(f_t-y)\quad\Longrightarrow\quad f_t=y+e^{-\Theta_\infty t}(f_0-y),$$
$t\to\infty$ 收敛到**核回归解**（相对于核 $\Theta_\infty$，以 $f_0$ 为偏移）。

*为什么 $\Theta_t$ 不变（直觉）.* 训练中参数变化量 $\|\theta_t-\theta_0\|=O(1)$，但每个参数的变化是 $O(1/\sqrt m)$。而 $\nabla_\theta f$ 的变化依赖于**单个**参数的变化，故 $O(1/\sqrt m)\to0$。**网络在参数空间中几乎不动，但因为参数极多，函数可以动 $\Theta(1)$。**

**NTK 的递推公式.** 深层 NTK 由前向核与其导数核递推：
$$\Theta^{(\ell+1)}=\Theta^{(\ell)}\odot \dot K^{(\ell)}+K^{(\ell+1)},\qquad \dot K^{(\ell)}(x,x')=\mathbb{E}[h'(u)h'(v)].$$

### 2.1 后果与解释力

- **收敛保证.** 若 $\Theta_\infty\succ0$（对不同的输入点成立，需要数据点两两不平行），则梯度流**全局收敛到零训练误差**，尽管 $L$ 非凸。这是深度学习第一个严格的全局收敛结果。有限宽版本（Du et al., Allen-Zhu–Li–Song, Zou et al.）给出所需宽度的多项式界（虽然指数很大）。
- **谱偏置.** $e^{-\Theta_\infty t}$ 沿 $\Theta_\infty$ 的特征方向以不同速率衰减：**大特征值方向学得快**。对均匀分布在球面上的数据，NTK 的特征函数是球谐函数，特征值随频率**多项式衰减**。故网络**先学低频、后学高频**——这是"spectral bias / frequency principle"（Rahaman et al. 2019; Xu et al. 2019）的严格解释，也解释了为什么早停有正则化效果。
- **可计算.** NTK 可以显式算出，于是"无限宽神经网络"就是一个具体的核方法，可以直接和 SVM/GP 比较。

## 3. Lazy regime：NTK 的致命缺陷

**问题：NTK 极限下没有特征学习。**

$\Theta_t=\Theta_0$ 意味着网络的表示 $\nabla_\theta f$ 从未改变。网络退化成一个**固定特征映射上的线性模型**：
$$f_\theta(x)\approx f_{\theta_0}(x)+\langle\nabla_\theta f_{\theta_0}(x),\theta-\theta_0\rangle.$$

**这与实践严重不符：**

- **经验上 NTK 核回归的表现明显差于同架构的实际训练网络**（在 CIFAR-10 上差 5–10 个百分点；在 ImageNet 上差距更大）。
- **深度学习的核心卖点就是"学表示"**（预训练模型的中间层特征可迁移）。NTK 下这不可能发生。
- **NTK 无法解释卷积网络优于全连接**的幅度，也无法解释迁移学习。

**Chizat–Oyallon–Bach (2019)** 把这个现象命名为 **lazy training**，并指出它不是"宽"造成的，而是**输出缩放**造成的：若 $f=\alpha\cdot g_\theta$ 且 $\alpha\to\infty$（同时缩放学习率），任何模型都进入 lazy regime。**NTK 是一个人为的缩放选择的产物。**

> [!warning] 这是理解整块内容的关键
> "无限宽极限"不唯一。**取什么极限取决于你怎么缩放输出层和学习率**：
>
> | 参数化 | 输出层缩放 | 极限行为 | 特征学习 |
> |---|---|---|---|
> | NTK / lazy | $1/\sqrt n$ | 核回归（线性化） | ❌ 无 |
> | Mean-field / $\mu\mathrm{P}$ | $1/n$ | 测度上的非线性梯度流 | ✅ 有 |
>
> $\mu\mathrm{P}$（见 [[06 初始化归一化与训练动力学#4-mup让超参数可迁移|上一篇]]）就是选了后者。**这也是为什么 $\mu$Transfer 在实践中有效而 NTK 预测的最优学习率缩放无效。**

## 4. Mean-field 极限：有特征学习的那个

回到单隐层，改用 $1/m$ 缩放：
$$f_\theta(x)=\frac1m\sum_{i=1}^m \phi(x;\theta_i),\qquad \theta_i=(a_i,w_i).$$

把参数看成**经验测度** $\mu_m=\frac1m\sum_i\delta_{\theta_i}$，则
$$f_{\mu}(x)=\int\phi(x;\theta)\,d\mu(\theta).$$

**$f$ 只依赖 $\mu$，且关于 $\mu$ 是线性的。** 损失
$$\mathcal{L}[\mu]=\frac12\mathbb{E}_{(x,y)}\Big[\Big(\int\phi(x;\theta)d\mu(\theta)-y\Big)^2\Big]$$
是 $\mu$ 的**凸**泛函（二次的）。

**定理（Chizat–Bach 2018; Mei–Montanari–Nguyen 2018; Rotskoff–Vanden-Eijnden 2018）.** $m\to\infty$ 时，SGD 的经验测度 $\mu_t^{(m)}$ 收敛到 McKean–Vlasov 型 PDE 的解：
$$\partial_t\mu_t=\nabla_\theta\cdot\big(\mu_t\,\nabla_\theta\Psi[\mu_t]\big),\qquad \Psi[\mu](\theta):=\frac{\delta\mathcal{L}}{\delta\mu}(\theta)=\mathbb{E}_{x}\big[(f_\mu(x)-y)\phi(x;\theta)\big].$$

**这是 $\mathcal{L}$ 在 Wasserstein-2 空间 $(\mathcal{P}_2(\R^p),W_2)$ 上的梯度流**（Otto 微积分意义下）。

> [!tip] 对数学家这是最舒服的表述
> - 状态空间：概率测度空间，带 $W_2$ 度量（Riemann 结构，Otto 1998）。
> - 能量泛函：$\mathcal{L}[\mu]$，**凸**。
> - 演化：梯度流 $\partial_t\mu=\nabla\cdot(\mu\nabla\frac{\delta\mathcal{L}}{\delta\mu})$，即连续性方程配速度场 $v=-\nabla\frac{\delta\mathcal{L}}{\delta\mu}$。
> - 全部 Ambrosio–Gigli–Savaré 的机器可用（JKO 格式、EVI、测地凸性）。
>
> **非凸的神经网络训练，在 $m\to\infty$ 后变成了测度空间上的凸问题。**过参数化的作用在这里被讲清楚了：它把参数空间的非凸性"稀释"进了测度空间的线性结构。

**全局收敛.** Chizat–Bach 证明：若初始测度 $\mu_0$ 的支撑足够"分散"（例如支撑在整个球面上）且 $\phi$ 满足齐次性条件，梯度流收敛到全局最优。**但收敛速度没有定量界**，且条件对有限 $m$ 不直接可用。

**Wasserstein 梯度流的正则化.** 加上熵正则 $\mathcal{L}[\mu]+\varepsilon\int\mu\log\mu$，PDE 变成
$$\partial_t\mu=\nabla\cdot(\mu\nabla\Psi[\mu])+\varepsilon\Delta\mu,$$
即**带噪声 SGD 的极限**。这时有指数收敛率（对数 Sobolev 不等式），是当前定量结果最好的设定。

### 4.1 与 lazy 的对比

| | Lazy / NTK | Mean-field |
|---|---|---|
| 缩放 | $1/\sqrt m$ | $1/m$ |
| 参数移动 | $O(1/\sqrt m)$，可忽略 | $O(1)$ |
| 极限对象 | 固定核 $\Theta_\infty$ | 测度 $\mu_t$ 的演化 |
| 数学工具 | 核方法、RKHS | 最优传输、PDE |
| 凸性 | 关于 $\theta$ 线性化后凸 | 关于 $\mu$ 凸 |
| 特征学习 | 无 | 有 |
| 定量收敛率 | 有（多项式） | 一般没有 |
| 深层推广 | 直接 | 困难（多层 mean-field 仍是开放问题） |

## 5. 这套理论的边界

**它解释了：**
- 过参数化下 SGD 为什么能达到零训练误差（非凸但可全局收敛）。
- 谱偏置：为什么网络先学低频。
- 为什么宽度有帮助。
- 为什么"合适的参数化"（$\mu\mathrm{P}$）能让超参可迁移。

**它没有解释：**
- **深度的作用。**Mean-field 的多层版本极其困难（Nguyen–Pham 有部分结果，但没有干净的极限对象）。而 [[02 神经网络作为函数类#3-深度为什么有用分离定理|深度分离定理]]告诉我们深度是本质的。
- **卷积/attention 的归纳偏置。**NTK 的卷积版本（CNTK）确实优于全连接 NTK，但差距远小于实际网络间的差距。
- **泛化。**核回归的泛化理论是经典的（RKHS 范数控制），但实际网络的泛化远好于其 NTK 对应物。
- **实际训练用的宽度。**理论要求的宽度是 $\mathrm{poly}(n,1/\lambda_{\min})$，指数往往是 6 以上，比实际大好几个数量级。

> [!note] 一个诚实的评估
> NTK 是一个**里程碑式的负面结果**：它精确地刻画了"神经网络退化成核方法"的条件，从而说明**真实深度学习必须在那个条件之外**。它的价值在于给出了一个可以严格分析的对照组。Mean-field 更接近实情但工具更难。两者合起来给了深度学习理论第一个坚实的数学骨架，但骨架上还没有肉。
>
> **对纯数学家：这里的开放问题（多层 mean-field 极限、有限宽修正的展开、feature learning 的定量刻画）是可以直接上手的，因为工具是 PDE、最优传输、随机矩阵，不需要 ML 的工程知识。**

## 6. 有限宽修正

$1/m$ 展开（Hanin–Nica; Yaida; Roberts–Yaida–Hanin 的 *Principles of Deep Learning Theory*）把网络视为高斯过程的微扰：
$$\Theta_t = \Theta_\infty + \frac{1}{m}\Theta^{(1)}+O(1/m^2).$$

$O(1/m)$ 项包含**核的涨落**与**核的演化**——后者正是特征学习的一阶效应。深度/宽度比 $L/m$ 是控制参数：$L/m\to0$ 时理论受控，$L/m$ 有限时出现非高斯效应。**这个视角与统计物理的微扰展开完全平行**（Roberts–Yaida 的书就是按有效场论写的），对物理背景的人特别友好。

## 参考

- Jacot, Gabriel, Hongler, *Neural tangent kernel: Convergence and generalization in neural networks*, NeurIPS 2018.
- Lee, Bahri, Novak, Schoenholz, Pennington, Sohl-Dickstein, *Deep neural networks as Gaussian processes*, ICLR 2018.
- Chizat, Oyallon, Bach, *On lazy training in differentiable programming*, NeurIPS 2019.
- Chizat & Bach, *On the global convergence of gradient descent for over-parameterized models using optimal transport*, NeurIPS 2018.
- Mei, Montanari, Nguyen, *A mean field view of the landscape of two-layer neural networks*, PNAS 2018.
- Ambrosio, Gigli, Savaré, *Gradient Flows in Metric Spaces and in the Space of Probability Measures* (2008). Wasserstein 梯度流的标准参考。
- Roberts, Yaida, Hanin, *The Principles of Deep Learning Theory* (CUP 2022). 有效场论视角的 $1/m$ 展开。
- Bartlett, Montanari, Rakhlin, *Deep learning: a statistical viewpoint*, Acta Numerica 2021. **最好的综述**，把 NTK、良性过拟合、隐式正则化串起来。

## Related

- [[index|深度学习（为纯数学研究者重写）]]
- [[06 初始化归一化与训练动力学]]
- [[08 泛化之谜]]
- [[02 神经网络作为函数类]]
