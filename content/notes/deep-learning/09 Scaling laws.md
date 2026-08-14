---
title: 09 Scaling laws
description: Kaplan 与 Chinchilla 的完整推导、compute-optimal、数据受限、推理时 scaling。
tags:
  - deep-learning
  - scaling
stage: 🌿 budding
date: 2026-08-14
---

# 09 Scaling laws

> Feng 的 Week 8 提了 "Chinchilla scaling laws" 一句。这个话题值得单独一篇，因为它是**过去十年 AI 领域唯一具有预测能力的定量规律**，而且它的数学（约束优化 + 幂律拟合）简单到可以完全讲清楚。它也是理解"为什么要造更大的模型"这个产业决策的全部依据。
>
> 前置：[[03 信息论]]（损失就是压缩率）、[[08 泛化之谜]]（幂律的可能来源）。

> [!question] 卡住了从哪儿看起
> - [CS336 Lec 9: Scaling laws 基础](https://github.com/stanford-cs336/spring2025-lectures/blob/fb79eb018fa047bf99c4c785dcbbd62fff361e54/nonexecutable/2025%20Lecture%209%20-%20Scaling%20laws%20basics.pdf)、[Lec 11: 细节](https://github.com/stanford-cs336/spring2025-lectures/blob/00191bba00d6d64621dc46ccaed9122681413a24/nonexecutable/2025%20Lecture%2011%20-%20Scaling%20details.pdf) — 含如何实际拟合一条 scaling law
> - [Kaplan 等 (2020)](https://arxiv.org/abs/2001.08361) 与 [Hoffmann 等, Chinchilla (2022)](https://arxiv.org/abs/2203.15556) — 两篇原文，对照着读最能看清分歧
> - [Bahri 等, *Explaining neural scaling laws*](https://arxiv.org/abs/2102.06701) — §4 理论解释的来源

## 1. 经验事实

**Kaplan et al. (2020), "Scaling Laws for Neural Language Models".** 训练一系列不同大小的 Transformer，测量交叉熵损失 $L$（单位 nat/token）。发现：

$$L(N)\approx\Big(\frac{N_c}{N}\Big)^{\alpha_N},\qquad L(D)\approx\Big(\frac{D_c}{D}\Big)^{\alpha_D},\qquad L(C)\approx\Big(\frac{C_c}{C}\Big)^{\alpha_C},$$

其中 $N$=非嵌入参数数，$D$=训练 token 数，$C$=计算量（FLOP）。Kaplan 的拟合值：$\alpha_N\approx0.076$，$\alpha_D\approx0.095$，$\alpha_C\approx0.050$。

**惊人之处：**

1. **跨越 7 个数量级都是直线**（log-log 图上）。
2. **架构细节几乎不影响**：深宽比、attention head 数、FFN 比例在合理范围内变化，损失只差百分之几。**只有 $N$、$D$、$C$ 重要。**
3. **没有观察到饱和。**

> [!note] 对这件事应有的态度
> 这是一个**纯经验规律**，没有第一性原理推导，和 Moore 定律地位类似。它在观测范围内极其可靠，外推到范围外**没有保证**。事实上 Kaplan 的具体指数后来被 Chinchilla 修正了（见 §3），原因是 Kaplan 实验中学习率调度没有随 $D$ 调整——**一个实验设计缺陷改变了整个产业的资源配置多年。**

## 2. 计算预算的约束优化

**FLOP 会计.** 对 Transformer，前向每 token 每参数约 2 FLOP（一次乘一次加），反向约 2 倍前向。于是
$$\boxed{C\approx 6ND}\quad\text{(FLOP)}.$$

（更精确要加 attention 的 $O(L\cdot s)$ 项，$s$=序列长度；当 $s\ll d_{\text{model}}\cdot 12/ (\text{层数系数})$ 时可忽略，长上下文时不可忽略。）

**问题.** 给定 $C$，如何分配 $N$ 与 $D$ 使 $L$ 最小？

**Chinchilla 的参数化（Hoffmann et al. 2022）.**
$$L(N,D)=E+\frac{A}{N^{\alpha}}+\frac{B}{D^{\beta}}.$$

三项的含义：
- $E$：**不可约损失**，自然语言的熵（Chinchilla 拟合 $E\approx1.69$ nat/token）。
- $A/N^\alpha$：模型容量不足造成的损失（[[02 神经网络作为函数类|逼近误差]]）。
- $B/D^\beta$：数据不足造成的损失（[[01 学习问题的数学表述|估计误差]]）。

**注意这正是 [[01 学习问题的数学表述#11-分解|逼近/估计分解]]的定量版本。**

**求解.** 最小化 $L$ s.t. $C=6ND$。用 Lagrange：令 $D=C/(6N)$，
$$L(N)=E+\frac{A}{N^\alpha}+B\Big(\frac{6N}{C}\Big)^{\beta}.$$
$$\frac{dL}{dN}=-\frac{\alpha A}{N^{\alpha+1}}+\frac{\beta B 6^\beta N^{\beta-1}}{C^\beta}=0$$
$$\Longrightarrow\quad N^{\alpha+\beta}=\frac{\alpha A\,C^\beta}{\beta B\,6^\beta}\quad\Longrightarrow\quad \boxed{N_{\mathrm{opt}}\propto C^{\frac{\beta}{\alpha+\beta}},\qquad D_{\mathrm{opt}}\propto C^{\frac{\alpha}{\alpha+\beta}}.}$$

**Chinchilla 的拟合值**：$\alpha\approx0.34$，$\beta\approx0.28$。于是
$$\frac{\beta}{\alpha+\beta}\approx0.46,\qquad\frac{\alpha}{\alpha+\beta}\approx0.54.$$

**$\alpha\approx\beta$ 意味着两个指数都接近 $0.5$，即 $N$ 与 $D$ 应当等比例增长。**

**Chinchilla 法则**：$D\approx 20N$。（70B 参数配 1.4T token。）

### 2.1 与 Kaplan 的冲突

Kaplan 的结论是 $N_{\mathrm{opt}}\propto C^{0.73}$，即**应当把预算主要花在模型大小上**，$D$ 只需缓慢增长。GPT-3（175B 参数，300B token，$D/N\approx1.7$）就是按这个建的。

**Chinchilla 说这是错的**：同样的计算量下，70B/1.4T 的模型（Chinchilla）全面优于 280B/300B（Gopher）。**GPT-3 严重欠训练。**

**分歧的原因**（Besiroglu et al. 2024 的复现分析）：
- Kaplan 对所有实验用了**固定的余弦学习率调度长度**，导致小 $D$ 的运行没有完成衰减，损失被高估。
- Kaplan 没有计入 embedding 参数，两边定义不同。

> [!warning] 教训
> 这是**实验方法论的错误直接导致数亿美元的资源错配**的案例。它也说明这类"定律"的脆弱性：拟合三个参数的幂律对实验设计极其敏感。看到任何 scaling law 论文，第一件事是检查学习率调度是否随 $D$ 正确调整。

### 2.2 推理成本改变最优点

Chinchilla 最优是**训练计算最优**。但模型训完要部署，推理成本 $\propto N$（每 token）。若预期推理 token 数 $D_{\mathrm{inf}}$ 很大，总成本
$$C_{\text{total}}=6ND_{\text{train}}+2ND_{\mathrm{inf}}$$
的最优解偏向**更小的模型、更多的训练数据**。

**这就是为什么 LLaMA 系列远超 Chinchilla 比例训练**：LLaMA-3 8B 用了 15T token，$D/N\approx1875$，是 Chinchilla 比例的 90 倍。Sardana et al. (2024) 给出了含推理的修正最优解。**"过度训练小模型"在部署经济学下是理性的。**

## 3. 数据受限的 scaling

**问题.** 高质量文本总量有限。Villalobos et al. (2024) 估计公开高质量文本约 $10^{14}$ token 量级，按当前增速在 2026–2032 年间耗尽。

**Muennighoff et al. (2023), "Scaling Data-Constrained Language Models".** 在固定数据上重复训练（多 epoch）：

- **前 ~4 个 epoch**：重复数据几乎和新数据一样有效。
- **4–16 epoch**：收益快速衰减。
- **>16 epoch**：几乎无收益（甚至有害）。

修正的 scaling law 引入"有效数据量" $D_{\mathrm{eff}}=D\cdot(1-e^{-k/\tau})$（$k$=epoch 数，$\tau\approx15$）。

**应对策略**：
- **合成数据**（用模型生成训练数据）——有模型坍缩（model collapse）风险，Shumailov et al. 2024 证明递归训练在纯合成数据上导致分布尾部丢失；实践中需混入真实数据。
- **多模态**（图像/视频/音频的 token 量远大于文本）。
- **提高数据质量**（去重、过滤、课程化）——见 [[18 大语言模型#数据]]。
- **把计算转移到推理时**——见 §5。

## 4. 幂律从哪里来

三条候选理论：

**(a) 数据流形维度（Sharma–Kaplan 2022）.** 若数据集中在内蕴维 $d$ 的流形上，目标函数 Lipschitz，用分片线性函数逼近，则参数数 $N$ 对应分辨率 $\varepsilon\sim N^{-1/d}$，损失 $\sim\varepsilon^{s}\sim N^{-s/d}$。于是
$$\alpha_N\approx \frac{s}{d}\quad(\text{对分片线性 }s\approx4).$$
观测 $\alpha_N\approx0.076$ $\Rightarrow$ $d\approx 50$。这个数在文本、图像、视频间惊人地一致。

**(b) 随机特征模型（Maloney–Roberts–Sully 2022; Bahri et al. 2024）.** 在可解的随机特征模型中，若数据协方差的特征值满足 $\lambda_i\sim i^{-1-\alpha}$，则损失的 scaling 指数直接由 $\alpha$ 决定。这**把 scaling law 归约到"为什么真实数据的协方差谱是幂律"**——一个更基本但同样未解的问题。这与 [[08 泛化之谜#3-良性过拟合benign-overfitting|良性过拟合]]的谱条件是同一个谱。

**(c) 技能/组合视角（Michaud et al. 2023, "quantization model"）.** 假设能力由离散的"量子"（quanta）组成，每个量子的使用频率服从 Zipf 律 $p_k\sim k^{-(1+\alpha)}$。模型按频率顺序学会量子，学会前 $K$ 个的损失 $\sim\sum_{k>K}p_k\sim K^{-\alpha}$。这**同时解释了平滑的幂律与个别能力的"涌现"**：整体损失平滑下降，但每个量子的习得是突变的。

> 三条解释都把幂律归结到**数据的某种幂律结构**（流形维度、协方差谱、Zipf 频率）。Zipf 律在自然语言中是老观察（Zipf 1935），所以 (c) 也许最接近真相。但没有一条是定理。

## 5. 推理时 scaling

**新轴（2024 之后）.** 除了训练时的 $N$、$D$，还可以在**推理时**花计算：

- **Chain-of-thought**：让模型生成中间推理步骤。
- **Best-of-$n$ / 自洽性**：采样 $n$ 条推理路径，取多数或用 verifier 选。
- **树搜索**：MCTS、beam search over reasoning steps。
- **长思考（extended thinking）**：训练模型自发生成长推理链，见 [[22 RLHF 与推理 RL]]。

**经验规律**（Snell et al. 2024; OpenAI o1 报告）：准确率关于**推理计算量**同样呈幂律，且在某些任务上**推理时计算比训练时计算更有效率**——即用小模型 + 大推理预算可以超过大模型 + 贪心解码。

**理论上的简单模型.** Best-of-$n$ 配一个准确率 $p$ 的 verifier：成功率 $1-(1-p)^n$，即 $\log(\text{失败率})\propto -n$——**指数改善**。但实际是幂律，因为 verifier 不完美且样本不独立（模型的错误是相关的）。这个 gap 的定量刻画是开放问题。

**Chinchilla 的推理时类比**：给定总计算，如何在"训练更大模型"与"推理时思考更久"之间分配？这是当前最重要的实践问题，还没有 Chinchilla 那样干净的答案。

## 6. 涌现能力：真的还是测量假象？

**Wei et al. (2022)** 报告某些能力（多位数算术、词义消歧）在模型规模跨过阈值后**突然**出现，此前接近随机。

**Schaeffer, Miranda, Koyejo (NeurIPS 2023 best paper), "Are Emergent Abilities of Large Language Models a Mirage?"** 反驳：涌现是**度量选择**的产物。

- 若用**非线性/不连续**度量（如"完全正确"的精确匹配、多选题准确率），平滑改善的底层能力会显示为突变。
- 若用**连续**度量（如 token 级编辑距离、对数似然），同样的模型显示平滑改善。
- 他们通过改变度量，**在视觉模型上人为制造出了"涌现"**，也在语言模型上**消除了**已报告的涌现。

> [!note] 我的读法
> 两边都对一部分。数学上：若真实能力 $a(N)$ 平滑增长，而度量是 $\mathbf{1}[a>\tau]$ 或 $a^k$（$k$ 大），则观测量必然显示突变。这在数学上是平凡的。
>
> 但"平滑的底层能力"这个假设本身需要检验，且**从实践角度，不连续的度量恰恰是我们关心的**（一个证明要么对要么错）。所以"涌现是假象"这个说法在预测上有用（能力可外推），在决策上误导（能力阈值确实是真实的分界）。
>
> Michaud et al. 的 quanta 模型给了一个调和：底层是离散的技能习得（真涌现），整体损失是它们的加权和（平滑）。

## 7. 对纯数学家的意义

1. **scaling law 是本领域唯一可证伪的定量预测**。判断任何 AI 论断时，先问"这符合 scaling law 吗"。
2. **它把资源分配变成了优化问题**，且这个优化问题极简单（两变量约束优化）。产业界数十亿美元的决策就建立在 §2 的四行代数上。
3. **它的理论解释是开放问题，且工具是数学的**：随机矩阵、逼近论、幂律统计。§4 的三条路线都需要更好的数学。
4. **它有明确的失效边界**：外推、数据耗尽、推理时 scaling 的新维度都没有理论。

## 参考

- Kaplan et al., *Scaling laws for neural language models*, arXiv 2020.
- Hoffmann et al., *Training compute-optimal large language models* (Chinchilla), NeurIPS 2022.
- Besiroglu et al., *Chinchilla scaling: A replication attempt*, 2024.
- Muennighoff et al., *Scaling data-constrained language models*, NeurIPS 2023.
- Sardana et al., *Beyond Chinchilla-optimal: Accounting for inference in language model scaling laws*, ICML 2024.
- Sharma & Kaplan, *Scaling laws from the data manifold dimension*, JMLR 2022.
- Bahri, Dyer, Kaplan, Lee, Sharma, *Explaining neural scaling laws*, PNAS 2024.
- Michaud, Liu, Girit, Tegmark, *The quantization model of neural scaling*, NeurIPS 2023.
- Schaeffer, Miranda, Koyejo, *Are emergent abilities of large language models a mirage?*, NeurIPS 2023.

## Related

- [[index|深度学习（为纯数学研究者重写）]]
- [[08 泛化之谜]]
- [[18 大语言模型]]
- [[13 系统与工程]]
- [[22 RLHF 与推理 RL]]
