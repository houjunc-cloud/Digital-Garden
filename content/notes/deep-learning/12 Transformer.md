---
title: 12 Transformer
description: attention 作为核平滑与联想记忆、RoPE 的群论、表达力（TC⁰、induction head）、优化困难。
tags:
  - deep-learning
  - transformers
stage: 🌿 budding
date: 2026-08-14
---

# 12 Transformer

> Feng Week 7 讲 attention 机制与 Transformer，指定读 *Attention is All You Need* 与 Annotated Transformer。本篇补：**attention 的多种数学解释（核平滑 / 联想记忆 / 在残差流上的读写）、位置编码尤其 RoPE 的群论刻画、表达力的严格结果（$\mathsf{TC}^0$ 上界与 induction head 的机制分析）、以及为什么 Transformer 难优化。**
>
> 前置：[[11 序列模型与状态空间]]（attention 从 seq2seq 的瓶颈问题中来）、[[06 初始化归一化与训练动力学]]（残差流与 pre-LN）。

## 1. 定义

**Scaled dot-product attention.** 输入 $X\in\R^{T\times d}$，
$$Q=XW_Q,\quad K=XW_K,\quad V=XW_V,\qquad W_Q,W_K\in\R^{d\times d_k},\ W_V\in\R^{d\times d_v}$$
$$\mathrm{Attn}(X)=\underbrace{\mathrm{softmax}\Big(\frac{QK^\top}{\sqrt{d_k}}+M\Big)}_{=:A\in\R^{T\times T}}V,$$
softmax 按行，$M$ 是掩码（因果语言模型取 $M_{ij}=-\infty$ 当 $j>i$）。

**为什么除以 $\sqrt{d_k}$.** 若 $q,k$ 各分量独立、零均值、方差 1，则 $q\cdot k$ 方差为 $d_k$。不缩放的话 logits 的尺度 $\sim\sqrt{d_k}$，softmax 饱和（梯度消失）。除以 $\sqrt{d_k}$ 使 logits 方差 $O(1)$。**这与 [[06 初始化归一化与训练动力学|方差分析]]是同一个方法。**

**多头.** $h$ 个独立的 attention，输出拼接后过 $W_O$：
$$\mathrm{MHA}(X)=\mathrm{Concat}(\mathrm{head}_1,\dots,\mathrm{head}_h)W_O.$$
通常 $d_k=d_v=d/h$，故总参数量与单头 $d\times d$ 相同。

**完整块（pre-LN）.**
$$x\leftarrow x+\mathrm{MHA}(\mathrm{LN}(x)),\qquad x\leftarrow x+\mathrm{FFN}(\mathrm{LN}(x)),$$
$$\mathrm{FFN}(x)=W_2\,\mathrm{SwiGLU}(W_1x)\quad\text{（现代）或}\quad W_2\,\mathrm{ReLU}(W_1x+b_1)+b_2\ \text{（原始）}.$$

## 2. attention 是什么：四个视角

### 2.1 核平滑（Nadaraya–Watson）

写成
$$\mathrm{Attn}(x_i)=\sum_j \frac{\kappa(q_i,k_j)}{\sum_{j'}\kappa(q_i,k_{j'})}v_j,\qquad \kappa(q,k)=\exp\!\Big(\frac{q\cdot k}{\sqrt{d_k}}\Big).$$

**这就是 Nadaraya–Watson 核回归**（1964），核为指数点积核。区别：核不是固定的，而是通过 $W_Q,W_K$ 学出来的；且它作用在**学到的**表示上，不是原始输入上。

于是 attention $=$ **可学习核的非参数回归**。这个视角把 attention 接到了核方法的整个传统上（见 [[07 无限宽极限 NTK 与 mean-field]]）。

### 2.2 联想记忆 / 现代 Hopfield 网络

**定理（Ramsauer et al. 2021）.** 定义能量
$$E(\xi)=-\mathrm{lse}(\beta,K\xi)+\frac12\|\xi\|^2+\text{const},\qquad \mathrm{lse}(\beta,z)=\beta^{-1}\log\sum_i e^{\beta z_i}.$$
其凹凸过程（CCCP）的更新恰是
$$\xi^{\mathrm{new}}=K^\top\mathrm{softmax}(\beta K\xi).$$
**即：单步 attention = 现代 Hopfield 网络的一步检索。**

**容量.** 现代 Hopfield 网络能存储**指数于维数**的模式（$\exp(cd)$），远超经典 Hopfield 的 $0.14d$。且检索通常**一步收敛**。

