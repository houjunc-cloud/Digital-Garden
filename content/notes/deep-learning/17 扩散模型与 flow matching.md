---
title: 17 扩散模型与 flow matching
description: 前向 SDE、Anderson 时间反演定理、score matching 恒等式、probability flow ODE、CFG、rectified flow。
tags:
  - deep-learning
  - generative-models
  - sde
stage: 🌿 budding
date: 2026-08-14
---

# 17 扩散模型与 flow matching

> Feng Week 10 讲 diffusion 与 "more ELBO"，参考 Bishop §19–20。这是**整门课里数学最丰富的一个题目**，值得完整展开：前向过程是一个 Ornstein–Uhlenbeck 型 SDE，反向过程由 Anderson 的时间反演定理给出，训练目标由 Hyvärinen/Vincent 的两个恒等式变成可算的回归，采样是 ODE/SDE 数值积分。**这里的每一步都是干净的随机分析。**
>
> 本篇同时补上原课完全没有的 **flow matching / stochastic interpolants** —— 2023 年后的统一框架，且比 diffusion 简洁得多。
>
> 前置：[[14 生成建模的统一视角]]、[[15 变分自编码器]]（ELBO）、基本的 Itô 微积分。

> [!question] 卡住了从哪儿看起
> - [MIT 6.S184 讲义](https://diffusion.csail.mit.edu/) — **首选**，SDE / ODE / flow matching 一条线讲下来
> - [Calvin Luo, *Understanding Diffusion Models: A Unified Perspective*](https://arxiv.org/abs/2208.11970) — ELBO 到 score matching 的**每一步代数都写全了**，卡在推导上就看这个
> - [Yang Song 的 score-based 博客](https://yang-song.net/blog/2021/score/) — Score-SDE 作者本人的讲法，图很好
> - [Lipman 等, *Flow Matching Guide and Code*](https://arxiv.org/abs/2412.06264) — flow matching 的官方长教程，含代码
> - [Sander Dieleman 的 diffusion 系列](https://sander.ai/) — 直觉性讨论，品味很好

## 1. 前向过程

**离散（DDPM, Ho–Jain–Abbeel 2020）.** 给定方差调度 $\beta_1,\dots,\beta_T$，
$$q(x_t|x_{t-1})=\mathcal{N}\big(\sqrt{1-\beta_t}\,x_{t-1},\ \beta_tI\big).$$

**闭式边缘.** 令 $\alpha_t=1-\beta_t$，$\bar\alpha_t=\prod_{s\le t}\alpha_s$。则
$$\boxed{q(x_t|x_0)=\mathcal{N}\big(\sqrt{\bar\alpha_t}\,x_0,\ (1-\bar\alpha_t)I\big)}\quad\Longleftrightarrow\quad x_t=\sqrt{\bar\alpha_t}x_0+\sqrt{1-\bar\alpha_t}\,\epsilon,\ \ \epsilon\sim\mathcal{N}(0,I).$$

*证明.* 归纳 + 两个独立高斯之和仍高斯。$\square$

**这个闭式是全部工程可行性的来源**：可以直接跳到任意时刻 $t$ 采样，无需模拟整条链。

**连续（Song et al. 2021, Score-SDE）.** $T\to\infty$ 的极限是 SDE
$$dx=f(x,t)\,dt+g(t)\,dw.$$

两个标准选择：

| 名称 | SDE | 说明 |
|---|---|---|
| **VP (variance preserving)** | $dx=-\frac12\beta(t)x\,dt+\sqrt{\beta(t)}\,dw$ | DDPM 的连续极限；OU 过程，方差守恒 |
| **VE (variance exploding)** | $dx=\sqrt{\tfrac{d\sigma^2(t)}{dt}}\,dw$ | SMLD/NCSN；纯扩散，方差发散 |

**VP 就是 Ornstein–Uhlenbeck 过程**，平稳分布 $\mathcal{N}(0,I)$，指数遍历。所以 $t\to\infty$ 时 $p_t\to\mathcal{N}(0,I)$，**与 $p_0$ 无关**——这正是我们要的"把数据推成噪声"。

## 2. 时间反演

**定理（Anderson 1982）.** 设 $x_t$ 满足 $dx=f(x,t)dt+g(t)dw$，$p_t$ 为其边缘密度。则反向时间过程 $\bar x_s:=x_{T-s}$ 满足
$$\boxed{d\bar x=\Big[-f(\bar x,\bar t)+g(\bar t)^2\,\nabla_{x}\log p_{\bar t}(\bar x)\Big]ds+g(\bar t)\,d\bar w},\qquad \bar t=T-s,$$
$\bar w$ 是反向的 Wiener 过程。

*证明梗概.* 前向的 Fokker–Planck 方程
$$\partial_tp_t=-\nabla\cdot(fp_t)+\frac{g^2}{2}\Delta p_t.$$
把 $\Delta p_t=\nabla\cdot(p_t\nabla\log p_t)$ 代入：
$$\partial_tp_t=-\nabla\cdot\Big[\big(f-\tfrac{g^2}{2}\nabla\log p_t\big)p_t\Big]+\frac{g^2}{2}\Delta p_t\cdot 0 + \ldots$$
更干净的做法：把 FP 方程在时间反演 $t\mapsto T-s$ 下改写，配平漂移与扩散项，验证反向 SDE 的 FP 方程给出同样的 $\{p_t\}$。$\square$

> [!tip] 这个定理是整个领域的支点
> **它说：只要知道每个时刻的 score $\nabla_x\log p_t(x)$，就能把噪声变回数据。**
>
> 生成建模于是变成：**估计 score 函数**。而 score 有 [[14 生成建模的统一视角#2-分类如何回避配分函数|绕过配分函数]]的性质——不需要归一化密度。这两点合起来就是 diffusion 模型的全部思想。

**Probability flow ODE（Song et al. 2021）.** 存在一个**确定性**的 ODE，其边缘分布与 SDE 完全相同：
$$\boxed{\frac{dx}{dt}=f(x,t)-\frac12g(t)^2\nabla_x\log p_t(x)}$$

*证明.* 两者的 Fokker–Planck / 连续性方程给出相同的 $\partial_tp_t$：SDE 的 $-\nabla\cdot(fp)+\frac{g^2}2\Delta p$ 与 ODE 的 $-\nabla\cdot\big((f-\frac{g^2}2\nabla\log p)p\big)=-\nabla\cdot(fp)+\frac{g^2}{2}\nabla\cdot(p\nabla\log p)=-\nabla\cdot(fp)+\frac{g^2}2\Delta p$。相等。$\square$

**三个后果：**
1. **确定性采样**（DDIM 就是它的一个离散化），可以用高阶 ODE 求解器加速。
2. **精确似然**：ODE 是一个连续归一化流，
 $$\log p_0(x_0)=\log p_T(x_T)+\int_0^T\nabla\cdot v(x_t,t)\,dt$$
 （散度用 Hutchinson 迹估计）。**于是 diffusion 可以报告精确的 bits/dim。**
3. **潜空间是可逆的**：同一个噪声给出同一张图，允许插值与编辑。

## 3. Score matching {#3-score-matching}

**目标（理想）：**
$$\min_\theta\ \mathbb{E}_{p(x)}\big\|s_\theta(x)-\nabla_x\log p(x)\big\|^2.$$
不可算（不知道 $\nabla\log p$）。两个恒等式救场。

### 3.1 Hyvärinen 的恒等式（1930 年代分部积分的重新发现）

**定理（Hyvärinen 2005）.** 在适当的衰减条件下（$p(x)s_\theta(x)\to0$ 当 $\|x\|\to\infty$），
$$\mathbb{E}_{p}\big\|s_\theta-\nabla\log p\big\|^2 = 2\,\mathbb{E}_{p}\Big[\operatorname{tr}\big(\nabla_xs_\theta(x)\big)+\tfrac12\|s_\theta(x)\|^2\Big]+\text{const}.$$

*证明.* 展开平方，交叉项
$$-2\mathbb{E}_p[\langle s_\theta,\nabla\log p\rangle]=-2\int\langle s_\theta,\nabla p\rangle=2\int p\,\nabla\cdot s_\theta$$
（分部积分，边界项为 0）。$\square$

**右边只依赖 $p$ 的样本，可算。**但需要 $\operatorname{tr}(\nabla s_\theta)$ —— **Jacobian 的迹，对高维网络代价 $O(D)$ 次反向传播，不可行**。

### 3.2 去噪 score matching（Vincent 2011）—— 实际用的那个

**定理.** 设 $q_\sigma(\tilde x|x)=\mathcal{N}(x,\sigma^2I)$，$q_\sigma(\tilde x)=\int q_\sigma(\tilde x|x)p(x)dx$。则
$$\mathbb{E}_{q_\sigma(\tilde x)}\big\|s_\theta(\tilde x)-\nabla_{\tilde x}\log q_\sigma(\tilde x)\big\|^2 = \mathbb{E}_{p(x)}\mathbb{E}_{q_\sigma(\tilde x|x)}\big\|s_\theta(\tilde x)-\nabla_{\tilde x}\log q_\sigma(\tilde x|x)\big\|^2+\text{const}.$$

*证明.* 展开两边的交叉项，关键一步：
$$\mathbb{E}_{q_\sigma(\tilde x)}\big[\langle s_\theta(\tilde x),\nabla\log q_\sigma(\tilde x)\rangle\big]=\int\langle s_\theta(\tilde x),\nabla q_\sigma(\tilde x)\rangle d\tilde x=\int\!\!\int\langle s_\theta(\tilde x),\nabla_{\tilde x}q_\sigma(\tilde x|x)\rangle p(x)\,dx\,d\tilde x,$$
后者恰是右边的交叉项。$\square$

**而 $\nabla_{\tilde x}\log q_\sigma(\tilde x|x)=-\frac{\tilde x-x}{\sigma^2}=-\frac{\epsilon}{\sigma}$ 是已知的！**

**于是目标变成一个纯回归：**
$$\boxed{\mathcal{L}=\mathbb{E}_{x_0,\,t,\,\epsilon}\Big[\big\|\epsilon_\theta(x_t,t)-\epsilon\big\|^2\Big],\qquad x_t=\sqrt{\bar\alpha_t}x_0+\sqrt{1-\bar\alpha_t}\,\epsilon}$$

**网络预测被加的噪声。**这就是 DDPM 的训练算法——**四行代码**：

```python
t   = randint(1, T)
eps = randn_like(x0)
xt  = sqrt(abar[t]) * x0 + sqrt(1 - abar[t]) * eps
loss = ((eps_theta(xt, t) - eps) ** 2).mean()
```

**score 与 $\epsilon$ 的换算**：$s_\theta(x_t,t)=-\dfrac{\epsilon_\theta(x_t,t)}{\sqrt{1-\bar\alpha_t}}$。

> [!note] 为什么 diffusion 好训练
> **它是一个监督回归问题。**没有 [[16 生成对抗网络#5-训练动力学为什么-gan-振荡|鞍点]]、没有 [[15 变分自编码器#5-posterior-collapse|posterior collapse]]、没有配分函数。目标是凸的（关于网络输出）、梯度是无偏的、损失值与质量单调相关。
>
> **这就是 diffusion 取代 GAN 的全部原因。**架构（U-Net / DiT）反而是次要的。

**Tweedie 公式（换个角度看同一件事）.** 对 $\tilde x=x+\sigma\epsilon$，
$$\mathbb{E}[x|\tilde x]=\tilde x+\sigma^2\nabla_{\tilde x}\log q_\sigma(\tilde x).$$
**即：score 等价于最优去噪器。**"预测噪声"、"预测干净图像"、"预测 score"三者线性等价。实践中用哪个参数化影响损失权重，从而影响样本质量（Karras et al. 2022 的 EDM 对此有系统研究，提出 $v$-预测与预条件化）。

## 4. DDPM 的 ELBO {#4-ddpm-的-elbo}

把 diffusion 看成一个 $T$ 层的层级 VAE，编码器**固定**（就是加噪），解码器是 $p_\theta(x_{t-1}|x_t)$。

$$-\log p_\theta(x_0)\le \mathbb{E}_q\Big[\underbrace{D_{\mathrm{KL}}(q(x_T|x_0)\|p(x_T))}_{L_T,\ \text{常数}}+\sum_{t=2}^{T}\underbrace{D_{\mathrm{KL}}\big(q(x_{t-1}|x_t,x_0)\,\|\,p_\theta(x_{t-1}|x_t)\big)}_{L_{t-1}}\underbrace{-\log p_\theta(x_0|x_1)}_{L_0}\Big].$$

**关键：$q(x_{t-1}|x_t,x_0)$ 有闭式**（高斯的 Bayes 公式）：
$$q(x_{t-1}|x_t,x_0)=\mathcal{N}\big(\tilde\mu_t(x_t,x_0),\ \tilde\beta_tI\big),\quad \tilde\mu_t=\frac{\sqrt{\bar\alpha_{t-1}}\beta_t}{1-\bar\alpha_t}x_0+\frac{\sqrt{\alpha_t}(1-\bar\alpha_{t-1})}{1-\bar\alpha_t}x_t,\quad\tilde\beta_t=\frac{1-\bar\alpha_{t-1}}{1-\bar\alpha_t}\beta_t.$$

两个高斯的 KL 有闭式，代入化简后 **$L_{t-1}$ 正比于 $\|\epsilon-\epsilon_\theta(x_t,t)\|^2$**。

**Ho et al. 的观察**：**去掉时间相关的权重系数**（即用均匀权重 $\mathcal{L}_{\text{simple}}$）反而效果更好。于是实际训练目标不是 ELBO，是一个**重加权**的 ELBO。

> 这是一个值得注意的模式：**理论给出正确的目标族，实践在族内挑一个不同的成员。**Kingma et al. (2021, VDM) 证明不同权重对应不同的噪声调度参数化，且在连续时间下 ELBO 只依赖信噪比的端点值——一个漂亮的不变性结果。

## 5. Flow matching：更简洁的框架

**动机**：diffusion 的推导绕了一大圈（SDE → 时间反演 → score matching → 重加权 ELBO）。**能不能直接学那个 ODE？**

### 5.1 连续性方程

给定概率路径 $\{p_t\}_{t\in[0,1]}$，$p_0=\mathcal{N}(0,I)$，$p_1=p_{\mathrm{data}}$。想找速度场 $u_t$ 使
$$\partial_tp_t+\nabla\cdot(p_tu_t)=0\qquad(\textbf{连续性方程}).$$

若知道 $u_t$，采样就是解 ODE $\dot x=u_t(x)$ 从 $x_0\sim\mathcal{N}(0,I)$ 积到 $t=1$。

**Flow matching 目标（理想）：**
$$\mathcal{L}_{\mathrm{FM}}=\mathbb{E}_{t,\,x\sim p_t}\big\|v_\theta(x,t)-u_t(x)\big\|^2.$$
不可算（不知道 $u_t$）。

### 5.2 条件 flow matching（关键定理）

**定理（Lipman et al. 2023）.** 设 $p_t(x)=\int p_t(x|x_1)q(x_1)dx_1$，其中每个**条件**路径 $p_t(\cdot|x_1)$ 有已知的条件速度场 $u_t(x|x_1)$。定义
$$\mathcal{L}_{\mathrm{CFM}}=\mathbb{E}_{t,\,x_1\sim q,\,x\sim p_t(\cdot|x_1)}\big\|v_\theta(x,t)-u_t(x|x_1)\big\|^2.$$
则
$$\nabla_\theta\mathcal{L}_{\mathrm{FM}}=\nabla_\theta\mathcal{L}_{\mathrm{CFM}}.$$

*证明.* 展开两者，常数项不同，交叉项相同：
$$\mathbb{E}_{p_t}\langle v_\theta,u_t\rangle=\int p_t(x)\Big\langle v_\theta(x),\frac{\int u_t(x|x_1)p_t(x|x_1)q(x_1)dx_1}{p_t(x)}\Big\rangle dx=\mathbb{E}_{x_1,x}\langle v_\theta,u_t(x|x_1)\rangle,$$
用到边缘速度场的表示 $u_t(x)=\frac{1}{p_t(x)}\int u_t(x|x_1)p_t(x|x_1)q(x_1)dx_1$（这本身是把条件的连续性方程对 $x_1$ 积分得到的）。$\square$

**这与 §3.2 的去噪 score matching 是同一个论证。**都是"边缘的难目标 = 条件的易目标 + 常数"。

### 5.3 最简单的选择：线性插值

取
$$x_t=(1-t)x_0+tx_1,\qquad x_0\sim\mathcal{N}(0,I),\ x_1\sim p_{\mathrm{data}}.$$
则条件速度是**常数**：
$$u_t(x_t|x_0,x_1)=x_1-x_0.$$

**训练目标：**
$$\boxed{\mathcal{L}=\mathbb{E}_{t\sim U[0,1],\,x_0\sim\mathcal{N},\,x_1\sim p_{\mathrm{data}}}\Big\|v_\theta\big((1-t)x_0+tx_1,\ t\big)-(x_1-x_0)\Big\|^2}$$

**三行。没有 $\bar\alpha_t$、没有噪声调度、没有 ELBO 推导。**

**这就是 rectified flow（Liu et al. 2023）/ stochastic interpolants（Albergo–Vanden-Eijnden 2023）/ conditional flow matching（Lipman et al. 2023）——三个独立同期工作，本质相同。**

> [!tip] 为什么这被广泛接受为"正确"的表述
> - **直线路径**使 ODE 的解轨迹接近直线 $\Rightarrow$ **少步采样误差小**（Euler 法对直线是精确的）。DDPM 需要 1000 步，rectified flow 用 20–50 步质量相当，蒸馏后 1–4 步。
> - **无需噪声调度调参**——diffusion 的 $\beta_t$ 调度是一个恼人的超参。
> - **可以在任意两个分布之间**插值（不必一端是高斯），于是统一了生成、图像翻译、超分等任务。
> - **理论最干净**：只需要连续性方程，不需要 Itô 微积分。
>
> **实际采用**：Stable Diffusion 3、FLUX、Movie Gen 等 2024 年后的模型全部用 flow matching。**Diffusion 的 SDE 表述现在主要是历史与理论价值。**

**Reflow.** 用训练好的模型生成 $(x_0,x_1)$ 配对，再用这些配对重训——迭代地把轨迹"拉直"。理论上 $k$ 次 reflow 后轨迹是分片直线，可以一步采样。

**与最优传输的关系**：若 $(x_0,x_1)$ 按最优传输耦合而非独立采样，轨迹交叉最少，路径最直。**Minibatch OT-CFM**（Tong et al. 2024）在小批量内解一个最优传输问题（用 Sinkhorn 或匈牙利算法）来近似这个耦合，进一步提升少步质量。**这是最优传输在生成模型中最成功的应用**，比 [[16 生成对抗网络#4-wgan换度量|WGAN]] 那次成功得多。

## 6. 采样器

| 方法 | 类型 | 步数 | 说明 |
|---|---|---|---|
| **DDPM ancestral** | SDE | 1000 | 原始，随机 |
| **DDIM** | ODE | 20–100 | probability flow ODE 的一阶离散；确定性 |
| **DPM-Solver / DPM-Solver++** | ODE | 10–20 | 利用半线性结构做指数积分器 + 高阶 Taylor |
| **Heun / EDM sampler** | ODE | 20–40 | 二阶 Runge–Kutta；Karras et al. 的系统研究 |
| **UniPC / DEIS** | ODE | 5–10 | 预测–校正、多步法 |
| **一致性模型** | 蒸馏 | 1–4 | 学 ODE 的解算子 $f(x_t,t)\mapsto x_0$ |
| **对抗蒸馏 (ADD/LADD)** | 蒸馏 | 1–4 | 加 GAN 损失提升单步质量 |

**DPM-Solver 的技巧**：probability flow ODE 有**半线性**结构
$$\frac{dx}{dt}=a(t)x+b(t)\,\epsilon_\theta(x,t).$$
线性部分可以**精确积分**（变易常数法），只对非线性部分做数值近似。这把误差阶数提高了，是"利用问题结构而非通用求解器"的典范。**这是数值分析在深度学习中最漂亮的应用之一。**

**一致性模型（Song et al. 2023）.** 学一个函数 $f_\theta(x_t,t)$ 满足**自洽条件**：对同一条 ODE 轨迹上的任意两点，$f_\theta(x_t,t)=f_\theta(x_{t'},t')=x_0$。训练用相邻时刻的一致性损失。于是**一步**就能从噪声到数据。

## 7. 条件生成与引导

见 [[14 生成建模的统一视角#7-条件生成与引导]] 的一般讨论。这里补 diffusion 特有的：

**CFG 的实现**：训练时以 10% 概率把条件替换为空标记 $\varnothing$，推理时
$$\tilde\epsilon=\epsilon_\theta(x_t,t,\varnothing)+w\big(\epsilon_\theta(x_t,t,c)-\epsilon_\theta(x_t,t,\varnothing)\big).$$
典型 $w=3\sim8$。代价：**每步两次前向**（可以 batch 起来）。

**副作用**：大 $w$ 导致过饱和、纹理异常、多样性坍缩。缓解：动态阈值（Imagen）、CFG 调度（只在中间时间步用）、CFG 蒸馏。

**其他控制**：
- **ControlNet**：复制 encoder 分支，用零初始化的卷积注入控制信号（边缘图、姿态、深度）。零初始化保证训练初期不破坏预训练模型。
- **图像编辑**：SDEdit（加噪到中途再去噪）、DDIM inversion（用确定性 ODE 反向求出噪声，再修改条件重新生成）、Prompt-to-Prompt（操纵 cross-attention map）。
- **Inpainting**：每步把已知区域替换成前向加噪的真值（RePaint）。

## 8. 潜在扩散与架构

**Latent Diffusion / Stable Diffusion（Rombach et al. 2022）.** 先用 VAE（带 GAN 损失的自编码器，见 [[15 变分自编码器]]）把 $512\times512\times3$ 压到 $64\times64\times4$，diffusion 在潜空间做。

**计算量降低 $\approx 48$ 倍**（空间 $64$ 倍，通道略增）。**这是文生图从研究走向普及的直接技术原因。**

**架构演进**：
- **U-Net + cross-attention**（SD 1.x/2.x）：卷积骨干，在若干分辨率插入 self/cross-attention。
- **DiT（Diffusion Transformer, Peebles–Xie 2023）**：纯 Transformer，把潜图切 patch，时间与条件通过 **adaLN-zero**（自适应 LayerNorm，零初始化）注入。**遵守 [[09 Scaling laws|scaling law]]**，这是它取代 U-Net 的关键——U-Net 的 scaling 行为不如 Transformer 干净。SD3、FLUX、Sora 都是 DiT 架构。

**视频**：把 3D 时空 patch 化，用 3D 位置编码。Sora 的核心思路就是 "DiT + 时空 patch + 变长训练"。

## 9. 理论问题

**收敛性保证.** Chen et al. (2023)、Lee–Lu–Tan (2023) 等给出了严格结果：若 score 估计的 $L^2$ 误差 $\le\varepsilon$，则采样分布与目标的 TV 距离 $\le O(\varepsilon\sqrt{D}\,\mathrm{polylog})$，**在只假设 $p_{\mathrm{data}}$ 有有限二阶矩的条件下**（不需要 log-concave 或流形假设）。

**这是罕见的、假设弱且结论强的结果。**证明用 Girsanov 定理把两个 SDE 的路径测度比较，再用数据处理不等式。**对做随机分析的人这是最直接可读的深度学习理论文献。**

**开放问题：**
- **为什么 score 网络能学好？**上述结果假设 score 误差小，但**没有解释**为什么神经网络能在高维学到 score。这是逼近论 + 优化的问题，基本未解。
- **维度诅咒去哪了？**理论界含 $\sqrt D$，$D\sim10^5$ 时应该灾难性，实际不然。必然是数据的低维结构在起作用（[[08 泛化之谜]] 的同一个谜）。
- **CFG 的正确理论**：$w>1$ 时采样的到底是什么分布？现有分析（Bradley–Nakkiran 2024）指出常见的 "$\propto p(x)p(c|x)^w$" 说法在 SDE 采样下**并不严格成立**。
- **离散数据上的 diffusion**：文本的连续松弛（D3PM、SEDD、掩码扩散）目前仍不敌自回归。为什么？

## 参考

- Ho, Jain, Abbeel, *Denoising diffusion probabilistic models*, NeurIPS 2020.
- Song, Sohl-Dickstein, Kingma, Kumar, Ermon, Poole, *Score-based generative modeling through stochastic differential equations*, ICLR 2021. **奠基性，把 DDPM 与 SMLD 统一到 SDE。**
- Anderson, *Reverse-time diffusion equation models*, Stochastic Processes and their Applications 1982.
- Vincent, *A connection between score matching and denoising autoencoders*, Neural Computation 2011.
- Karras, Aittala, Aila, Laine, *Elucidating the design space of diffusion-based generative models* (EDM), NeurIPS 2022. **工程上最系统的一篇。**
- Lipman, Chen, Ben-Hamu, Nickel, Le, *Flow matching for generative modeling*, ICLR 2023.
- Liu, Gong, Liu, *Flow straight and fast: Learning to generate and transfer data with rectified flow*, ICLR 2023.
- Albergo, Boffi, Vanden-Eijnden, *Stochastic interpolants: A unifying framework for flows and diffusions*, 2023.
- Rombach, Blattmann, Lorenz, Esser, Ommer, *High-resolution image synthesis with latent diffusion models*, CVPR 2022.
- Peebles & Xie, *Scalable diffusion models with transformers* (DiT), ICCV 2023.
- Chen, Chewi, Li, Li, Salim, Zhang, *Sampling is as easy as learning the score*, ICLR 2023.
- **MIT 6.S184, Flow Matching and Diffusion Models**（讲义在 diffusion.csail.mit.edu）。**对数学家最合适的系统课程**，从 SDE 第一性原理讲起，比 Bishop §20 严格得多。

## Related

- [[index|深度学习（为纯数学研究者重写）]]
- [[14 生成建模的统一视角]]
- [[15 变分自编码器]]
- [[16 生成对抗网络]]
