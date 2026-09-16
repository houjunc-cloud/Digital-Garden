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
4. **练习。** 每篇末尾有估算、推导、编程题，答案折叠。
5. **勘误。** 讲义的笔误用 `[!warning]` 标出，不静默改。

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
| 2 | 4/1 | PyTorch、资源核算 | Percy | py | ⏳ |
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

---

*状态：🌱 第 1 篇（01）完成，其余按讲次推进。每篇的数字与代码都对照 trace 或本地重跑核对过；发现错误直接改原篇。*

## Related

- [[01 课程总览与 tokenization]]
- [[notes/deep-learning/index|深度学习（为纯数学研究者重写）]]
