---
title: 10 线性 attention 实现梯度下降
description: 一层线性 attention 的前向恰是一步（预条件）梯度下降；最优参数就是它；梯度流的全局收敛与分布外行为。
tags:
  - scientific-foundation-models
  - in-context-learning
  - transformers
stage: 🌱 seedling
date: 2026-08-18
---

# 10 线性 attention 实现梯度下降

> 原大纲 10/27, 10/29 是 `TBD`。[[09 ICL 的数学表述：任务分布与贝叶斯预测器|09]] 说明了 ICL 的 oracle 是贝叶斯预测器；这一篇回答**机制**问题：Transformer 在前向传播里到底在算什么。
>
> 答案惊人地具体：**一层线性 attention 的前向传播就是一步梯度下降，而且这不是"可以构造成"，是"最优参数恰好就是"。**并且梯度流会全局收敛到它，极限有闭式。
>
> 这是整个 ICL 理论里定理最硬的一块——**唯一的代价是必须用线性 attention。**代价有多大，§7 讲。

> [!question] 卡住了从哪儿看起
> - [von Oswald 等, *Transformers learn in-context by gradient descent*](https://arxiv.org/abs/2212.07677), ICML 2023 — §1 的构造，读 Prop. 1 就够
> - 📐 [Ahn, Cheng, Daneshmand, Sra, *Transformers learn to implement preconditioned gradient descent for ICL*](https://arxiv.org/abs/2306.00297), NeurIPS 2023 — §3
> - 📐 [Zhang, Frei, Bartlett, *Trained transformers learn linear models in-context*](https://arxiv.org/abs/2306.09927), JMLR 2024 — §4–5，**非凸目标的全局收敛定理，这在这个领域很罕见**
> - [Cheng, Chen, Sra, *Transformers implement functional gradient descent*](https://arxiv.org/abs/2312.06528), ICML 2024 — §6 的非线性推广

## 1. 构造：一层 $=$ 一步 GD

**线性 self-attention**（去掉 softmax），token $e_j=(x_j,y_j)\in\R^{d+1}$：
$$e_j\ \longleftarrow\ e_j+P\,V\,K^\top q_j,\qquad K=W_KE,\ V=W_VE,\ q_j=W_Qe_j .$$

**要匹配的 GD 侧.** 对 $L(W)=\frac1{2n}\sum_i\lVert Wx_i-y_i\rVert^2$，一步学习率 $\eta$ 的 GD 是
$$\Delta W=-\frac{\eta}{n}\sum_i(Wx_i-y_i)x_i^\top,$$
它对任意 $x_j$ 处预测的影响是 $\Delta y_j=\Delta W\,x_j$。

> **命题 1（von Oswald 等 2023）.** 存在 $W_K,W_Q,W_V,P$ 使得该层对每个 token 的更新恰好是
> $$e_j=(x_j,y_j)\ \longmapsto\ (x_j,\ y_j-\Delta y_j).$$
> 显式构造（按 $x$/$y$ 分块，$W_0$ 是"当前"线性模型）：
> $$W_K=W_Q=\begin{pmatrix}I_x&0\\0&0\end{pmatrix},\qquad W_V=\begin{pmatrix}0&0\\ W_0&-I_y\end{pmatrix},\qquad P=\frac{\eta}{n}I .$$

**验算**：$W_Ke_i=(x_i,0)$、$W_Qe_j=(x_j,0)$，故 $K^\top q_j$ 的分量是 $\langle x_i,x_j\rangle$；$W_Ve_i=(0,\,W_0x_i-y_i)$，即 value 是**残差**。于是
$$PVK^\top q_j=\Big(0,\ \tfrac{\eta}{n}\sum_i(W_0x_i-y_i)\langle x_i,x_j\rangle\Big)=(0,\,-\Delta W x_j).$$

> [!tip] 对偶性：它不更新权重，它更新标签
> 层里根本没有"权重"可以更新。它做的是
> $$L(W_0+\Delta W)=\frac{1}{2n}\sum_i\big\lVert W_0x_i-(y_i-\Delta y_i)\big\rVert^2 .$$
> **"对 $W$ 走一步 GD" $\equiv$ "保持 $W_0$ 不动，把 $y_i$ 换成 $y_i-\Delta y_i$"。**
>
> 于是**堆 $k$ 层就是走 $k$ 步 GD**，深度是迭代计数器。这是一个**精确的代数恒等式**，不是逼近——这一部分是真正被证明的。

**GD++.** 允许该层也变换协变量 $x_j\leftarrow H(X)x_j$，$H(X)=I-\gamma\frac1nXX^\top$，得到一个 Newton 式的白化/曲率修正。**训练出来的多层线性 Transformer 匹配的是 GD++ 而非朴素 GD**——它用 $K$ 层打败 $K$ 步朴素 GD。这一条是**经验的**（用损失、模型余弦相似度、敏感性三个指标测出来的），von Oswald 的论文里没有"训练收敛到该构造"的定理。补上这个缺口的是 §3 和 §4。

## 2. 资源计数：深度 vs 宽度

> **定理（Akyürek, Schuurmans, Andreas, Ma, Zhou, ICLR 2023）.**
> 1. Transformer 可以用**常数层数**与 $O(d)$ 隐藏维数算出 in-context 最小二乘 / ridge 目标的**一步 GD**。
> 2. Transformer 可以实现 **Sherman–Morrison** 秩一更新，于是迭代 $n$ 次算出**闭式** ridge/OLS 解 $(X^\top X+\lambda I)^{-1}X^\top Y$，每次更新常数层，但需要 $O(d^2)$ 隐藏维数（必须在残差流里携带 $d\times d$ 的逆协方差）。

> [!note] 这个二分是真内容
> **迭代的一阶算法宽度便宜（$O(d)$），精确的二阶算法宽度昂贵（$O(d^2)$）；深度买迭代次数。**
>
> 这是计算复杂性意义上的权衡，不是实现细节。它也解释了实验里看到的**深度相变**：1 层 $\approx$ 一步 GD（很差）；2–4 层 $\approx$ ridge；$\ge8$ 层 $\approx$ OLS。
>
> 以及：有标签噪声时模型匹配的是**最小贝叶斯风险**预测器，即 $\lambda=\sigma^2/\tau^2$ 的 ridge。**这是 [[09 ICL 的数学表述：任务分布与贝叶斯预测器#2-icl-最优预测器-后验预测分布|09 §2]] 的 oracle 在机制层面的确认。**

## 3. 最优参数**就是**预条件 GD

von Oswald 只说"能构造"。Ahn 等把它升级成"最优就是"。

**架构.** $Z\in\R^{(d+1)\times(n+1)}$，$M=\mathrm{diag}(I_n,0)$，
$$\mathrm{Attn}_{P,Q}(Z)=P\,Z\,M\,(Z^\top QZ),\qquad Z_{\ell+1}=Z_\ell+\tfrac1n\mathrm{Attn}_{P_\ell,Q_\ell}(Z_\ell).$$

> **引理 1（前向 $=$ 预条件 GD）.** 若参数取稀疏形式
> $$P_\ell=\begin{pmatrix}0&0\\0&1\end{pmatrix},\qquad Q_\ell=-\begin{pmatrix}A_\ell&0\\0&0\end{pmatrix},$$
> 则 $L$ 层前向恰好算出 $L$ 步
> $$w_{\ell+1}=w_\ell-A_\ell\,\nabla R(w_\ell),\qquad R(w)=\frac{1}{2n}\sum_i\big(\langle w,x_i\rangle-\langle w_\star,x_i\rangle\big)^2,\quad w_0=0 .$$
> 即 $A_\ell$ 是**预条件子**（矩阵步长）。

> **定理 1（单层全局极小，各向异性数据）.** 设 $x_i\sim\mathcal{N}(0,\Sigma)$，$\Sigma=U\Lambda U^\top$，$w_\star\sim\mathcal{N}(0,I_d)$。则单层 in-context 损失的**全局极小元**给出
> $$A_0=\Gamma^{-1},\qquad \boxed{\ \Gamma=\frac{n+1}{n}\Sigma+\frac{\operatorname{tr}\Sigma}{n}I_d\ }$$
> 即一步预条件 GD，预条件子是**收缩后的逆协方差**。

**读 $\Gamma$：**$\frac{n+1}{n}\Sigma$ 是数据的二阶矩，$\frac{\operatorname{tr}\Sigma}{n}I$ 是一个**随 $n$ 消失的 ridge 型修正项**——数据不足时的自动正则化。各向同性 $\Sigma=I$ 时 $A_0=\frac{n}{n+d+1}I$。

同时期的 [Mahankali–Hashimoto–Ma (ICLR 2024)](https://arxiv.org/abs/2307.03576) 给出互补的结论：协变量标准高斯时最优单层就是**一步朴素 GD**；协变量或 $w_\star$ 各向异性时是**预条件** GD；**只改变响应的分布（甚至改成非线性 $y=g(x)$）最优单层仍是朴素 GD**——标签方向稳健，与协变量方向形成对照（§5）。

## 4. 梯度流全局收敛

上面是"最优点在哪"。还剩"能不能到"。

**架构.** 单层线性 self-attention（LSA）
$$f_{\text{LSA}}(E;\theta)=E+W^{PV}E\cdot\frac{E^\top W^{KQ}E}{n},$$
损失是**总体**损失 $L(\theta)=\frac12\mathbb{E}[(\widehat y_{\text{query}}-\langle w_\tau,x_{\text{query}}\rangle)^2]$，对 $\theta=(W^{KQ},W^{PV})$ **非凸**（双线性，整体四次）。

> **定理 4.1（Zhang–Frei–Bartlett, JMLR 2024）.** 在平衡的块稀疏初始化下，若 $\sigma^2\lVert\Gamma\rVert_{\text{op}}\sqrt d<2$，则**梯度流收敛到全局极小**，且
> $$W^{KQ}_*=\big[\operatorname{tr}(\Gamma^{-2})\big]^{-1/4}\begin{pmatrix}\Gamma^{-1}&0\\0&0\end{pmatrix},\qquad W^{PV}_*=\big[\operatorname{tr}(\Gamma^{-2})\big]^{1/4}\begin{pmatrix}0&0\\0&1\end{pmatrix},$$
> $\Gamma$ **与 Ahn 等的定理 1 完全相同**。

> **定理 4.2（极限算什么）.** 在**新的** prompt $(x_1,y_1,\dots,x_M,y_M,x_{\text{query}})$（$(x_i,y_i)\sim\mathcal{D}$ 任意！）上，训练好的模型输出
> $$\boxed{\ \widehat y_{\text{query}}=x_{\text{query}}^\top\,\Gamma^{-1}\Big(\frac1M\sum_{i=1}^My_ix_i\Big)\ }$$

**读这个公式**：从 $w=0$ 出发的**一步预条件 GD**——等价地，用**训练时**的二阶矩 $\Gamma$ 和**测试时**的交叉矩 $\frac1M\sum y_ix_i$ 拼出来的 ridge 型估计量。$M,n$ 大时 $\Gamma^{-1}\to\Lambda^{-1}$，于是 $\widehat y\to x^\top\Lambda^{-1}\mathbb{E}[yx]$，即 $\mathcal{D}$ 下的**最佳线性预测器**。

> [!tip] 这是本篇最有用的一条
> 有了闭式，分布外行为不用做实验，**读公式就知道**。见 §5。
>
> 也要注意它的范围：梯度**流**（非离散 GD）、**总体**损失（非有限样本）、单层、线性 attention、无 MLP、主定理里无标签噪声。但这**确实是一个非凸目标的全局收敛定理**，在这个领域里很罕见。

## 5. 分布外行为：哪个方向脆弱

从 $\widehat y=x^\top\Gamma^{-1}\big(\frac1M\sum y_ix_i\big)$ 直接读：

| 偏移类型 | 结论 |
|---|---|
| **任务偏移**（$w_\star$ 换分布、非高斯、标签有噪、响应非线性） | **稳健。**$\frac1M\sum y_ix_i$ 仍是 $\mathbb{E}[yx]$ 的无偏估计，模型仍返回最佳线性预测器。**这证明了 Garg 等观察到的稳健性。** |
| **query 偏移**（$x_{\text{query}}$ 换分布） | **稳健。**公式对 $x_{\text{query}}$ 是固定线性泛函 |
| **协变量偏移**（$x_i\sim\mathcal{N}(0,\Lambda')$，$\Lambda'\ne\Lambda$） | **失败。**模型算的是 $x^\top\Gamma^{-1}\Lambda'w_\star$ 而非 $x^\top w_\star$，偏差由 $\lVert\Gamma^{-1}\Lambda'-I\rVert$ 控制 |

> [!warning] 脆弱性的根源是结构性的
> **$\Gamma$ 在训练时就被烘进权重，无法在上下文里调整。**这不是训练不足，是单层线性 attention 的表达力上限。
>
> 回到 [[09 ICL 的数学表述：任务分布与贝叶斯预测器#6-反复出现的那个对象|09 §6]] 那张表：四套形式化里都出现"预训练分布二阶矩的逆"。**它既是近最优性的来源，也是脆弱性的来源，同一个对象。**
>
> 修法（经验的）：在**协变量协方差的一个分布**上预训练更大的非线性 Transformer，它会学会在上下文里做算法选择——这是 [[12 transformer 作为 in-context solver：表达力与极限|12]] 的内容。

## 6. 非线性推广：核 attention $=$ RKHS 里的泛函梯度下降

把 attention 的"活化函数"一般化：$\mathrm{Attn}^{\tilde h}_{V,B,C}(Z)=V\,Z\,M\,\tilde h(BX,CX)$。

> **命题 1（Cheng, Chen, Sra, ICML 2024）.** 若 $\tilde h$ 取一个正定**核** $\mathcal{K}$，则一层 attention 实现 RKHS $\mathcal{H}_{\mathcal{K}}$ 中的**一步泛函梯度下降**
> $$f_{\text{new}}=f_{\text{old}}-\eta\,\nabla_f\mathcal{L}(f_{\text{old}}).$$
> 因为 $\nabla_f\frac{1}{2n}\sum(f(x_i)-y_i)^2=\frac1n\sum(f(x_i)-y_i)\mathcal{K}(x_i,\cdot)$，在 query 处求值就是"残差作 value、核作权重"的 attention 输出。

> **命题 2.** 若标签由核为 $\mathcal{K}$ 的高斯过程生成，则该构造（层数足够）收敛到**贝叶斯最优预测器**——前提是 attention 的非线性**匹配**数据生成核。

> [!tip] 这一节把 Part 5 闭环了
> - [[09 ICL 的数学表述：任务分布与贝叶斯预测器#2-icl-最优预测器-后验预测分布|09 §2]]：ICL 最优 $=$ 贝叶斯；
> - 本节：核 attention $+$ 深度 $=$ GP 数据下的贝叶斯；
> - §1：$\mathcal{K}(x,x')=\langle x,x'\rangle$ 是特例。
>
> 而且它给出一条设计原则：**对的 activation 是那个 RKHS 包含目标函数类的核。**这与 [[P3 RKHS 与不适定逆问题的正则化|P3]] 里"惩罚范数的选择就是先验的选择"是同一句话。

## 7. 线性 attention 的代价，以及 softmax 的现状

**必须记住**：§1–§5 全部建立在**线性** attention 上。而 [[09 ICL 的数学表述：任务分布与贝叶斯预测器#5-attention-本身就是核平滑|09 §5]] 说明了**线性 attention 恰好丢掉自适应带宽**——softmax 的归一化才是让它成为平滑器的东西。

**softmax 的理论现状：**

- [Huang, Cheng, Liang (ICML 2024)](https://arxiv.org/abs/2310.05249)：单层 softmax attention，上下文 token 取自有限个正交特征。**平衡特征**下有限时间收敛，动力学分**两个阶段**；**不平衡特征**下是**分阶段**收敛——先在主导特征上收敛，再经过**四个额外阶段**在弱特征上收敛。技术核心是追踪两族 attention 权重的竞争。
- 多头 softmax 的训练动力学有若干工作，但结论都依赖对数据的强结构假设。

> [!warning] 诚实的总结
> **线性 attention：有全局收敛定理与闭式极限。softmax attention：只有在离散/正交特征假设下的分阶段收敛，没有 Zhang–Frei–Bartlett 强度的结果。**
>
> 高斯协变量下 softmax attention 的 ICL 训练动力学是**公开问题**。这是这块最显眼的缺口，也是最值得做的题之一。

## 8. 一页速查

| 结论 | 内容 |
|---|---|
| von Oswald 命题 1 | 一层线性 attention $\equiv$ 一步 GD，**精确恒等式** |
| 对偶性 | 不更新权重，更新标签；深度 $=$ 迭代次数 |
| Akyürek | 一步 GD：$O(1)$ 层 $+$ $O(d)$ 宽；精确 OLS：$O(d^2)$ 宽 |
| 深度相变（经验） | 1 层 $\approx$ 一步 GD；2–4 层 $\approx$ ridge；$\ge8$ 层 $\approx$ OLS |
| Ahn 定理 1 | **最优**单层 $=$ 一步预条件 GD，$A_0=\Gamma^{-1}$ |
| $\Gamma$ | $\frac{n+1}{n}\Sigma+\frac{\operatorname{tr}\Sigma}{n}I$；后一项是自动 ridge |
| Zhang–Frei–Bartlett | 梯度流**全局收敛**到它（非凸目标） |
| 极限算什么 | $\widehat y=x^\top\Gamma^{-1}(\frac1M\sum y_ix_i)$ |
| 分布外 | 任务偏移稳健、query 偏移稳健、**协变量偏移失败** |
| 核 attention | $=$ RKHS 里的泛函 GD；GP 数据下深度足够即贝叶斯最优 |
| 缺口 | 高斯协变量下 softmax 的训练动力学 |

## 参考

- [von Oswald, Niklasson, Randazzo, Sacramento, Mordvintsev, Zhmoginov, Vladymyrov, *Transformers learn in-context by gradient descent*](https://arxiv.org/abs/2212.07677), ICML 2023.
- [Akyürek, Schuurmans, Andreas, Ma, Zhou, *What learning algorithm is in-context learning?*](https://arxiv.org/abs/2211.15661), ICLR 2023.
- [Ahn, Cheng, Daneshmand, Sra, *Transformers learn to implement preconditioned gradient descent for in-context learning*](https://arxiv.org/abs/2306.00297), NeurIPS 2023.
- [Mahankali, Hashimoto, Ma, *One step of gradient descent is provably the optimal in-context learner with one layer of linear self-attention*](https://arxiv.org/abs/2307.03576), ICLR 2024.
- [Zhang, Frei, Bartlett, *Trained transformers learn linear models in-context*](https://arxiv.org/abs/2306.09927), JMLR 25 (2024).
- [Cheng, Chen, Sra, *Transformers implement functional gradient descent to learn non-linear functions in context*](https://arxiv.org/abs/2312.06528), ICML 2024.
- [Huang, Cheng, Liang, *In-context convergence of transformers*](https://arxiv.org/abs/2310.05249), ICML 2024.

## Related

- [[index|科学基础模型的数学]]
- [[09 ICL 的数学表述：任务分布与贝叶斯预测器]]
- [[11 ICL 用于逆线性回归：学到的是先验与正则化]]
- [[12 transformer 作为 in-context solver：表达力与极限]]
- [[notes/deep-learning/12 Transformer|DL 12 Transformer]]
