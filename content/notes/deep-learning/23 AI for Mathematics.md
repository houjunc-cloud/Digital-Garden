---
title: 23 AI for Mathematics
description: Lean 形式化、AlphaProof/AlphaGeometry、神经网络辅助猜想、数学家的比较优势。
tags:
  - deep-learning
  - ai4math
  - formalization
stage: 🌱 seedling
date: 2026-08-14
---

# 23 AI for Mathematics

> **原课没有这一块**，尽管它是这门课的目标听众最应该关心的部分。Feng 在 Week 13 的案例里提了 AlphaGeometry，但没有展开。这一篇讲：**形式化数学与 Lean 的现状、AlphaProof/AlphaGeometry 的技术内容、神经网络辅助猜想生成的几个真实案例、以及一个诚实的评估——什么已经能做，什么还不能，纯数学家的比较优势在哪。**
>
> 前置：[[22 RLHF 与推理 RL]]（RLVR 与形式化验证的关系）、[[20 值函数方法#6-alphagoalphazerofeng-的案例|AlphaZero 范式]]。
>
> 这一篇标为 🌱 seedling —— 这个领域每几个月就变一次，下面的具体成绩会过时，但**结构性的判断**应该更稳定。

> [!question] 卡住了从哪儿看起
> - [Mathematics in Lean](https://leanprover-community.github.io/mathematics_in_lean/) — Lean 4 的标准教程，几周可入门
> - [Lean 社区主页](https://leanprover-community.github.io/) 与 [mathlib 概览](https://leanprover-community.github.io/mathlib-overview.html) — 看看你的领域被形式化到什么程度了
> - [Terence Tao 的博客](https://terrytao.wordpress.com/) — 一线数学家做形式化与 AI 辅助的实时记录，**最值得跟的一个源**
> - [Kevin Buzzard, Xena Project](https://xenaproject.wordpress.com/) — 形式化数学的布道与实践

## 1. 为什么形式化是关键接口

回顾 [[22 RLHF 与推理 RL#53-rlvr可验证奖励|RLVR]] 的核心前提：**需要一个便宜、准确的验证器。**

对数学，**证明助手就是那个验证器**：

$$\text{Lean 类型检查器接受一个证明项}\quad\Longleftrightarrow\quad\text{证明正确}$$

由 **[Curry–Howard 对应](https://en.wikipedia.org/wiki/Curry%E2%80%93Howard_correspondence)**，"证明"就是"程序"，"定理"就是"类型"，"验证证明"就是"类型检查"。这是**完全可靠、完全自动、完全便宜**的奖励信号——比任何人类评价或答案匹配都强。

> [!tip] 这是数学在 AI 中的独特地位
> 数学是**唯一一个拥有完美自动验证器的知识领域**。物理需要实验，生物需要实验，法律与伦理没有基准真理。数学有 Lean。
>
> 于是数学成为 AI 推理能力的**天然试验场与训练场**：可以生成无限多的训练信号，无需人类标注，无奖励黑客。这不是巧合——AI 在数学上的快速进步与这个结构性优势直接相关。

**主要系统**：[Lean 4](https://lean-lang.org/)（+ [mathlib](https://leanprover-community.github.io/mathlib-overview.html)，当前最活跃）、Isabelle/HOL、Coq/Rocq、Metamath。

**mathlib** 是关键基础设施：一个统一的、社区维护的形式化数学库，覆盖到本科加相当一部分研究生课程（交换代数、代数几何的基础、测度论、泛函分析、范畴论、部分数论）。**它既是 AI 的训练数据，也是 AI 输出的评价标准。**

## 2. 两条技术路线

### 2.1 形式化路线：AlphaProof

**架构**：预训练 LLM + AlphaZero 式的强化学习，在 Lean 中搜索证明。

**关键组件：**

1. **自动形式化（autoformalization）**：用 LLM 把自然语言问题翻译成 Lean 命题。DeepMind 报告形式化了约 **100 万**个竞赛题为形式命题（约一亿条形式陈述）。质量参差，但数量弥补。
2. **证明搜索**：把证明视为 MDP——状态是当前的证明目标（goal），动作是策略（tactic）调用，转移由 Lean 内核给出，奖励是"证明完成"。**用 AlphaZero 的 MCTS + 价值/策略网络**（见 [[20 值函数方法#6-alphagoalphazerofeng-的案例]]）。
3. **测试时 RL（test-time RL）**：**这是最有意思的部分**。遇到难题时，生成该问题的大量**变体**（改变常数、弱化结论、特殊化），在变体上做 RL 训练，用学到的东西攻击原题。**这是"课程学习"的自动化版本。**

**成绩**（[Nature 论文](https://www.nature.com/articles/s41586-025-09833-y)）：2024 年 IMO 达到银牌水平（6 题中解出 4 题，28/42 分，恰好差 1 分到金牌）。工作发表在 *Nature* (2025)。

**代价**：某些题目用了远超比赛时限的计算（数天）。**这是"能力"与"效率"分离的典型案例**——见 [[09 Scaling laws#5-推理时-scaling|推理时 scaling]]。

### 2.2 非形式化路线：直接用 LLM

2025 年，Google DeepMind 与 OpenAI 分别报告其通用推理模型在 IMO 上达到**金牌**水平（DeepMind 的 Gemini Deep Think 解出 6 题中的 5 题，35/42 分），**用自然语言**，在正式比赛时限内，无需形式化。

> [!warning] 两条路线的取舍
> | | 形式化 | 非形式化 |
> |---|---|---|
> | 正确性 | **保证**（Lean 检查） | 需人工审核 |
> | 训练信号 | 完美（RLVR） | 需要评分模型或答案匹配 |
> | 覆盖面 | 受限于 mathlib 已形式化的部分 | 全部数学文献 |
> | 数学家可读性 | 差（Lean 证明冗长、非人类风格） | **好** |
> | 到研究数学的距离 | 形式化本身是瓶颈 | 幻觉是瓶颈 |
>
> **两条路线在收敛**：非形式化模型生成候选证明，形式化系统验证。这个混合方案（"informal-to-formal pipeline"）是当前主流方向。

### 2.3 [AlphaGeometry](https://www.nature.com/articles/s41586-023-06747-5)：神经–符号

欧氏几何有一个特殊性质：**存在完备的符号推理引擎**（演绎数据库 + 代数方法）。但纯符号方法卡在需要**辅助构造**（加辅助线、辅助点）的题上——这是搜索空间爆炸的地方。

**AlphaGeometry 的分工：**
- **符号引擎**：做演绎闭包（从已知条件推出所有能推的结论）；
- **神经网络**：只负责**提议辅助构造**（"在 BC 上取中点 M"）。

**训练数据完全合成**：随机生成几何构型 → 用符号引擎推出所有结论 → 反向追溯得到 (问题, 证明) 对 → 识别其中需要辅助构造的，作为神经网络的训练样本。**1 亿条合成样本，零人类数据。**

**成绩**：AlphaGeometry (2024) 在 30 道 IMO 几何题上解出 25 道（人类金牌平均 25.9）；AlphaGeometry2 (2025) 提升到 84%。

> [!tip] 这个架构是可推广的模板
> **神经网络负责"提出候选"（直觉、创造性的一步），符号系统负责"验证与推演"（严格性）。**这个分工正好对应了数学家自己的工作方式，也正好利用了两者的比较优势：神经网络有好的先验但不可靠，符号系统可靠但没有先验。
>
> 问题是：**除了欧氏几何，哪些数学领域有足够强的符号引擎？**答案不多（线性算术、实闭域的量词消去、某些组合恒等式）。这是这条路线的天花板。

## 3. 神经网络作为猜想机器

**这条线索与定理证明正交，且对研究数学可能更重要。**

### 3.1 已有的成功案例

**扭结理论（[Davies et al., Nature 2021](https://www.nature.com/articles/s41586-021-04086-x)）.** 用监督学习预测扭结的**签名**（signature，代数不变量）从其**几何不变量**（体积、子午/纵向平移）。网络表现很好 ⟹ 存在未知的关系。用**显著性分析**（saliency）找出哪些输入最重要，缩小到三个量，人类数学家据此发现并证明了一个新的定理（关于 signature 与 "natural slope" 的不等式）。

**表示论：组合不变性猜想.** 同一篇 Nature 论文用 GNN 预测 Kazhdan–Lusztig 多项式（从 Bruhat 区间的图结构），发现了一个结构（"hypercube 分解"），导致对对称群情形的一个新猜想与部分证明。

**[FunSearch（Romera-Paredes et al., Nature 2024）](https://www.nature.com/articles/s41586-023-06924-6).** 用 LLM 生成**程序**（而非直接生成答案），用评价函数打分，做进化搜索。在**cap set 问题**上找到了比已知更好的构造（$n=8$ 时的新下界），在**装箱问题**上找到了更好的启发式。

> **关键设计**：让 LLM 生成**程序**而不是对象。程序是紧凑的、可解释的、可组合的，且可以自动评估。**这利用了 LLM 的代码能力，同时保证了可验证性。**这是一个非常聪明的框架转换。

**[PatternBoost](https://arxiv.org/abs/2411.00566) / 组合构造.** 用 Transformer 在已知的好构造上训练，生成新候选，用局部搜索改进，迭代。在多个极值组合问题上改进了已知界。

**符号回归.** 从数据拟合出**闭式公式**（[AI Feynman](https://arxiv.org/abs/1905.11481)、[PySR](https://github.com/MilesCranmer/PySR)）。已在物理定律重发现、以及若干数学猜想（如某些序列的显式公式）上有用。

### 3.2 Erdős 问题与研究级数学

2025–2026 年出现了 AI 系统（Aristotle、AxiomProver 等）为若干**开放的 Erdős 问题**给出 Lean 形式化解答的报道。这些通常是难度较低的、被遗忘的、或对现代技术而言不难但无人去做的问题。

> [!warning] 对这类新闻的正确读法
> **"AI 解决了 Erdős 问题"这类标题需要仔细看细节。**要问的问题：
> 1. 这个问题真的是开放的吗？（很多 Erdős 问题在文献某处已被解决但未被记录）
> 2. AI 做了多少，人类提示了多少？
> 3. 用了多少计算？
> 4. 证明是否可被数学家理解，还是只是通过了类型检查？
>
> 目前的诚实评估：**AI 已经能独立完成"熟练研究生水平、技术性的、方向明确的"证明**；**还不能提出重要的新概念或看出深刻的结构联系**。前者已经非常有用（可以自动化大量文献中的例行验证），后者是数学的核心。

## 4. 等变网络与科学计算

见 [[10 归纳偏置与等变性#42-steerable-cnn-与不可约分解]]。$E(3)$-等变网络（用 Clebsch–Gordan 系数与球谐函数构造）是分子性质预测、蛋白质结构（AlphaFold 3）、材料发现（GNoME）的基础。

**这是纯数学（表示论）直接决定架构设计的最清晰案例。**如果你懂 Peter–Weyl 与 Clebsch–Gordan，你已经具备了设计这类网络的全部数学工具。

## 5. 数学家的比较优势

这门课的听众是纯数学研究者。诚实地说，你们在哪些方面有优势？

**(a) 机制可解释性.**
[[08 泛化之谜#6-grokking|grokking 中的 Fourier 电路]]、[[12 Transformer#induction-head|induction head]]、群运算网络学到的不可约表示——**这些逆向工程的结果全部是表示论/调和分析的对象**。这个方向缺人，且缺的正是能识别代数结构的人。工具门槛低（小模型可以在笔记本上训），数学门槛高。

**(b) 等变与几何架构.**
见 §4。表示论的直接应用。

**(c) 生成模型的理论.**
[[17 扩散模型与 flow matching]] 的核心是 SDE、Fokker–Planck、最优传输。[[07 无限宽极限 NTK 与 mean-field]] 的 mean-field 极限是 Wasserstein 空间上的梯度流。**这些是纯粹的分析问题**，且有大量开放问题（多层 mean-field 极限、CFG 的严格理论、score 逼近的复杂度）。

**(d) 优化的动力系统分析.**
[[05 优化的数学#8-edge-of-stability经典理论的失效|Edge of stability]] 本质是一个非线性动力系统的分岔问题。[[16 生成对抗网络#5-训练动力学为什么-gan-振荡|GAN 的收敛性]]是鞍点动力学。这些问题干净、具体、且现有工具明显不够。

**(e) 形式化.**
参与 mathlib 建设本身就有价值，且它是 AI4Math 的基础设施。门槛：学 Lean（几周），无需 ML 知识。

**(f) 判断力.**
知道什么问题重要、什么证明有意思、什么方向死路。**这是 AI 目前最弱的地方，也是最难自动化的。**

**你们相对不擅长的**：大规模工程、经验调参、跟上每周的新论文。**不要试图在这些方面竞争。**

## 6. 一个清醒的时间线

**已经可靠（2026）：**
- 竞赛级问题（IMO 水平）——形式化与非形式化路线都行；
- 例行的代数化简、大量情形的验证、文献检索与关联；
- 从数据中发现模式并提出（可能是对的）猜想；
- 形式化已有的自然语言证明（半自动，仍需大量人力）。

**部分可行：**
- 研究级但技术性的引理证明；
- 组合构造的搜索（在有好的评价函数时）；
- 大型形式化项目的辅助（如 PNT、Fermat 大定理的形式化项目）。

**还不行：**
- 提出一个新的**概念**或**框架**；
- 看出两个领域之间的深刻联系；
- 判断一个方向是否值得追求；
- 处理需要"理解为什么"而非"验证是否"的问题。

> [!note] 我的判断
> **AI 会在数学中扮演的角色，最可能类似于计算机代数系统的历史：**从一个新奇玩具，到一个不可或缺的工具，到最终改变什么问题被认为是"可做的"。Mathematica 没有取代数学家，但它改变了数学家做什么。
>
> 但有一个重要区别：CAS 的能力边界是清晰的（能做符号计算，不能做证明策略），而 AI 的边界是模糊且在移动的。**这使得"AI 不能做 X" 这类断言的保质期很短。**
>
> 对个人的建议：**学会用它**（作为搜索、验证、粗糙草稿的工具），**学会不信它**（每个论断都要独立验证），**不要把判断力外包出去**（那是唯一不会贬值的东西）。

## 7. 上手路径

**想用 AI 辅助研究：**
1. 用推理模型（带 extended thinking 的）做文献综述、粗糙的计算验证、代码生成；
2. **每一个论断都独立验证**——幻觉率仍然不低，且在小众领域更高；
3. 用它来检查自己的证明（"找出这个论证的漏洞"比"证明这个定理"有用得多）。

**想做 AI4Math 研究：**
1. **学 Lean**：[*Mathematics in Lean*](https://leanprover-community.github.io/mathematics_in_lean/)（Avigad–Massot），几周入门；
2. **参与 mathlib**：从形式化你自己领域的基础结果开始；
3. **看 [Formal Conjectures](https://github.com/google-deepmind/formal-conjectures) / [miniF2F](https://github.com/openai/miniF2F) / [PutnamBench](https://github.com/trishullab/PutnamBench)** 等基准，理解当前的能力边界；
4. 关注 Terence Tao 的博客与他在形式化上的实验——他是最认真在做这件事的一线数学家。

**想做深度学习理论：**
回到 [[07 无限宽极限 NTK 与 mean-field]]、[[08 泛化之谜]]、[[17 扩散模型与 flow matching#9-理论问题]] 列的开放问题。这些需要的是分析与概率，不需要 ML 背景。

## 参考

- Davies et al., *Advancing mathematics by guiding human intuition with AI*, Nature 2021.
- Trinh, Wu, Le, He, Luong, *Solving olympiad geometry without human demonstrations* (AlphaGeometry), Nature 2024.
- DeepMind, *Olympiad-level formal mathematical reasoning with reinforcement learning* (AlphaProof), Nature 2025.
- Romera-Paredes et al., *Mathematical discoveries from program search with large language models* (FunSearch), Nature 2024.
- [Avigad, Massot, *Mathematics in Lean*](https://leanprover-community.github.io/mathematics_in_lean/). mathlib 的官方教程。
- Buzzard 的博客 *Xena Project*，以及他关于形式化 Fermat 大定理的项目。
- [Terence Tao 的博客](https://terrytao.wordpress.com/)，形式化与 AI 辅助数学的实验记录。
- *Formal Conjectures*（Google DeepMind 的开放基准，收集尚未形式化证明的猜想）。
- Wang et al., *Goedel-Prover-V2* (Princeton, 2025). 开源的 Lean 4 定理证明器。

## Related

- [[index|深度学习（为纯数学研究者重写）]]
- [[22 RLHF 与推理 RL]]
- [[10 归纳偏置与等变性]]
- [[08 泛化之谜]]
