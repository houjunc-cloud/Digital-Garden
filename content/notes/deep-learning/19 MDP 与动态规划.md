---
title: 19 MDP 与动态规划
description: 严格设定、Bellman 算子的压缩映射、值/策略迭代收敛、occupancy measure 的 LP 对偶。
tags:
  - deep-learning
  - reinforcement-learning
stage: 🌿 budding
date: 2026-08-14
---

# 19 MDP 与动态规划

> Feng Week 12 一节课里塞了 MDP、预测与控制、Monte Carlo、TD、SARSA、值函数逼近。本篇先把**基础打严**：MDP 的测度论设定、Bellman 算子作为 Banach 空间上的压缩映射（收敛性是 Banach 不动点定理的直接推论）、值迭代与策略迭代的收敛证明、以及 occupancy measure 给出的线性规划对偶——后者是理解现代策略优化方法的关键，但入门材料几乎不讲。
>
> 前置：泛函分析的基本知识（Banach 不动点定理）。

> [!question] 卡住了从哪儿看起
> - [Sutton & Barto, *RL: An Introduction*](http://incompleteideas.net/book/RLbook2020.pdf) §3–4 — Feng 指定，免费 PDF
> - [David Silver 的 UCL RL 课](https://www.davidsilver.uk/teaching/) Lec 2–3 — Feng 指定，MDP 与 DP 讲得极清楚
> - [Agarwal, Jiang, Kakade, Sun, *RL: Theory and Algorithms*](https://rltheorybook.github.io/) — **严格版本**，含 LP 对偶与样本复杂度
> - [CS285 Lec 4: RL Basics](https://rail.eecs.berkeley.edu/deeprlcourse/static/slides/lec-4.pdf) — 深度 RL 视角的设定
> - Puterman, *Markov Decision Processes* — 测度论设定的标准参考

## 1. 设定

**定义（MDP）.** 五元组 $(\mathcal{S},\mathcal{A},P,r,\gamma)$：

- $\mathcal{S}$：状态空间（Borel 空间）；
- $\mathcal{A}$：动作空间；
- $P(\cdot|s,a)$：转移核，$\mathcal{S}\times\mathcal{A}\to\mathcal{P}(\mathcal{S})$ 可测；
- $r:\mathcal{S}\times\mathcal{A}\to\R$：奖励，有界 $|r|\le R_{\max}$；
- $\gamma\in[0,1)$：折扣因子。

**策略** $\pi:\mathcal{S}\to\mathcal{P}(\mathcal{A})$（平稳、随机）。

**轨迹分布**：$s_0\sim\rho_0$，$a_t\sim\pi(\cdot|s_t)$，$s_{t+1}\sim P(\cdot|s_t,a_t)$。由 [Ionescu-Tulcea 定理](https://en.wikipedia.org/wiki/Ionescu-Tulcea_theorem)，这在轨迹空间 $(\mathcal{S}\times\mathcal{A})^\infty$ 上唯一确定一个概率测度 $\Pr^\pi$。

**回报与值函数**：
$$G_t=\sum_{k=0}^{\infty}\gamma^kr_{t+k},\qquad V^\pi(s)=\mathbb{E}^\pi[G_0|s_0=s],\qquad Q^\pi(s,a)=\mathbb{E}^\pi[G_0|s_0=s,a_0=a].$$

$|G_t|\le R_{\max}/(1-\gamma)$，故 $V^\pi\in\mathcal{B}(\mathcal{S})$（有界可测函数，带 $\|\cdot\|_\infty$，是 Banach 空间）。

> [!note] $\gamma<1$ 在做什么
> 三个作用叠在一起：(1) **保证级数收敛**（数学上的必要性）；(2) **压缩因子**（下一节的全部内容）；(3) **有效视界** $\approx\frac{1}{1-\gamma}$ 步。
>
> $\gamma\to1$ 时压缩因子 $\to1$，所有收敛率退化（$\log(1/\varepsilon)/\log(1/\gamma)\approx\frac{1}{1-\gamma}\log(1/\varepsilon)$ 步）。**这是 RL 长视界问题困难的数学根源，且是一个硬的、无法绕过的困难。**平均奖励设定（$\gamma=1$）需要完全不同的工具（遍历理论、Poisson 方程）。

## 2. Bellman 算子

**定义.** 对 $\pi$，**Bellman 期望算子** $T^\pi:\mathcal{B}(\mathcal{S})\to\mathcal{B}(\mathcal{S})$：
$$(T^\pi V)(s):=\mathbb{E}_{a\sim\pi(\cdot|s)}\Big[r(s,a)+\gamma\,\mathbb{E}_{s'\sim P(\cdot|s,a)}\big[V(s')\big]\Big].$$

**Bellman 最优算子**：
$$(T^*V)(s):=\max_{a\in\mathcal{A}}\Big[r(s,a)+\gamma\,\mathbb{E}_{s'}\big[V(s')\big]\Big].$$

**定理（压缩性）.** $T^\pi$ 与 $T^*$ 都是 $\|\cdot\|_\infty$ 下的 $\gamma$-压缩：
$$\|T^\pi V_1-T^\pi V_2\|_\infty\le\gamma\|V_1-V_2\|_\infty,\qquad \|T^*V_1-T^*V_2\|_\infty\le\gamma\|V_1-V_2\|_\infty.$$

*证明（对 $T^*$）.* 对任意 $s$，
$$|(T^*V_1)(s)-(T^*V_2)(s)|=\Big|\max_a\big[r+\gamma\mathbb{E}V_1\big]-\max_a\big[r+\gamma\mathbb{E}V_2\big]\Big|\le\max_a\Big|\gamma\mathbb{E}_{s'}[V_1(s')-V_2(s')]\Big|\le\gamma\|V_1-V_2\|_\infty,$$
用到 $|\max_af(a)-\max_ag(a)|\le\max_a|f(a)-g(a)|$ 与转移核是概率测度。$\square$

**定理（Bellman 方程）.** 由 **[Banach 不动点定理](https://en.wikipedia.org/wiki/Banach_fixed-point_theorem)**，$T^\pi$ 与 $T^*$ 各有唯一不动点：
$$V^\pi=T^\pi V^\pi\qquad\text{（Bellman 期望方程）},$$
$$V^*=T^*V^*\qquad\text{（Bellman 最优方程）},$$
且对任意初始 $V_0$，$\|(T^*)^nV_0-V^*\|_\infty\le\gamma^n\|V_0-V^*\|_\infty$。

> [!tip] 整个 RL 理论的地基就是这一句话
> **"$T$ 是 $\gamma$-压缩" + Banach 不动点定理 = 值迭代收敛、Q-learning 收敛（加随机逼近）、误差传播界。**
>
> 后面所有的困难都来自**破坏这个结构**的东西：
> - **函数逼近**：$V$ 被限制在一个子空间 $\mathcal{F}$ 中，需要投影 $\Pi$。而 $\Pi T$ 可能**不是压缩**（$\Pi$ 在 $\|\cdot\|_\infty$ 下不是非扩张的）。→ [[20 值函数方法#3-deadly-triad]]
> - **采样**：只能用 $T$ 的无偏估计。→ 随机逼近理论
> - **离策略**：数据来自 $\mu\ne\pi$，分布不匹配。→ 重要性采样、分布偏移
>
> **RL 的全部技术困难，都可以理解为"如何在破坏压缩性的情况下保住某种收敛保证"。**

**单调性.** $V_1\le V_2$（逐点）$\Rightarrow T^\pi V_1\le T^\pi V_2$，$T^*V_1\le T^*V_2$。加上压缩性，这两条给出更精细的界（如策略迭代的单调改进）。

## 3. 值迭代与策略迭代

### 3.1 值迭代

$$V_{k+1}=T^*V_k.$$

**收敛率**：$\|V_k-V^*\|_\infty\le\gamma^k\|V_0-V^*\|_\infty$。要 $\varepsilon$-精度需 $O\big(\frac{\log(1/\varepsilon)}{1-\gamma}\big)$ 次迭代，每次 $O(|\mathcal{S}|^2|\mathcal{A}|)$。

**从值到策略.** 贪心策略 $\pi_V(s)=\arg\max_a[r+\gamma\mathbb{E}V]$。

**定理（策略误差界）.** 若 $\|V-V^*\|_\infty\le\varepsilon$，则
$$\|V^{\pi_V}-V^*\|_\infty\le\frac{2\gamma\varepsilon}{1-\gamma}.$$

*证明.* 三角不等式加压缩性，链式展开。$\square$

**注意 $\frac{1}{1-\gamma}$ 的放大因子。**这是 RL 的一个基本现象：**值函数的小误差会被放大成策略的大误差**，且放大倍数随视界增长。见 [[21 策略梯度方法#4-trpo-的性能差界]]。

### 3.2 策略迭代

```
重复:
  策略评估: 解 V^π = T^π V^π   (线性方程组, 或迭代 T^π 到收敛)
  策略改进: π'(s) = argmax_a [r(s,a) + γ E_{s'}[V^π(s')]]
```

**定理（策略改进定理）.** $V^{\pi'}\ge V^\pi$ 逐点，且若 $\pi'\ne\pi$（在某个状态上改进了），则严格。

*证明.* 由构造 $T^{\pi'}V^\pi\ge T^\pi V^\pi=V^\pi$。用 $T^{\pi'}$ 的单调性反复作用：
$$V^\pi\le T^{\pi'}V^\pi\le (T^{\pi'})^2V^\pi\le\cdots\to V^{\pi'}.\qquad\square$$

**定理（有限终止）.** 有限 MDP 上策略迭代在至多 $|\mathcal{A}|^{|\mathcal{S}|}$ 次迭代内**精确**收敛（策略数有限且严格改进）。

**实际上快得多**：[Ye (2011)](https://web.stanford.edu/~yyye/simplexmdp1.pdf) 证明策略迭代（对固定 $\gamma$）是**强多项式**的，迭代次数 $O\big(\frac{|\mathcal{S}|^2|\mathcal{A}|}{1-\gamma}\log\frac{|\mathcal S|^2}{1-\gamma}\big)$。这是运筹学里的一个漂亮结果——**策略迭代其实是单纯形法的一个变种**（见 §4）。

**修正策略迭代**：策略评估只做 $m$ 步而非到收敛。$m=1$ 是值迭代，$m=\infty$ 是策略迭代。**实践中的 actor-critic 就是这个谱系上的点**（critic 做不完全的策略评估，actor 做策略改进）。

## 4. 线性规划对偶与 occupancy measure

**这一节是入门材料通常跳过的，但它是理解现代策略优化的关键。**

### 4.1 原问题

$$\min_{V}\ \sum_s\rho_0(s)V(s)\quad\text{s.t.}\quad V(s)\ge r(s,a)+\gamma\sum_{s'}P(s'|s,a)V(s'),\ \forall (s,a).$$

**约束就是 $V\ge T^*V$。**最小的这样的 $V$ 就是 $V^*$（由单调性与压缩性）。

### 4.2 对偶：occupancy measure

**定义.** 策略 $\pi$ 的**折扣占用测度**：
$$d^\pi(s,a):=(1-\gamma)\sum_{t=0}^{\infty}\gamma^t\Pr^\pi[s_t=s,a_t=a].$$

$d^\pi\in\mathcal{P}(\mathcal{S}\times\mathcal{A})$（归一化后是概率测度）。

**对偶问题：**
$$\max_{d\ge0}\ \sum_{s,a}d(s,a)r(s,a)\quad\text{s.t.}\quad \sum_ad(s',a)=(1-\gamma)\rho_0(s')+\gamma\sum_{s,a}P(s'|s,a)d(s,a),\ \forall s'.$$

**约束是"流守恒"**（Bellman flow constraint）：进入 $s'$ 的流 = 离开 $s'$ 的流。

**定理（占用测度的刻画）.** $d$ 满足流守恒约束 $\iff$ 存在策略 $\pi$ 使 $d=d^\pi$，且对应关系是
$$\pi(a|s)=\frac{d(s,a)}{\sum_{a'}d(s,a')}.$$

**推论（极其重要）.**
$$\mathbb{E}^\pi\Big[\sum_t\gamma^tr(s_t,a_t)\Big]=\frac{1}{1-\gamma}\,\mathbb{E}_{(s,a)\sim d^\pi}\big[r(s,a)\big].$$

> [!tip] 为什么这个视角重要
> **它把"在策略空间上优化"变成了"在占用测度的凸多面体上优化线性函数"。**
>
> - 目标 $\langle d,r\rangle$ 关于 $d$ 是**线性**的；约束集是**凸多面体**。所以 MDP 本质上是一个**线性规划**。
> - 策略空间是非凸的（$J(\pi)$ 关于 $\pi$ 的参数非凸），但占用测度空间是凸的。**这个凸化解释了为什么策略梯度方法尽管目标非凸却能全局收敛**（Agarwal–Kakade–Lee–Mahajan 2021 的分析正是走这条路）。
> - **策略迭代 = 这个 LP 上的单纯形法**（每次改进对应一次 pivot），这解释了 Ye 的强多项式结果。
> - **分布偏移**在这里有精确含义：离策略学习时，数据来自 $d^\mu$ 但要评估 $d^\pi$，两者的比值 $\frac{d^\pi}{d^\mu}$ 就是重要性权重。它可以无界——这是离策略 RL 一切困难的来源。
> - **TRPO/PPO 的信任域**约束的正是 $d^\pi$ 与 $d^{\pi_{\text{old}}}$ 的接近程度（通过 KL 代理）。见 [[21 策略梯度方法]]。

**约束 MDP.** 加上额外的线性约束 $\langle d,c_i\rangle\le b_i$（如安全约束），仍是 LP，可用 Lagrange 方法。**这是安全 RL 的标准框架。**

## 5. 探索与部分可观测

**探索–利用权衡.** 上述全部假设已知 $P,r$。未知时必须探索。

**多臂赌博机**（无状态的特例）：
- **[UCB](https://link.springer.com/article/10.1023/A:1013689704352)**：$a_t=\arg\max_a\big[\hat\mu_a+\sqrt{\frac{2\log t}{n_a}}\big]$，遗憾 $O(\sqrt{KT\log T})$。
- **Thompson 采样**：从后验采一个参数，按它贪心。遗憾同阶，实践中常更好。
- **下界**（[Lai–Robbins 1985](https://doi.org/10.1016/0196-8858(85)90002-8)）：任何一致好的算法遗憾 $\ge\Omega(\sum_{a\ne a^*}\frac{\log T}{\Delta_a})$。**这是信息论下界**（用 KL 散度构造难以区分的实例）。

**表格 MDP 的最优遗憾**：$\tilde\Theta(\sqrt{HSAT})$（$H$=视界，[Azar et al. 2017](https://arxiv.org/abs/1703.05449) 的 UCBVI 达到）。

**深度 RL 中的探索**：$\epsilon$-贪心（最常用，理论上很差）、熵正则（SAC）、内在动机（好奇心、随机网络蒸馏 RND）、参数噪声。**理论与实践在这里差距极大**——有理论保证的方法在深度 RL 中基本不可用。

**POMDP.** 观测 $o_t\sim O(\cdot|s_t)$，真实状态不可见。最优策略需要**信念状态** $b_t=\Pr[s_t|o_{1:t},a_{1:t-1}]$，它是 $\mathcal{P}(\mathcal{S})$ 上的一个 MDP（**信念 MDP**）——状态空间变成无穷维单形。

**求解 POMDP 是 PSPACE-hard**（有限视界），无限视界不可判定。实践中用循环网络或 Transformer 隐式维护信念（历史压缩）。

> **LLM 的对话本身就是一个 POMDP**：模型看不到用户的真实意图，只能从对话历史推断。这个视角对理解对齐问题有帮助。

## 6. 与 LLM 的接口

现代 LLM 的 RL 微调（[[22 RLHF 与推理 RL]]）在这个框架下的翻译：

| MDP 元素 | LLM 中的对应 |
|---|---|
| 状态 $s_t$ | 当前的 token 前缀 $x_{<t}$ |
| 动作 $a_t$ | 下一个 token $x_t$ |
| 转移 $P$ | **确定的**（拼接），无随机性 |
| 奖励 $r$ | 通常只在序列末尾（**稀疏**） |
| $\gamma$ | 通常取 1（有限视界） |
| 策略 $\pi_\theta$ | 语言模型本身 |

**特殊性：**
1. **转移确定** ⟹ 不需要建模环境动力学，$Q(s,a)=r+V(s')$ 精确。
2. **奖励稀疏且在末尾** ⟹ 信用分配是主要困难，需要 GAE 或过程奖励。
3. **动作空间巨大**（$|V|\sim10^5$）但**结构化**（softmax 可解析）。
4. **状态空间是所有 token 序列** ⟹ 表格方法完全不适用，必须函数逼近。
5. **初始策略已经很好**（预训练模型），所以是**微调**而非从零学习 ⟹ 信任域/KL 约束是自然的（不要偏离太远）。

这些特殊性解释了为什么 LLM 的 RL 用的算法（PPO、GRPO）与机器人 RL 的重点很不同。

## 参考

- [Sutton & Barto, *Reinforcement Learning: An Introduction*](http://incompleteideas.net/book/the-book-2nd.html) (2nd ed., 2018). §3–4。[免费 PDF](http://incompleteideas.net/book/RLbook2020.pdf)，Feng 指定。
- Puterman, *Markov Decision Processes: Discrete Stochastic Dynamic Programming* (1994). **最严格的参考**，测度论设定、LP 对偶、收敛性证明都在这里。对数学家首选。
- Bertsekas, *Dynamic Programming and Optimal Control*, Vol. 1–2.
- [Agarwal, Jiang, Kakade, Sun, *Reinforcement Learning: Theory and Algorithms*](https://rltheorybook.github.io/). 免费在线讲义，现代理论视角，含样本复杂度分析。
- Lattimore & Szepesvári, *Bandit Algorithms* (2020). 探索理论的标准参考。
- Ye, *The simplex and policy-iteration methods are strongly polynomial for the Markov decision problem with a fixed discount rate*, Math. of OR 2011.
- [David Silver 的 UCL RL 课程](https://www.davidsilver.uk/teaching/)。Feng 指定，讲得很清楚。

## Related

- [[index|深度学习（为纯数学研究者重写）]]
- [[20 值函数方法]]
- [[21 策略梯度方法]]
- [[22 RLHF 与推理 RL]]
