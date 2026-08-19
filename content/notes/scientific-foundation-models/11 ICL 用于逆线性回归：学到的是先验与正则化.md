---
title: 11 ICL 用于逆线性回归：学到的是先验与正则化
description: 欠定的 in-context 逆回归；纯数据失配损失下唯一破除退化的是跨任务结构；涌现的是广义 Tikhonov 正则化。
tags:
  - scientific-foundation-models
  - in-context-learning
  - inverse-problems
stage: 🌱 seedling
date: 2026-08-18
---

# 11 ICL 用于逆线性回归：学到的是先验与正则化

> 课程 11/3, 11/5：*"ICL for inverse linear regression"*。
>
> **这一篇是整门课的接缝。**前半程（Part 3、Part 6）讲不适定逆问题与正则化；后半程（Part 5）讲 in-context learning。[Lu–Yu (2025)](https://arxiv.org/abs/2505.12138) 把两者接在一起：**训练好的 Transformer 在病态问题上给出的不是最小二乘解，而是带正则的解，而正则化算子是从跨任务结构里学出来的。**
>
> 用 [[P3 RKHS 与不适定逆问题的正则化|P3]] 的语言：**Transformer 在预训练中学到了那个惩罚范数。**
>
> 前置：[[P3 RKHS 与不适定逆问题的正则化|P3]]（Tikhonov、源条件、贝叶斯对应）、[[09 ICL 的数学表述：任务分布与贝叶斯预测器|09]]、[[10 线性 attention 实现梯度下降|10]]。

> [!question] 卡住了从哪儿看起
> - [Lu & Yu, *Transformer learns the cross-task prior and regularization for in-context learning*](https://arxiv.org/abs/2505.12138) (2025) — 本篇的全部
> - 📐 [[P3 RKHS 与不适定逆问题的正则化#6-贝叶斯对应|P3 §6]] — Tikhonov 与高斯先验的对应，本篇的解读框架
> - Hansen, *Rank-Deficient and Discrete Ill-Posed Problems*, SIAM 1998 — 论文引用的经典参考

## 1. 设定：与 Part 5 前面几篇的三处不同

跨 $j=1,\dots,n_s$ 个任务：
$$y^j_i=\langle x^j_i,w^j\rangle+\varepsilon^j_i,\qquad x^j_i\sim\mathcal{N}(0,\Sigma_x),\ \ \varepsilon^j_i\sim\mathcal{N}(0,\sigma_\varepsilon^2),\ \ w^j\sim\mathcal{N}(w_0,\Sigma_w),$$
数据 $\mathcal{D}=\{(X^j,Y^j)\}_{j=1}^{n_s}$，$X^j\in\R^{n\times d}$。

**三处结构性差别：**

1. **$n<d$：上下文比未知数少。**每个任务本身是**欠定的**，解集是 $(d-n)$ 维仿射子空间。[[10 线性 attention 实现梯度下降|10]] 里的全部工作都在超定区 $n>d$（OLS 存在）。
2. **任务的内蕴维数低**：$\mathrm{rank}(\Sigma_w)=r_w<n<d$。任务活在 $\R^d$ 的 $r_w$ 维仿射子空间上。
3. **目标是 $\widehat w\approx w^j$，不是下一个标签。**这是**逆**问题，不是前向预测。

**训练损失（关键）：**
$$\mathcal{L}(\theta)=\frac{1}{n_s}\sum_{j=1}^{n_s}\big\lVert X^jw_\theta(X^j,Y^j)-Y^j\big\rVert^2 .$$

> [!warning] 这是一个纯数据失配损失，真 $w^j$ 从不出现
> **无监督。**而且因为 $n<d$，**对每个单独的 $j$，损失可以被无穷多个 $\widehat w$ 打到零**，其中绝大多数是垃圾。
>
> **单任务损失里没有任何东西能选出解。**唯一破除退化的是：**所有任务共享同一个 $\theta$。**
>
> 于是正则化必须从**跨任务结构**里被制造出来。这是全文的中心论点，也是一个对数学家极舒服的表述：**Transformer 是一台把任务多样性转化成正则化的经验贝叶斯机器。**

**架构.** $L$ 层**线性** attention（多头，带偏置），每层后跟 **layer normalization**，最后一层读出 $w_\theta\in\R^d$。作者强调：虽然 attention 是线性的，**LayerNorm 加多层复合使 $\theta\mapsto w_\theta(X,Y)$ 关于 $(X,Y)$ 真正非线性**，而这是必要的——一个有效的正则化子必须非线性地依赖 $X$ 与 $Y$，而固定的二次 Tikhonov 惩罚的解映射对 $Y$ 是线性的。

## 2. 三个基准

**(RE) 逐上下文 ridge，不用跨任务信息.**
$$\widehat w_\lambda=(X^\top X+n\lambda I)^{-1}X^\top Y,$$
$\lambda$ 由广义交叉验证（GCV）逐上下文选。**这是经典逆问题的标准答案**，惩罚是**标量** $\lambda\lVert w\rVert^2$。

**(TRE) 两阶段 ridge，显式经验贝叶斯.**
- 阶段一：从训练集估先验。$\widehat w_0=\frac1{n_s}\sum_j\widehat w^j$；对 $\{\widehat w^j\}$ 的经验协方差做谱分解，用**谱隙**估 $\widehat r_w$，扣掉噪声贡献，得 $\widehat\Sigma_w$。
- 阶段二：在先验几何下做白化 ridge。

TRE 是手工做出来的、**确实用了**跨任务先验的竞争者，$n_s\to\infty$ 时渐近最优。

**(ORE) oracle ridge，贝叶斯基准.** 写 $\Sigma_w=U\Lambda U^\top$（$U\in\R^{d\times r_w}$ 列正交），重参数化 $w=w_0+Uv$，$v\sim\mathcal{N}(0,\Lambda)$。$v$ 的高斯后验是 $\mathcal{N}(\widehat v,\Sigma_v^{\text{post}})$：
$$\boxed{\ \Sigma_v^{\text{post}}=\Big(\Lambda^{-1}+\tfrac{1}{\sigma_\varepsilon^2}(XU)^\top XU\Big)^{-1},\quad \widehat v=\Sigma_v^{\text{post}}\tfrac{1}{\sigma_\varepsilon^2}(XU)^\top(Y-Xw_0),\quad \widehat w^{\text{ORE}}=w_0+U\widehat v.\ }$$

## 3. 涌现的正则化是什么

把 $\widehat v$ 写成变分形式：
$$\widehat v=\arg\min_{v\in\R^{r_w}}\ \big\lVert XUv-(Y-Xw_0)\big\rVert^2\ +\ \sigma_\varepsilon^2\,v^\top\Lambda^{-1}v .$$

**于是涌现的正则化是广义 Tikhonov，不是标量 ridge：**

- **惩罚算子**是**先验精度** $\Lambda^{-1}$（等价地 $\Sigma_w^\dagger$ 在 $\mathrm{ran}(U)$ 上，在其正交补上是 $+\infty$——即**硬约束到 $r_w$ 维任务子空间**）；
- **强度**是**噪声方差** $\sigma_\varepsilon^2$，逐模式看就是 $\lambda_k=\sigma_\varepsilon^2/\lambda^w_k$，经典的信噪比。

> [!tip] "学到了正则化"的精确含义
> **形状**（$\Lambda^{-1}$，从跨任务结构学）$+$ **尺度**（$\sigma_\varepsilon^2$），而不是一个 GCV 调出来的标量。
>
> 标量 $\lambda$ 的 ridge **在原理上无法**表达一个各向异性、秩 $r_w$ 的惩罚——这就是 RE 输得很惨的原因，而且它输的不是调参，是表达力。

**用 [[P3 RKHS 与不适定逆问题的正则化#6-贝叶斯对应|P3 §6]] 的字典翻译一遍**：Tikhonov $=$ MAP，惩罚范数 $\leftrightarrow$ 先验协方差。这里先验协方差就是 $\Sigma_w$，而**高斯测度的 Cameron–Martin 空间恰是它的协方差算子诱导的 RKHS**。所以
$$\sigma_\varepsilon^2\,v^\top\Lambda^{-1}v\ =\ \sigma_\varepsilon^2\,\big\lVert w-w_0\big\rVert^2_{\mathcal{H}_{\Sigma_w}} .$$

> **Lu–Yu 的"学到的正则化"，就是在跨任务协方差核生成的 RKHS 里做 Tikhonov 正则化，正则化参数是噪声水平。**

这是经典的 Kimeldorf–Wahba 贝叶斯/Tikhonov 对应。**新东西是核从哪来**：不是人选的、不是从单个数据集估的，而是**由一个纯无监督的失配损失、通过梯度下降、从任务的整体分布里蒸馏出来的。**

## 4. 定理与它们的范围

> **命题 2.1（ORE 的条件贝叶斯风险）.** 条件于 $X$，
> $$\mathbb{E}_{w,\varepsilon}\lVert\widehat w^{\text{ORE}}-w\rVert^2=\operatorname{tr}\big(\Sigma_v^{\text{post}}\big);$$
> 且若 $\frac1nU^\top X^\top XU\succeq bI_{r_w}$，则
> $$\mathbb{E}_{w,\varepsilon}\lVert\widehat w^{\text{ORE}}-w\rVert^2\ \le\ \frac{\sigma_\varepsilon^2\,r_w}{n\,b}.$$

**读法**：有效样本量是 $n$，**有效维数是 $r_w$ 而不是 $d$**，$b$ 是设计在任务子空间上的受限最小特征值。这也说明**为什么必须 $r_w<n$**：要 $U^\top X^\top XU\succ0$，而 $X$ 只有 $n$ 行。

> [!tip] $b$ 就是 coercivity
> $\frac1nU^\top X^\top XU\succeq bI$ 与 [[04 从轨迹学交互核：变分表述与可辨识性#4-可辨识函数空间与-coercivity|04 §4]] 的 coercivity 条件是**同一个东西**：正规算子在可辨识子空间上有下界。
>
> 而 $\mathrm{ran}(U)$ 就是这里的 **FSOI**。**Part 3 与 Part 5 在这里用同一套语言说了同一句话。**

> **引理 2.4（oracle 估计量的矩）.**
> $$\mathbb{E}[\widehat w^{\text{ORE}}]=w_0,\qquad \mathrm{Cov}(\widehat w^{\text{ORE}})=\Sigma_w-\sigma_\varepsilon^2C,\quad C=U\,\mathbb{E}_X\big[(\sigma_\varepsilon^2\Lambda^{-1}+U^\top X^\top XU)^{-1}\big]U^\top .$$

（标准的全协方差公式：后验均值被收缩，其协方差比先验协方差小掉平均后验协方差。）

**这给出"Transformer 学到了先验"的可操作检验**：
$$\frac{1}{n_s}\sum_jw_\theta(X^j,Y^j)\ \approx\ w_0,\qquad \mathrm{Cov}\big(w_\theta(X,Y)\big)+\sigma_\varepsilon^2C\ \approx\ \Sigma_w .$$
两条经验上都成立，而且恢复出的协方差的**谱能识别出真实的任务维数 $r_w$**。

> [!warning] 范围：论文里没有关于训练好的 Transformer 的定理
> 全部严格结果（命题 2.1、2.2、引理 2.4）都是关于 **oracle 估计量**的，而 oracle 知道 $(w_0,\Sigma_w,\sigma_\varepsilon)$。"Transformer 学到了先验与正则化"是**经验结论**，由上面的矩检验与误差比较支持。
>
> 在这一点上，这篇论文之于 §3 的地位，相当于 [von Oswald](https://arxiv.org/abs/2212.07677) 之于 [[10 线性 attention 实现梯度下降|10]] 在 Ahn/Mahankali 出现之前的地位：**机制被识别出来了，动力学定理还空着。**
>
> **这是一个很好的选题**：把 [[10 线性 attention 实现梯度下降#4-梯度流全局收敛|Zhang–Frei–Bartlett]] 的全局收敛论证搬到 $n<d$ 的欠定设定上。障碍是 LayerNorm 引入的非线性——而作者论证那个非线性是必要的。

**经验结果的层次**（值得记住，因为它反直觉）：
$$\mathrm{Err}(\mathrm{RE})\ \gg\ \mathrm{Err}(\mathrm{TRE})\ \gtrsim\ \mathrm{Err}(w_\theta)\ \gtrsim\ \mathrm{Err}(\mathrm{ORE}).$$
**Transformer 打败了手工的两阶段经验贝叶斯估计量，并逼近 oracle。**

另外：把 $r_w$ 从 2 扫到 50（$n=50$），**所有**估计量（**包括 oracle**）都在 $r_w\uparrow n$ 时急剧变差。**所以 $r_w\ge n$ 处的失败是信息论的，不是 Transformer 的毛病。**

## 5. 与 DARTR 的对照

Lu 自己更早的那条线（[[P3 RKHS 与不适定逆问题的正则化#5-dartr让正则化适应数据|DARTR]]）解决的是同一个结构性问题，走的是另一条路。并排看：

| | **DARTR**（逆问题） | **Lu–Yu 的 ICL Transformer** |
|---|---|---|
| 问题 | 不适定的 $\mathcal{A}\phi=f^\delta$，有不可辨识方向 | $Xw=Y$，$n<d$ |
| 困难 | $L^2$ 惩罚**不适应数据**：它在与算子零空间无关的几何里做正则化 | 标量 ridge $\lambda\lVert w\rVert^2$ 不适应：看不见秩 $r_w$ 的任务子空间 |
| 修法 | **从数据造 RKHS**：惩罚用 $\lVert\cdot\rVert_{\mathcal{H}_{\bar G}}$，$\bar G$ 由正规算子与探索测度决定 | **从任务族造惩罚**：惩罚算子 $=\Sigma_w^\dagger=U\Lambda^{-1}U^\top$ |
| 正规方程 | $(\mathcal{A}^*\mathcal{A}+\lambda\mathcal{L}_{\bar G}^{-1})\phi=\mathcal{A}^*f$ | $(U^\top X^\top XU+\sigma_\varepsilon^2\Lambda^{-1})v=U^\top X^\top(Y-Xw_0)$ |
| 自适应性来自 | **一个**数据集，通过探索测度 | **许多**任务，通过经验先验 |
| 谁选的核 | 算法（显式构造） | 梯度下降（隐式） |

> [!tip] 这张表是这门课的中心论点
> **"基础模型"相对"逐问题求解"的全部优势，可以被精确地表述为：它用任务的整体分布替代了人工选择的正则化。**
>
> 这也解释了为什么这门课把两半放在一起。前半程告诉你**正则化是什么、为什么必需、选错了会怎样**；后半程告诉你**一个足够大的模型可以从任务族里把它学出来**。
>
> **注意这个综合是我的整理，不是论文的措辞**——论文里没有出现 RKHS 这个词。但字典是严丝合缝的，值得在讲义里点破。

**相关的架构工作：Nonlocal Attention Operator（NAO）**（[Yu, Liu, Lu, Gao, Jafarzadeh, Silling, NeurIPS 2024](https://arxiv.org/abs/2408.07307)）把同一想法用在算子的核上：从多个物理系统同时学，attention **提供了核的可辨识函数空间**，起到自动的、数据驱动的正则化作用，代替显式的 Tikhonov/DARTR。详见 [[13 学习算子中的核：正规算子、FSOI 与 DARTR#7-注意力作为学到的正则化子|13 §7]]。

## 6. 一页速查

| 结论 | 内容 |
|---|---|
| 设定 | $n<d$（欠定），$\mathrm{rank}\Sigma_w=r_w<n$，目标是 $\widehat w$ |
| 损失 | 纯数据失配，无监督，真 $w$ 不出现 |
| 退化 | 单任务损失可被无穷多解打到零 |
| 唯一的救星 | 所有任务共享一个 $\theta$ $\Rightarrow$ 跨任务结构 $\Rightarrow$ 正则化 |
| 涌现的正则化 | **广义 Tikhonov**：惩罚算子 $=\Sigma_w^\dagger$，强度 $=\sigma_\varepsilon^2$ |
| RKHS 翻译 | $=\sigma_\varepsilon^2\lVert w-w_0\rVert^2_{\mathcal{H}_{\Sigma_w}}$，跨任务协方差核诱导的 RKHS |
| 风险 | $\operatorname{tr}\Sigma_v^{\text{post}}\le\sigma_\varepsilon^2r_w/(nb)$；有效维数 $r_w$ 而非 $d$ |
| $b$ | $=$ coercivity 常数；$\mathrm{ran}(U)$ $=$ FSOI |
| 检验先验 | 均值 $\approx w_0$；协方差 $+\sigma_\varepsilon^2C\approx\Sigma_w$ |
| 范围 | 定理都关于 oracle；Transformer 的部分是经验的 |
| 经验层次 | RE $\gg$ TRE $\gtrsim$ Transformer $\gtrsim$ ORE |
| $r_w\ge n$ 的失败 | 信息论的，oracle 也垮 |

## 参考

- [Lu & Yu, *Transformer learns the cross-task prior and regularization for in-context learning*](https://arxiv.org/abs/2505.12138) (2025).
- [Yu, Liu, Lu, Gao, Jafarzadeh, Silling, *Nonlocal attention operator: materializing hidden knowledge towards interpretable physics discovery*](https://arxiv.org/abs/2408.07307), NeurIPS 2024.
- Hansen, *Rank-Deficient and Discrete Ill-Posed Problems*, SIAM 1998.
- Golub, Heath, Wahba, *Generalized cross-validation as a method for choosing a good ridge parameter*, Technometrics **21** (1979) 215–223.
- Kimeldorf & Wahba, *A correspondence between Bayesian estimation on stochastic processes and smoothing by splines*, Ann. Math. Statist. **41** (1970) 495–502.
- Lu, Lang, An, *DARTR: Data adaptive RKHS Tikhonov regularization*, MSML 2022; [arXiv:2203.03791](https://arxiv.org/abs/2203.03791).

## Related

- [[index|科学基础模型的数学]]
- [[P3 RKHS 与不适定逆问题的正则化]]
- [[09 ICL 的数学表述：任务分布与贝叶斯预测器]]
- [[10 线性 attention 实现梯度下降]]
- [[13 学习算子中的核：正规算子、FSOI 与 DARTR]]
- [[04 从轨迹学交互核：变分表述与可辨识性]]
