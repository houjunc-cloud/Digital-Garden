---
title: 15 in-context operator learning
description: 把"求解一个新 PDE"当成一次 in-context 任务；ICON 的构造与它没有的理论；线性情形的严格泛化理论与任务多样性条件。
tags:
  - scientific-foundation-models
  - operator-learning
  - in-context-learning
stage: 🌱 seedling
date: 2026-08-18
---

# 15 in-context operator learning

> 课程 12/1, 12/3：*"In-context operator learning"*。这是整门课的汇合点：**Part 5 的 in-context 框架 $+$ Part 6 的算子学习。**
>
> 一句话设定：不再为每个 PDE 训一个神经算子，而是训**一个**网络，它以"若干组该 PDE 的输入–输出函数对"为 prompt，直接回答新的 query——**不更新任何权重**。
>
> 这一篇也是全课程里"经验领先理论最多"的一块。诚实地标出边界是本篇的一半价值。

> [!question] 卡住了从哪儿看起
> - [Yang, Liu, Meng, Osher, *In-context operator learning with data prompts for differential equation problems*](https://www.pnas.org/doi/10.1073/pnas.2310142120), PNAS **120**(39) (2023) — 架构与现象
> - 📐 [Cole, Lu, Xu, Zhang, *In-context learning of linear systems: generalization theory and applications to operator learning*](https://arxiv.org/abs/2409.12293) — **唯一有完整定理的那条线**
> - [[12 transformer 作为 in-context solver：表达力与极限|12]]、[[14 算子学习：DeepONet、FNO 与逼近理论|14]] — 两个前置

## 1. ICON：构造与现象

**prompt 是什么.** 一个可变长的序列：
$$\underbrace{(\mathrm{cond}_1,\mathrm{QoI}_1),\dots,(\mathrm{cond}_J,\mathrm{QoI}_J)}_{\text{demos，来自同一个未知算子}},\quad \underbrace{\mathrm{cond}_{J+1}}_{\text{question}} .$$
每个 condition 与 QoI 都是一个函数，以**（坐标，取值）对的集合**给出——不规则、任意基数的点云，不是固定网格。prompt 矩阵的每一列是一个 key–value 对，拼上一个索引向量（$+e_j$ 标第 $j$ 个 demo 的 condition，$-e_j$ 标它的 QoI，$e_{J+1}$ 标 question）。由 attention 的置换等变性，**列的顺序无关**。

**query** 是任意时空点 $y$，网络输出 question 的 QoI 在那里的值。

**架构.** 编码器–解码器 Transformer：prompt 列过共享线性嵌入 $\to$ **self-attention 编码器**融合所有 demo 与 question，产出一个**算子嵌入**；query 点过另一个线性层 $\to$ **cross-attention 解码器**去注意那个算子嵌入。

> [!tip] 一个架构细节值得注意
> **解码器里 query 之间没有 self-attention。**于是每个输出值只依赖它自己的 query，可以并行、任意多个、无网格。
>
> 这不是工程优化，它是"输出是一个**函数**而不是一个**向量**"这件事的架构实现——与 [[14 算子学习：DeepONet、FNO 与逼近理论#1-万有逼近|DeepONet 的 trunk 网]]起同样的作用，只是这里 trunk 是被 prompt 条件化的。

**训练**：19 类问题（前向/反向 ODE、PDE、平均场控制），每类 1000 个算子，共 19000 个不同算子。损失是 MSE。

**主张**：单个网络是**少样本算子学习器**，推理时"从 prompt 里学到算子并应用到新问题上，不做任何权重更新"，且能外推到训练分布之外的算子。

> [!warning] PNAS 那篇里没有任何定理
> **全部主张都是经验的**（误差–demo 数曲线、OOD 演示）。这是讲义里必须标出的第一件事：**ICON 是架构 $+$ 现象学的论文，理论是后来由别的组、在别的（线性）设定下做的。**

**后续（同组）：**

- **ICON-LM**：加入自然语言 caption 与符号方程作为额外模态，把训练重写成"下一个函数预测"（类比下一个 token 预测），大幅提高训练效率。经验。
- **PDE 泛化**（[J. Comput. Phys. 519 (2024) 113379](https://arxiv.org/abs/2401.07364)）：一维标量守恒律 $\partial_tu+\partial_xf(u)=0$，训练只用**三次通量** $f(u)=au^3+bu^2+cu$。同一个训练好的模型通过灵活拼装 prompt 实现**前向、反向（非唯一！）、多步、变步长、长时间递归**等不同算子，并且**不微调**就推广到 $\sin u-\cos u$、$\tanh u$ 等其它形式的通量（借助自变量替换与步长变换）。**全部经验，无理论保证。**

## 2. 有定理的那一半：线性系统

理论目前只在**线性** in-context 问题上。这条线的代表是 Cole–Lu–Xu–Zhang。

**设定.** 任务 $=$ 一个可逆矩阵 $A\in\R^{d\times d}$，$A\sim P_{\mathcal{A}}$；prompt $\big((x_1,y_1),\dots,(x_n,y_n),x_{n+1}\big)$ 满足 $y_i=A^{-1}x_i$；$x_i\sim\mathcal{N}(0,\Sigma)$。**单层线性 Transformer**：
$$y^\theta_{n+1}=P\Big(\frac1n\sum_{i=1}^ny_ix_i^\top\Big)Q\,x_{n+1},$$
即对经验矩阵做**学到的预条件**——一个 in-context 线性求解器。**与 [[10 线性 attention 实现梯度下降#3-最优参数就是预条件-gd|10 §3]] 的结构完全一样，只是任务从"向量 $w$"换成了"矩阵 $A$"。**

> **定理 1（同分布泛化）.** 高斯协变量、任务有界可逆、测试 prompt 长度 $m\le n$，则以高概率
> $$\mathcal{R}_m(\widehat\theta)\ \lesssim\ \frac1m+\frac1{n^2}+\frac1{\sqrt N},$$
> （在一个额外结构条件下末项改进为 $1/N$），$N=$ 预训练任务数、$n=$ 训练 prompt 长度、$m=$ 测试 prompt 长度。

**三项分别是**：测试时上下文不足、训练时上下文不足、预训练任务不足。**这是这个领域里第一批把三种资源分离开的界。**

**任务多样性（本篇最有意思的部分）：**

> **定义（多样性）.** $P_{\mathcal{A}}$ **相对于** $P'_{\mathcal{A}}$ 多样，若极限风险 $\mathcal{R}_\infty$ 在 $P_{\mathcal{A}}$ 下的极小元集合**包含**在 $P'_{\mathcal{A}}$ 下的极小元集合里。
>
> **定理 2（任务偏移）.** 此时
> $$\mathcal{R}'_m(\widehat\theta)\ \lesssim\ \mathcal{R}_m(\widehat\theta)+\mathrm{dist}(\widehat\theta,\mathcal{M}_\infty)+\frac{d(P_{\mathcal{A}},P'_{\mathcal{A}})}{m}.$$
>
> **定理 3（多样性的充分条件）.** (a) $\mathrm{supp}(P'_{\mathcal{A}})\subseteq\mathrm{supp}(P_{\mathcal{A}})$；或 (b) **中心化子条件**：若与 $\{A_1A_2^{-1}:A_1,A_2\in\mathrm{supp}(P_{\mathcal{A}})\}$ 全部交换的矩阵只有 $I$ 的数乘，则 $P_{\mathcal{A}}$ 相对**任何**容许的 $P'_{\mathcal{A}}$ 多样。

> **命题 1（必要性）.** 若预训练任务**可同时正交对角化**而测试任务不可，则模型可以有零训练损失与 $\Omega(1)$ 的测试误差。

> [!tip] 中心化子条件是这篇论文最漂亮的地方
> 它把"预训练任务够不够多样"变成一个**纯代数条件**：一族矩阵的中心化子平凡。
>
> 而命题 1 说明这不是技术条件——**同时可对角化的任务族真的会失败**。这是一个**矩阵值的现象，没有标量类比**：在 [[09 ICL 的数学表述：任务分布与贝叶斯预测器#4-有效先验可以比经验先验宽任务多样性阈值|09 §4]] 的向量设定里，"任务多样性"只是一个计数阈值 $M^\star$；到了矩阵设定，它变成了群论/表示论意义上的条件。
>
> **这大概是这门课里最适合纯数学背景的人接手的题目**：中心化子条件能推广到什么程度？非交换情形的定量版本是什么？

> **定理 4（协变量偏移）.** $\mathbb{E}\lVert y^{\widehat\theta}_{m+1}-A^{-1}x_{m+1}\rVert^2\lesssim\mathcal{R}_m(\widehat\theta)+\lVert\Sigma-\Sigma'\rVert_{\text{op}}+\frac1m\lVert U-W\rVert_{\text{op}}$。
>
> **与任务偏移不同，这个误差不随数据增多而消失。**

**又一次**：任务方向稳健、协变量方向脆弱——与 [[10 线性 attention 实现梯度下降#5-分布外行为哪个方向脆弱|10 §5]] 完全一致。**这个二分在三个独立的设定里出现了三次。**

## 3. 接到算子上

> **定理 5 / 推论 2（算子学习）.** 取编码器 $\mathcal{E}:\mathcal{X}\to\R^d$、解码器 $\mathcal{D}:\R^d\to\mathcal{Y}$、目标 $T\in\mathcal{L}(\mathcal{X},\mathcal{Y})$，则
> $$\mathbb{E}\big\lVert\mathcal{D}(y^{\widehat\theta}_{m+1})-T(f_{m+1})\big\rVert^2_{\mathcal{Y}}\ \lesssim\ \epsilon^2_{\mathcal{E},\mathcal{D}}+C_{\mathcal{D}}^2\,\mathcal{R}_m(\widehat\theta).$$
> 具体到 $-\nabla\cdot(a\nabla u)+Vu=f$ 于 $[0,1]$、$P^1$ 有限元维数 $d$：
> $$\mathbb{E}\big\lVert\mathcal{D}(y^{\widehat\theta}_{m+1})-T(f_{m+1})\big\rVert^2_{H^1}\ \lesssim\ \frac1{d^2}+\frac{d^2}{m}+\frac1{n^2}+\frac1{\sqrt N}.$$

> [!tip] 注意 $\frac1{d^2}+\frac{d^2}{m}$ 这一对
> **离散化误差与 prompt 长度的权衡**：网格越细逼近越好（$d^{-2}$）但要更长的上下文才能定出更多未知数（$d^2/m$）。最优在 $d\asymp m^{1/4}$。
>
> 这是本篇里最"应用数学"的一条，也是最实用的：**上下文长度决定了你能用多细的离散化。**在 [[14 算子学习：DeepONet、FNO 与逼近理论|14]] 的固定权重算子学习里没有这个权衡，因为那里的"上下文"是整个训练集。

**在测度空间上的版本**：Cole–Wang–Chen–Lu–Lai（[arXiv:2601.09979](https://arxiv.org/abs/2601.09979)）把 in-context 学习搬到 Wasserstein 空间：从少量样本 prompt 学"（一对测度）$\mapsto$（最优传输映射）"。含两类结果：非参数区的 scaling law（精度 vs prompt 规模、内蕴任务维数、模型容量），与参数区的显式架构（**在上下文里精确恢复 OT 映射**）加有限样本超额风险界。

**为什么线性理论是对的理想化.** Liu, Erichson, Bhatia, Mahoney, Ré（DLDE-III @ NeurIPS 2023）给了一个干净的归约：经**伪谱 / Chebyshev 插值**，in-context 解 ODE 变成 in-context **最小二乘**——而那正是 [[10 线性 attention 实现梯度下降|10]]、[[12 transformer 作为 in-context solver：表达力与极限|12]] 已知 Transformer 能做的事。**这解释了 ICON 为什么可能 work。**

## 4. 诚实的现状与开放问题

**有的：**
1. 线性系统 / 线性算子的 in-context 泛化理论，率 $\frac1m+\frac1{n^2}+\frac1{\sqrt N}$，任务多样性的代数刻画，协变量偏移的不可消误差；
2. Wasserstein 空间上 OT 映射的 in-context 理论；
3. 伪谱归约，说明为什么线性理论是合适的理想化。

**没有的：**
- **ICON 本身**（非线性算子、编码器–解码器、19 类问题）的**任何**逼近或统计理论；
- 它最惊人的现象——三次通量训练 $\to$ $\tanh$ 通量泛化——**完全没有解释**；
- 反向（非唯一）算子的 in-context 学习：这是一个**不适定**问题，按 [[11 ICL 用于逆线性回归：学到的是先验与正则化|11]]、[[13 学习算子中的核：正规算子、FSOI 与 DARTR|13]] 的框架，模型必然在**选一个正则化**——**选的是哪个？没有人回答过。**

> [!tip] 我认为最值得做的题
> **把 [[11 ICL 用于逆线性回归：学到的是先验与正则化|11]] 的框架搬到 in-context 算子学习上。**
>
> Lu–Yu 已经在有限维证明了：欠定的 in-context 逆问题里，训练好的 Transformer 学到的是跨任务先验诱导的广义 Tikhonov 正则化。ICON 的"反向算子"任务是同一个结构在无穷维上的版本。
>
> 具体问题：**当 in-context 任务是不适定的，模型隐式选择的正则化算子是什么？它是不是跨任务协方差的伪逆？**这个问题在有限维有答案（[[11 ICL 用于逆线性回归：学到的是先验与正则化|11]]），在算子层面有强烈的暗示（[[13 学习算子中的核：正规算子、FSOI 与 DARTR#7-注意力作为学到的正则化子|NAO]]），但没有定理。
>
> **这是这门课全部内容汇合的那个点。**

## 5. 全课程的一句话

把 15 篇串起来：

> **科学基础模型 $=$ 一个把任务分布转化成正则化的装置。**
>
> - **Part 3/6** 告诉你，科学计算里的学习问题几乎都是不适定的第一类方程，**正则化不可回避**，而正则化的形状（惩罚范数、先验协方差、RKHS）决定一切；
> - **Part 4** 给了一个例外——去噪 score matching 是良态的——并说明**例外的来源是磨光**；
> - **Part 5** 说明，一个在任务族上预训练的模型，其最优行为就是该族先验下的贝叶斯推断，**而这在机制上表现为把先验的二阶统计量编译成前向传播里的预条件子 / 惩罚算子**；
> - **Part 2** 说明，做这件事的架构本身（attention）是一个非局部 Markov 算子，它的长时间行为是坍缩，实际的表示活在亚稳态里。
>
> 而贯穿全部的定量原则只有一条：**率由正规算子的谱决定，不由算法决定。**

## 6. 一页速查

| 结论 | 内容 |
|---|---|
| ICON prompt | 变长的 (condition, QoI) demo 序列 $+$ question，函数以点云给出 |
| 架构 | self-attention 编码器出算子嵌入；cross-attention 解码器逐 query 输出 |
| ICON 的理论 | **没有**。全部经验 |
| 线性理论 | $\mathcal{R}_m\lesssim\frac1m+\frac1{n^2}+\frac1{\sqrt N}$ |
| 任务多样性 | 中心化子条件；同时可对角化的任务族**会失败** |
| 协变量偏移 | 误差不随数据消失（第三次出现） |
| 算子版本 | $\frac1{d^2}+\frac{d^2}{m}+\frac1{n^2}+\frac1{\sqrt N}$，最优 $d\asymp m^{1/4}$ |
| 伪谱归约 | in-context 解 ODE $\to$ in-context 最小二乘 |
| 最大缺口 | 不适定 in-context 任务里，隐式正则化是什么 |

## 参考

- [Yang, Liu, Meng, Osher, *In-context operator learning with data prompts for differential equation problems*](https://www.pnas.org/doi/10.1073/pnas.2310142120), PNAS **120**(39) (2023); [arXiv:2304.07993](https://arxiv.org/abs/2304.07993).
- Yang, Liu, Osher, *Fine-tune language models as multi-modal differential equation solvers* (ICON-LM); [arXiv:2308.05061](https://arxiv.org/abs/2308.05061).
- Yang & Osher, *PDE generalization of in-context operator networks*, J. Comput. Phys. **519** (2024) 113379; [arXiv:2401.07364](https://arxiv.org/abs/2401.07364).
- [Cole, Lu, Xu, Zhang, *In-context learning of linear systems: generalization theory and applications to operator learning*](https://arxiv.org/abs/2409.12293).
- [Cole, Wang, Chen, Lu, Lai, *In-context operator learning on the space of probability measures*](https://arxiv.org/abs/2601.09979) (2026).
- Liu, Erichson, Bhatia, Mahoney, Ré, *Does in-context operator learning generalize to domain-shifted settings?*, DLDE-III @ NeurIPS 2023.
- [Yu, Liu, Lu, Gao, Jafarzadeh, Silling, *Nonlocal attention operator*](https://arxiv.org/abs/2408.07307), NeurIPS 2024.

## Related

- [[index|科学基础模型的数学]]
- [[12 transformer 作为 in-context solver：表达力与极限]]
- [[14 算子学习：DeepONet、FNO 与逼近理论]]
- [[13 学习算子中的核：正规算子、FSOI 与 DARTR]]
- [[11 ICL 用于逆线性回归：学到的是先验与正则化]]
