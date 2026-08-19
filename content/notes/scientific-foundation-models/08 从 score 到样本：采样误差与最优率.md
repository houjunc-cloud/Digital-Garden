---
title: 08 从 score 到样本：采样误差与最优率
description: Girsanov 把 score 的 L² 误差转成分布误差；Chen 等与 Benton 等的迭代复杂度；扩散模型作为最小最大最优密度估计器；维数在哪一侧。
tags:
  - scientific-foundation-models
  - generative-models
  - minimax
stage: 🌱 seedling
date: 2026-08-18
---

# 08 从 score 到样本：采样误差与最优率

> 原大纲 10/13, 10/15 是 `TBD`。[[07 score matching 作为统计回归|07]] 说明了 score 估计是一个良态的非参数回归问题；这一篇回答剩下的一半：**score 估准了，生成出来的分布就对吗？**
>
> 答案是一个漂亮的归约：**对，而且代价只是多项式的。**所有的困难被隔离在 $\varepsilon_{\text{score}}$ 里，而那一项由 [[07 score matching 作为统计回归|07]] 完全负责。
>
> 这一篇也是这门课里"分析"最重的一节：Girsanov、数据处理不等式、随机局部化。

> [!question] 卡住了从哪儿看起
> - 📐 [Chen, Chewi, Li, Li, Salim, Zhang, *Sampling is as easy as learning the score*](https://arxiv.org/abs/2209.11215), ICLR 2023 — **标题就是结论**，本篇 §2 的主线
> - 📐 [Benton, De Bortoli, Doucet, Deligiannidis, *Nearly $d$-linear convergence bounds via stochastic localization*](https://arxiv.org/abs/2308.03686), ICLR 2024 — 目前最好的维数依赖
> - [Oko, Akiyama, Suzuki, *Diffusion models are minimax optimal distribution estimators*](https://arxiv.org/abs/2303.01861), ICML 2023 — §4 的率
> - Chewi, *Log-concave sampling*（在线书稿）— 采样理论的背景，写得非常清楚

## 1. 设定与 Girsanov 机器

前向 OU：$\mathrm{d}X_t=-X_t\mathrm{d}t+\sqrt2\,\mathrm{d}B_t$，$q_t=\mathrm{Law}(X_t)$。反向 SDE（[[P1 随机微分方程与 Fokker–Planck#6-时间反演|P1 §6]]）：
$$\mathrm{d}Y_s=\big(Y_s+2\nabla\log q_{T-s}(Y_s)\big)\mathrm{d}s+\sqrt2\,\mathrm{d}\bar B_s,\qquad Y_0\sim q_T .$$

算法做三处替换：(i) $q_T\rightsquigarrow\gamma^d=\mathcal{N}(0,I_d)$；(ii) $\nabla\log q_t\rightsquigarrow s_\theta$；(iii) 连续时间 $\rightsquigarrow$ 网格 $0=t_0<\cdots<t_N=T$。

**分析的骨架（记住这四步，后面所有定理都是它的变奏）：**

1. **Girsanov.** 两个同扩散系数、不同漂移的 SDE，路径测度的 KL 有显式表达
$$\mathrm{KL}(P\Vert Q)=\tfrac14\,\mathbb{E}_P\int_0^T\big\lVert b_t(Y_t)-\widehat b_t(Y_{t_k})\big\rVert^2\mathrm{d}t .$$
2. **拆项.** $b-\widehat b$ 分成**score 误差**（网格点上，$\Rightarrow\varepsilon^2_{\text{score}}$）与**离散化误差**（$\Rightarrow$ $\mathbb{E}\lVert\nabla\log q_{T-t}(Y_t)-\nabla\log q_{T-t_k}(Y_{t_k})\rVert^2$，维数从这里进来）。
3. **初始化.** $\mathrm{KL}(q_T\Vert\gamma^d)\le e^{-2T}\mathrm{KL}(q_0\Vert\gamma^d)$，由高斯的对数 Sobolev 不等式（[[P1 随机微分方程与 Fokker–Planck#54-langevin-与-gibbs-测度|P1 §5.4]]）。**这是全篇唯一用到的泛函不等式，而且它是高斯的，白送的。**
4. **数据处理 $+$ Pinsker.** 路径测度的 KL $\ge$ 末端边际的 KL；再转 TV。

> [!warning] Girsanov 这一步不是簿记
> 定理要求随机指数是**真鞅**，而 Novikov 条件在只有 $L^2$ score 假设下拿不到。文献里的处理是截断 $+$ 局部化 $+$ KL 的下半连续性。**在讲义里值得点明这是一个真实的技术步骤**，不是形式操作。

## 2. 主定理

> **定理（Chen–Chewi–Li–Li–Salim–Zhang, ICLR 2023, Thm 2）.** 假设
> - **A1**：对所有 $t\ge0$，$\nabla\log q_t$ 是 $L$-Lipschitz；
> - **A2**：$\mathfrak{m}_2^2:=\mathbb{E}_q\lVert\cdot\rVert^2<\infty$；
> - **A3**：$\mathbb{E}_{q_{kh}}\lVert s_{kh}-\nabla\log q_{kh}\rVert^2\le\varepsilon^2_{\text{score}}$ 对每个 $k$。
>
> 则对步长 $h=T/N\lesssim1/L$，DDPM 输出 $p_T$ 满足
> $$\mathrm{TV}(p_T,q)\ \lesssim\ \sqrt{\mathrm{KL}(q\Vert\gamma^d)}\,e^{-T}\;+\;\big(L\sqrt{dh}+L\mathfrak{m}_2h\big)\sqrt T\;+\;\varepsilon_{\text{score}}\sqrt T .$$
> 特别地，若 $\mathrm{KL}(q\Vert\gamma^d)\le\mathrm{poly}(d)$、$\mathfrak{m}_2\lesssim\sqrt d$，则达到 $\mathrm{TV}\le\varepsilon$ 只需 $\varepsilon_{\text{score}}\le\widetilde O(\varepsilon)$ 与
> $$N=\widetilde\Theta\big(L^2d/\varepsilon^2\big).$$

**缺席的假设值得单独列出**：没有对数凹性、没有任何泛函不等式（LSI/Poincaré）、没有紧支撑、没有 $L^\infty$ score 精度、没有单峰性、没有等周。

> [!tip] 这就是标题的意思
> $\widetilde\Theta(L^2d/\varepsilon^2)$ **与对数凹情形下 Langevin Monte Carlo 的最好结果相同**——但这里不假设对数凹。
>
> 也就是说：**生成建模的全部统计与计算困难被完整地隔离在 $\varepsilon_{\text{score}}$ 这一项里。**采样这一侧没有任何隐藏的难度。
>
> 与 [[07 score matching 作为统计回归#6-fisher-散度的盲点与它如何被修复|07 §6]] 对照着读：单尺度 Fisher 散度需要等周常数才能控制分布误差，多尺度 $+$ Girsanov 不需要。**这条定理就是那个"预条件"效果的定量形式。**

**改进：近似线性于 $d$.**

> **定理（Benton–De Bortoli–Doucet–Deligiannidis, ICLR 2024, Thm 1 + Cor 1）.** 只假设 $\mathbb{E}[X_0]=0$、$\mathrm{Cov}=I_d$（**有限二阶矩，无 Lipschitz、无光滑性**）与积分形式的 score 误差，则
> $$\mathrm{KL}(q_\delta\Vert p_{t_N})\ \lesssim\ \varepsilon^2_{\text{score}}+\kappa^2dN+\kappa dT+d\,e^{-2T},$$
> 取 $T=\frac12\log(d/\varepsilon^2_{\text{score}})$ 得迭代复杂度
> $$N=\widetilde O\Big(\frac{d\log^2(1/\delta)}{\varepsilon^2}\Big),$$
> 改进了此前的 $\widetilde O(d^2/\varepsilon^2)$。

**机制值得记住**：他们把扩散过程在时间变换 $t(s)=\frac12\log(1+s^{-1})$ 下认成**随机局部化**（stochastic localization），得到关于后验协方差 $\Sigma_t=\mathrm{Cov}(X_0\mid X_t)$ 的微分恒等式
$$\frac{\sigma_t^3}{2\dot\sigma_t}\frac{\mathrm{d}}{\mathrm{d}t}\mathbb{E}[\Sigma_t]=\mathbb{E}[\Sigma_t^2].$$
由 Tweedie 的二阶版本，$\nabla^2\log q_t$ 是 $\Sigma_t$ 的仿射函数，于是这条恒等式**在期望意义下**控制了离散化误差——不需要逐点的 Lipschitz 界。**超线性的 $d$ 依赖正是从那些逐点界来的。**

## 3. ODE 采样器：换来什么，代价是什么

概率流 ODE $\dot Y_s=Y_s+\nabla\log q_{T-s}(Y_s)$ 有相同的一维边际，但分析完全不同。

**(a) Girsanov 原则上不可用.** 两个不同向量场的 ODE 路径测度互相奇异，$\mathrm{KL}=\infty$。**SDE 的分析之所以成立，恰恰因为噪声让 $P\ll Q$。**于是 ODE 只能直接在边际上工作（输运/Grönwall/耦合），结论通常是 TV 或 $W_p$ 而非 KL。

**(b) $L^2$ 精度不够了.** ODE 流映射的稳定性由 Jacobian $\nabla s$ 控制，Grönwall 给出 $\exp(\int\mathrm{Lip})$ 的放大。于是需要新假设：

- [Chen–Chewi–Lee–Li–Lu–Salim (NeurIPS 2023)](https://arxiv.org/abs/2305.11798)：额外要求 **score 估计本身 $L$-Lipschitz**，并且必须加 **corrector**（每个噪声水平上做 Langevin 步）重新注入随机性，否则"动力学不收缩，小误差迅速累积放大"。结论：$\widetilde\Theta(L^2\sqrt d/\varepsilon)$。
- [Li–Wei–Chi–Chen (2024)](https://arxiv.org/abs/2408.02320)：纯确定性 DDIM 型，额外假设 **Jacobian 误差** $\varepsilon_{\text{Jacobi}}$ 小：
$$\mathrm{TV}(q_1,p_1)\le C\frac{d\log^4T}{T}+C\sqrt{d\log^4T}\,\varepsilon_{\text{score}}+Cd(\log^2T)\,\varepsilon_{\text{Jacobi}}.$$

**(c) 权衡，说清楚.** 离散化误差 SDE 是 $O(1/\sqrt N)$、ODE 是 $O(1/N)$，于是步数 $\widetilde O(d/\varepsilon^2)$ vs $\widetilde O(d/\varepsilon)$。

> [!warning] ODE 的优势是有代价的，而且代价在统计框架之外
> $\varepsilon_{\text{Jacobi}}$ 是 **score 的导数**的误差，而训练目标（DSM）**只控制 score 本身的 $L^2$ 误差**，对它的导数一言不发。而且没有任何关于 $\nabla s$ 的最小最大理论。
>
> **这是一个诚实的理论缺口，值得在讲义里标出来**：ODE 采样器更快，但它的保证依赖于一个训练不控制、统计学也没研究过的量。反过来，SDE 采样器是自纠错的（噪声通过半群收缩误差），所以不需要 Jacobian 控制。

**ODE 的附带好处**：$\nabla\log q_t$ Lipschitz 时流映射是微分同胚，生成的分布与 $\gamma^d$ 等价，且可用瞬时变量替换公式精确计算似然（连续正规化流）。SDE 采样器没有这个。

## 4. 端到端：扩散模型是最小最大最优的密度估计器

把 [[07 score matching 作为统计回归|07]] 的统计与 §2 的分析接起来。

> **定理（Oko–Akiyama–Suzuki, ICML 2023）.** 设 $p_0$ 支撑在 $[-1,1]^d$、上下有界，且属于 Besov 球 $B^s_{p,q}$（允许**不连续**密度），并有边界光滑性假设。用适当规模的 ReLU 网络类做经验 DSM，配合 early stopping，则
> $$\mathbb{E}\big[\mathrm{TV}(X_0,\widehat Y)\big]\ \lesssim\ n^{-\frac{s}{2s+d}}\log^8n,$$
> 且 $\inf_{\widehat\mu}\sup_{p\in B^s_{p,q}}\mathbb{E}[\mathrm{TV}(\widehat\mu,p)]\gtrsim n^{-\frac{s}{2s+d}}$。$W_1$ 下的率是 $n^{-\frac{s+1-\delta}{d+2s}}$。

$n^{-s/(2s+d)}$ 就是 $L^1$ 下密度估计的经典非参数率。**于是"DSM 训练 $+$ 反向 SDE 采样"整体上是一个最小最大最优的密度估计器**，不比小波阈值估计器差。

**自动适应低维结构.** 同一篇的 Thm 6.4：若数据实际落在 $d'$ 维结构上，**同一个估计量**（不需要知道 $d'$）达到 $W_1\lesssim n^{-(s+1-\delta)/(d'+2s)}$。相关工作：[Tang–Yang (AISTATS 2024)](https://proceedings.mlr.press/v238/) 在流形假设下给出最小最大最优率；[Li–Yan (NeurIPS 2024)](https://arxiv.org/abs/2405.14861) 从**采样侧**给出只依赖内蕴维数 $k$ 的迭代复杂度 $O(k^4/\varepsilon^2)$，对环境维数只有对数依赖。

## 5. 维数住在哪一侧

这是本篇最该带走的判断。

| 侧 | 维数依赖 | 来源 |
|---|---|---|
| **采样（分析）** | **多项式，现在是线性** $N=\widetilde O(d/\varepsilon^2)$ | (i) 初始化 $\mathrm{KL}(q_T\Vert\gamma^d)\lesssim de^{-2T}$，只要 $T=O(\log d)$；(ii) 离散化，$\mathbb{E}\lVert\nabla^2\log q_t\rVert_F^2\lesssim d/(1\wedge t)$；(iii) 二阶矩 $\mathfrak{m}_2^2\asymp d$ |
| **学习（统计）** | **指数** $n\asymp\varepsilon^{-(2s+d)/s}$ | 非参数 score/密度估计的最小最大下界（Wibisono 等 Thm 3；Oko 等 Prop 5.2） |

> [!tip] 结论
> **扩散模型里指数级的维数诅咒完全是"非参数 score 估计"这件事的性质，在采样分析里一点也没有。**
>
> "Sampling is as easy as learning the score" 是一个**归约**：它把所有困难集中到 $\varepsilon_{\text{score}}$。于是逃离维数诅咒**必须**靠对 $p_{\text{data}}$ 的结构假设（低内蕴维数、流形、组合性），不可能靠改采样器。
>
> 这与 [[05 学习交互核的最小最大率#5-与其它率的对照|05 §5]] 那张表是同一个教训的两次出现：**率由问题的结构决定，不由算法决定。**

**一个补充警告**：$\varepsilon^2_{\text{score}}$ 是 $t\in[t_0,T]$ 上 $L^2(q_t)$ 误差的平均，而 $t\downarrow0$ 端以 $t^{-(d+2)/2}$ 发散（[[07 score matching 作为统计回归#4-最小最大率|07 §4]]）。**early stopping 不是工程技巧，是让这个复合界有限的必要条件。**

## 6. 一页速查

| 结论 | 内容 |
|---|---|
| 分析骨架 | Girsanov $\to$ 拆 score/离散化 $\to$ 高斯 LSI 初始化 $\to$ 数据处理 $+$ Pinsker |
| Chen 等 | $\mathrm{TV}\lesssim\sqrt{\mathrm{KL}}e^{-T}+(L\sqrt{dh}+L\mathfrak{m}_2h)\sqrt T+\varepsilon_{\text{score}}\sqrt T$；$N=\widetilde\Theta(L^2d/\varepsilon^2)$ |
| 缺席的假设 | 对数凹、泛函不等式、紧支撑、$L^\infty$ score、单峰 |
| Benton 等 | 随机局部化；$N=\widetilde O(d/\varepsilon^2)$，只要有限二阶矩 |
| ODE | 步数 $\widetilde O(d/\varepsilon)$，但要 Jacobian 误差控制（训练不管、统计无理论） |
| 端到端率 | $\mathrm{TV}\lesssim n^{-s/(2s+d)}$，**最小最大最优**（Besov 类） |
| 低维适应 | 同一估计量自动达到 $d'$ 维的率 |
| 维数在哪 | 采样侧线性；学习侧指数 |
| early stopping | 让 $\int_{t_0}^T\varepsilon^2_{\text{score}}(t)\mathrm{d}t$ 有限的必要条件 |

## 参考

- [Chen, Chewi, Li, Li, Salim, Zhang, *Sampling is as easy as learning the score*](https://arxiv.org/abs/2209.11215), ICLR 2023.
- [Benton, De Bortoli, Doucet, Deligiannidis, *Nearly $d$-linear convergence bounds for diffusion models via stochastic localization*](https://arxiv.org/abs/2308.03686), ICLR 2024.
- Chen, Lee, Lu, *Improved analysis of score-based generative modeling*, ICML 2023; [arXiv:2211.01916](https://arxiv.org/abs/2211.01916).
- Chen, Chewi, Lee, Li, Lu, Salim, *The probability flow ODE is provably fast*, NeurIPS 2023; [arXiv:2305.11798](https://arxiv.org/abs/2305.11798).
- Li, Wei, Chi, Chen, *A sharp convergence theory for the probability flow ODEs of diffusion models*; [arXiv:2408.02320](https://arxiv.org/abs/2408.02320).
- [Oko, Akiyama, Suzuki, *Diffusion models are minimax optimal distribution estimators*](https://arxiv.org/abs/2303.01861), ICML 2023.
- Tang & Yang, *Adaptivity of diffusion models to manifold structures*, AISTATS 2024.
- Li & Yan, *Adapting to unknown low-dimensional structures in score-based diffusion models*, NeurIPS 2024; [arXiv:2405.14861](https://arxiv.org/abs/2405.14861).
- Chewi, *Log-Concave Sampling*（在线书稿）— 采样理论的系统背景。

## Related

- [[index|科学基础模型的数学]]
- [[07 score matching 作为统计回归]]
- [[P1 随机微分方程与 Fokker–Planck]]
- [[05 学习交互核的最小最大率]]
- [[notes/deep-learning/17 扩散模型与 flow matching|DL 17 扩散模型与 flow matching]]
