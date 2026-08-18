---
title: 科学基础模型的数学
description: 在 JHU Math 110.773（Fei Lu, 2026 Fall）大纲上补前置、补深度：交互粒子系统、attention、生成建模、in-context learning、算子学习。
tags:
  - scientific-foundation-models
  - machine-learning
  - MOC
stage: 🌱 seedling
date: 2026-08-18
---

# 科学基础模型的数学

这套笔记的骨架来自 Johns Hopkins 的 [Math 110.773: Topics in Data Science — *Mathematics of Scientific Foundation Models*](https://math.jhu.edu/~feilu/26Fall_topicsDS/topicDS26.html)（[Fei Lu](https://math.jhu.edu/~feilu/), Fall 2026, TuTh 9:00–10:15, Krieger 411）。课程自己的定位是：

> *"This course aims to investigate the mathematics of scientific foundation models, with a focus on learning theory in controlled settings. … The emphasis is on mathematically transparent models rather than a broad survey of scientific machine learning."*

**"mathematically transparent" 是关键词。**这门课不讲怎么把 Transformer 训得更好，它挑那些能把整个学习问题写成一个有解析结构的对象的设定：交互粒子系统的漂移项、线性回归的 in-context 版本、算子里的卷积核。在这些设定里，"模型学到了什么"是可以被定理回答的。

> [!note] 这套笔记与 [[notes/deep-learning/index|深度学习（为纯数学研究者重写）]] 的关系
> 那一套是**横向**的：把整个深度学习按数学主题铺开一遍。这一套是**纵向**的：只挑一条线——*科学计算里的函数/算子估计问题 + Transformer 架构*——往下挖到定理层。
>
> 两套之间大量互引。凡是那边讲过的（attention 的定义、diffusion 的 SDE、NTK、mean-field 梯度流、统计不等式），这边直接引用不重讲。

## 一、前置盘点

课程列的 prerequisites 与我实际的背景对照：

| 课程要求 | 状态 | 从哪补 |
|---|---|---|
| Graduate probability | ✅ 有 | — |
| Measure theory | ✅ 有 | — |
| Functional analysis | ✅ 有 | 这是**优势项**，第五、六部分基本就是算子理论 |
| Introductory PDE | ✅ 有 | — |
| Introductory **SDE** | ❌ 缺 | **[[P1 随机微分方程与 Fokker–Planck]]** |
| **Nonparametric regression** | ❌ 缺 | **[[P2 非参数回归与最小最大率]]** |
| Basic optimization | ⚠️ 半有 | [[notes/deep-learning/05 优化的数学\|DL 05 优化的数学]] 够用 |
| Stochastic processes | ⚠️ 半有 | P1 里补 Markov 半群与遍历性那一块 |
| Scientific computing | ⚠️ 半有 | 需要时在正文里插；主要是求积、离散化误差、条件数 |
| Prior ML theory | ✅ 有 | [[notes/deep-learning/01 学习问题的数学表述\|DL 01]]、[[notes/deep-learning/12 Transformer\|DL 12]]、[[notes/deep-learning/17 扩散模型与 flow matching\|DL 17]] |

除此之外我自己加了一篇**不在 prerequisites 里但整门课都在用**的东西：

- **[[P3 RKHS 与不适定逆问题的正则化]]** — 因为这门课的所有"学习"问题，去掉包装之后都是**第一类算子方程 $\mathcal{A}\phi=f$ 在噪声下的求解**。讲师自己的 DARTR / FSOI / 最小最大率那条线全在这个框架里。对有泛函分析背景的人，这一篇是整套笔记里性价比最高的：你已经会紧算子谱理论了，剩下的只是把统计噪声装进去。

> [!tip] 三篇前置的读法
> P1 → P2 → P3 是线性的，但**P3 才是这门课真正的数学内核**。如果时间紧，P1 只读 §3（生成元与 Kolmogorov 方程）、§5（Langevin 与不变测度）、§7（Girsanov 与轨迹似然），P2 只读 §2（率的来源）与 §4（Fano 下界），然后直接进 P3。

## 二、这套笔记在原大纲上加了什么

原大纲有 4 个 `TBD` 格子和 2 个半 `TBD`。这里的处理是：**按数学主题重组，把 TBD 按讲师本人的研究线索填上**——因为这门课没有教材，讲的就是 instructor notes + 他自己那一系列论文。补充的三条线：

1. **补前置**（Part P，上面已说）。
2. **补讲师的研究主线。**"Learning interaction laws from data" 一格背后是从 [Lu–Zhong–Tang–Maggioni (PNAS 2019)](https://www.pnas.org/doi/10.1073/pnas.1822012116) 到 [Wang–Seroussi–Lu (2023) 最小最大率](https://arxiv.org/abs/2311.16852) 的十年工作，包含可辨识性、coercivity 条件、正则化、网络上的推断。一格课讲不完，这里拆成三篇。
3. **补通用 ML 理论的对接。**ICL 那几周原大纲只写了 `TBD In-context learning`，但这块 2022 年以来的理论文献已经很厚（线性 attention 实现 GD、贝叶斯视角、训练动力学），且讲师 2025 年有 [Lu–Yu, *Transformer learns the cross-task prior and regularization for in-context learning*](https://arxiv.org/abs/2505.12138) 把 ICL 直接接到了逆问题的正则化上——这恰好是把这门课两半缝起来的那一针。

## 三、模块

> 🚧 = 尚未写。索引先把结构定死，内容逐篇填。

### Part P — 前置补课（原课假设你已有）

- [[P1 随机微分方程与 Fokker–Planck]] — Itô 积分、生成元、Kolmogorov 前后方程、Langevin 与不变测度、时间反演、Girsanov 与轨迹似然、Euler–Maruyama
- [[P2 非参数回归与最小最大率]] — 核估计与投影估计、偏差–方差如何产生 $n^{-2\beta/(2\beta+1)}$、Le Cam 与 Fano 下界、维数诅咒与结构假设、自适应、核岭回归
- [[P3 RKHS 与不适定逆问题的正则化]] — 紧算子 SVD 与 Picard 判据、Tikhonov 与谱滤波、源条件与饱和、RKHS 与表示定理、正规算子与可辨识函数空间（FSOI）、DARTR、贝叶斯对应

### Part 1 — 学习问题的框架（9/1, 9/3）

- 🚧 `01 科学基础模型：统计实验、损失与 oracle 基准` — 什么叫"基础模型"在科学计算语境下；把任务族写成统计实验 $\{P_\theta\}$；损失的选择如何决定可辨识性；oracle benchmark 作为"最好能做到多好"的定义

### Part 2 — attention 作为非局部算子与粒子系统（9/8–9/17）

- 🚧 `02 attention 作为非局部映射与平均场极限` — softmax attention 写成对经验测度的非局部算子；token 数 $\to\infty$ 的 Vlasov 型平均场方程；与 [[notes/deep-learning/07 无限宽极限 NTK 与 mean-field|DL 07]] 的 mean-field 是**不同方向的极限**（那边是宽度，这边是序列长度）
- 🚧 `03 自注意力作为交互粒子系统：聚类定理` — [Geshkovski–Letrouit–Polyanskiy–Rigollet](https://arxiv.org/abs/2312.10794) 的连续时间 Transformer 流；$t\to\infty$ 时 token 聚成有限簇的定理；与 Kuramoto 同步、Cucker–Smale flocking 的对应

### Part 3 — 从数据学交互律（9/22–10/1，含一格 TBD）

- 🚧 `04 从轨迹学交互核：变分表述与可辨识性` — 一阶/二阶系统的 $\dot{x}_i=\frac1N\sum_j\phi(|x_{ij}|)x_{ij}$；把学 $\phi$ 写成加权 $L^2(\rho_T)$ 上的最小二乘；**coercivity 条件**是这里的"设计矩阵非退化"
- 🚧 `05 学习交互核的最小最大率` — tLSE 达到 $M^{-2\beta/(2\beta+1)}$（[Wang–Seroussi–Lu](https://arxiv.org/abs/2311.16852)）；为什么高维粒子系统里能拿到**一维**的率（径向核是结构假设，见 P2 §5）
- 🚧 `06 平均场方程、网络与异质系统` — 从有限 $N$ 到 McKean–Vlasov；[Lang–Lu 的平均场可辨识性](https://math.jhu.edu/~feilu/pub/LangLu_id_mfe.pdf)；网络与核的联合推断

### Part 4 — 生成建模（10/6–10/15，一格半 TBD）

- 🚧 `07 score matching 作为统计回归` — Hyvärinen 恒等式的严格版本与积分条件；denoising score matching 就是**以 $\nabla\log p_t$ 为回归函数的非参数回归**；这一格是把 P2 直接用上去
- 🚧 `08 从 score 到样本：采样误差与最优率` — score 误差如何传播到分布误差（KL / TV / $W_2$）；[Oko–Akiyama–Suzuki](https://arxiv.org/abs/2303.01861) 的最小最大最优性；[Wibisono–Wu–Yang 的 empirical Bayes 平滑](https://proceedings.mlr.press/v247/wibisono24a/wibisono24a.pdf)；与 [[notes/deep-learning/17 扩散模型与 flow matching|DL 17]] 的分工：那边讲构造，这边讲率

### Part 5 — in-context learning（10/20–11/12）

- 🚧 `09 ICL 的数学表述：任务分布与贝叶斯预测器` — 把 prompt 建模成来自任务先验 $\pi$ 的一个统计实验；ICL 的 oracle 就是**贝叶斯预测器**；这解释了"为什么预训练分布决定了 ICL 能做什么"
- 🚧 `10 线性 attention 实现梯度下降` — 单层线性 attention 的前向恰好是一步预条件 GD；多层是多步；训练动力学的全局收敛（[Zhang–Frei–Bartlett](https://arxiv.org/abs/2306.09927)）
- 🚧 `11 ICL 用于逆线性回归：学到的是先验与正则化` — [Lu–Yu (2025)](https://arxiv.org/abs/2505.12138)：训练好的 transformer 在病态设计下给出的不是 OLS 而是带正则的解，正则项由**跨任务先验**决定。**这是 Part 5 与 Part 6 的接缝**
- 🚧 `12 transformer 作为 in-context solver：表达力与极限` — 能实现哪些算法（GD、Newton、岭回归、最小二乘）；深度—步数的对应；不能实现什么

### Part 6 — 算子中的核与算子学习（11/19–12/10）

- 🚧 `13 学习算子中的核：正规算子、FSOI 与 DARTR` — 非局部算子 $\mathcal{L}_\phi u=\int \phi(|y|)\,g(u,y)\,dy$ 里学 $\phi$；这是 P3 的完整应用；最小最大率（[Zhang–Wang–Lu 2025](https://math.jhu.edu/~feilu/publications.html)）与小噪声分析（Lang–Lu 2023）
- 🚧 `14 算子学习：DeepONet、FNO 与逼近理论` — 无限维之间的映射如何被参数化；万有逼近定理与它的**代价**（维数诅咒在算子层面的形式）；离散不变性
- 🚧 `15 in-context operator learning` — [Yang–Osher 的 ICON (PNAS 2023)](https://www.pnas.org/doi/10.1073/pnas.2310142120)：把"求解一个新 PDE"当成一次 in-context 任务；与 Part 5 的框架合流

## 四、周次对照

| 周 | 原大纲 | 本笔记 |
|---|---|---|
| 9/1, 3 | Scientific foundation models; statistical experiments, losses, oracle benchmarks | 01 |
| 9/8, 10 | Attention as a nonlocal map; mean-field IPS | 02 |
| 9/15, 17 | Self-attention as an interacting particle system | 03 |
| 9/22, 24 | Learning interaction laws from data | 04 |
| 9/29, 10/1 | *TBD* | 05, 06 |
| 10/6, 8 | Score matching as statistical regression | 07 |
| 10/13, 15 | *TBD* | 08 |
| 10/20, 22 | In-context learning (ICL) | 09 |
| 10/27, 29 | *TBD* | 10 |
| 11/3, 5 | ICL for inverse linear regression | 11 |
| 11/10, 12 | Transformers as in-context solvers | 12 |
| 11/19 | Learning kernels in operators（11/17 停课） | 13 |
| 12/1, 3 | In-context operator learning | 14, 15 |
| 12/8, 10 | Online | — |

## 五、阅读路径

- **只想跟上课**：P1 §3,5,7 → P2 §2,4 → 01 → 02 → 03 → 04 …（按周走）
- **冲讲师的研究方向**（想做题目）：P2 → P3 → 04 → 05 → 13 → 11。这条线是自洽的，**不碰 Transformer 也能读完**
- **从深度学习那边接过来**：[[notes/deep-learning/12 Transformer|DL 12]] → 02 → 03，以及 [[notes/deep-learning/17 扩散模型与 flow matching|DL 17]] → 07 → 08
- **纯泛函分析视角**：P3 → 13 → 14 → 11。整条线就是"带噪声的第一类方程"，Transformer 只是最后出现的一个求解器

## 六、参考文献分层

课程明确说了 **no textbook**，只有 instructor notes 与论文。所以参考不是"教材 + 补充"，而是按用途分层：

| 来源 | 用途 |
|---|---|
| Øksendal, *Stochastic Differential Equations* | P1 的标准入口，第 3–8 章 |
| Pavliotis, *Stochastic Processes and Applications* | P1 的 Fokker–Planck / 遍历性部分更好，且面向应用 |
| Tsybakov, *Introduction to Nonparametric Estimation* | P2 的唯一必需品，§1–2 是核估计，§2.6 是 Fano |
| Györfi–Kohler–Krzyżak–Walk, *A Distribution-Free Theory of Nonparametric Regression* | P2 的非渐近版本，最小二乘型估计写得最全 |
| Engl–Hanke–Neubauer, *Regularization of Inverse Problems* | P3 的确定性部分（源条件、饱和、参数选择） |
| Cucker–Smale, *On the mathematical foundations of learning* (BAMS 2002) | P3 把 RKHS 与学习理论接起来的经典综述，📐 对数学家最友好 |
| Steinwart–Christmann, *Support Vector Machines* | RKHS 与插值空间 $[\mathcal{H}]^s$ 的严格来源 |
| [Geshkovski et al., *A mathematical perspective on Transformers*](https://arxiv.org/abs/2312.10794) (BAMS 2025) | Part 2 的主线；**这是一篇给数学家写的 Transformer 综述**，可以当讲义读 |
| [Lu–Maggioni–Tang, FoCM 2021](https://math.jhu.edu/~feilu/pub/LMT21foc_corrected.pdf) / [JMLR 2021](https://www.jmlr.org/papers/volume22/19-861/19-861.pdf) | Part 3 的主线论文 |
| [Fei Lu 的 publication 页](https://math.jhu.edu/~feilu/publications.html) | Part 3/5/6 的原始来源，按主题分好组了 |
| [MIT 6.S184 Flow Matching and Diffusion](https://diffusion.csail.mit.edu/) | Part 4 的构造性背景（率的部分它不讲） |
| [[notes/deep-learning/A 概率与统计不等式手册\|DL 附录 A]] | 集中度不等式全在那儿，这套笔记直接引用 |

---

*状态：🌱 结构已定，内容逐篇填。前置三篇先写，正课按周补。发现错误直接改，不要另开一篇。*

## Related

- [[notes/deep-learning/index|深度学习（为纯数学研究者重写）]]
- [[P1 随机微分方程与 Fokker–Planck]]
- [[P2 非参数回归与最小最大率]]
- [[P3 RKHS 与不适定逆问题的正则化]]
