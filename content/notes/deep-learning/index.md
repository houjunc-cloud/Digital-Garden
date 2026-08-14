---
title: 深度学习（为纯数学研究者重写）
description: 在 Tony Feng 的 Math 270 框架上按数学主题重组，把广度课补成有深度的讲义。
tags:
  - deep-learning
  - machine-learning
  - MOC
stage: 🌿 budding
date: 2026-08-14
---

# 深度学习（为纯数学研究者重写）

这套笔记的出发点是 Berkeley 的 [Math 270: A Survey of Deep Learning for Mathematicians](https://math.berkeley.edu/~fengt/2025F_270.html)（Tony Feng, Fall 2025）。那门课的定位极准：**面向数学成熟度高、但没有统计/优化/CS 背景的纯数学家**。它的问题也很明确——按 Feng 自己在讲义摘要里的话，*"The emphasis is on breadth rather than on depth, with each lecture giving a superficial exposure to one major topic."* 一周一个 CS 系整学期的题目，必然只能给一层皮。

这里做三件事：

1. **数学基础严格化。** 该有定理陈述的地方给定理陈述，该有证明的地方给证明或可检查的证明梗概。统计推断不止于"MLE 是什么"，而到渐近正态性的正则条件、Fisher 信息作为 Riemann 度量；优化不止于"Adam 的更新公式"，而到收敛率证明和 Adam 不收敛的反例。
2. **补现代理论前沿。** 无限宽极限（NTK / mean-field）、良性过拟合与 double descent、scaling law 的理论来源、Transformer 的表达力（$\mathsf{TC}^0$、induction head）、diffusion 的 SDE 时间反演与 flow matching 的统一框架。这些是 2018 年之后才成形的东西，恰好是数学家能读懂也能贡献的部分。
3. **补工程与实现细节。** 因为"理论上等价"的两件事在 $10^{25}$ FLOP 尺度上完全不等价。FlashAttention 为什么是 IO 复杂度问题、$\mu\mathrm{P}$ 为什么让超参可迁移、KV cache 与算术强度、并行策略的通信量、MoE 的路由。不懂这一层就读不懂现代论文的实验部分。

## 与原课的关系

按**数学主题**重组，不按周次。Feng 的 14 周映射到下面的模块，但顺序和边界都改了：他的"Week 4 优化"被拆成优化理论与训练动力学两块，"Week 9 GAN+VAE"拆开并各自补到能讲清楚为什么 GAN 难训，"Week 12–13 RL"前面加了一节严格的 MDP 与压缩映射。新增的是 Part 0（学习理论）、Part 3（理论前沿）、13（系统与工程）、23（AI for Math）——原课完全没有或只有一句话带过。

## 阅读路径

**假设的前置知识**：实分析与测度论、抽象线性代数、本科概率论。不假设任何统计、优化、机器学习、CS 背景。（这正是 Feng 的假设，我保持不变。）Python 会在实现环节需要，但笔记本身不依赖。

三条路径：

- **理论优先**（想搞清楚深度学习到底是什么数学对象）：01 → 02 → 05 → 07 → 08 → 09
- **架构优先**（想读懂现代论文）：01 → 03 → 04 → 06 → 12 → 13 → 18
- **生成模型优先**（想理解 diffusion / flow）：03 → 04 → 14 → 15 → 17

## 模块

### Part 0 — 学习问题本身

- [[01 学习问题的数学表述]] — 风险、经验风险、一致收敛、Rademacher 复杂度、no free lunch，以及深度学习为什么违背这套理论
- [[02 神经网络作为函数类]] — 万有逼近的定量版本、Barron 空间、深度分离定理、ReLU 网络的分片线性几何

### Part 1 — 概率与信息（Feng Week 2–3）

- [[03 信息论]] — 熵的公理化、$f$-散度、Donsker–Varadhan 变分表示、Pinsker、AEP、算术编码与"压缩即智能"
- [[04 统计推断]] — 指数族、Cramér–Rao、MLE 渐近理论的正则条件、信息几何、变分推断、PAC-Bayes

### Part 2 — 优化与训练（Feng Week 4）

- [[05 优化的数学]] — GD/SGD 收敛率证明、Nesterov 的 ODE 解释、PL 条件、Adam 的收敛反例、SGD 作为 SDE、隐式正则化、edge of stability
- [[06 初始化归一化与训练动力学]] — Kaiming 推导、BN/LN/RMSNorm、pre-LN vs post-LN、残差流、$\mu\mathrm{P}$ 与超参迁移

### Part 3 — 理论前沿（原课无）

- [[07 无限宽极限 NTK 与 mean-field]] — 高斯过程极限、NTK 定理、lazy vs rich、Wasserstein 梯度流
- [[08 泛化之谜]] — 随机标签、double descent、良性过拟合、norm-based bound、grokking
- [[09 Scaling laws]] — Kaplan 与 Chinchilla 的完整推导、compute-optimal、数据受限、推理时 scaling

### Part 4 — 架构（Feng Week 5–7）

- [[10 归纳偏置与等变性]] — 群表示论视角下的 CNN、等变网络的一般理论、geometric deep learning
- [[11 序列模型与状态空间]] — RNN 梯度消失的谱分析、LSTM、HiPPO、S4/Mamba 与并行扫描
- [[12 Transformer]] — attention 作为核平滑与联想记忆、RoPE 的群论、表达力（$\mathsf{TC}^0$、induction head）、优化困难
- [[13 系统与工程]] — BPE、FlashAttention 的 IO 复杂度、混合精度、并行策略、MoE、推理优化

### Part 5 — 生成模型（Feng Week 9–10）

- [[14 生成建模的统一视角]] — 显式/隐式密度、$f$-散度 vs IPM、四种训练范式的关系
- [[15 变分自编码器]] — ELBO 的严格推导、amortized inference、posterior collapse、rate–distortion、VQ-VAE
- [[16 生成对抗网络]] — minimax 的博弈论、JS 散度的病态、Kantorovich 对偶与 WGAN、局部稳定性分析
- [[17 扩散模型与 flow matching]] — 前向 SDE、Anderson 时间反演定理、score matching 恒等式、probability flow ODE、CFG、rectified flow

### Part 6 — 语言模型（Feng Week 8）

- [[18 大语言模型]] — 自回归分解、数据管线、SFT、in-context learning 的理论解释、采样与评测

### Part 7 — 强化学习（Feng Week 12–13）

- [[19 MDP 与动态规划]] — 严格设定、Bellman 算子的压缩映射、值/策略迭代收敛、occupancy measure 的 LP 对偶
- [[20 值函数方法]] — 随机逼近理论、Q-learning 收敛证明、deadly triad 与 Baird 反例、DQN、distributional RL
- [[21 策略梯度方法]] — 策略梯度定理证明、自然梯度与 Fisher 信息、TRPO 的性能差界、PPO、GAE
- [[22 RLHF 与推理 RL]] — Bradley–Terry、DPO 的推导、GRPO/DAPO/GSPO、RLVR、过程监督

### Part 8 — 回到数学（原课无）

- [[23 AI for Mathematics]] — Lean 形式化、AlphaProof/AlphaGeometry、神经网络辅助猜想、数学家的比较优势

## 参考文献的分层

Feng 给的书单是好的起点，但用途不同：

| 来源 | 用途 |
|---|---|
| Bishop & Bishop, *Deep Learning: Foundations and Concepts* (2024) | 最接近这门课覆盖面的教材，当索引用 |
| MacKay, *Information Theory, Inference, and Learning Algorithms* | 信息论部分的最佳来源，Part 1 主要跟它 |
| Casella & Berger, *Statistical Inference* | 统计推断的标准参考，§7 是 Feng 指定的 |
| Sutton & Barto, *Reinforcement Learning* (2nd ed.) | RL 的标准教材，Part 7 主要跟它 |
| Shalev-Shwartz & Ben-David, *Understanding Machine Learning* | 学习理论，Part 0 的来源，**原课没列** |
| Telgarsky, *Deep Learning Theory* lecture notes | 逼近论与泛化理论，Part 0/3 的来源，**原课没列** |
| Stanford CS336 (Language Modeling from Scratch) | 系统与工程层，13 与 18 的来源，**原课没列** |
| MIT 6.S184 (Flow Matching and Diffusion Models) | 17 的来源，比 Bishop §20 严格得多，**原课没列** |
| Berkeley CS285 (Deep RL) | Part 7 的深度补充，**原课没列** |

---

*状态：这是一份长期修订的讲义，不是一次写完的东西。每个模块独立标注成熟度。发现错误请直接改，不要另开一篇。*
