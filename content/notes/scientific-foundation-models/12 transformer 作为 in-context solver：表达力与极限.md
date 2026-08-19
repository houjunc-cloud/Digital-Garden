---
title: 12 transformer 作为 in-context solver：表达力与极限
description: 能在上下文里跑哪些算法、要多深多宽；in-context 算法选择；端到端统计保证；以及做不到的事。
tags:
  - scientific-foundation-models
  - in-context-learning
  - expressivity
stage: 🌱 seedling
date: 2026-08-18
---

# 12 transformer 作为 in-context solver：表达力与极限

> 课程 11/10, 11/12：*"Transformers as in-context solvers"*。
>
> [[10 线性 attention 实现梯度下降|10]] 证明了"一层 $=$ 一步 GD"。这一篇问上界：**在上下文里究竟能跑哪些算法，代价是多少层多少宽？**以及一个更有意思的问题：**能不能在上下文里选算法？**
>
> 后者是这门课"基础模型"这个词最实在的内容：一个模型同时在异质的任务族上近最优，靠的不是记住所有解，而是**在前向传播里做模型选择**。

> [!question] 卡住了从哪儿看起
> - 📐 [Bai, Chen, Wang, Xiong, Mei, *Transformers as statisticians: provable in-context learning with in-context algorithm selection*](https://arxiv.org/abs/2306.04637), NeurIPS 2023 — **本篇的全部主线**
> - [[10 线性 attention 实现梯度下降|10]] — 单层的精确结果，本篇是它的多层放大
> - 📐 Telgarsky, *Deep Learning Theory* 讲义 — 逼近论式的资源计数体例

## 1. 架构与记账单位

Bai 等用的是 $L$ 层交替的 attention 与 MLP，作用在 $H\in\R^{D\times(n+1)}$ 上，$D=\Theta(d)$：
$$\tilde H=H+\frac1n\sum_{m=1}^MV_mH\,\sigma\big((Q_mH)^\top(K_mH)\big),\qquad \sigma=\mathrm{ReLU}.$$

**注意 $\sigma$ 是 ReLU 不是 softmax。**这是为了让构造的代数可算——一个自觉的取舍，作者论证它是合理的代理。**在讲义里应当标出来**：这一整套表达力结果说的是"ReLU-attention 能干什么"，不是"softmax attention 能干什么"。

**记账用三个量**：层数 $L$（$=$ 算法的迭代次数）、每层头数 $M$、参数范数 $\vertiii{\theta}$（后者进入泛化界）。

## 2. In-context 梯度下降（ICGD）

**基本引理.** 一个 $(L+1)$ 层 Transformer 可以逼近对任意足够光滑的凸 in-context 风险做 $L$ 步 GD，**逼近误差只随 $L$ 线性累积**，不是指数。

> [!note] "线性累积"是技术上最难的一步
> 朴素的估计里，每层的逼近误差会被下一层的 Lipschitz 常数放大，$L$ 层后是 $\prod_\ell\mathrm{Lip}_\ell$，指数。要做到线性，必须用 GD 迭代本身的**收缩性**吸收误差——即在强凸区里，误差不累积而是被压缩。
>
> **这是一个通用教训**：模拟一个**收敛**的算法比模拟一个一般的动力系统便宜得多。

## 3. 资源计数：三个定理

> **定理 4（ridge 回归）.** 设 $\alpha\le\lambda_{\min}(X^\top X/n)\le\lambda_{\max}(X^\top X/n)\le\beta$，$\lVert w^\lambda_{\text{ridge}}\rVert\le B_w/2$，条件数 $\kappa=(\beta+\lambda)/(\alpha+\lambda)$。则存在 Transformer 满足
> $$L=\lceil 2\kappa\log(B_xB_w/2\varepsilon)\rceil+1,\qquad \max_\ell M^{(\ell)}\le3,\qquad \vertiii\theta\le 4R+8(\beta+\lambda)^{-1}$$
> 使得 $\lvert\widehat y_{n+1}-\langle w^\lambda_{\text{ridge}},x_{n+1}\rangle\rvert\le\varepsilon$。

**读法：深度 $=O(\kappa\log(1/\varepsilon))$，头数 $O(1)$，宽度 $\Theta(d)$。**

> [!tip] 深度就是迭代计数器，条件数就是价钱
> 与 [[10 线性 attention 实现梯度下降#2-资源计数深度-vs-宽度|10 §2]] 的 $O(d^2)$ 宽度精确求解并排：
>
> | 路线 | 深度 | 宽度 |
> |---|---|---|
> | 迭代（GD / ISTA） | $O(\kappa\log\frac1\varepsilon)$ | $O(d)$ |
> | 直接（Sherman–Morrison / 求逆） | $O(1)$ 每次更新 | $O(d^2)$ |
>
> **这是数值线性代数里"迭代法 vs 直接法"的权衡，一字不差地出现在 Transformer 的资源账上。**对纯数学背景的读者，这大概是这套理论里最容易共鸣的一条。

> **定理 7（广义线性模型）.** 链接函数 $g$、Lipschitz 常数 $L_g$，在 Hessian 谱被 $[\alpha,\beta]$ 夹住的假设下，
> $$L=\lceil2\kappa\log(L_gB_wB_x/\varepsilon)\rceil+1,\qquad \max_\ell M^{(\ell)}\le\widetilde O(C_g^2\kappa_w^2\varepsilon^{-2}),\qquad \vertiii\theta\le O(R+\beta^{-1}C_g).$$

**注意头数现在带 $\varepsilon^{-2}$**：非线性链接必须被 ReLU-attention 单元的和逼近，多项式膨胀在这里。

**Lasso 与两层网络**：类似构造。Lasso 走 proximal / ISTA 型步骤，仍是条件数的对数深度、$O(1)$ 头。

## 4. In-context 算法选择

这一节是这篇论文真正独特的部分，也是"基础模型"三个字的数学内容。

**两种机制，都有显式构造：**

**(a) Post-ICL 验证.** Transformer 把上下文序列**切成训练段与验证段**，在残差流里**并行**跑几个基础 ICL 算法（比如若干个 $\lambda$ 的 ridge），在验证段上评估，选最好的。

结果：对**噪声水平混合**的贝叶斯线性模型，做到近乎贝叶斯最优——**模型在没有被告知 $\sigma$ 的情况下，逐序列选对了 $\lambda=\sigma^2/\tau^2$。**

**(b) Pre-ICL 测试.** Transformer 先算序列的汇总统计量，判断面对的是哪类任务（回归 vs 分类），再路由。

> [!tip] 这是对 [[10 线性 attention 实现梯度下降#5-分布外行为哪个方向脆弱|10 §5]] 那个脆弱性的正面回答
> 单层线性 attention 把 $\Gamma$ 烘死在权重里，遇到协变量偏移就垮。**但一个更深、更宽、非线性的 Transformer 可以在上下文里做交叉验证。**
>
> 表达力这一侧说：**自适应是可实现的**。它需要的是深度（跑多个算法）与宽度（并行存它们）。**"更大的模型更稳健"这条经验规律在这里有了机制解释。**
>
> 反过来也要诚实：这些是**构造**，不是"训练会找到它们"的证明。

## 5. 端到端的统计保证

表达力之外，论文也给了完整的风险界：

- **推论 5（线性回归）**：$n\gtrsim\widetilde O(d)$、$L=\widetilde O(\kappa\log(\kappa n/\sigma))$ 时
$$\mathbb{E}\big[(\widehat y_{n+1}-y_{n+1})^2\big]\le\inf_w\mathbb{E}\big[(y-\langle w,x\rangle)^2\big]+\widetilde O\big(d\sigma^2/n\big),$$
**率最优**。
- **推论 6（混合噪声的贝叶斯线性模型）**：$n\ge\max\{d/10,O(\log\frac1\varepsilon)\}$、$L=O(\log\frac1\varepsilon)$ 给出相对贝叶斯的超额风险 $O(\varepsilon)$。
- **定理 8（GLM）**：$n\gtrsim O(d)$、$L=O(\log n)$ 给出超额风险 $O(d/n)$。
- **预训练泛化**：通过参数范数 $\vertiii\theta$ 与覆盖数论证，证明**多项式多**的预训练序列足以让**训练出来的** Transformer 达到上述保证。

> [!note] 三个层次要分清
> 1. **oracle 是什么**（[[09 ICL 的数学表述：任务分布与贝叶斯预测器|09]]）；
> 2. **架构能不能表示 oracle**（本篇 §2–§4）；
> 3. **训练能不能找到它**（[[10 线性 attention 实现梯度下降#4-梯度流全局收敛|10 §4]] 对单层线性有答案；一般情形只有本篇的泛化界，即"如果找到了低损失解，它就好"）。
>
> **第三层是最弱的一环。**这在整个深度学习理论里都是如此，不是这个领域特有的。

## 6. 做不到的、以及缺口

**(a) softmax 的表达力理论几乎空白.** §1 用的是 ReLU-attention。[[10 线性 attention 实现梯度下降#7-线性-attention-的代价以及-softmax-的现状|10 §7]] 已经说过训练动力学的缺口；表达力这边同样：softmax 的归一化让构造的代数变得难算，而它恰恰是 [[09 ICL 的数学表述：任务分布与贝叶斯预测器#5-attention-本身就是核平滑|09 §5]] 里自适应带宽的来源。**"最能算的模型恰好丢掉了最有意思的能力"是这个领域的通病。**

**(b) 一般的表达力上界.** 深度固定时哪些算法**不能**被实现？Transformer 的计算复杂性上界（对数精度下在 $\mathsf{TC}^0$ 里，见 [[notes/deep-learning/12 Transformer#5-表达力|DL 12 §5]]）给出一些，但它们太粗，抓不住"在上下文里跑一个统计算法"这个尺度上的限制。**这是一个开放且具体的方向。**

**(c) 条件数的依赖没法回避.** 所有深度界都带 $\kappa$。病态问题（正是 [[11 ICL 用于逆线性回归：学到的是先验与正则化|11]] 关心的 $n<d$ 情形）里 $\kappa$ 可以任意大。**于是"深度买迭代"这条路对不适定问题不够**——必须靠正则化改变问题本身，而不是多跑几步。这正是 11 的内容。

> [!tip] 把 12 与 11 放在一起读
> - **12 说**：良态问题上，深度 $O(\kappa\log\frac1\varepsilon)$ 就能跑出最优估计量，还能选算法。
> - **11 说**：病态问题上，$\kappa=\infty$，深度救不了，唯一的出路是从任务族里学出正则化。
>
> **两篇合起来是这门课对"基础模型能干什么"的完整回答。**

## 7. 一页速查

| 结论 | 内容 |
|---|---|
| 架构 | ReLU-attention（非 softmax），$D=\Theta(d)$ |
| ICGD | $(L+1)$ 层逼近 $L$ 步凸 GD，误差**线性**累积 |
| ridge | $L=O(\kappa\log\frac1\varepsilon)$，头 $O(1)$，宽 $\Theta(d)$ |
| GLM | 同深度，但头数 $\widetilde O(\varepsilon^{-2})$ |
| 迭代 vs 直接 | 深度 $O(\kappa\log\frac1\varepsilon)$/宽 $O(d)$ vs 深度 $O(1)$/宽 $O(d^2)$ |
| 算法选择 | Post-ICL 验证（切验证段、并行跑、选最好）；Pre-ICL 路由 |
| 混合噪声 | 不告诉 $\sigma$ 也能选对 $\lambda=\sigma^2/\tau^2$ |
| 端到端 | 线性回归 $\widetilde O(d\sigma^2/n)$，率最优；GLM $O(d/n)$ |
| 预训练泛化 | 多项式多序列足够（覆盖数 $+$ $\vertiii\theta$） |
| 缺口 | softmax 的表达力；一般上界；$\kappa$ 无法回避 |

## 参考

- [Bai, Chen, Wang, Xiong, Mei, *Transformers as statisticians: provable in-context learning with in-context algorithm selection*](https://arxiv.org/abs/2306.04637), NeurIPS 2023.
- [Akyürek, Schuurmans, Andreas, Ma, Zhou, *What learning algorithm is in-context learning?*](https://arxiv.org/abs/2211.15661), ICLR 2023.
- [Ahn, Cheng, Daneshmand, Sra](https://arxiv.org/abs/2306.00297), NeurIPS 2023.
- Merrill & Sabharwal, *The parallelism tradeoff: limitations of log-precision transformers*, TACL 2023. 表达力上界的背景。
- Telgarsky, *Deep Learning Theory* 讲义. [mjt.cs.illinois.edu/dlt](https://mjt.cs.illinois.edu/dlt/)

## Related

- [[index|科学基础模型的数学]]
- [[10 线性 attention 实现梯度下降]]
- [[11 ICL 用于逆线性回归：学到的是先验与正则化]]
- [[15 in-context operator learning]]
- [[notes/deep-learning/12 Transformer|DL 12 Transformer]]
