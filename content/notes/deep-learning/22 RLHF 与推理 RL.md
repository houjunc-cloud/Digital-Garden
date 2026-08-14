---
title: 22 RLHF 与推理 RL
description: Bradley–Terry、DPO 的推导、GRPO/DAPO/GSPO、RLVR、过程监督。
tags:
  - deep-learning
  - reinforcement-learning
  - llm
stage: 🌿 budding
date: 2026-08-14
---

# 22 RLHF 与推理 RL

> Feng Week 13 的案例是 DeepSeek-R1、AlphaGeometry、AlphaCode。这一篇把从 RLHF 到当前推理模型的技术链条讲完整：**Bradley–Terry 偏好模型、KL 约束下 RL 目标的闭式解（这是理解一切的关键）、DPO 的完整推导、GRPO 及其 2025–26 年的后继者、RLVR 范式、以及过程监督与推理时搜索。**
>
> 前置：[[21 策略梯度方法]]（PPO、KL 信任域）、[[18 大语言模型]]。

> [!question] 卡住了从哪儿看起
> - [CS336 Lec 15: RLHF](https://github.com/stanford-cs336/spring2025-lectures/blob/61eddac004df975466cff0329b615f2d24230069/nonexecutable/2025%20Lecture%2015%20-%20RLHF%20Alignment.pdf)、[Lec 16: RLVR](https://github.com/stanford-cs336/spring2025-lectures/blob/e94e33f433985e57036b25215dff2a4292e67a4f/nonexecutable/2025%20Lecture%2016%20-%20RLVR.pdf) — **最贴近本篇的讲义**
> - [CS336 作业 5：自己实现 SFT + GRPO](https://github.com/stanford-cs336/assignment5-alignment) — 想真正搞懂就做这个
> - [CS285 Lec 14: LLM RL](https://rail.eecs.berkeley.edu/deeprlcourse/static/slides/lec-14.pdf) — 从 RL 理论一侧看 LLM 微调
> - [Rafailov 等, *DPO*](https://arxiv.org/abs/2305.18290) — §4 推导的原文，附录写得很清楚
> - [DeepSeek-R1 论文](https://arxiv.org/abs/2501.12948) — §5.3 的一手材料

## 1. 为什么需要 RL

预训练目标是模仿语料（[[18 大语言模型#1-目标函数|MLE]]），SFT 是模仿演示。两者的共同局限：

- **只能达到演示的水平**（模仿学习的天花板）；
- **无法利用"哪个更好"这种比较信号**——而人类给绝对分数不可靠、给相对比较可靠；
- **无法利用可验证的正确性**（数学答案对不对、代码跑不跑得通）。

**RL 的作用：把"评价"信号变成"生成"能力。**评价比生成容易（$\mathsf{NP}$ 的直觉），这个不对称性是全部价值所在。

## 2. 奖励建模

**[Bradley–Terry 模型](https://en.wikipedia.org/wiki/Bradley%E2%80%93Terry_model).** 给定两个回答 $y_w$（胜）、$y_l$（负），假设
$$\Pr[y_w\succ y_l\,|\,x]=\frac{\exp(r^*(x,y_w))}{\exp(r^*(x,y_w))+\exp(r^*(x,y_l))}=\sigma\big(r^*(x,y_w)-r^*(x,y_l)\big).$$

**这是 Luce 选择公理的二元情形**，也是 Elo 评分系统的基础。

**训练奖励模型**（MLE）：
$$\mathcal{L}_{\mathrm{RM}}(\psi)=-\mathbb{E}_{(x,y_w,y_l)\sim\mathcal{D}}\Big[\log\sigma\big(r_\psi(x,y_w)-r_\psi(x,y_l)\big)\Big].$$

**实现**：在预训练模型上换一个标量输出头，用最后一个 token 的隐状态。

> [!note] BT 模型的隐含假设及其失效
> 1. **偏好是传递的**——人类偏好经常不传递（Condorcet 循环）。
> 2. **单一效用函数**——不同标注者的偏好可能不一致，$r^*$ 只是某种平均。
> 3. **$r^*$ 只由 $(x,y)$ 决定**——实际偏好依赖标注者、心情、呈现顺序。
>
> **奖励只在 $\log$-差的意义上被确定**：$r$ 与 $r+c(x)$ 给出相同的偏好分布。这个**平移不变性**在 §4 的 DPO 推导中是关键。

**奖励黑客（reward hacking）.** 策略会找到 $r_\psi$ 高但实际不好的输出——因为 $r_\psi$ 只在训练分布上准确，而 RL 会把策略推到分布外。表现：过长的回答、迎合、格式化的空话、特定关键词堆砌。

**这是 Goodhart 定律的实例。**[Gao–Schulman–Hilton (2023)](https://arxiv.org/abs/2210.10760) 给出定量规律：真实奖励与代理奖励的差距随 $\sqrt{D_{\mathrm{KL}}(\pi\|\pi_{\mathrm{ref}})}$ 增长。**这直接给了 KL 惩罚一个经验依据。**

## 3. KL 约束的 RL 目标 —— 一切的核心

$$\max_{\pi}\ \mathbb{E}_{x\sim\mathcal{D},\,y\sim\pi(\cdot|x)}\big[r(x,y)\big]-\beta\,D_{\mathrm{KL}}\big(\pi(\cdot|x)\,\|\,\pi_{\mathrm{ref}}(\cdot|x)\big).$$

**定理（闭式最优解）.**
$$\boxed{\pi^*(y|x)=\frac{1}{Z(x)}\,\pi_{\mathrm{ref}}(y|x)\,\exp\!\Big(\frac{1}{\beta}r(x,y)\Big)},\qquad Z(x)=\sum_y\pi_{\mathrm{ref}}(y|x)e^{r(x,y)/\beta}.$$

*证明.* 把目标改写：
$$\mathbb{E}_\pi[r]-\beta D_{\mathrm{KL}}(\pi\|\pi_{\mathrm{ref}})=-\beta\,\mathbb{E}_\pi\Big[\log\frac{\pi(y|x)}{\pi_{\mathrm{ref}}(y|x)e^{r/\beta}}\Big]=-\beta\,D_{\mathrm{KL}}\big(\pi\,\|\,\pi^*\big)+\beta\log Z(x),$$
由 Gibbs 不等式（[[03 信息论#2-kl-散度与-f-散度]]），最大值在 $\pi=\pi^*$ 处。$\square$

> [!tip] 这个公式必须内化
> - 它是 **Gibbs / Boltzmann 分布**：$\pi_{\mathrm{ref}}$ 是先验，$r/\beta$ 是负能量，$\beta$ 是温度。
> - $\beta\to\infty$：$\pi^*\to\pi_{\mathrm{ref}}$（完全不动）。$\beta\to0$：$\pi^*\to$ 集中在 $\arg\max r$（贪心）。
> - 它是**贝叶斯后验**：先验 $\pi_{\mathrm{ref}}$，似然 $e^{r/\beta}$。"RLHF 是在做贝叶斯更新"这个说法在这里是字面上正确的。
> - 它同时是 [[21 策略梯度方法#7-其他重要算法|最大熵 RL]] 的解（那里 $\pi_{\mathrm{ref}}$ 是均匀分布）。
> - **$Z(x)$ 不可算**（要对所有序列求和），这是所有困难的来源。PPO 通过采样绕开它，DPO 通过消去它绕开。

## 4. DPO：把 RL 变成分类

**核心技巧**：对最优解取对数并解出 $r$：
$$r(x,y)=\beta\log\frac{\pi^*(y|x)}{\pi_{\mathrm{ref}}(y|x)}+\beta\log Z(x).$$

**把这个代入 Bradley–Terry**：
$$\Pr[y_w\succ y_l]=\sigma\big(r(x,y_w)-r(x,y_l)\big)=\sigma\Big(\beta\log\frac{\pi^*(y_w|x)}{\pi_{\mathrm{ref}}(y_w|x)}-\beta\log\frac{\pi^*(y_l|x)}{\pi_{\mathrm{ref}}(y_l|x)}\Big).$$

**$\beta\log Z(x)$ 在相减时消掉了！**（因为它只依赖 $x$——正是 §2 提到的平移不变性。）

**DPO 损失（[Rafailov et al. 2023](https://arxiv.org/abs/2305.18290)）：**
$$\boxed{\mathcal{L}_{\mathrm{DPO}}(\theta)=-\mathbb{E}_{(x,y_w,y_l)}\left[\log\sigma\left(\beta\log\frac{\pi_\theta(y_w|x)}{\pi_{\mathrm{ref}}(y_w|x)}-\beta\log\frac{\pi_\theta(y_l|x)}{\pi_{\mathrm{ref}}(y_l|x)}\right)\right]}$$

**这是一个标准的二分类损失，可以直接用 SGD 优化。没有奖励模型、没有采样、没有 PPO。**

**梯度的解读：**
$$\nabla_\theta\mathcal{L}_{\mathrm{DPO}}=-\beta\,\mathbb{E}\Big[\underbrace{\sigma\big(\hat r_\theta(y_l)-\hat r_\theta(y_w)\big)}_{\text{隐式奖励错序的程度}}\Big(\nabla\log\pi_\theta(y_w|x)-\nabla\log\pi_\theta(y_l|x)\Big)\Big].$$
**权重是"模型当前排错的程度"**——排得越错，梯度越大。这是一个自动的难例挖掘。

> [!tip] 为什么这个推导漂亮
> 它说明：**语言模型本身就是一个奖励模型**（$\hat r_\theta=\beta\log\frac{\pi_\theta}{\pi_{\mathrm{ref}}}$）。RLHF 的两阶段（学 $r$，再优化 $\pi$）在这个参数化下坍缩成一步。
>
> 数学上这是一个**变量替换**：把优化变量从 $r$ 换到 $\pi$，利用两者之间的双射（在 KL 正则的设定下）。

**DPO 的局限（重要，不要只记住优点）：**

1. **离策略**。偏好数据来自其他模型，不来自 $\pi_\theta$。分布偏移导致效果不如在线 RL。修复：在线 DPO、迭代 DPO（用当前模型采样、标注、再训）。
2. **在数据外的行为无约束**。[Xu et al. (2024)](https://arxiv.org/abs/2404.10719) 指出 DPO 可能提高**未见过的**低质量回答的概率——因为它只约束了 $y_w$ 与 $y_l$ 的相对概率，两者都降低而其他上升是可行的。
3. **不能利用可验证奖励**。DPO 需要成对偏好；数学题的对错是标量。
4. **对 $\beta$ 与数据质量敏感**。

**变体**：[IPO](https://arxiv.org/abs/2310.12036)（换损失函数避免过拟合到确定性偏好）、[KTO](https://arxiv.org/abs/2402.01306)（用 Kahneman–Tversky 前景理论，只需单个"好/坏"标签而非成对）、[SimPO](https://arxiv.org/abs/2405.14734)（去掉 $\pi_{\mathrm{ref}}$，用长度归一化的对数概率）、ORPO（把 SFT 与偏好合并成一步）。

## 5. GRPO 与推理 RL

### 5.1 动机

PPO 需要 critic $V_\phi$（与策略同样大的网络），在 LLM 上：

- **显存翻倍**（策略 + critic + 参考模型 + 奖励模型 = 4 个模型）；
- **critic 难训**：奖励只在序列末尾，中间状态的价值估计方差极大；
- 而 LLM 的 MDP 转移是**确定的**（见 [[19 MDP 与动态规划#6-与-llm-的接口]]），critic 的作用被削弱。

### 5.2 GRPO（[DeepSeekMath, 2024](https://arxiv.org/abs/2402.03300)）

**去掉 critic，用组内统计做 baseline。**

对每个 prompt $x$，采样 $G$ 个回答 $\{y_1,\dots,y_G\}\sim\pi_{\theta_{\mathrm{old}}}$，得奖励 $\{r_1,\dots,r_G\}$。**组相对优势**：
$$\hat A_i=\frac{r_i-\mathrm{mean}(r_1,\dots,r_G)}{\mathrm{std}(r_1,\dots,r_G)}.$$

**这是 §3.1 的 baseline 思想的最直接实现**：$\mathrm{mean}$ 是 $V(x)$ 的 Monte Carlo 估计（$G$ 个样本），而 $\mathrm{std}$ 归一化是额外的方差控制。

**目标**（token 级 PPO-Clip，优势在序列内共享）：
$$\mathcal{L}_{\mathrm{GRPO}}=\mathbb{E}\left[\frac{1}{G}\sum_{i=1}^{G}\frac{1}{|y_i|}\sum_{t}\min\big(\rho_{i,t}\hat A_i,\ \mathrm{clip}(\rho_{i,t},1\pm\epsilon)\hat A_i\big)-\beta D_{\mathrm{KL}}(\pi_\theta\|\pi_{\mathrm{ref}})\right],$$
$\rho_{i,t}=\dfrac{\pi_\theta(y_{i,t}|x,y_{i,<t})}{\pi_{\theta_{\mathrm{old}}}(y_{i,t}|x,y_{i,<t})}$。

**优点**：无 critic（省一半显存）、实现简单、对稀疏末端奖励天然适配。

### 5.3 RLVR：可验证奖励

**RLVR = Reinforcement Learning with Verifiable Rewards.**

奖励不来自学出来的模型，而来自**程序化验证**：

| 领域 | 验证器 |
|---|---|
| 数学 | 答案匹配、SymPy 化简、Lean 类型检查 |
| 代码 | 单元测试、编译器 |
| 形式化 | 证明助手（Lean、Coq、Isabelle） |
| 指令遵循 | 规则检查（格式、长度、约束） |

**为什么这是范式转折：**

- **没有奖励黑客**（验证器是真相，不是代理）—— 至少在验证器正确的范围内；
- **可以无限扩展**（不需要人类标注）；
- **信号是稀疏但准确的**。

**[DeepSeek-R1-Zero 的结果（2025）](https://arxiv.org/abs/2501.12948)**：**纯 RL，无 SFT**，直接在基座模型上用 GRPO + 规则奖励训练，模型自发涌现出：

- 长推理链（回答长度从数百 token 自发增长到数千）；
- **自我验证与回溯**（"wait, let me reconsider..."）；
- AIME 准确率从 15.6% 到 71.0%（多数投票后 86.7%）。

> [!tip] 这是 AlphaZero 范式在 LLM 上的实现
> 对照 [[20 值函数方法#6-alphagoalphazerofeng-的案例|AlphaZero]]：
> - **搜索** ↔ 生成长推理链、多次采样；
> - **胜负判定** ↔ 验证器；
> - **蒸馏回网络** ↔ RL 更新。
>
> 关键前提相同：**存在一个便宜、准确的结果验证器**。这解释了为什么推理 RL 首先在数学和代码上成功，而在开放式写作、事实性上进展慢得多——**那里没有验证器**。
>
> **这也定义了当前 AI 能力增长的边界**：能被自动验证的任务进步快，不能的慢。

### 5.4 GRPO 的后继者（2025–2026）

GRPO 被大规模使用后暴露出若干问题，一系列改进相继出现：

| 算法 | 主要改动 | 解决的问题 |
|---|---|---|
| **[DAPO](https://arxiv.org/abs/2503.14476)** (2025) | 解耦上下裁剪边界（clip-higher）、**动态采样**（丢弃全对/全错的组）、token 级损失聚合、超长回答的软惩罚 | 熵坍缩、无梯度的组浪费算力、长回答被长度归一化稀释 |
| **[GSPO](https://arxiv.org/abs/2507.18071)** (Qwen, 2025) | 重要性比与裁剪在**序列级**而非 token 级 | token 级比值的方差在长序列上累积；对 MoE 训练尤其不稳定 |
| **Dr. GRPO** | 去掉 $\mathrm{std}$ 归一化与长度归一化 | 这两项引入了**系统性偏差**（偏好长回答、偏好低方差的题） |
| **VAPO / VinePPO** | 重新引入价值估计但用蒙特卡洛树 | 稀疏奖励下的信用分配 |

**几个共同的技术主题：**

1. **熵管理**。RL 训练中策略熵单调下降，最终坍缩（只输出一种回答），性能停滞。对策：clip-higher（给低概率 token 更多上升空间）、熵奖励、周期性重置。
2. **KL 惩罚的取舍**。推理 RL 中很多实践**去掉** KL 惩罚——因为要让模型大幅偏离初始行为（学会长思考）。代价是可能丧失通用能力，需要混合数据缓解。
3. **长度偏差**。序列级平均 vs token 级平均给出不同的隐式长度偏好，这个看似技术性的选择显著影响最终行为。
4. **数据难度调度**。全对或全错的题目梯度为零（组内优势全为 0），需要动态筛选处于"能力边缘"的题——**这是课程学习在 RL 上的体现**。

> [!warning] 这个领域变化极快
> 上表反映的是 2026 年中的状态。**具体算法会继续变，但底层的数学不变**：都是 §3 的 KL 约束目标 + §5.2 的方差缩减 + 各种偏差修正。理解了那两条，新算法的论文可以在十分钟内读懂。

## 6. 过程监督与推理时搜索

**结果监督（ORM）** vs **过程监督（PRM）**：

- ORM：只看最终答案对不对。信号稀疏，但标注便宜（自动）。
- PRM：给推理链的**每一步**打分。信号稠密，信用分配容易，但标注昂贵。

**[Lightman et al. (2023), "Let's Verify Step by Step"](https://arxiv.org/abs/2305.20050)** ：在 MATH 数据集上用于 best-of-$n$ 重排时，PRM 显著优于 ORM 与多数投票（约 78% vs 约 72%）。且 PRM 更不容易奖励"过程错误但答案碰巧对"的解答——这一点在训练信号的质量上比准确率差距更重要。

**自动获得过程标签.** **[Math-Shepherd](https://arxiv.org/abs/2312.08935) / [OmegaPRM](https://arxiv.org/abs/2406.06592)**：从某个中间步骤出发**多次 rollout**，用"能到达正确答案的比例"作为该步的价值估计——**这就是 Monte Carlo 值估计**（[[20 值函数方法#1-从模型已知到样本]]），只是应用在推理树上。

**推理时搜索：**

| 方法 | 描述 |
|---|---|
| **Best-of-$n$** | 采样 $n$ 条，用 verifier/PRM 选最好的 |
| **多数投票 / 自洽性** | 采样 $n$ 条，取答案的众数（不需要 verifier） |
| **束搜索（步级）** | 在推理步的层面做 beam search，PRM 做打分 |
| **MCTS** | 完整的树搜索，PRM 做值函数 |
| **长思考** | 训练模型自发生成长推理链，单条但很长 |

**当前的经验**：对已经过 RL 训练的推理模型，**"长思考"这条单链路径的效率优于并行搜索**——因为模型学会了自己回溯和验证，把搜索内化了。这与 AlphaZero 的外置 MCTS 形成对比，是一个有意思的分歧。

**推理时 scaling law**：准确率随推理计算量呈幂律，见 [[09 Scaling laws#5-推理时-scaling]]。

## 7. 未解的问题

1. **RL 是在教新能力还是只在提取已有能力？**
 [Yue et al. (2025)](https://arxiv.org/abs/2504.13837) 的实验：RLVR 训练后模型的 pass@1 大幅提升，但 **pass@$k$（$k$ 大）不如基座模型**——说明 RL 把概率质量集中到已有的正确路径上，而**缩小了**能解决的问题集合。若成立，这意味着 RL 的收益有天花板，且天花板由预训练决定。这是当前最重要的争论之一，证据两边都有。

2. **奖励模型的可扩展性。**人类无法评价超出自己能力的输出（"可扩展监督"问题）。方向：辩论（debate）、递归奖励建模、weak-to-strong 泛化。**这是对齐研究的核心难题，且它有清晰的形式化空间**（博弈论、交互式证明系统——事实上 debate 的理论基础正是 IP = PSPACE 那一套）。

3. **过程奖励的理论。**PRM 实际上是在学一个值函数，但训练它的目标不是 Bellman 一致的。把 PRM 与 [[19 MDP 与动态规划|MDP 理论]]正确对接是一个开放问题。

4. **验证器的覆盖范围。**目前 RLVR 局限于有自动验证器的领域。扩展到开放领域需要根本性的新想法。

5. **多轮与工具使用。**真实智能体任务是多轮的、带工具调用的，转移不再确定，信用分配跨越多轮。这把问题推回了标准 RL 的困难。

## 参考

- Christiano et al., *Deep reinforcement learning from human preferences*, NeurIPS 2017.
- Ouyang et al., *Training language models to follow instructions with human feedback* (InstructGPT), NeurIPS 2022.
- Bai et al., *Constitutional AI: Harmlessness from AI feedback*, Anthropic 2022.
- Rafailov, Sharma, Mitchell, Ermon, Manning, Finn, *Direct preference optimization*, NeurIPS 2023.
- Shao et al., *DeepSeekMath: Pushing the limits of mathematical reasoning in open language models*, 2024. GRPO 的出处。
- DeepSeek-AI, *DeepSeek-R1: Incentivizing reasoning capability in LLMs via reinforcement learning*, Nature 2025.
- Yu et al., *DAPO: An open-source LLM reinforcement learning system at scale*, 2025.
- Zheng et al., *Group sequence policy optimization* (GSPO), 2025.
- Lightman et al., *Let's verify step by step*, ICLR 2024.
- Gao, Schulman, Hilton, *Scaling laws for reward model overoptimization*, ICML 2023.
- Yue et al., *Does RL really incentivize reasoning capacity in LLMs beyond the base model?*, 2025.
- Turing Post, *Reasoning RL in 2026*（综述，跟踪算法演进）。

## Related

- [[index|深度学习（为纯数学研究者重写）]]
- [[21 策略梯度方法]]
- [[18 大语言模型]]
- [[09 Scaling laws]]
- [[23 AI for Mathematics]]