> [!tip] 这个视角解释了 attention 在做什么
> **Attention 是在一个软的键值数据库里查询。**$K$ 是存储的键，$V$ 是值，$Q$ 是查询。温度 $\beta=1/\sqrt{d_k}$ 控制检索的"硬度"：$\beta\to\infty$ 是精确检索（argmax），$\beta$ 小是加权平均。
>
> 这也解释了**上下文学习**（in-context learning）：模型在推理时把上下文当作临时的键值存储，这是一种不改变权重的"记忆"。见 [[18 大语言模型#in-context-learning]]。

### 2.3 残差流上的读写（电路视角）

**Elhage et al. (2021), "A Mathematical Framework for Transformer Circuits".**

把注意力头重写。定义两个矩阵：
$$W_{QK}:=W_QW_K^\top\in\R^{d\times d}\quad(\text{“QK 电路”，决定}\textbf{从哪读}),$$
$$W_{OV}:=W_VW_O\in\R^{d\times d}\quad(\text{“OV 电路”，决定}\textbf{写什么}).$$

则一个 attention 头的作用是
$$x\ \longmapsto\ \sum_{j}A_{ij}\,x_jW_{OV},\qquad A=\mathrm{softmax}\big(xW_{QK}x^\top/\sqrt{d_k}\big).$$

**注意 $W_Q,W_K$ 只以乘积 $W_QW_K^\top$ 出现，$W_V,W_O$ 只以 $W_VW_O$ 出现。**这两个乘积的秩至多 $d_k=d/h$，是**低秩**的。于是每个头只在残差流的一个低维子空间上读写。

**零层 Transformer**（只有 embedding + unembedding）：$W_EW_U$ 是双字母组（bigram）统计。
**单层**：加上 $W_E W_{OV}W_U$（"skip trigram"）项。
**两层**：出现 **Q-composition / K-composition / V-composition**——一个头的输出成为另一个头的查询/键/值。**这是 induction head 的机制来源，也是"两层比一层强得多"的具体内容。**

### 2.4 图上的消息传递

Attention 是**完全图上的消息传递 GNN**，边权由内容决定。位置编码相当于给节点加特征。这把 Transformer 放进了 [[10 归纳偏置与等变性#5-geometric-deep-learning-的统一框架|geometric deep learning 框架]]：域是集合，群是 $S_T$，attention 是 $S_T$-等变的层。

**关键推论**：**不带位置编码的 Transformer 对输入的置换等变**。位置编码是**故意打破**这个对称性以引入序列结构。

## 3. 位置编码

### 3.1 正弦编码（原始）

$$\mathrm{PE}(t,2i)=\sin\!\Big(\frac{t}{10000^{2i/d}}\Big),\qquad \mathrm{PE}(t,2i+1)=\cos\!\Big(\frac{t}{10000^{2i/d}}\Big).$$

**性质**：$\mathrm{PE}(t+\Delta)$ 是 $\mathrm{PE}(t)$ 的线性函数（旋转矩阵作用），于是相对位置可以被线性层提取。但这个性质在加到 embedding 上并经过 attention 后被严重破坏。

### 3.2 RoPE：正确的做法

**旋转位置编码（Su et al. 2021）**。把 $d_k$ 维分成 $d_k/2$ 个二维块，第 $m$ 块用频率 $\theta_m=10000^{-2m/d_k}$。定义分块对角旋转
$$R_t=\bigoplus_{m=1}^{d_k/2}\begin{pmatrix}\cos t\theta_m & -\sin t\theta_m\\ \sin t\theta_m & \cos t\theta_m\end{pmatrix}\in SO(d_k),$$
然后
$$q_t\leftarrow R_tq_t,\qquad k_s\leftarrow R_sk_s.$$

**关键恒等式.**
$$\langle R_tq,\ R_sk\rangle = q^\top R_t^\top R_sk=q^\top R_{s-t}k.$$

**即：attention logits 只依赖相对位置 $s-t$。**

> [!tip] 群论的表述
> $t\mapsto R_t$ 是从 $(\R,+)$ 到 $SO(d_k)$ 的**群同态**（一维环面的乘积 $\mathbb{T}^{d_k/2}$ 中的一条直线）。相对位置性质就是同态性 $R_t^{-1}R_s=R_{s-t}$ 加上正交性 $R^\top=R^{-1}$。
>
> **RoPE 就是选了一个 $(\R,+)$ 在 $\R^{d_k}$ 上的酉表示，用它对 query/key 作用。**这是一个非常干净的构造，也解释了它为什么比加性编码好：它把位置信息编码在**度量结构**（内积）里而非**加性偏移**里，于是不与内容信息竞争同一个残差流子空间。
>
> 推广是显然的：换群就得到新编码。2D RoPE（用于 ViT）、3D RoPE（视频）都是取 $\R^2,\R^3$ 的表示。

**长度外推.** RoPE 在训练长度外性能骤降。修复方法都是在改频率：
- **位置插值（PI）**：$t\mapsto t\cdot L_{\text{train}}/L_{\text{target}}$，压缩所有频率。
- **NTK-aware / YaRN**：高频（局部）保持不变，低频（全局）插值。理由：高频负责局部语法，不该动；低频负责长程，需要拉伸。
- **训练时用更大的 base**（如 $500000$ 而非 $10000$），LLaMA-3 的做法。

**ALiBi**（Press et al. 2022）：直接给 logits 加线性偏置 $-m\cdot|i-j|$，无需可学参数，外推性好但表达力弱于 RoPE。

## 4. 表达力

### 4.1 上界：Transformer 在 $\mathsf{TC}^0$ 内

**定理（Merrill–Sabharwal 2023; Hao–Angluin–Frank 2022）.** 固定深度、多项式宽度、$O(\log n)$ 精度的 Transformer（软 attention）可被**均匀 $\mathsf{TC}^0$** 电路模拟。

**推论（在 $\mathsf{TC}^0\subsetneq\mathsf{NC}^1$ 的标准猜想下）**：固定深度 Transformer **无法**解决 $\mathsf{NC}^1$-完全问题，例如：
- 计算**正则语言的成员资格**（一般情形，如 $S_5$ 上的字问题）；
- **图连通性**（$\mathsf{NL}$-完全，更强）；
- 迭代的模运算。

**为什么**：attention 本质上是一层"加权求和 + 阈值"，即阈值门；固定深度的阈值电路就是 $\mathsf{TC}^0$。

> [!note] 这个结果的实践意义
> 它精确解释了**为什么需要 chain-of-thought**。CoT 让模型生成中间 token，每个 token 是一次完整的前向传播，于是**有效深度变成 $O(\text{生成长度})$**。
>
> **定理（Merrill–Sabharwal 2024）.** 带 $T(n)$ 步 CoT 的 Transformer 的表达力等价于 $\mathsf{TIME}(T(n))$ 内的图灵机（多项式步 CoT $\Rightarrow$ $\mathsf{P}$）。
>
> **所以"让模型思考更久"不是启发式技巧，是严格意义上的计算类提升。**这是 [[09 Scaling laws#5-推理时-scaling|推理时 scaling]] 的理论基础，也是 [[22 RLHF 与推理 RL]] 的存在理由。

### 4.2 下界：万有性

**定理（Yun et al. 2020）.** 带位置编码的 Transformer 是紧集上连续序列到序列函数的万有逼近器。

**定理（Pérez–Marinković–Barceló 2019）.** 带任意精度与无界步数的 Transformer 是图灵完备的。

这两个结果与 §4.1 不矛盾：万有性允许深度/宽度随 $\varepsilon$ 增长，$\mathsf{TC}^0$ 上界是对**固定深度**的。

### 4.3 Induction head {#induction-head}

**Olsson et al. (2022), "In-context Learning and Induction Heads".**

**机制**：一个两头组成的电路，实现模式 $[A][B]\dots[A]\to[B]$：

1. **前一 token 头**（层 $\ell_1$）：每个位置 attend 到前一个位置，把"前一个 token 是什么"写入残差流。
2. **归纳头**（层 $\ell_2>\ell_1$）：当前 token 是 $[A]$，查询"哪个位置的前一个 token 是 $[A]$"（用 K-composition 读取第 1 步写的信息），找到后复制那个位置的 token（$[B]$）到输出。

**证据链**：
- 训练过程中有一个明显的**相变**（loss 曲线上的"bump"），此时 induction head 突然形成；
- 该相变与 **in-context learning 能力的出现**在时间上精确重合；
- 消融 induction head 大幅损害 ICL；
- 在 1–2 层的小模型上可以完全逆向工程出这个电路。

> [!tip] 为什么值得数学家注意
> 这是**为数不多的、我们知道网络到底在算什么的例子**（另一个是 [[08 泛化之谜#6-grokking|grokking 中的 Fourier 电路]]）。它示范了一种方法论：**把网络的计算分解成低秩的"电路"，然后识别每个电路实现的算法。**
>
> 数学结构：残差流 $\R^d$ 上有一族近似正交的子空间，每个头是一对低秩映射（读 / 写）。整个网络是这些映射的组合图。**这本质上是在做一个"表示的分解"**——不是群表示，但精神相通。

**Superposition.** Elhage et al. (2022) 观察到：网络在 $d$ 维空间里存储 $\gg d$ 个"特征"，利用高维空间中随机向量近似正交（Johnson–Lindenstrauss）。这解释了为什么单个神经元往往对应多个不相关概念（polysemanticity），也是**稀疏自编码器（SAE）**方法的动机——用过完备字典恢复稀疏的特征基。**数学内容是压缩感知 / 字典学习。**

## 5. 优化困难

Transformer 比 CNN 难训得多。已知的具体困难：

**(a) 必须用 Adam。**SGD 在 Transformer 上表现极差（差距可达数倍 loss）。原因（Zhang et al. 2020; Kunstner et al. 2023）：梯度的**重尾**分布与**不同参数块间的尺度差异极大**（embedding vs attention vs FFN）。Adam 的逐坐标归一化解决了这个问题。见 [[05 优化的数学#51-rmsprop-与-adam]]。

**(b) 必须 warmup（post-LN）或至少有益（pre-LN）。**见 [[06 初始化归一化与训练动力学#23-位置pre-ln-vs-post-ln]]。

**(c) Attention entropy collapse.** 训练中 attention 分布可能坍缩到近似 one-hot，logits 无界增长，导致不稳定。修复：**QK-Norm**（对 $q,k$ 做 LayerNorm 后再点积，限制 logits 尺度）——Gemma、多个开源模型采用。

**(d) 损失尖峰（loss spikes）.** 大规模训练中损失偶尔剧烈上升。与梯度范数尖峰、特定数据批次、以及浅层的梯度爆炸有关。工程做法：跳过异常 batch、回滚 checkpoint、降低 $\epsilon$。**没有令人满意的理论。**

## 6. 复杂度与变体

**基本复杂度**：attention 是 $O(T^2d)$ 时间、$O(T^2)$ 内存（朴素实现）。这是长上下文的瓶颈。

| 方向 | 方法 | 复杂度 | 备注 |
|---|---|---|---|
| IO 优化 | FlashAttention | $O(T^2d)$ 但 $O(T)$ 内存 | **精确**，无近似；见 [[13 系统与工程]] |
| 稀疏 | Longformer, BigBird | $O(T)$ | 局部 + 全局 + 随机；BigBird 证明了图灵完备性保持 |
| 低秩 | Linformer | $O(T)$ | 投影 $K,V$ 到固定维数 |
| 核方法 | Performer | $O(T)$ | 用随机特征逼近 $\exp$ 核（FAVOR+） |
| 去 softmax | 线性 attention | $O(T)$ | $\mathrm{softmax}(QK^\top)V\to\phi(Q)(\phi(K)^\top V)$，结合律换顺序 |
| 推理 | MQA / GQA | KV cache 减少 $h$ 倍 | 多个 Q 头共享 K/V 头 |

> [!warning] 效率变体的现实
> 除了 FlashAttention（**精确**，无质量损失）与 GQA（推理优化）之外，**大多数"高效 attention"变体没有被前沿模型采用**。原因：它们在长序列上的理论优势在实际序列长度（2k–128k）与硬件特性下往往不敌优化良好的稠密 attention，且质量有损。
>
> 教训：**渐近复杂度不是全部，常数与硬件亲和性同样重要。**这是深度学习系统研究的普遍规律，见 [[13 系统与工程]]。

## 7. 视觉与多模态

**ViT（Dosovitskiy et al. 2021）.** 把图像切成 $16\times16$ 的 patch，每个 patch 线性投影成 token，然后就是标准 Transformer。

**结论**：数据量小时不如 CNN（缺少平移等变的归纳偏置），数据量大时（JFT-300M）超过 CNN。**这是 [[10 归纳偏置与等变性#5-geometric-deep-learning-的统一框架|归纳偏置 vs 数据量]]权衡的最清晰实证。**

**多模态**：图像编码器 + 投影层 + LLM（LLaVA 范式），或原生多模态（图像 token 与文本 token 在同一个序列里，如 Chameleon）。核心洞察是 **Transformer 对模态不可知**——只要能 tokenize，就能处理。

## 参考

- Vaswani et al., *Attention is all you need*, NeurIPS 2017.
- Rush, *The Annotated Transformer* (Harvard NLP). Feng 指定，最好的代码级讲解。
- Elhage et al., *A mathematical framework for transformer circuits*, Anthropic 2021. **对数学家最合适的 Transformer 内部结构讲解。**
- Olsson et al., *In-context learning and induction heads*, Anthropic 2022.
- Ramsauer et al., *Hopfield networks is all you need*, ICLR 2021.
- Su et al., *RoFormer: Enhanced transformer with rotary position embedding*, Neurocomputing 2024.
- Merrill & Sabharwal, *The parallelism tradeoff: Limitations of log-precision transformers*, TACL 2023.
- Merrill & Sabharwal, *The expressive power of transformers with chain of thought*, ICLR 2024.
- Yun, Bhojanapalli, Rawat, Reddi, Kumar, *Are transformers universal approximators of sequence-to-sequence functions?*, ICLR 2020.
- Dosovitskiy et al., *An image is worth 16x16 words* (ViT), ICLR 2021.

## Related

- [[index|深度学习（为纯数学研究者重写）]]
- [[11 序列模型与状态空间]]
- [[13 系统与工程]]
- [[18 大语言模型]]
- [[10 归纳偏置与等变性]]
