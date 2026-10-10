---
title: CS336：从零构建语言模型
description: 跟着 Stanford CS336（Spring 2026）逐讲做的工程向笔记：术语先行、数字可验算、代码能跑，面向没有 AI 行业背景的数学研究者。
tags:
  - cs336
  - language-models
  - engineering
  - MOC
stage: 🌱 seedling
date: 2026-09-15
---

# CS336：从零构建语言模型

这套笔记跟的是 Stanford 的 [CS336: Language Modeling from Scratch](https://cs336.stanford.edu/)（Spring 2026，Percy Liang 与 Tatsunori Hashimoto）。课程在第 1 讲的自我定位：

> *"**Full understanding** of this technology is necessary for **fundamental research**."*
> *"Philosophy of this course: **understanding via building**."*

以及贯穿全课的问题：**给定算力和数据预算，能造出的最好模型是什么？——最大化效率。**

> [!note] 与另外两套笔记的分工
> - [[notes/deep-learning/index|深度学习（为纯数学研究者重写）]]：**横向**，按数学主题把深度学习铺开。
> - [[notes/scientific-foundation-models/index|科学基础模型的数学]]：**纵向**，挑一条线挖到定理层。
> - **本栏目：工程向。** 关心一个真实的语言模型怎么被造出来、训起来、跑起来：资源怎么算、瓶颈在哪、代码怎么写。数学只在帮助估算或把定义说准时出现；需要深挖的，链到上面两套。

## 一、写法约定

读者有扎实的数学背景，但**不熟悉 AI 行业的术语和生态**。每篇都遵守：

1. **术语先行。** 开头一节「术语预备」，把本讲会用到的行话、公司与模型名、硬件名先讲清楚，正文不再打断。
2. **数字可验算。** 凡是数量级（FLOPs、显存、带宽、token 数）都给来源，能算的给算法；讲义 trace 里的值与本地重跑结果对照过。
3. **代码走读。** 可执行讲义里的关键代码原样摘录、加中文注释，附 Python 语法要点。
4. **练习。** 每篇末尾有估算、推导、编程题，答案附在最后。
5. **勘误。** 讲义的笔误在正文里直接写明，不静默改。
6. **说人话。** 从第 2 讲起按知识点写，一篇回答一个问题：先说问题，再推导、实测，然后讲它在哪里失效，最后一句话总结。目标是读完被说服，不用彩色提示框，也不靠专门的论文撑场面。样板是 [[02.4 训练的计算量为什么是 6ND]]。

## 二、材料形式

- **可执行讲义**（`lecture_XX.py`）：一个 Python 程序，执行过程就是讲课内容；[trace 视图](https://cs336.stanford.edu/lectures/?trace=lecture_01) 可以逐步看变量的值。Percy 的讲次是这种形式。
- **PDF 幻灯片**（`lecture_XX.pdf`）：Tatsu 的讲次。
- 全部材料在 [stanford-cs336/lectures](https://github.com/stanford-cs336/lectures)；2025 年的讲课录像在 [YouTube](https://www.youtube.com/playlist?list=PLoROMvodv4rOY23Y0BoGoBGgQ1zmU_MT_)。

## 三、前置要求与本栏目的处理

| 课程列的前置 | 本栏目怎么处理 |
|---|---|
| 熟练的 Python 与软件工程能力 | 每篇代码走读都附 Python 语法要点 |
| 深度学习与系统优化经验（PyTorch、存储层级） | 不预设；第 2、5、6 讲的笔记从零讲起 |
| 微积分、线性代数 | 默认已有，只在估算和定义处使用 |
| 概率与统计基础 | 默认已有 |
| 机器学习基础 | 默认读过 [[notes/deep-learning/01 学习问题的数学表述\|DL 01]]、[[notes/deep-learning/12 Transformer\|DL 12]]，需要时链过去 |

## 四、讲次与笔记

| # | 日期 | 主题 | 讲者 | 材料 | 笔记 |
|---|---|---|---|---|---|
| 1 | 3/30 | 课程总览、tokenization | Percy | py | ✅ [[01 课程总览与 tokenization]] |
| 2 | 4/1 | PyTorch、资源核算 | Percy | py | 🔄 [[02.4 训练的计算量为什么是 6ND]]（1/6，见第七节） |
| 3 | 4/6 | 架构、超参数 | Tatsu | pdf | ⏳ |
| 4 | 4/8 | 注意力的替代方案、MoE | Tatsu | pdf | ⏳ |
| 5 | 4/13 | GPU、TPU | Tatsu | pdf | ⏳ |
| 6 | 4/15 | Kernel、Triton | Percy | py | ⏳ |
| 7 | 4/20 | 并行（一） | Percy | py | ⏳ |
| 8 | 4/22 | 并行（二） | Tatsu | pdf | ⏳ |
| 9 | 4/27 | Scaling laws（一） | Tatsu | pdf | ⏳ |
| 10 | 4/29 | 推理 | Percy | py | ⏳ |
| 11 | 5/4 | Scaling laws（二） | Tatsu | pdf | ⏳ |
| 12 | 5/6 | 评测 | Percy | py | ⏳ |
| 13 | 5/11 | 数据来源与数据集 | Percy | py | ⏳ |
| 14 | 5/13 | 数据过滤、去重、配比 | Percy | py | ⏳ |
| 15 | 5/18 | 中期训练与后训练（SFT / RLHF） | Tatsu | pdf | ⏳ |
| 16 | 5/20 | 后训练：RLVR | Tatsu | pdf | ⏳ |
| 17 | 5/27 | 对齐：多模态 | Percy | py | ⏳ |
| 18 | 6/1 | 客座讲座：Daniel Selsam | — | — | — |
| 19 | 6/3 | 客座讲座：Dan Fu | — | — | — |

## 五、作业

| 作业 | 模块 | 要实现的东西 | 排行榜 |
|---|---|---|---|
| [A1 basics](https://github.com/stanford-cs336/assignment1-basics) | 基础 | BPE tokenizer、Transformer、交叉熵、AdamW、训练循环；在 TinyStories 与 OpenWebText 上训练 | 一张 B200、45 分钟内的 OpenWebText perplexity |
| [A2 systems](https://github.com/stanford-cs336/assignment2-systems) | 系统 | Triton 融合 RMSNorm kernel、分布式数据并行、优化器状态分片、benchmark 与 profile | — |
| [A3 scaling](https://github.com/stanford-cs336/assignment3-scaling) | 缩放定律 | 在 FLOPs 预算内"提交训练"、拟合 scaling law、外推超参与 loss | 给定 FLOPs 预算下的 loss |
| [A4 data](https://github.com/stanford-cs336/assignment4-data) | 数据 | Common Crawl HTML 转文本、质量与有害内容分类器、MinHash 去重 | 给定 token 预算下的 perplexity |
| [A5 alignment](https://github.com/stanford-cs336/assignment5-alignment) | 对齐 | DPO、GRPO | — |

> [!tip] 作业节奏
> 01 的 §5 读完就可以开始写 A1 的 BPE tokenizer；Transformer 与训练部分等 02–04 之后再动手。A1 自带单元测试，本地就能验证正确性。

## 六、阅读路径

- **按周跟课**：01 → 02 → … 顺序读。
- **先建立行业全景**：01 的 §0、§2、§4 → 13、14（数据）→ 15、16（后训练）。
- **冲系统与性能**：01 §4.2 → 02 → 05 → 06 → 07、08 → 10。
- **从数学那边接过来**：[[notes/deep-learning/12 Transformer|DL 12]] → 03、04；scaling laws（09、11）对照 [[notes/deep-learning/05 优化的数学|DL 05]] 读。

## 七、知识点拆解

从第 2 讲起，笔记按知识点写：每篇回答一个问题（"为什么是 6ND""为什么用 bf16"），讲清楚它为什么成立、在哪里失效。编号 = 讲次.序号；✅ 已写，其余是规划，可以调整。

**第 1 讲 总览与 tokenization**（内容已在 [[01 课程总览与 tokenization]] 里，需要时再拆）
- 01.1 字符、字节、词：三种切法各差在哪
- 01.2 BPE：从字节出发，反复合并最常见的相邻对

**第 2 讲 PyTorch 与资源核算**
- 02.1 浮点格式：为什么训练用 bf16
- 02.2 数 FLOPs：矩阵乘法的 2mnk 与 MFU
- 02.3 算术强度与 roofline
- ✅ [[02.4 训练的计算量为什么是 6ND]]
- 02.5 训练显存账：参数、梯度、优化器状态、激活
- 02.6 梯度累积与激活重计算

**第 3 讲 架构与超参数**
- 03.1 pre-norm 与 post-norm
- 03.2 从 LayerNorm 到 RMSNorm，以及去掉 bias
- 03.3 门控激活 SwiGLU
- 03.4 位置编码：正弦编码到 RoPE（对话里已写过，待归档）
- 03.5 超参数的共识：d_ff/d、头维度、宽深比、词表大小
- 03.6 为什么预训练不用 dropout，却用 weight decay
- 03.7 训练稳定性：z-loss、QK norm、logit soft-capping
- 03.8 GQA 与 MQA：为 KV cache 省显存
- 03.9 滑动窗口与全局/局部交错注意力

**第 4 讲 注意力的替代方案、MoE**
- 04.1 线性注意力：去掉 softmax 就能写成 RNN
- 04.2 Mamba-2、Gated DeltaNet 与混合架构
- 04.3 稀疏注意力（DeepSeek DSA）
- 04.4 MoE：参数多、计算少
- 04.5 路由：top-k、细粒度专家与共享专家
- 04.6 负载均衡：辅助损失与无辅助损失的偏置法
- 04.7 MoE 的坑：稳定性、微调与 upcycling

**第 5 讲 GPU 与 TPU**
- 05.1 GPU 的结构：SM、warp、HBM 与片上 SRAM
- 05.2 算力涨得比带宽快：tensor core 与内存墙
- 05.3 让 GPU 跑快的几招：低精度、算子融合、重计算、合并访存
- 05.4 分块与 wave quantization：矩阵尺寸为什么影响速度
- 05.5 FlashAttention：分块加在线 softmax

**第 6 讲 Kernel 与 Triton**
- 06.1 benchmark 与 profile：怎么量才准
- 06.2 Triton 的编程模型：以 block 为单位写 kernel
- 06.3 归约类 kernel：softmax 与按行求和
- 06.4 融合的矩阵乘法 + ReLU：用共享内存分块

**第 7 讲 并行（一）**
- 07.1 集合通信：all-reduce = reduce-scatter + all-gather
- 07.2 GPU 之间怎么连：NVLink、InfiniBand 与带宽层级
- 07.3 数据、张量、流水线并行的最小实现

**第 8 讲 并行（二）**
- 08.1 ZeRO 1/2/3 与 FSDP：把优化器状态、梯度、参数分片
- 08.2 流水线并行与气泡
- 08.3 张量并行与序列并行：激活显存怎么随卡数下降
- 08.4 专家并行
- 08.5 3D/4D 并行怎么组合：真实模型的配置

**第 9 讲 Scaling laws（一）**
- 09.1 数据 scaling law：误差为什么随数据量按幂律下降
- 09.2 模型工程的 scaling：架构、优化器、宽深比、critical batch size
- 09.3 Chinchilla 与 D≈20N
- 09.4 训练最优不等于部署最优

**第 10 讲 推理**
- 10.1 prefill 与 decode：为什么 decode 卡在带宽
- 10.2 吞吐与延迟，以及 KV cache 的显存账
- 10.3 缩小 KV cache：GQA、MLA、跨层共享、局部注意力
- 10.4 量化与剪枝
- 10.5 投机采样：为什么输出分布和大模型完全相同
- 10.6 continuous batching 与 PagedAttention

**第 11 讲 Scaling laws（二）**
- 11.1 真实的 scaling recipe：MiniCPM、DeepSeek 怎么定学习率和 batch
- 11.2 WSD 学习率：一次训练拿到多个规模的数据点
- 11.3 μP：让最优超参数不随宽度变
- 11.4 优化器与规模（含 Muon）

**第 12 讲 评测**
- 12.1 perplexity：它衡量什么，为什么不够
- 12.2 benchmark 的类型：考试、对话、agent、推理、安全
- 12.3 评测的效度：污染、真实性与怎么读分数

**第 13 讲 数据来源与数据集**
- 13.1 数据从哪来：Common Crawl、维基、GitHub、arXiv 与版权
- 13.2 预训练数据集的演进：从 WebText 到 DCLM 与 Nemotron-CC

**第 14 讲 数据处理**
- 14.1 HTML 转文本
- 14.2 过滤：KenLM 与 fastText 两类打分器
- 14.3 去重：MinHash 与 LSH
- 14.4 数据配比
- 14.5 后训练数据

**第 15 讲 SFT 与 RLHF**
- 15.1 SFT：数据里有什么，风格与知识
- 15.2 中期训练：把指令数据混进预训练
- 15.3 RLHF：偏好数据、奖励模型与 PPO 的思路
- 15.4 DPO：从 RLHF 目标解出闭式最优策略
- 15.5 RLHF 的坑：过度优化、模式坍缩、长度偏差

**第 16 讲 RLVR**
- 16.1 PPO 的实现细节：rollout、奖励整形、GAE
- 16.2 GRPO：用组内均值当基线，以及它的偏差
- 16.3 推理模型的训练流水线：DeepSeek R1、Kimi K1.5、Qwen 3

**第 17 讲 多模态**
- 17.1 CLIP 与 SigLIP：对比学习的两种损失
- 17.2 LLaVA 一系：视觉编码器 + 投影 + 语言模型
- 17.3 Qwen-VL 一系：动态分辨率与 M-RoPE
- 17.4 Chameleon：把图像也变成 token

---

*状态：🌱 第 1 篇（01）完成；第 2 讲起改为按知识点写，样章 [[02.4 训练的计算量为什么是 6ND]] 已完成，其余见第七节。每篇的数字与代码都对照 trace 或本地重跑核对过；发现错误直接改原篇。*

## Related

- [[01 课程总览与 tokenization]]
- [[02.4 训练的计算量为什么是 6ND]]
- [[notes/deep-learning/index|深度学习（为纯数学研究者重写）]]
