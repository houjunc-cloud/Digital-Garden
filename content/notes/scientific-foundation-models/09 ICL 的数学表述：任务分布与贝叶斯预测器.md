---
title: 09 ICL 的数学表述：任务分布与贝叶斯预测器
description: 把 prompt 写成任务先验下的统计实验；ICL 最优预测器就是后验预测分布；任务多样性阈值；attention 作为核平滑。
tags:
  - scientific-foundation-models
  - in-context-learning
  - bayesian
stage: 🌱 seedling
date: 2026-08-18
---

# 09 ICL 的数学表述：任务分布与贝叶斯预测器

> 课程 10/20, 10/22：*"In-context learning (ICL)"*（原大纲标 TBD）。
>
> ICL 的经验现象是：一个训练好的 Transformer，在**不更新任何权重**的情况下，从 prompt 里的几个 $(x_i,y_i)$ 学会一个新函数。这看起来很神秘。这一篇说明它一点也不神秘——**只要把预训练损失写清楚，最优预测器是什么就是一行 Gibbs 不等式的事。**
>
> 神秘的部分在别处：Transformer **怎么**实现这个最优预测器（[[10 线性 attention 实现梯度下降|10]]、[[12 transformer 作为 in-context solver：表达力与极限|12]]），以及当预训练先验与测试任务不匹配时会怎样（[[11 ICL 用于逆线性回归：学到的是先验与正则化|11]]）。
>
> 前置：[[01 科学基础模型：统计实验、损失与 oracle 基准#4-oracle-基准|01 §4]]（三层 oracle）、[[notes/deep-learning/18 大语言模型|DL 18]]（ICL 的经验面貌）。

> [!question] 卡住了从哪儿看起
> - [Garg, Tsipras, Liang, Valiant, *What can transformers learn in-context?*](https://arxiv.org/abs/2208.01066), NeurIPS 2022 — **先看这篇的图**，全部理论都是在解释它们
> - 📐 [Müller, Hollmann, Arango, Grabocka, Hutter, *Transformers can do Bayesian inference*](https://arxiv.org/abs/2112.10510), ICLR 2022 — §2 的定理，一页纸
> - [Xie, Raghunathan, Liang, Ma, *An explanation of in-context learning as implicit Bayesian inference*](https://arxiv.org/abs/2111.02080), ICLR 2022 — §3
> - [Raventós, Paul, Chen, Ganguli, *Pretraining task diversity and the emergence of non-Bayesian ICL*](https://arxiv.org/abs/2306.15063), NeurIPS 2023 — §4

## 1. 标准设定

固定维数 $d$、上下文长度 $n$、**任务分布** $\mathcal{D}_{\mathcal{W}}$ 与协变量分布 $\mathcal{D}_{\mathcal{X}}$：
$$w_\star\sim\mathcal{D}_{\mathcal{W}},\qquad x_i\overset{\text{iid}}\sim\mathcal{D}_{\mathcal{X}},\qquad y_i=\langle w_\star,x_i\rangle+\varepsilon_i,$$
$$P=\big(x_1,y_1,\dots,x_n,y_n,x_{\text{query}}\big)\ \longmapsto\ \widehat y_{\text{query}} .$$

**Token 嵌入**（后面几篇都用这个）：
$$E=\begin{pmatrix}x_1&\cdots&x_n&x_{\text{query}}\\ y_1&\cdots&y_n&0\end{pmatrix}\in\R^{(d+1)\times(n+1)},$$
预测从右下角读出，掩码 $M=\mathrm{diag}(I_n,0)$ 保证 query 的（缺失的）标签不被当作 value。

**预训练损失对 $w_\star$ 取平均**：
$$\min_\theta\ \mathbb{E}_{w_\star\sim\mathcal{D}_{\mathcal{W}}}\,\mathbb{E}_{x}\ \ell\big(M_\theta(P),\,y_{\text{query}}\big).$$

> [!warning] 这不是一个回归问题
> 它是一个**元学习 / 经验贝叶斯**问题。参数 $\theta$ 不是"某个任务的解"，而是"从任务数据到任务解的映射"。
>
> [[01 科学基础模型：统计实验、损失与 oracle 基准#2-任务族作为一族统计实验|01 §2]] 里说的"两层结构"在这里第一次真正起作用：**单任务是频率派的，任务族是贝叶斯的。**

Garg 等的实验里还有一个细节值得注意：损失对**所有前缀** $P^i=(x_1,y_1,\dots,x_i,y_i,x_{i+1})$ 取平均。**于是模型被迫在每个样本量上都是好的学习器，即学出一整条学习曲线，而不是一个估计量。**

## 2. ICL 最优预测器 $=$ 后验预测分布

> **定理（Müller 等 2022）.** 设 $q_\theta(\cdot\mid x,D)$ 是任意模型族，预训练损失是 prior-data 负对数似然
> $$\ell(\theta)=\mathbb{E}_{D\cup\{(x,y)\}\sim\pi}\big[-\log q_\theta(y\mid x,D)\big].$$
> 则
> $$\ell(\theta)=\mathbb{E}_{x,D}\big[H\big(p(\cdot\mid x,D),\,q_\theta(\cdot\mid x,D)\big)\big]=\mathbb{E}_{x,D}\big[\mathrm{KL}\big(p\,\Vert\,q_\theta\big)\big]+\text{const},$$
> 其中 $p(y\mid x,D)=\int p(y\mid x,\phi)\,\pi(\mathrm{d}\phi\mid D)$ 是**后验预测分布**（PPD），常数是 PPD 的期望熵。
> 特别地，若 PPD 落在模型族里，则全局极小元满足 $q_{\theta^\star}=p$。

**证明**：交叉熵 $=$ 熵 $+$ KL，然后 Gibbs 不等式。**一行。**

平方损失下同样的论证给出 $\widehat y^\star(P)=\mathbb{E}[y_{\text{query}}\mid P]$，即后验均值。

> [!tip] 这就是 ICL 的 oracle
> **"预训练到最优"和"在预训练先验下做贝叶斯推断"是同一件事。**
>
> Garg 等的四个经验发现全部是它的推论：
>
> | 观察 | 解释 |
> |---|---|
> | 线性任务上追平 OLS，且在 $k=d$ 处有相变 | $w\sim\mathcal{N}(0,I)$、无噪时贝叶斯规则 $=$ 最小范数 OLS |
> | 稀疏线性上像 Lasso，远好于 OLS | 贝叶斯规则在稀疏先验下 $\approx$ Lasso |
> | 决策树上**打败**贪心建树与 XGBoost | 贪心不是贝叶斯最优的，模型是 |
> | query 与上下文张成空间正交时输出 $\approx0$ | 那**正是**贝叶斯最优的 |
> | 有标签噪声时出现 double descent | 贝叶斯规则 $=$ ridge，$\lambda=\sigma^2/\tau^2$ |
>
> 最后一行尤其值得注意：模型不是"学会了 OLS 这个算法"，而是"学会了这个任务族的贝叶斯规则"，而后者恰好在无噪时长得像 OLS。

## 3. 非参数版本：混合 HMM

Müller 等的定理干净但抽象（它只说最优预测器是什么，不说任何具体模型能不能达到）。Xie 等给了一个**具体的生成模型**，在其中"后验集中"可以被证明。

**预训练分布**：隐概念 $\theta\sim p(\theta)$ 指标一个 HMM，文档 $o_{1:T}\sim p(\cdot\mid\theta)$。即预训练分布是**HMM 的混合**。有一组**分隔符隐状态** $\mathcal{D}$，观测到分隔符揭示"隐状态在 $\mathcal{D}$ 里"但不揭示是哪一个——这是让链在样例之间"重启"却保留残余不确定性的技术装置。

**测试 prompt**：$S_n=[x_1,y_1,o^{\text{delim}},\dots,x_n,y_n]$，各样例在共享的 $\theta^\star$ 下条件独立。**注意它不在预训练分布的典型支撑里**（样例之间的转移在 $p$ 下是低概率的），全部困难在于控制这个失配。

> **定理 1（粗略）.** 在结构假设与**可区分性条件**
> $$\sum_{j=1}^k\mathrm{KL}_j(\theta^\star\Vert\theta)\ >\ \epsilon^\theta_{\text{start}}+\epsilon^\theta_{\text{delim}}\qquad\forall\theta\ne\theta^\star$$
> 下，$n\to\infty$ 时 in-context 预测器渐近贝叶斯最优。

**读法**：把后验对 $\theta$ 的对数似然比写成 $\exp(n\,r_n(\theta))$，每个样例的速率分解成**信号项**（真概念与错概念在样例分布上的 KL）减去**两个失配惩罚**（起始状态与分隔符）。信号赢，后验就集中。

> [!note] 范围
> **这是关于生成模型的精确条件分布的定理，不是关于任何 Transformer 的定理。**它说的是"ICL 最优预测器长什么样"，不涉及架构或优化。
>
> 这个区分在这门课里反复出现，值得养成习惯：**oracle 的性质**（§2、§3）与**某个架构能不能实现 oracle**（[[10 线性 attention 实现梯度下降|10]]、[[12 transformer 作为 in-context solver：表达力与极限|12]]）是两个独立问题。

## 4. 有效先验可以比经验先验宽：任务多样性阈值

Müller 的定理说"贝叶斯 w.r.t. 预训练先验"。但如果预训练只用了**有限个**任务 $\{w^{(1)},\dots,w^{(M)}\}$，先验是离散测度 $\frac1M\sum\delta_{w^{(m)}}$，贝叶斯规则应该只能处理见过的任务。实际不是。

> **Raventós 等（NeurIPS 2023）的经验发现.** 存在**任务多样性阈值** $M^\star$：
> - $M<M^\star$：模型表现得像离散先验的贝叶斯估计量（"dMMSE"），**解不了没见过的任务**；
> - $M>M^\star$：模型表现得像 **ridge 回归**，即**连续高斯先验**下的贝叶斯估计量，包括从未见过的任务。

**这是"有效先验"与"经验先验"分离的最清楚证据**，也是 Müller 定理**没有**预言的现象——它来自模型类的归纳偏置（有限容量的 Transformer 更容易表示光滑的先验），不来自损失。

> [!tip] 一个可做的题目
> **什么条件下经验先验的贝叶斯规则会被模型类"平滑"成连续先验的贝叶斯规则？**这在统计上是经验贝叶斯的经典问题（Robbins 的非参数经验贝叶斯、compound decision），在这里被架构的归纳偏置调制。据我所知没有令人满意的理论。

## 5. attention 本身就是核平滑

回到架构。单个 softmax attention 单元在标准 prompt 上算的是
$$\widehat y_{\text{query}}=\frac{\sum_iy_i\exp\big(x_{\text{query}}^\top Wx_i\big)}{\sum_i\exp\big(x_{\text{query}}^\top Wx_i\big)},$$
**这字面上就是 Nadaraya–Watson 核回归**，核 $K_W(x,x')=e^{x^\top Wx'}$，带宽由 $\lVert W\rVert$ 控制（[[notes/deep-learning/12 Transformer#21-核平滑nadaraya-watson|DL 12 §2.1]] 已经指出过这一点）。

> **定理（Collins, Parulekar, Mokhtari, Sanghavi, Shakkottai, NeurIPS 2024，粗略）.** 预训练会选出一个对任务族最优的**注意力窗宽**：目标函数越不 Lipschitz、标签噪声越大，窗越**宽**。这正是核回归的经典偏差–方差带宽权衡（$h^\star\sim(\sigma^2/(L^2n))^{1/(d+2)}$）。低秩线性问题上，$W$ 会变成低秩，即先投影再平滑。

**并且：线性 attention 做不到这件事。**归一化（softmax 的分母）是让它成为"平滑器"而非"仿射映射"的原因。

> [!warning] 这是 softmax 的价值的最锐利陈述
> [[10 线性 attention 实现梯度下降|10]] 的全部理论建立在**线性** attention 上（那是唯一能算清楚的），而线性 attention **恰好丢掉了自适应带宽这个能力**。
>
> 读那一批定理时要记住这个代价：它们解释的是"Transformer 如何实现一个固定的估计量"，不是"Transformer 如何自适应"。

**第三个化身：HMM 混合下的核回归.** Han–Wang–Zhao–Ji（[arXiv:2305.12766](https://arxiv.org/abs/2305.12766)）证明：在 Xie 式的混合 HMM 模型下，$n$ 大时贝叶斯 ICL 预测渐近等于 Nadaraya–Watson 估计量
$$\widehat y=\frac{\sum_i\mathbf{e}(y_i)\,\mathcal{K}(x_{\text{test}},x_i)}{\sum_i\mathcal{K}(x_{\text{test}},x_i)},\qquad \mathcal{K}(x,x')=\mathrm{vec}(T_x)^\top\,\Sigma_{p_{\text{pretrain}}}^{-1}\,\mathrm{vec}(T_{x'}),$$
$T_x$ 是 $x$ 对应的 HMM 转移算子。**核是预训练度量下的 Mahalanobis 核。**

## 6. 反复出现的那个对象

把上面和后面几篇的结果并排：

| 出处 | 对象 | 角色 |
|---|---|---|
| Ahn 等（[[10 线性 attention 实现梯度下降\|10]]） | $\Gamma^{-1}$，$\Gamma=\frac{n+1}{n}\Sigma+\frac{\operatorname{tr}\Sigma}{n}I$ | GD 的预条件子 |
| Zhang–Frei–Bartlett（[[10 线性 attention 实现梯度下降\|10]]） | 同一个 $\Gamma^{-1}$ | 梯度流的极限 |
| Lu–Yu（[[11 ICL 用于逆线性回归：学到的是先验与正则化\|11]]） | $\Sigma_w^\dagger=U\Lambda^{-1}U^\top$，强度 $\sigma_\varepsilon^2$ | Tikhonov 惩罚算子 |
| Han 等（§5） | $\Sigma_{p_{\text{pretrain}}}^{-1}$ | Mahalanobis 核 |

> [!tip] 这张表是 Part 5 最该带走的东西
> **四套完全不同的形式化，训练好的模型里都出现了"预训练分布的二阶矩的逆"。**
>
> 一句话总结：**Transformer 把预训练分布的一个二阶统计量编译进了权重，然后在前向传播里用它当预条件子 / 惩罚算子 / 核。**
>
> 这同时解释了两件事：为什么它在预训练分布上接近最优（用了正确的先验），以及为什么它在**协变量分布**偏移时脆弱（那个统计量在训练时就固定了，无法在上下文里调整）。见 [[10 线性 attention 实现梯度下降#5-分布外行为哪个方向脆弱|10 §5]]。

## 7. 一页速查

| 结论 | 内容 |
|---|---|
| 设定 | 任务 $w\sim\mathcal{D}_{\mathcal{W}}$，prompt 是 $(x_i,y_i)$ 加 query |
| 预训练损失 | 对任务取平均 $\Rightarrow$ 元学习 / 经验贝叶斯 |
| **ICL oracle** | $=$ 后验预测分布（Gibbs 不等式，一行） |
| 平方损失版本 | $\widehat y^\star=\mathbb{E}[y_{\text{query}}\mid P]$ |
| Garg 的四个现象 | 全是 oracle 的推论 |
| 混合 HMM | 可区分性条件下后验集中（Xie 等），关于精确条件分布 |
| 任务多样性阈值 | $M<M^\star$ 离散先验；$M>M^\star$ 表现得像连续先验 |
| attention $=$ NW 核回归 | 带宽由预训练自适应选出；**线性 attention 没有这个能力** |
| 反复出现的对象 | 预训练分布二阶矩的逆 |
| 脆弱方向 | 协变量偏移（那个统计量固定在权重里） |

## 参考

- [Müller, Hollmann, Arango, Grabocka, Hutter, *Transformers can do Bayesian inference*](https://arxiv.org/abs/2112.10510), ICLR 2022.
- [Garg, Tsipras, Liang, Valiant, *What can transformers learn in-context?*](https://arxiv.org/abs/2208.01066), NeurIPS 2022.
- [Xie, Raghunathan, Liang, Ma, *An explanation of in-context learning as implicit Bayesian inference*](https://arxiv.org/abs/2111.02080), ICLR 2022.
- [Raventós, Paul, Chen, Ganguli, *Pretraining task diversity and the emergence of non-Bayesian in-context learning for regression*](https://arxiv.org/abs/2306.15063), NeurIPS 2023.
- Collins, Parulekar, Mokhtari, Sanghavi, Shakkottai, *In-context learning with transformers: softmax attention adapts to function Lipschitzness*, NeurIPS 2024; [arXiv:2402.11639](https://arxiv.org/abs/2402.11639).
- Han, Wang, Zhao, Ji, *Understanding emergent in-context learning from a kernel regression perspective*; [arXiv:2305.12766](https://arxiv.org/abs/2305.12766).
- Robbins, *An empirical Bayes approach to statistics*, Berkeley Symp. 1956. 经验贝叶斯的源头，§4 的背景。

## Related

- [[index|科学基础模型的数学]]
- [[01 科学基础模型：统计实验、损失与 oracle 基准]]
- [[10 线性 attention 实现梯度下降]]
- [[11 ICL 用于逆线性回归：学到的是先验与正则化]]
- [[12 transformer 作为 in-context solver：表达力与极限]]
- [[notes/deep-learning/18 大语言模型|DL 18 大语言模型]]
