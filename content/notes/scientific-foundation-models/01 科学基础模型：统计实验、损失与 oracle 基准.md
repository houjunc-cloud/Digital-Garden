---
title: 01 科学基础模型：统计实验、损失与 oracle 基准
description: 把任务族写成一族统计实验；损失如何决定可辨识性；三层 oracle 基准（贝叶斯 / 最小最大 / 可辨识性）。
tags:
  - scientific-foundation-models
  - learning-theory
stage: 🌱 seedling
date: 2026-08-18
---

# 01 科学基础模型：统计实验、损失与 oracle 基准

> 课程第一周（9/1, 9/3）。大纲写的是 *"Scientific foundation models; statistical experiments, losses, and oracle benchmarks"*。这三个词组恰好是这门课的三块地基，值得单独一篇讲清楚：
>
> 1. **统计实验** — 把"一个基础模型面对一族任务"翻译成 Le Cam 意义下的一族实验 $\{\mathcal{E}_\theta\}$。
> 2. **损失** — 损失不是评价指标，**它决定了什么东西可辨识、误差在哪个范数下被度量**。这在轨迹数据上尤其明显。
> 3. **oracle 基准** — "我的方法好不好"是个空问题；"我的方法离最好能做到的有多远"才是。这门课全程用三层 oracle。
>
> 前置：[[P2 非参数回归与最小最大率]]（最小最大的语言）、[[P1 随机微分方程与 Fokker–Planck#7-girsanov-与轨迹似然这门课的核心工具|P1 §7]]（似然如何变成最小二乘）。

> [!question] 卡住了从哪儿看起
> - 📐 Le Cam & Yang, *Asymptotics in Statistics: Some Basic Concepts* — 统计实验与 deficiency 的标准入口，薄
> - 📐 van der Vaart, *Asymptotic Statistics* §9（Le Cam 的实验比较）— 更现代的写法
> - [Müller, Hollmann, Arango, Grabocka, Hutter, *Transformers Can Do Bayesian Inference*](https://arxiv.org/abs/2112.10510) — §4 的 oracle 恒等式就一行，**这门课后半程全靠它**
> - [[notes/deep-learning/01 学习问题的数学表述|DL 01]] — 学习理论的问法，与这里的统计问法对照着看

## 1. 什么叫"科学基础模型"

**基础模型**（foundation model）的通俗定义是"在大规模数据上预训练、能被适配到多种下游任务的模型"。这个定义对数学没用。这门课需要的是：

> **工作定义.** 给定一族任务，每个任务 $\tau$ 是一个统计决策问题；一个**基础模型**是一个**单一**的映射，它以任务的数据为输入、直接输出该任务的解，而**不为每个任务重新训练**。

关键的三个字是"不重新训练"。这把基础模型和"对每个 PDE 训一个网络"区分开来。

**"科学"限定了任务族的来源**：任务由物理/数学模型参数化。三个典型：

| 任务 $\tau$ 是什么 | 数据 | 要输出什么 | 出现在 |
|---|---|---|---|
| 一个交互律 $\phi$ | 粒子轨迹 | $\widehat\phi$ | Part 3 |
| 一个分布 $p$ | i.i.d. 样本 | 采样器 | Part 4 |
| 一个算子 $\mathcal{L}$ 或它的核 | 输入–输出函数对 | $\widehat{\mathcal{L}}$ 或 $\widehat\phi$ | Part 6 |
| 一个线性方程 $Xw=Y$ | prompt 里的 $(x_i,y_i)$ | $\widehat w$ 或 $\widehat y$ | Part 5 |

> [!note] 为什么"controlled settings"是这门课的关键词
> 大纲说 *"learning theory in controlled settings"*、*"mathematically transparent models"*。翻译过来：**只研究那些任务族本身有解析参数化的情形。**
>
> 代价是放弃了对真实 LLM 的解释力。收获是：一旦任务族写成 $\{P_\theta:\theta\in\Theta\}$，"模型学到了什么"就变成一个可以被定理回答的问题——答案通常是"它学到了 $\Theta$ 上的某个先验，并用它做贝叶斯推断"（§4）。

## 2. 任务族作为一族统计实验

**Le Cam 的语言.** 一个**统计实验**是一个三元组
$$\mathcal{E}=\big(\mathcal{X},\mathcal{A},\{P_\theta\}_{\theta\in\Theta}\big),$$
$\mathcal{X}$ 是样本空间，$\{P_\theta\}$ 是一族概率测度。**实验就是"数据里含有多少关于 $\theta$ 的信息"这件事的载体**，独立于你用什么算法。

这门课的每一格都可以写成这个形状。三个例子：

**(a) 交互核.** $\Theta=\{\phi\in\Sigma(\beta,L)\}$，$P_\phi$ 是随机粒子系统在路径空间 $C([0,T];\R^{Nd})$ 上诱导的测度。由 [[P1 随机微分方程与 Fokker–Planck#7-girsanov-与轨迹似然这门课的核心工具|Girsanov]]，这一族测度**互相绝对连续**，密度显式：
$$\frac{\mathrm{d}P_\phi}{\mathrm{d}P_0}=\exp\Big(\int_0^Tb_\phi\cdot\mathrm{d}X-\tfrac12\int_0^T|b_\phi|^2\mathrm{d}s\Big).$$
**这是一个指数族**（以 $\phi$ 的线性泛函为自然参数），于是整套指数族理论可用。

**(b) score.** $\Theta$ 是数据分布 $p$ 的一个非参数类，实验是 $p^{\otimes n}$。

**(c) in-context 回归.** 任务 $w\sim\pi$，实验 $P_w=\mathcal{N}(Xw,\sigma^2I)$。

**元层面（这才是"基础模型"的部分）.** 基础模型面对的不是一个实验，而是**一族实验加上一个任务先验**：
$$\pi\in\mathcal{P}(\Theta),\qquad \text{数据}\ (\theta,D)\sim\pi\otimes P_\theta .$$
预训练损失是对 $\pi$ 取平均的。**于是预训练是一个经验贝叶斯 / 元学习问题，不是一个回归问题**——这个观察是 Part 5 的全部。

> [!tip] 一句话
> **单个任务的层面是频率派的（$\theta$ 固定未知），任务族的层面是贝叶斯的（$\theta\sim\pi$）。**基础模型的全部特殊性都来自这两层的交错。你会在 [[notes/deep-learning/04 统计推断|DL 04]] 里见过这两套语言，这里第一次需要同时用。

## 3. 损失

### 3.1 损失决定可辨识性

朴素的想法是"损失是评价标准，选哪个无所谓，最优解都一样"。**对不适定问题这是错的。**

以交互核为例。三个看起来都合理的损失：

| 损失 | 表达式 | 后果 |
|---|---|---|
| 轨迹似然（连续观测） | $-\int b_\phi\cdot\mathrm{d}X+\frac12\int\lvert b_\phi\rvert^2$ | 误差在 $L^2(\rho_T)$ 下度量，$\rho_T$ 由动力学决定 |
| 差商最小二乘（离散观测） | $\frac1M\sum_k\lvert \frac{\Delta X_k}{\Delta}-b_\phi(X_{t_k})\rvert^2\Delta$ | 同上 $+$ $O(\Delta^q)$ 的离散化偏差 |
| 弱形式 / self-test | $\sup_{\psi}\big(\langle X_T,\psi\rangle-\langle X_0,\psi\rangle-\int\langle b_\phi,\nabla\psi\rangle\big)$ | 不需要估导数，但测试函数族的选择改变可辨识空间 |

三者的**正规算子不同**，于是[[P3 RKHS 与不适定逆问题的正则化#4-学习问题的正规算子与可辨识函数空间|FSOI]] 不同、coercivity 常数不同、率不同。

> [!warning] 这是这门课最容易被忽略的一点
> **"损失"和"误差度量"在良态问题里可以分开谈，在不适定问题里不能。**
>
> 二次损失 $\mathcal{E}(\phi)=\langle\mathcal{L}\phi,\phi\rangle-2\langle\phi,b\rangle+c$ 自带一个内积 $\langle\mathcal{L}\cdot,\cdot\rangle$。这个内积就是问题**自己**给出的几何：它的零空间是数据完全说不出话的方向，它的小特征值方向是数据只能微弱约束的方向。选了损失就等于选了这个几何。
>
> 换句话说：**损失的选择先于函数空间的选择。**这与你在纯数学里的习惯（先固定空间再谈算子）是反过来的。

### 3.2 弱形式损失

这门课里有一格专门讲弱形式（Gao–Lang–Lu, *Self-test loss functions for learning weak-form operators and gradient flows*, 2024）。动机是数值的但结论是数学的：

- **动机**：差商放大噪声。观测 $X_{t_k}+\text{noise}$，差商的噪声是 $O(\text{noise}/\Delta)$——**$\Delta$ 越小越糟**，与统计直觉相反。
- **做法**：对方程配测试函数 $\psi$ 做分部积分，把导数移到 $\psi$ 上。得到的损失只用到 $X$ 本身。
- **代价**：测试函数族 $\Psi$ 有限时，只能辨识"被 $\Psi$ 看到"的那部分 $\phi$。**$\Psi$ 的选择就是正则化的一部分**，不是实现细节。
- **"self-test"** 的意思是让测试函数从数据里自适应地生成，从而使正规算子的谱尽可能好。

## 4. Oracle 基准

"我的估计误差是 $10^{-3}$"这句话没有信息量。这门课全程用三层 oracle 来把它变成有信息量的陈述。

### 4.1 第一层：贝叶斯 oracle（知道先验 $\pi$）

给定任务先验 $\pi$，**最好的可能预测器是贝叶斯后验预测**。这在基础模型语境下有一个干净的定理形式：

> **定理（Müller–Hollmann–Arango–Grabocka–Hutter 2022；prior-data fitted networks）.** 设 $q_\theta(y\mid x,D)$ 是任意模型族，预训练损失取
> $$\ell(\theta)=\mathbb{E}_{D\cup\{(x,y)\}\sim\pi}\big[-\log q_\theta(y\mid x,D)\big].$$
> 则
> $$\ell(\theta)=\mathbb{E}_{x,D}\big[\mathrm{KL}\big(p(\cdot\mid x,D)\,\Vert\,q_\theta(\cdot\mid x,D)\big)\big]+\text{const},$$
> 其中 $p(y\mid x,D)=\int p(y\mid x,\theta')\,\pi(\mathrm{d}\theta'\mid D)$ 是**后验预测分布**，常数是它的期望熵。特别地，若 $p(\cdot\mid x,D)$ 落在模型族里，则全局极小元恰是 $q_{\theta^\star}=p$。

**证明就是 Gibbs 不等式**（交叉熵 $=$ 熵 $+$ KL）。平方损失下同样的论证给出 $\widehat y^\star(D,x)=\mathbb{E}[y\mid D,x]$。

> [!tip] 这一行是 Part 5 的地基
> **"预训练到最优 $=$ 在预训练先验下做贝叶斯推断。"**
>
> 它一次性解释了一堆经验现象：为什么在稀疏线性任务上预训练出来的模型表现得像 Lasso 而不像 OLS；为什么在决策树上预训练出来的模型打得过贪心建树算法（贪心不是贝叶斯最优的，模型是）；为什么 query 与上下文张成空间正交时模型输出 $\approx0$（那正是贝叶斯最优的）。参见 [Garg–Tsipras–Liang–Valiant](https://arxiv.org/abs/2208.01066) 的实验。
>
> 也一次性解释了脆弱性：**贝叶斯最优是相对于预训练先验的**，不是相对于测试任务的。见 [[10 线性 attention 实现梯度下降|10]]。

### 4.2 第二层：最小最大 oracle（知道函数类，不知道先验）

$$\mathcal{R}_n(\Theta)=\inf_{\widehat\theta}\sup_{\theta\in\Theta}\mathbb{E}_\theta\,\ell(\widehat\theta,\theta).$$
这是 [[P2 非参数回归与最小最大率|P2]] 的问法。用在这门课里：Part 3 问"学交互核的最小最大率是不是经典非参数率"（答案：有限 $N$ 时是），Part 4 问扩散模型是不是最小最大最优的密度估计器（答案：在 Besov 类上是），Part 6 问学算子里的核的率（答案：由正规算子的谱衰减决定）。

**两层 oracle 的关系.** 贝叶斯 oracle 依赖 $\pi$，最小最大 oracle 是"最坏的 $\pi$"下的贝叶斯 oracle（在正则条件下，minimax $=$ 最不利先验的 Bayes 风险）。**基础模型的全部优势就来自它用的是真实的 $\pi$ 而不是最坏的 $\pi$**——这是为什么它能打败"对每个任务分别做最优估计"的方法。

### 4.3 第三层：可辨识性 oracle（连无穷数据也做不到的）

前两层都假设"信息足够、只是样本有限"。不适定问题里还有第三种障碍：

> **可辨识性 oracle.** 即使 $n=\infty$、噪声为零，能恢复的也只是 $\phi$ 在 [[P3 RKHS 与不适定逆问题的正则化#4-学习问题的正规算子与可辨识函数空间|FSOI]] 上的投影。

这一层最容易被忽略，但在这门课里最重要——因为它意味着**"我的误差还是很大"可能不是算法的问题，而是问题本身的**。诊断方法是看正规算子的谱：零特征值 $\Rightarrow$ 不可辨识；小特征值 $\Rightarrow$ 可辨识但不稳定。

> [!note] 三层 oracle 的用法
> 拿到一个新问题，按顺序问：
> 1. **它可辨识吗？**（正规算子有零空间吗？）→ 决定你能不能问后面两个问题。
> 2. **最小最大率是多少？**（正规算子的谱怎么衰减？）→ 决定"多少数据够用"。
> 3. **真实的任务先验是什么？**（$\pi$ 集中在哪？）→ 决定基础模型能比逐任务方法好多少。
>
> 这三问是这门课的方法论骨架。**后面每一篇都在回答这三问中的某一个。**

## 5. 三条主线在这个框架里的位置

| | 未知量 | 实验 | 损失 | 主要 oracle |
|---|---|---|---|---|
| Part 2–3 交互律 | 一元核 $\phi$ | 路径测度族（指数族） | 轨迹似然 $=$ $L^2(\rho_T)$ 最小二乘 | 最小最大 $+$ 可辨识性 |
| Part 4 生成 | 分布 $p$ | $p^{\otimes n}$ | denoising score matching | 最小最大 |
| Part 5 ICL | 任务 $w$ 与先验 $\pi$ | $\pi\otimes P_w$ | prompt 上的平方损失 | 贝叶斯 |
| Part 6 算子核 | 一元核 $\phi$ | 输入–输出对 | 二次损失 $+$ 正则 | 三层都要 |

**三条线共用的结构**：未知量是**一元函数**，前向映射**线性于它**，损失**二次**。于是每一处的正规算子都是同一个对象，只是由不同的数据生成。这是把它们放进同一门课的数学理由，也是这套笔记的组织原则。

## 6. 一页速查

| 概念 | 内容 |
|---|---|
| 统计实验 | $(\mathcal{X},\mathcal{A},\{P_\theta\})$；信息的载体，独立于算法 |
| 任务先验 $\pi$ | 基础模型的定义性成分；预训练损失对它取平均 |
| 预训练 $=$ 经验贝叶斯 | 最优预测器 $=$ 后验预测分布（Gibbs 不等式） |
| 损失决定几何 | 二次损失自带内积 $\langle\mathcal{L}\cdot,\cdot\rangle$；FSOI 与 coercivity 都是它的性质 |
| 弱形式损失 | 避开差商噪声，代价是测试函数族限制可辨识空间 |
| 贝叶斯 oracle | 知道 $\pi$；ICL 的基准 |
| 最小最大 oracle | 知道函数类；Part 3/4/6 的基准 |
| 可辨识性 oracle | 无穷数据的上限；FSOI |

## 参考

- Le Cam & Yang, *Asymptotics in Statistics: Some Basic Concepts*, 2nd ed., Springer 2000.
- van der Vaart, *Asymptotic Statistics*, CUP 1998, §9.
- [Müller, Hollmann, Arango, Grabocka, Hutter, *Transformers can do Bayesian inference*](https://arxiv.org/abs/2112.10510), ICLR 2022. §4.1 的 oracle 恒等式。
- [Garg, Tsipras, Liang, Valiant, *What can transformers learn in-context?*](https://arxiv.org/abs/2208.01066), NeurIPS 2022.
- Gao, Lang & Lu, *Self-test loss functions for learning weak-form operators and gradient flows*, 2024. [Fei Lu publications](https://math.jhu.edu/~feilu/publications.html)
- Bommasani et al., *On the opportunities and risks of foundation models*, 2021. 术语来源，非数学。

## Related

- [[index|科学基础模型的数学]]
- [[P1 随机微分方程与 Fokker–Planck]]
- [[P2 非参数回归与最小最大率]]
- [[P3 RKHS 与不适定逆问题的正则化]]
- [[02 attention 作为非局部映射与平均场极限]]
- [[09 ICL 的数学表述：任务分布与贝叶斯预测器]]
