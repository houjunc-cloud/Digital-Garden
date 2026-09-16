---
title: 01 课程总览与 tokenization
description: CS336 第 1 讲。为什么要"从零构建"语言模型、以效率为主轴的课程五大模块，以及第一个技术单元 tokenizer：字符 / 字节 / 词 / BPE 四种方案的取舍与实现。
tags:
  - cs336
  - language-models
  - tokenization
  - engineering
stage: 🌿 budding
date: 2026-09-15
source: https://cs336.stanford.edu/lectures/?trace=lecture_01
---

# 01 课程总览与 tokenization

> [!info] 出处
> Stanford CS336 *Language Modeling from Scratch*（Spring 2026）第 1 讲，2026-03-30，讲者 Percy Liang。
> 讲义本身是一个可执行的 Python 程序 [lecture_01.py](https://github.com/stanford-cs336/lectures/blob/main/lecture_01.py)，[trace 视图](https://cs336.stanford.edu/lectures/?trace=lecture_01) 是它逐步执行的记录。本篇里的数字都取自 trace，或在本地重跑确认过。
> 所属栏目：[[notes/cs336/index|CS336：从零构建语言模型]]

> [!abstract] 本讲一句话
> **在给定的算力和数据预算下，造出最好的模型——"效率"是这门课一切设计决策的主轴。** 第一个技术单元 tokenizer 就是这条主轴的第一次体现：文本切成多大的块，直接决定序列有多长、算力花在哪里。

## 0 术语预备

> [!tip] 怎么用这一节
> 先扫一遍，正文遇到再回来查。表格按主题分组；0.4 里的术语本讲只点名，后面几讲才展开。

### 0.1 基本对象

| 术语 | 含义 | 备注 |
|---|---|---|
| 语言模型 (language model, LM) | 给 token 序列分配概率的模型。按链式法则 $p(x_1,\dots,x_n)=\prod_t p(x_t\mid x_{<t})$ 分解，实际做的事就是**预测下一个 token** | 反复"预测 → 采样 → 接到末尾"就是生成文本 |
| token | 模型处理的最小单位，实现上是一个整数编号 | 英文平均 1 token ≈ 4 字节（讲义：1000 bytes → ~250 tokens） |
| tokenizer（分词器） | 文本 ↔ token 序列的双向转换器 | 本讲 §5 |
| 词表 (vocabulary) | 所有 token 的集合；**词表大小** = 编号的取值个数 | GPT-5 所用 tokenizer 为 200,019 |
| 上下文长度 (context length) | 模型一次能处理的 token 数上限 | 序列越长 attention 越贵（见 0.4） |
| 参数 (parameters) | 模型里需要学习的数。"70B" = 70 billion = 700 亿个参数 | B = $10^9$，T = $10^{12}$ |
| 训练 (training) | 用数据调整参数 | |
| **推理 (inference)** | **参数固定，运行模型得到输出**（比如生成回复） | ⚠️ 和统计推断无关，业内就是"用模型" |
| 损失 (loss) / 交叉熵 | 训练目标：真实下一个 token 的负对数概率，取平均 | |
| 困惑度 (perplexity) | $\exp(\text{平均交叉熵})$，可理解为"模型平均在几个候选之间犹豫"，越低越好 | 作业排行榜的指标 |
| prompt（提示词） | 喂给模型的输入文本 | |
| 超参数 (hyperparameters) | 训练前人为设定、不靠学习得到的配置：学习率、batch size、层数…… | |
| benchmark / eval | 标准化的测试集与评测流程 | §4.4 |

### 0.2 训练流水线

工业界训练一个可用的模型，大致分三段：

| 术语 | 含义 |
|---|---|
| 预训练 (pretraining) | 在海量网页、书、代码上做"预测下一个 token"，得到 **base model**（只会续写，不会对话） |
| 中期训练 (mid-training) | 预训练的后段换成更高质量、含长上下文的数据继续训 |
| 后训练 (post-training) | 把 base model 调成可用的助手，包括下面的 SFT 和 RL |
| 微调 (fine-tuning) | 在训好的模型上用较少的特定数据继续训练。**SFT**（supervised fine-tuning）是用"指令 → 理想回答"或对话数据做的微调 |
| RLHF | reinforcement learning from human feedback：人给回答打分或排序，再用强化学习让模型偏向高分回答 |
| 对齐 (alignment) | 让模型行为符合人的意图与偏好；本课第 5 模块泛指"在弱监督下继续改进模型"的方法 |
| agent（智能体） | 能调用工具（终端、浏览器、代码执行）、多步自主完成任务的 LM 系统 |

### 0.3 算力与硬件

| 术语 | 含义 | 备注 |
|---|---|---|
| **FLOPs** | floating-point operations，浮点运算的**次数**（总量） | 训练总成本 ≈ 6 × 参数量 × token 数（§4.2）。注意和 FLOP/s（**速率**）区分 |
| GPU / TPU | 做训练和推理的加速芯片。数据中心 GPU 基本来自 NVIDIA；TPU 是 Google 自研 | 常见型号：H100（Hopper 架构）、B200（下一代 Blackwell 架构） |
| 集群 (cluster) | 成千上万张卡用高速网络连在一起 | |
| HBM | high bandwidth memory，GPU 上的大容量显存，参数、中间结果都放这里 | 讲义用 HBM 指"内存" |
| SM | streaming multiprocessor，GPU 里真正执行运算的单元 | 讲义用 SMs 指"算力" |
| 内存带宽 (memory bandwidth) | 每秒能在显存与计算单元之间搬运的字节数 | B200 为 8 TB/s（讲义） |
| kernel | 在 GPU 上执行的一个函数，比如一次矩阵乘法 | PyTorch 的每个基本算子背后都是 kernel |
| bf16 | bfloat16，16 位浮点（1 位符号、8 位指数、7 位尾数），训练常用精度 | 每个参数占 2 字节 |
| compute-bound / memory-bound | 瓶颈在"算"，还是在"搬数据" | §4.2 |
| MFU | model FLOPs utilization：实际用于模型计算的算力 ÷ 硬件理论峰值 | 第 2 讲的估算取 0.5 |

### 0.4 模型与算法（本讲只点名，后面展开）

| 术语 | 含义 |
|---|---|
| Transformer | 2017 年提出的神经网络架构，今天几乎所有 LM 的骨架：attention 层与 MLP 层交替堆叠。数学版见 [[notes/deep-learning/12 Transformer\|DL 12]] |
| attention（注意力） | 每个位置对前面所有位置做加权汇总。计算量随序列长度 $n$ **平方**增长——"序列越短越好"的根源 |
| MLP / FFN | Transformer 每层里对每个位置独立作用的两层全连接网络。大模型的多数 FLOPs 花在这里（§1.2） |
| MoE (mixture of experts) | 把 MLP 拆成很多"专家"，每个 token 只激活其中几个：参数总量大，每个 token 的计算量小 |
| KV cache | 生成时把已处理 token 的中间结果（key / value）缓存起来，避免每一步重算 |
| scaling law（缩放定律） | loss 随算力、参数量、数据量按幂律下降的经验规律，用于"小规模实验外推大规模" |
| emergence（涌现） | 某些能力在规模跨过某个量级后才突然出现 |
| in-context learning | 不改参数，只在 prompt 里给几个例子，模型就能照着做（GPT-3 首次大规模展示）。理论见 [[09 ICL 的数学表述：任务分布与贝叶斯预测器]] |
| optimizer（优化器） | 按梯度更新参数的规则，如 Adam、AdamW。数学版见 [[notes/deep-learning/05 优化的数学\|DL 05]] |

### 0.5 行业格局

| 术语 | 含义 | 例子 |
|---|---|---|
| 前沿模型 (frontier model) | 当前能力最强的那一档模型 | OpenAI 的 GPT、Anthropic 的 Claude、Google 的 Gemini、xAI 的 Grok |
| 闭源 / API 模型 | 权重不公开，只能通过付费接口调用 | 同上 |
| **open-weight**（开放权重） | 公开可下载的权重 + 技术报告；训练数据与完整代码不公开 | Meta Llama、Mistral、DeepSeek、阿里 Qwen、月之暗面 Kimi、智谱 GLM、MiniMax、小米 MiMo |
| **open-source**（完全开源） | 权重 + 论文 + 代码 + 数据全部公开 | AI2 的 Olmo、NVIDIA 的 Nemotron、Marin |
| 技术报告 (technical report) | 公司发布模型时的说明文档，一般不经同行评审，透明度差别极大 | GPT-4 的报告明确不公开架构与规模（§1.2） |

### 0.6 数量级速查

| 量 | 数值 | 来源 |
|---|---|---|
| 英文每 token 字节数 | ≈ 4 | 讲义 |
| GPT-5 tokenizer 词表 | 200,019 | trace |
| 训练算力 | $C\approx6ND$；70B 参数 × 1T tokens = $4.2\times10^{23}$ FLOPs | 讲义 |
| B200 单卡 | 2.25 PFLOP/s（$2.25\times10^{15}$ FLOP/s，bf16）；显存 192 GB；显存带宽 8 TB/s | 第 1、6 讲 |
| Chinchilla 配比 | 每个参数约 20 个训练 token（70B ↔ 1.4T） | 讲义 |
| GPT-4 训练成本 | 据称约 1 亿美元（2023） | 讲义引 Wired |
| xAI 训练集群 | 23 万张 GPU（2025） | 讲义引 Musk 推文 |
| 算法效率进步 | ImageNet 上达到同等精度所需算力，2012→2019 降到 1/44 | Hernandez & Brown 2020 |

## 1 为什么要"从零构建"

### 1.1 研究者正在和底层技术脱节

| 年份 | 研究者的典型工作方式 |
|---|---|
| 2016 | 自己实现、自己训练模型 |
| 2018 | 下载预训练模型（如 BERT），在自己的任务上微调 |
| 今天 | 调用 API 写 prompt（GPT / Claude / Gemini） |

抽象层次往上走，生产力提高了，但有两个问题：

1. **这些抽象是"漏的"(leaky)。** 编程语言、操作系统的抽象很少逼你关心下层；LM 的接口不是这样——模型行为会以难以预料的方式受 tokenizer、训练数据、训练方法影响，而这些都藏在接口下面。例：Karpathy 的 tokenization 视频列过一串怪现象（不会拼写、不会反转字符串、简单算术出错、非英语表现差），Karpathy 把它们都归因于 tokenization（§5）。
2. **还有基础研究需要把整个技术栈拆开重做。**

结论：做基础研究需要**完整理解**这门技术。本课的方法论：**通过构建来理解 (understanding via building)**。

### 1.2 麻烦：语言模型已经工业化了

**贵。** 2023 年 GPT-4 据称训练花了约 1 亿美元；2025 年 xAI 为训练 Grok 建了 23 万张 GPU 的集群。

**不透明。** 前沿模型怎么造的，没有公开细节。GPT-4 技术报告原文：

> *"Given both the competitive landscape and the safety implications of large-scale models like GPT-4, this report contains no further details about the architecture (including model size), hardware, training compute, dataset construction, training method, or similar."*

**小模型不一定有代表性。** 课上训得起的是 1B 参数以下的模型，但有些现象随规模改变。

**例 1：FLOPs 花在哪，随规模变。** Stephen Roller（2022）给出的 OPT 系列各部分算力占比（原表还有 MHA、logit 两列，这里略）：

![Roller 的 FLOPs 占比表](https://raw.githubusercontent.com/stanford-cs336/lectures/main/images/roller-flops.png)

| 模型 | 每步 FLOPs | FFN 占比 | attn 占比 |
|---|---|---|---|
| 760M | $4.3\times10^{15}$ | 44% | 14.8% |
| 6.7B | $1.1\times10^{17}$ | 65% | 8.1% |
| 175B | $2.4\times10^{18}$ | 80% | 3.3% |

为什么：每层每个 token，FFN 的运算量 $\propto d^2$（$d$ = 隐藏维度），而 attention 里"打分 + 加权求和"那部分 $\propto n\cdot d$（$n$ = 序列长度）。OPT 的 $n$ 固定为 2048，$d$ 从 1536 涨到 12288，后者占比自然被稀释。表中 attn/FFN 与 $n/(4d)$ 吻合到 1% 左右（练习 7）。

> [!tip] 工程含义
> 在小模型上 profile，会以为 attention 是大头；到了大模型，矩阵乘法密集的 FFN 才是大头。前提是上下文长度不变——上下文拉长，天平又会拨回 attention 一侧。

**例 2：能力涌现。** Wei et al. (2022) 汇总了多个模型在 8 个任务上的表现：训练算力到达 $10^{22}$–$10^{24}$ FLOPs 的某个量级之前，准确率贴着随机水平，之后陡然上升。比如模运算任务上，GPT-3 到最大一档（175B，约 $3\times10^{23}$ FLOPs）才达到约 33% 的准确率，更小的规模都在 10% 以下。只在小模型上做实验，根本看不到这些能力。

![Wei et al. 2022 涌现曲线](https://raw.githubusercontent.com/stanford-cs336/lectures/main/images/wei-emergence-plot.png)

> [!warning] 对"涌现"的一个保留
> Schaeffer et al. (2023, *Are Emergent Abilities of Large Language Models a Mirage?*) 指出，不少"突变"来自评测指标本身不连续（比如必须完全答对才算分）；换成连续指标，曲线往往是平滑的。这也呼应了 §4.4 里内部评测看重"跨规模平滑"的要求：平滑的指标才能从小规模外推。

### 1.3 那课上能学到什么可迁移的东西

| 知识类型 | 内容 | 能教吗 | 能迁移到前沿规模吗 |
|---|---|---|---|
| **机制 (mechanics)** | 东西怎么工作：Transformer 是什么、模型并行怎么做 | ✅ | ✅ |
| **思维方式 (mindset)** | 把硬件压榨到极致；认真对待 scaling | ✅ | ✅ |
| **直觉 (intuitions)** | 哪些数据和建模决策能带来好效果 | 部分 | ⚠️ 不一定跨规模成立 |

直觉难教，是因为很多设计决策**目前没有解释**，只来自实验。典型例子：提出 SwiGLU（今天主流 LM 的激活函数）的 Shazeer (2020) 在论文结论里写：

> *"We offer no explanation as to why these architectures seem to work; we attribute their success, as all else, to divine benevolence."*
> （我们无法解释这些架构为何有效；和其他一切一样，归功于神的仁慈。）

### 1.4 "苦涩的教训"与效率

**The Bitter Lesson** 是强化学习奠基人之一 Rich Sutton 2019 年的短文：70 年 AI 史表明，能利用算力增长的通用方法（搜索、学习）最终总会胜过人工注入的领域知识。

| 误读 | 正解 |
|---|---|
| 只有规模重要，算法无所谓 | **能随规模扩展的算法**才重要 |

讲义把它写成：

$$\text{accuracy} = \text{efficiency} \times \text{resources}$$

- 规模越大，效率越重要——浪费不起。
- 证据：Hernandez & Brown (2020) 测得，2012–2019 年间 ImageNet 上达到同等精度所需的算力降到 1/44，纯靠算法进步。

**本课的问题框架：给定算力和数据预算，能造出的最好模型是什么？换句话说，最大化效率。**

## 2 行业地图：从 n-gram 到 agent

### 2.1 技术演进

| 阶段 | 里程碑 | 意义 |
|---|---|---|
| 前神经网络（2010 年代以前） | Shannon (1950) 用语言模型度量英文的熵 | "语言模型"这个概念比深度学习早半个多世纪 |
| | n-gram 模型（Brants et al. 2007，Google） | 用前 $n-1$ 个词的出现计数预测下一个词；曾是机器翻译、语音识别的核心组件 |
| 神经网络组件（2010 年代） | LSTM (1997)；第一个神经语言模型 (Bengio et al. 2003) | |
| | seq2seq (2014)、attention (Bahdanau et al. 2015) | 都是为**机器翻译**提出的 |
| | Adam 优化器 (2014) | 至今训练 LM 的默认优化器家族 |
| | Transformer (2017，同样为机器翻译提出)、MoE (2017) | 今天 LM 的骨架与稀疏化手段 |
| | 模型并行：GPipe (2018)、ZeRO (2019)、Megatron-LM (2019) | 单卡放不下之后怎么训 |
| 早期基础模型（2010 年代末） | ELMo (2018, LSTM)、BERT (2018, Transformer) | 范式确立：**预训练 + 微调**，下游任务普遍提升 |
| | Google T5 (2019, 11B) | 把所有任务统一成"文本到文本" |
| 拥抱规模 | OpenAI GPT-2 (2019, 1.5B) | 文本流畅；首次出现 zero-shot（不给例子直接做任务）的迹象 |
| | Scaling laws (Kaplan et al. 2020) | 让扩大规模变得**可预测** |
| | OpenAI GPT-3 (2020, 175B) | in-context learning |
| | Google PaLM (2022, 540B) | 规模巨大但 **undertrained**：540B 参数只训了 780B token，按 Chinchilla 配比应约 10T |
| | DeepMind Chinchilla (2022, 70B) | compute-optimal scaling laws：同样算力下，模型小一点、数据多一点更好（§4.3） |

### 2.2 开放程度光谱

| 类型 | 公开什么 | 讲义列举 |
|---|---|---|
| 闭源 | 只有 API | GPT、Claude、Gemini 等 |
| 早期复现 GPT-3 的尝试 | 数据集、权重 | EleutherAI 的 The Pile 数据集与 GPT-J 模型；Meta 的 OPT-175B（公开的训练日志记录了大量硬件故障）；Hugging Face / BigScience 的 BLOOM-176B（重点在数据来源） |
| **open-weight** | 权重 + 论文 | Meta Llama；Mistral（法国）；DeepSeek（深度求索）；阿里 Qwen（通义千问）；Moonshot Kimi（月之暗面）；Z.ai GLM（智谱）；MiniMax；小米 MiMo |
| **open-source** | 权重 + 论文 + 代码 + 数据 | AI2 Olmo；NVIDIA Nemotron；Marin（Percy Liang 等发起的"开放实验室"，连研发过程本身都公开，任何人可参与） |

几点观察：
- 讲义的判断：open-weight 模型正在逼近闭源模型。
- 讲义列的 8 家 open-weight 里，6 家是中国公司。
- 开放对信任和创新都重要（讲义引 [arXiv:2403.07918](https://arxiv.org/abs/2403.07918)）；这门课能讲这么细，靠的正是开放模型公开的思路。

### 2.3 "语言模型"这个词的含义在变

| 年份 | LM 是…… |
|---|---|
| 2018（BERT） | 拿来**微调**的东西 |
| 2020（GPT-3） | 拿来**写 prompt** 的东西 |
| 2022（ChatGPT） | 拿来**对话**的东西 |
| 2026（agents） | 能**自主行动**的东西 |

**基础没变**（attention、kernel、优化），**规格变了**（上下文更长，推理效率更关键——一次 agent 任务要生成大量 token）。

## 3 课程运作（自学视角）

- **5 学分，出了名的重。** 2024 年课评："第一个作业的工作量约等于 CS 224n 全部 5 个作业加期末项目。"
- **适合**：对"东西到底怎么工作"有执念；想练研究工程能力。**不适合**：这学期就想出研究成果；想追最新热点，如多模态、RAG（retrieval-augmented generation，先检索文档再生成）——该去上 seminar；只想在自己的应用上拿到好结果——直接 prompt 或微调现成模型即可。
- **5 个作业**：basics、systems、scaling laws、data、alignment。**不给脚手架代码**，但提供单元测试和 adapter 接口（测试通过 adapter 调用你的实现）。先在本地测正确性，再上集群测精度和速度。部分作业有排行榜。
- **AI 政策**：coding agent 能做完所有作业，但那样什么也学不到；鼓励把 AI 当答疑和辅导工具，并要求使用课程提供的 `AGENTS.md`（让 AI 以教学为导向回答）。
- **算力**：选课学生用 Modal 提供的算力；课程主页列了自学可用的云 GPU 厂商（Modal、Lambda、RunPod、Nebius、Together）。
- **自学**：讲义和作业全部公开（[lectures](https://github.com/stanford-cs336/lectures) 与各作业仓库）；2025 年的讲课录像在 [YouTube](https://www.youtube.com/playlist?list=PLoROMvodv4rOY23Y0BoGoBGgQ1zmU_MT_)。

## 4 课程地图：五个模块

> [!note] 读法
> 这一节是后面 16 讲的预告。每个模块先记住"它要解决的效率问题是什么"，细节到对应讲次再看。

| 模块 | 目标 | 对应讲次 | 作业 |
|---|---|---|---|
| 基础 (basics) | 能训出一个基本的语言模型 | 1–4 | A1：BPE、Transformer、AdamW、训练循环 |
| 系统 (systems) | 把硬件压榨到极致 | 5–8、10 | A2：Triton kernel、分布式数据并行、优化器状态分片 |
| 缩放定律 (scaling laws) | 用小实验决定大训练怎么配 | 9、11 | A3：拟合 scaling law 并外推 |
| 数据 (data) | 决定模型具备什么能力 | 12–14 | A4：网页转文本、过滤、去重 |
| 对齐 (alignment) | 在弱监督下继续改进模型 | 15–17 | A5：DPO、GRPO |

### 4.1 基础：tokenizer、架构、训练

**Tokenization**：模型操作的"原子"是什么？→ §5。

**架构**：起点是原始 Transformer (2017)，此后的主要改进：

| 部件 | 演进 | 一句话动机 |
|---|---|---|
| 激活函数 | ReLU → SwiGLU | 带门控的 MLP，实验上更好（就是 §1.3"神的仁慈"那篇） |
| 位置编码 | 正弦编码 → RoPE | 把位置编码成 query / key 向量的旋转，天然表达相对位置 |
| 归一化 | LayerNorm → RMSNorm；post-norm → pre-norm；QK norm | 训练稳定性（RMSNorm 还更省算） |
| 注意力 | 全注意力 → 稀疏 / 局部（滑动窗口）、GQA、MLA | 省计算和 KV cache 显存。GQA：多个 query 头共享一组 key/value；MLA：把 key/value 压缩到低维 |
| 循环 / 状态空间 / 线性注意力 | Mamba、Gated DeltaNet | 计算量随序列长度线性增长的替代方案 |
| MLP | 稠密 → MoE | 参数多，但每个 token 的计算少 |
| 形状 | 隐藏维度、层数、头数、专家数 | 同样的参数量怎么分配 |

**训练**：参数怎么定？讲义列的旋钮：

| 旋钮 | 例子 |
|---|---|
| 损失函数 | 标准的下一 token 交叉熵；multi-token prediction（一次预测多个未来 token，DeepSeek-V3 用了） |
| 优化器 | AdamW；新一代的 SOAP、Muon（利用参数矩阵的结构） |
| 初始化尺度 | Xavier 初始化；μP（换一种参数化，使最优超参不随模型宽度变化） |
| 学习率调度 | cosine；WSD（warmup–stable–decay：先升、再平、最后衰减） |
| 正则化 | dropout、weight decay |
| batch size | critical batch size（超过它之后，再加大 batch 已不能等比例减少所需步数） |
| MoE 专属 | 负载均衡（让各专家分到的 token 大致均匀），如 DeepSeek-V3 的 aux-loss-free 方案 |

**A1 (basics)**：实现 BPE tokenizer、Transformer、交叉熵、AdamW、训练循环；做资源核算；在 TinyStories（用简单词汇写的合成儿童故事）和 OpenWebText（网页文本）上训练。除容器类等少数例外，不许用 `torch.nn`、`torch.nn.functional`、`torch.optim` 里的现成实现。排行榜：**一张 B200、45 分钟内，把 OpenWebText 的 perplexity 压到最低。**

**贯穿全课的三方平衡**：
- 表达力 (expressivity)：能表示数据里复杂的依赖；
- 稳定性 (stability)：参数和梯度的范数待在"刚刚好"的区间；
- 效率 (efficiency)：训练和推理都在硬件上跑得快。

### 4.2 系统：把硬件压榨到极致

**资源核算。** 训练总算力的标准估算：

$$C \approx 6ND \qquad (N = \text{参数量},\ D = \text{训练 token 数})$$

直觉：前向传播时每个 token 大约让每个参数做一次乘法、一次加法（≈ $2N$ 次运算），反向传播约为前向的两倍（≈ $4N$）。讲义例子：70B 参数训 1T tokens，$6\times70\times10^{9}\times10^{12}=4.2\times10^{23}$ FLOPs。第 2 讲细算。

**算力 vs 内存。** GPU 可以粗画成两块：做运算的 SM 和存参数的 HBM，中间是一条带宽有限的通道。参数必须先从 HBM 搬到 SM 才能参与运算。

![compute 与 memory](https://raw.githubusercontent.com/stanford-cs336/lectures/main/images/compute-memory.png)

讲义给的 B200 数据：算力 2.25 PFLOP/s（P = peta = $10^{15}$，bf16 精度）；显存带宽 8 TB/s。

**Roofline 分析**（Williams, Waterman & Patterson 2009 提出的性能模型）判断一段计算是 **compute-bound**（卡在算）还是 **memory-bound**（卡在搬）。关键量是**算术强度 (arithmetic intensity)**：每搬 1 字节数据，要做多少次运算。

> [!example] 用讲义的数字粗算
> - **B200 的拐点**：$2.25\times10^{15}$ FLOP/s ÷ $8\times10^{12}$ 字节/s ≈ **281 FLOPs/字节**。算术强度低于它就是 memory-bound，高于它就是 compute-bound。
> - **生成一个 token（decode）**：要把全部参数读一遍（bf16 下 $2N$ 字节），做约 $2N$ 次运算，强度 ≈ **1**，远低于 281，严重 memory-bound。70B 模型在 bf16 下占 140 GB，放得进 B200 的 192 GB；单请求生成速度 ≈ 带宽 ÷ 模型字节数 = $8\times10^{12}/1.4\times10^{11}$ ≈ 57 token/s，由带宽而非算力决定。同时服务 $B$ 个请求，强度 ≈ $B$——这就是推理服务要拼 batch 的原因。
> - **处理长 prompt（prefill）或训练**：读一遍参数、算 $n$ 个 token，强度 ≈ $n$；$n$ 上千时是 compute-bound。
>
> 以上忽略了 KV cache 等开销，只看量级；严格版本在第 2、10 讲。

**Kernel。**
- kernel 是在 GPU 上运行的函数。用 PyTorch 时，每个基本算子调用一个标准 kernel；也可以手写定制 kernel 提速。
- **原则：组织计算，尽量少搬数据。**
  - 朴素：读 HBM → 算 A → 写 HBM → 读 HBM → 算 B → 写 HBM
  - 融合 (fused)：读 HBM → 算 A 和 B → 写 HBM
- 策略：**算子融合**（如矩阵乘法 + 激活函数一起算）；**分块 (tiling)**（如 FlashAttention：把 attention 分块放进片上高速存储计算，不在 HBM 上物化 $n\times n$ 的注意力矩阵）。
- 讲义还点名了一串 GPU 微观性能概念，第 6 讲展开：warp divergence（同组 32 个线程锁步执行，走不同分支就只能串行）、memory coalescing（访问 HBM 时合并成事务）、bank conflicts（多个线程同时访问共享内存的同一分区时被迫串行）、occupancy（每个线程占用的寄存器越多，同时能调度的线程越少）、bulk-async memory transfers。
- 写 kernel 的工具：CUDA（NVIDIA 的 GPU 编程平台）、**Triton**（OpenAI 开源的 Python 风格 kernel 语言，A2 用它）、CUTLASS、ThunderKittens。

**并行。**
- 1024 张卡怎么用？卡与卡之间搬数据更慢，但"少搬数据"的原则不变。
- 使用经典的**集合通信 (collective operations)**：gather、reduce、all-reduce 等。all-reduce：每张卡各有一个向量，结束后每张卡都拿到所有向量之和，数据并行靠它同步梯度。
- 把参数、激活值、梯度、优化器状态**分片 (shard)** 到多张卡上。
- 计算怎么切：

| 并行方式 | 切什么 |
|---|---|
| 数据并行 (data) | 每卡一份完整模型，切 batch |
| 张量并行 (tensor) | 把单个大矩阵乘法切到多卡 |
| 流水线并行 (pipeline) | 按层切，像流水线一样逐段传递 |
| 序列并行 (sequence) | 沿序列长度方向切（长上下文） |
| 专家并行 (expert) | MoE 的不同专家放在不同卡上 |

**推理。**
- 目标：给定 prompt 生成 token——真正使用模型靠的就是它。强化学习、test-time compute（推理时多花算力换更好的答案，如更长的思考链、多次采样）、评测也都要做推理。
- 两个阶段：

![prefill 与 decode](https://raw.githubusercontent.com/stanford-cs336/lectures/main/images/prefill-decode.png)

| 阶段 | 做什么 | 瓶颈 |
|---|---|---|
| prefill | prompt 里的 token 都已知，一次并行处理完（与训练类似） | compute-bound |
| decode | 每次只能生成一个 token，并读写 KV cache | memory-bound |

- 加速 decode 的办法：
  - **换便宜的模型**：剪枝（pruning，删掉不重要的参数）、量化（quantization，用更少的比特存参数）、蒸馏（distillation，训一个小模型模仿大模型）；
  - **投机解码 (speculative decoding)**：小的"草稿"模型先连续猜几个 token，大模型一次并行打分验证；配合特定的接受 / 拒绝规则，输出分布与大模型逐个生成**完全相同**（讲义称 exact decoding）；
  - **系统优化**：融合 kernel；continuous batching（新请求随到随插入正在运行的 batch，不必等整批结束）。

**A2 (systems)**：用 Triton 写融合的 RMSNorm kernel；实现分布式数据并行；实现优化器状态分片；做 benchmark 与 profile。推荐书：Google 的 [How to Scale Your Model](https://jax-ml.github.io/scaling-book/)（以 TPU 为例，概念通用）。

### 4.3 Scaling laws：用小实验决定大训练

**场景**：手里有 $10^{25}$ FLOPs 算力，超参怎么定？在全规模上调参太贵了。

**关键的观念转变：不要只盯着一个规模，要设计一个 scaling recipe——从 FLOPs 到超参的映射。**

对一个 recipe：
1. 在一系列较小规模（比如最多 $10^{24}$ FLOPs）上跑实验，得到 loss；
2. 拟合 scaling law，预测它在目标规模（$10^{25}$ FLOPs）上的 loss。

于是可以：(1) 用小实验优化面向大规模的 recipe；(2) **在真正开跑之前预测 loss**。

- scaling law 不会自动出现，要精心构造 recipe，比如用 μP 参数化让超参能**跨规模迁移**。
- 讲义原话：**可预测性至少和最优性一样重要。**

**经典问题：算力 $C=6ND$ 固定，把模型做大（$N$）还是多训数据（$D$）？**

- 经典工作是 Kaplan et al. (2020) 与 Chinchilla (2022)。讲义介绍的是 Chinchilla 的 **IsoFLOP 曲线**方法：取若干个小算力预算，每个预算下扫一遍模型大小，找 loss 最低的 $N$；再把各预算的最优点拟合成对数坐标下的直线，外推到大预算。
- 下图左：每条曲线是一个固定算力（$6\times10^{18}$ 到 $3\times10^{21}$ FLOPs），loss 对参数量呈 U 形。中、右：各预算的最优参数量、最优 token 数在对数坐标下近似直线，外推到约 $6\times10^{23}$ FLOPs 时给出 63B 参数、1.4T tokens。

![Chinchilla IsoFLOP](https://raw.githubusercontent.com/stanford-cs336/lectures/main/images/chinchilla-isoflop.png)

- **结论：$D\approx20N$ 大致最优**（70B 模型应训约 1.4T tokens）。

> [!tip] 代数上就一行
> 把 $D=20N$ 代入 $C=6ND$ 得 $C=120N^2$，即 $N_\text{opt}=\sqrt{C/120}$。$C=10^{25}$ 时 $N\approx289\text{B}$、$D\approx5.8\text{T}$（练习 6）。

- **注意**：这个配比没有计入推理成本。模型要大规模部署时，宁可小一点、多训很多数据。例如 Llama 3 的 8B 模型训了 15T tokens，约每个参数 1900 个 token。

**实时例子：Marin 的预注册预测。** Percy Liang 在推特公布了 Marin 的 "Delphi" scaling 实验：在 $3\times10^{18}$ 到 $3\times10^{20}$ FLOPs 的小预算上画 IsoFLOP 曲线（纵轴是在 Paloma 评测集上的 loss，横轴是训练 token 数），拟合出 compute-optimal 前沿并预测更大规模的 loss；在 $10^{21}$ 和 $10^{22}$ FLOPs 上验证，实际 loss 与预测只差 +0.011 和 +0.005。更大的一次训练正在进行，预测值事先公布（即"预注册"），训完再对答案。

**A3 (scaling laws)**：课程用以往的真实训练结果搭了一个"训练 API"（超参 → loss）。你在 FLOPs 预算内提交"训练任务"收集数据点，拟合 scaling law，再提交外推出的超参和 loss 预测。排行榜：给定 FLOPs 预算下 loss 最低。

### 4.4 数据：决定模型会什么

**先问：想要模型具备什么能力？** 多语言？擅长对话？能做 agent 式编程？

**评测 (evaluation)** 有两种目的：

| 目的 | 关心什么 |
|---|---|
| 内部：指导模型开发 | 指标跨规模**平滑**（才能外推）；相对好坏 |
| 外部：衡量真实用途的绝对质量 | 生态效度 (ecological validity)：测试场景要像真实使用场景 |

评测举例：
1. **Perplexity**：最好用不在互联网上的私有文档来测，避免**污染 (contamination)**——测试文本早就混进了训练数据，分数虚高。
2. **高级用例**：

| Benchmark | 测什么 |
|---|---|
| GPQA | 研究生水平的生物 / 物理 / 化学选择题，由领域专家出题，设计成"搜不到答案" |
| HLE (Humanity's Last Exam) | 各学科专家出的极难问题 |
| SWE-Bench | 修复真实 GitHub 项目里的 issue，用项目自带的测试判定对错 |
| Terminal-Bench | 在命令行终端里完成多步任务（agent 能力） |

LM 是通用系统，必须用多样的评测。

**数据整理 (curation)**：
- 数据不会从天上掉下来。来源：互联网网页抓取、书、arXiv 论文、GitHub 代码等。例：The Pile（EleutherAI 2020）由 22 个子集拼成。
- 版权：能否以 fair use（合理使用）为由训练受版权保护的数据？也可能得买授权，比如 Google 与 Reddit 的数据授权协议。
- 原始数据是 HTML、PDF、目录结构，不是干净的文本，必须处理。

**数据处理流水线**：

| 步骤 | 做什么 |
|---|---|
| 转换 (transformation) | HTML / PDF → 文本，抽取正文 |
| 过滤 (filtering) | 用分类器保留高质量数据、去掉有害内容 |
| 去重 (deduplication) | 省算力、避免死记硬背；用 Bloom filter 或 MinHash |
| 配比 (mixing) | 各来源该加权还是降权（RegMix、Olmix） |
| 改写 / 合成数据 | 用 LM 改写真实数据，使其更接近下游任务（如 WRAP） |

> [!note] 两个去重工具，各一句话
> - **Bloom filter**：用 $k$ 个哈希函数把元素映射进一个位数组，回答"这个元素见过吗"。可能误报、不会漏报，极省内存，适合精确去重。
> - **MinHash**：把文档看成 n-gram 的集合 $A$。对随机排列 $\pi$，有 $\Pr[\min\pi(A)=\min\pi(B)]=|A\cap B|/|A\cup B|$（Jaccard 相似度）。用 $k$ 个哈希近似 $k$ 个排列，每篇文档压成 $k$ 个整数的"签名"，再配合分桶在海量文档里找近似重复。

**数据类型**：

| 阶段 | 数据特点 |
|---|---|
| 预训练 | 量大、多样 |
| 中期训练 | 高质量，含长上下文 |
| 后训练 | SFT 数据：对话、带工具调用的 agent 轨迹 |

**A4 (data)**：把 Common Crawl（一个非营利组织定期抓取的全网公开网页存档）的 HTML 转成文本；训练质量与有害内容分类器来过滤；用 MinHash 去重。排行榜：给定 token 预算下 perplexity 最低。

### 4.5 对齐：在弱监督下继续改进

到目前为止，模型是在**完全监督**下训的（每个位置都有"正确的下一个 token"）。模型已经像样之后，可以用**弱监督**继续改进。为什么可行？**因为评判比生成容易**——判断一个回答好不好，比写出好回答容易，就像验证一个证明比找到它容易。

基本模板：
1. 让模型生成回答；
2. 给回答打分，打分者可以是人、**verifier**（程序化判定，如数学题答案对不对、代码能否通过测试），或 **LM judge**（让另一个 LM 当裁判）；
3. 更新模型，让它偏向更好的回答。

| 算法 | 要点 |
|---|---|
| PPO (Proximal Policy Optimization) | 来自强化学习；InstructGPT（ChatGPT 的"兄弟"模型）用它做 RLHF |
| DPO (Direct Preference Optimization) | 面向"两个回答哪个更好"的偏好数据；不跑强化学习循环，直接写成一个分类式的损失，简单得多 |
| GRPO (Group Relative Policy Optimization) | 去掉 PPO 里的 value function（另一个用来估计基线的网络）：对同一个问题采样一组回答，用组内得分的均值和标准差当基线 |

> [!warning] 讲义笔误
> 讲义把两个缩写的展开写反了："Direct **Policy** Optimization"、"Group Relative **Preference** Optimization"。正确名称是 **Direct Preference Optimization**（Rafailov et al. 2023）和 **Group Relative Policy Optimization**（Shao et al. 2024，DeepSeekMath）。

挑战：
- 强化学习算法不稳定、难调；
- 规模上去之后要大量新基础设施，比如**异步 rollout 推理**（rollout：让当前模型生成回答的过程；异步：生成与训练分开并行跑）；
- 系统效率与 **on-policy 程度**之间要不断权衡。on-policy 指用当前参数生成的数据更新当前参数；为了吞吐让生成端用稍旧的参数，就会偏离 on-policy。

**A5 (alignment)**：实现 DPO 与 GRPO。

### 4.6 收束：一切为了效率

资源 = 数据 + 硬件（算力、内存、通信带宽）。问题始终是：**资源固定，怎么训出最好的模型？**

**今天我们受算力约束**，所以设计决策都在压榨硬件：

| 环节 | 效率体现 |
|---|---|
| 系统 | 不言自明 |
| tokenization | 直接处理原始字节很优雅，但在今天的模型架构下算力上不划算 |
| 模型架构 | 很多改动是为了省内存或 FLOPs，如共享 KV cache、滑动窗口注意力 |
| 数据过滤 | 不把宝贵的算力浪费在差数据或无关数据上 |
| scaling laws | 在小模型上花少量算力调超参 |

**明天我们会受数据约束……**（算力的增长快于可用的高质量数据。）

## 5 Tokenization

> [!info] 参考
> 讲义说本单元受 Karpathy 的视频启发，推荐一看：[Let's build the GPT Tokenizer](https://www.youtube.com/watch?v=zduSFxRajkE)。

### 5.1 问题定义

原始文本是 Unicode 字符串，语言模型处理的是整数序列，所以需要一对过程：**encode**（字符串 → token 序列）与 **decode**（token 序列 → 字符串）。讲义里的接口：

```python
class Tokenizer(ABC):
    """Abstract interface for a tokenizer."""
    def encode(self, string: str) -> list[int]:
        raise NotImplementedError

    def decode(self, indices: list[int]) -> str:
        raise NotImplementedError
```

写成映射：记 $\Sigma$ 为 Unicode 字符集、$V$ 为 token 编号的集合，则 $\text{encode}:\Sigma^*\to V^*$，$\text{decode}:V^*\to\Sigma^*$。**硬性要求只有一条：无损往返 (round-trip)**

$$\text{decode}\circ\text{encode}=\mathrm{id}_{\Sigma^*}.$$

所以 encode 必须是单射；反过来 $\text{encode}\circ\text{decode}\ne\mathrm{id}$——同一个字符串可以对应多种 token 序列，encode 只挑其中一种（"规范切分"，例子在 §5.6）。严格说 decode 只是部分函数：并非每个 token 序列都能解出合法字符串（§5.2 就有一个反例）。

两个工程指标：

| 指标 | 定义 | 希望 | 为什么 |
|---|---|---|---|
| 压缩率 (compression ratio) | UTF-8 字节数 ÷ token 数 | 大 | 序列短 → attention（$\propto n^2$）便宜，同样的上下文窗口装下更多文本 |
| 词表大小 $\lvert V\rvert$ | token 编号的个数 | 适中 | 太大：嵌入层与输出层参数 $\propto\lvert V\rvert\cdot d$，且每个 token 出现得更稀疏、更难学 |

量级感：词表 200,019、隐藏维度 $d=4096$ 时，光输入嵌入矩阵就有约 8.2 亿个参数。

```python
def get_compression_ratio(string: str, indices: list[int]) -> float:
    """每个 token 平均对应多少个 UTF-8 字节。"""
    num_bytes = len(bytes(string, encoding="utf-8"))
    num_tokens = len(indices)
    return num_bytes / num_tokens
```

### 5.2 先看一个真实的 tokenizer

讲义的示意图用的就是 GPT-5 的 tokenizer（tiktoken 库里的 `o200k_base`），本地复现一致：

![encode 与 decode](https://raw.githubusercontent.com/stanford-cs336/lectures/main/images/tokenized-example.png)

```
"Stanford was founded in 1885."
→ [93447, 9201, 673, 24303, 306, 220, 13096, 20, 13]
→ "Stan" | "ford" | " was" | " founded" | " in" | " " | "188" | "5" | "."
```

在 [tiktokenizer](https://tiktokenizer.vercel.app/?encoder=gpt2) 上玩一会儿，能看到三条规律（括号里是 `o200k_base` 的实测）：

1. **单词和它前面的空格属于同一个 token**：`" world"` 是一个 token（2375）。
2. **同一个词在开头和在中间编码不同**：`"hello hello"` → `hello`(24912) + `" hello"`(40617)。
3. **数字每几位切一段**：`"1234567"` → `123` | `456` | `7`。

讲义接着用 tiktoken 调用 GPT-5 的 tokenizer：

```python
tokenizer = tiktoken.get_encoding("o200k_base")
string = "Hello, 🌍! 你好!"
indices = tokenizer.encode(string)          # [13225, 11, 130321, 235, 0, 220, 177519, 0]
assert tokenizer.decode(indices) == string  # 往返无损
```

逐个 token 看（`␣` 表示空格）：

| token id | 对应字节 | 说明 |
|---|---|---|
| 13225 | `Hello` | |
| 11 | `,` | |
| 130321 | `␣ F0 9F 8C` | 空格 + 🌍 的**前 3 个字节** |
| 235 | `8D` | 🌍 的**最后 1 个字节** |
| 0 | `!` | |
| 220 | `␣` | |
| 177519 | `E4 BD A0 E5 A5 BD` | "你好"两个字合成一个 token |
| 0 | `!` | |

- 20 字节 / 8 token → **压缩率 2.5**（这句含 emoji 和中文，低于英文常见的 ~4）。
- 词表大小 `n_vocab` = **200,019** = 最大编号 + 1。其中普通 token 199,998 个（编号 0–199,997），另有特殊 token `<|endoftext|>`(199,999) 和 `<|endofprompt|>`(200,018)。

> [!warning] 反直觉：token 不一定是完整的字符
> 🌍 的 4 个 UTF-8 字节被切进了两个 token，单独 decode 其中任何一个都会失败。于是：(1) 讲义导出词表文件时要用 `errors="replace"`；(2) 聊天界面流式输出时，必须先缓存不完整的字节，凑齐一个字符再显示。

### 5.3 方案一：字符 tokenizer

每个 Unicode 字符对应一个整数 code point：`ord` 取码，`chr` 还原。

```python
assert ord("a") == 97 and chr(97) == "a"
assert ord("🌍") == 127757 and chr(127757) == "🌍"

class CharacterTokenizer(Tokenizer):
    """把字符串表示成 Unicode code point 序列。"""
    def encode(self, string: str) -> list[int]:
        return list(map(ord, string))

    def decode(self, indices: list[int]) -> str:
        return "".join(map(chr, indices))
```

`"Hello, 🌍! 你好!"` → `[72, 101, 108, 108, 111, 44, 32, 127757, 33, 32, 20320, 22909, 33]`，13 个 token。

- **词表**：Unicode 目前约有 15 万个字符（code point 空间是 0 到 0x10FFFF）。仅这一句话就把词表下界推到 127,758（`max(indices) + 1`）。
- **压缩率**：20 / 13 ≈ **1.54**。

问题：① 词表很大；② 很多字符极少出现（比如 🌍），白占词表位置。**两头都差：词表大，压缩率还低。**

### 5.4 方案二：字节 tokenizer

把字符串按 UTF-8 编码成字节，每个字节（0–255）就是一个 token。

> [!note] UTF-8 速览
>
> | code point 范围 | 字节数 | 位模式 |
> |---|---|---|
> | U+0000 – U+007F | 1 | `0xxxxxxx` |
> | U+0080 – U+07FF | 2 | `110xxxxx 10xxxxxx` |
> | U+0800 – U+FFFF | 3 | `1110xxxx 10xxxxxx 10xxxxxx` |
> | U+10000 – U+10FFFF | 4 | `11110xxx 10xxxxxx 10xxxxxx 10xxxxxx` |
>
> 这是一个**前缀码**：看首字节的高位就知道这个字符占几个字节，`10` 开头的永远是后续字节。所以单独一个 `8D`（`10001101`）不是合法字符——这就是 §5.2 那个 token 解不出来的原因。
>
> 例：`a` → `61`；`你`(U+4F60) → `E4 BD A0`；`好`(U+597D) → `E5 A5 BD`；`🌍`(U+1F30D) → `F0 9F 8C 8D`。

```python
class ByteTokenizer(Tokenizer):
    """把字符串表示成字节序列。"""
    def encode(self, string: str) -> list[int]:
        string_bytes = string.encode("utf-8")
        return list(map(int, string_bytes))

    def decode(self, indices: list[int]) -> str:
        return bytes(indices).decode("utf-8")
```

`"Hello, 🌍! 你好!"` → 20 个 token：
`[72, 101, 108, 108, 111, 44, 32, 240, 159, 140, 141, 33, 32, 228, 189, 160, 229, 165, 189, 33]`

- **词表**：256，又小又整齐。
- **压缩率**：**恰好 1**。序列太长，而 Transformer 的上下文长度有限（attention 是平方复杂度），"看起来不太妙"。

### 5.5 方案三：词 tokenizer

更接近传统 NLP 的做法：按词切。

```python
string = "I'll say supercalifragilisticexpialidocious!"
chunks = regex.findall(r"\w+|.", string)
# ['I', "'", 'll', ' ', 'say', ' ', 'supercalifragilisticexpialidocious', '!']
```

正则 `\w+|.` 的意思：连续的字母 / 数字 / 下划线算一块（`\w+`）；否则（`|`）任意单个字符自成一块（`.`）。再给每个不同的块分配一个整数，就是一个 tokenizer。

- **优点**：每个 token 都有意义（词是人发明的单位）。
- **压缩率**：44 字节 / 8 块 = **5.5**，很好。

问题：
- 词表可能巨大，而且**没有固定上限**，取决于训练数据里出现过多少不同的块；
- 很多词很罕见，模型学不到什么；
- 训练时没见过的词只能映射成特殊的 **UNK** token，既丑陋，又会搞乱 perplexity 的计算（练习 8）。

### 5.6 方案四：BPE (Byte Pair Encoding)

**来历**：Philip Gage 1994 年提出的数据压缩算法 → Sennrich et al. (2016) 用于神经机器翻译（此前的论文多用词 tokenizer）→ GPT-2 (2019) 采用，此后成为语言模型的标配。

**基本想法**：在原始文本上**训练** tokenizer，构造贴合数据的词表。常见的字节序列用一个 token 表示，罕见的序列用多个 token 表示。

**做法**：从"每个字节一个 token"出发，反复把**出现最多的相邻 token 对**合并成一个新 token。

#### 训练算法

> **输入**：训练文本 $s$，合并次数 $k$
> 1. $x\leftarrow s$ 的 UTF-8 字节序列；词表 $\text{vocab}[b]=$ `bytes([b])`，$b=0,\dots,255$
> 2. 对 $i=0,\dots,k-1$：
>    - 统计每个相邻对 $(x_j,x_{j+1})$ 的出现次数 $c(p)$
>    - $p^*\leftarrow\arg\max_p c(p)$
>    - 新编号 $256+i$：$\text{vocab}[256+i]=\text{vocab}[p^*_0]+\text{vocab}[p^*_1]$，记录合并规则 $p^*\mapsto256+i$
>    - 在 $x$ 中**从左到右、不重叠地**把 $p^*$ 替换成 $256+i$
> 3. **输出**：词表（大小 $256+k$）与**有序的**合并规则表

#### 手算讲义的例子："the cat in the hat"，合并 3 次

初始是 18 个字节：`[116, 104, 101, 32, 99, 97, 116, 32, 105, 110, 32, 116, 104, 101, 32, 104, 97, 116]`

| 轮次 | 出现 2 次的相邻对（其余均 1 次） | 选中 | 新 token | 合并后长度 |
|---|---|---|---|---|
| 1 | `th` `he` `e␣` `at` | (116, 104) | 256 = `b"th"` | 16 |
| 2 | `(th)e` `e␣` `at` | (256, 101) | 257 = `b"the"` | 14 |
| 3 | `(the)␣` `at` | (257, 32) | 258 = `b"the "` | 12 |

最终 `[258, 99, 97, 116, 32, 105, 110, 32, 258, 104, 97, 116]`，12 个 token，压缩率 18 / 12 = **1.5**。

两个细节：
- **平局怎么破？** 每一轮都有多个对并列最多。讲义代码用 `max(counts, key=counts.get)`，返回**最先出现**的那个，所以 `at` 一直有 2 次却一直落选。A1 则规定**选字典序更大的对**，保证不同人的实现结果一致。
- **合并跨过了词边界。** 第 3 轮学到的 `"the "` 带着尾随空格。真实的 tokenizer 会先做 pre-tokenization（见下文），把空格粘在**后一个**词的开头（`" cat"`），不允许跨块合并。

#### 编码新文本

按训练时的**顺序**，把合并规则逐条应用到整个序列上：

```
"the quick brown fox"（19 字节）
→ [258, 113, 117, 105, 99, 107, 32, 98, 114, 111, 119, 110, 32, 102, 111, 120]（16 个 token）
```

只有开头的 `"the "` 被合并；`quick`、`brown`、`fox` 训练时没见过，就老老实实保持字节。**这是 BPE 相对词 tokenizer 的关键优势：任何字节串都能编码，永远不需要 UNK。**

**规范切分**：`decode([116, 104, 101])`、`decode([256, 101])`、`decode([257])` 都是 `"the"`，但 `encode("the")` 只会给出 `[257]`。模型训练时只见过 encode 产生的规范切分。

#### 代码走读

```python
def merge(indices: list[int], pair: tuple[int, int], new_index: int) -> list[int]:
    """把 indices 里所有的 pair 替换成 new_index（从左到右、不重叠）。"""
    new_indices = []
    i = 0
    while i < len(indices):
        if i + 1 < len(indices) and indices[i] == pair[0] and indices[i + 1] == pair[1]:
            new_indices.append(new_index)
            i += 2                        # 匹配成功，一次吃掉两个
        else:
            new_indices.append(indices[i])
            i += 1
    return new_indices


@dataclass(frozen=True)
class BPETokenizerParams:
    """确定一个 BPE tokenizer 所需的全部信息。"""
    vocab: dict[int, bytes]               # 编号 -> 字节串
    merges: dict[tuple[int, int], int]    # (编号1, 编号2) -> 新编号；插入顺序就是合并顺序


def count_adjacent_pairs(indices: list[int]) -> dict[tuple[int, int], int]:
    counts = defaultdict(int)
    for index1, index2 in zip(indices, indices[1:]):
        counts[(index1, index2)] += 1
    return counts


def train_bpe(string: str, num_merges: int) -> BPETokenizerParams:
    indices = list(map(int, string.encode("utf-8")))
    merges: dict[tuple[int, int], int] = {}
    vocab: dict[int, bytes] = {x: bytes([x]) for x in range(256)}
    for i in range(num_merges):
        counts = count_adjacent_pairs(indices)
        pair = max(counts, key=counts.get)        # 出现最多的相邻对（平局取先出现的）
        new_index = 256 + i
        merges[pair] = new_index
        vocab[new_index] = vocab[pair[0]] + vocab[pair[1]]
        indices = merge(indices, pair, new_index)
    return BPETokenizerParams(vocab=vocab, merges=merges)


class BPETokenizer(Tokenizer):
    def __init__(self, params: BPETokenizerParams):
        self.params = params

    def encode(self, string: str) -> list[int]:
        indices = list(map(int, string.encode("utf-8")))
        # 注意：很慢，要遍历全部合并规则
        for pair, new_index in self.params.merges.items():
            indices = merge(indices, pair, new_index)
        return indices

    def decode(self, indices: list[int]) -> str:
        bytes_list = list(map(self.params.vocab.get, indices))
        return b"".join(bytes_list).decode("utf-8")
```

> [!tip] 这段代码里的 Python 要点
>
> | 写法 | 含义 |
> |---|---|
> | `@dataclass(frozen=True)` | 自动生成 `__init__` 等方法；`frozen` 让实例不可修改（训练好的参数就此定死） |
> | `dict[tuple[int, int], int]` | 类型标注，只给人和工具看，运行时不检查 |
> | `defaultdict(int)` | 访问不存在的键时自动给默认值 `int()`，即 0，所以 `+= 1` 前不用判断键是否存在 |
> | `zip(indices, indices[1:])` | 生成相邻对 $(x_0,x_1),(x_1,x_2),\dots$ |
> | `max(counts, key=counts.get)` | 对字典的**键**取最大，比较依据是对应的值；并列时返回迭代中遇到的第一个。字典按插入顺序迭代，于是"先出现者胜" |
> | `bytes([97])` 与 `bytes(3)` | 前者是 `b'a'`；后者是 3 个零字节 `b'\x00\x00\x00'`，常见陷阱 |
> | `b"".join(...)` | 把一串 `bytes` 拼起来 |
> | `merge` 里用 `while` 而非 `for` | 匹配成功时要跳过两个位置，需要手动控制下标 |

#### 从玩具到能用：A1 要做的改进

讲义列了四条：

1. **encode 不要遍历全部合并规则**，只处理用得上的；
2. **识别并保留特殊 token**，如 `<|endoftext|>`（分隔文档，必须始终是一个 token）；
3. **使用 pre-tokenization**，如 GPT-2 的正则；
4. **尽可能快。**

为什么必须优化：设训练文本长 $L$ 字节、合并 $k$ 次。玩具实现每一轮都全文计数、全文替换，训练是 $O(kL)$。A1 要在 TinyStories 上训 10K 词表、在 OpenWebText 上训 32K 词表（后者要求 ≤ 12 小时、≤ 100 GB 内存、不用 GPU），而 $L$ 是 GB 量级。

| 瓶颈 | 优化思路 |
|---|---|
| 每轮全文计数 | 先 pre-tokenize，统计"每个不同的块出现几次"，在块上计数（`text` 出现 10 次，就一次加 10） |
| 每轮重算全部计数 | 一次合并只影响被合并位置两侧的相邻对，**增量更新**计数 |
| pre-tokenization 本身 | 按 `<\|endoftext\|>` 把语料切成大块，**多进程并行** |
| encode 遍历全部规则 | 反复在当前序列里找**合并序号最小**的相邻对并合并，直到无对可合并。它与"按序遍历全部规则"输出相同（练习 4） |

**Pre-tokenization**：先用正则把文本粗切成块，BPE 只在块内合并。A1 用的 GPT-2 风格正则：

```python
PAT = r"""'(?:[sdmt]|ll|ve|re)| ?\p{L}+| ?\p{N}+| ?[^\s\p{L}\p{N}]+|\s+(?!\S)|\s+"""
```

| 分支 | 匹配什么 |
|---|---|
| `'(?:[sdmt]\|ll\|ve\|re)` | 英文缩写后缀：`'s` `'d` `'m` `'t` `'ll` `'ve` `'re` |
| `␣?\p{L}+` | 可带一个前导空格的字母串（`\p{L}` 是任何语言的字母，包括汉字） |
| `␣?\p{N}+` | 可带一个前导空格的数字串 |
| `␣?[^\s\p{L}\p{N}]+` | 可带一个前导空格的标点 / 符号串 |
| `\s+(?!\S)` | 一串空白，但把最后一个空格留给后面的词 |
| `\s+` | 其余空白 |

实测（`import regex as re`，然后 `re.findall(PAT, text)`）：

```
"some text that i'll pre-tokenize" → ['some', ' text', ' that', ' i', "'ll", ' pre', '-', 'tokenize']
"hello hello world 1234567"        → ['hello', ' hello', ' world', ' 1234567']
"Hello, 🌍! 你好!"                  → ['Hello', ',', ' 🌍!', ' 你好', '!']
```

这解释了 §5.2 的规律 1、2：`" world"` 与 `"hello"`、`" hello"` 在 pre-tokenization 阶段就已经是不同的块。规律 3 来自更新的 tokenizer：`o200k_base` 的正则里有 `\p{N}{1,3}`，先把数字切成最多 3 位一段；GPT-2 的正则则把整串数字放在一块。

Pre-tokenization 的三个好处：
- **快**：只对"不同的块"计数；
- **词表干净**：不会出现 `dog.`、`dog!` 这种只差一个标点却各占一个编号的 token；
- **不跨词合并**：不会学出玩具例子里 `"the "` 那样的 token。

A1 另外要求：训练前先按特殊 token 切开语料（`[Doc 1]<|endoftext|>[Doc 2]` 两段分别处理），保证不会跨文档合并。

### 5.7 小结与展望

| 方案 | 词表 | 压缩率（本讲示例） | 主要问题 |
|---|---|---|---|
| 字符 | ~15 万，且很稀疏 | 1.54 | 词表大 + 压缩率低 |
| 字节 | 256 | 1.0 | 序列太长 |
| 词 | 无上限 | 5.5 | 罕见词、UNK |
| **BPE** | 可控：$256+k$ | GPT-5 tokenizer 在示例句上 2.5，英文约 4 | 启发式，且是独立于模型的预处理步骤 |

讲义的总结：
- tokenizer：字符串 ↔ token（整数编号）；
- 字符、字节、词三种切法都远非最优；
- **BPE 是一个有效的、数据驱动的启发式方法**；
- tokenization 目前是一个独立步骤，也许有一天能端到端地直接从字节学起。

**梦想：无 tokenizer 的架构**，直接在字节上工作：ByT5 (2021)、MEGABYTE (2023)、BLT (2024)、T-FREE (2024)、H-Net (2025)。前景可观，但都还没在前沿规模上验证过。

无论最终方案是什么，讲义认为都要满足：
1. 模型（比如 Transformer）应当在序列的**块**（抽象单位）上操作——文本、视频、DNA 都一样；
2. 块应当**可变长**，把更多模型容量分给"有意思"的部分。

> [!abstract] 工程视角的一句话
> tokenizer 本质上是**一层为当前硬件与架构的经济性服务的压缩**：用 BPE 把序列压短约 4 倍，换来 attention 平方开销的大幅下降。字节级建模更优雅，只是今天还算不起。

**下一讲**：资源核算（PyTorch 与 FLOPs / 显存的精确计算）。

## 6 练习

难度大致递增，答案默认折叠。

**练习 1（UTF-8 手算）** 把"好"（U+597D）手工编码成 UTF-8 字节；再解释为什么 `bytes([0x8D]).decode("utf-8")` 会报错。

> [!example]- 答案
> U+597D 落在 U+0800–U+FFFF，占 3 字节，模板 `1110xxxx 10xxxxxx 10xxxxxx` 共 16 个 x。
> 0x597D = `0101 1001 0111 1101`，按 4 | 6 | 6 位切成 `0101` | `100101` | `111101`，填进模板得 `11100101 10100101 10111101` = `E5 A5 BD`。
> `8D` = `10001101`，以 `10` 开头，是后续字节；前面没有首字节，构不成合法字符。

**练习 2（从 token id 反推字节）** §5.2 中 GPT-5 tokenizer 的输出是 `[13225, 11, 130321, 235, 0, 220, 177519, 0]`。已知这类 tokenizer 的 256 个单字节 token 这样编号：先按字节值从小到大排 188 个"可打印"字节（`0x21–0x7E`、`0xA1–0xAC`、`0xAE–0xFF`），编号 0–187；再按字节值从小到大排其余 68 个（`0x00–0x20`、`0x7F–0xA0`、`0xAD`），编号 188–255。只用这条规则和原字符串的 UTF-8 字节，推出每个 token 的内容。

> [!example]- 答案
> - 0 → 第一组第 0 个 = `0x21` = `!`；11 → `0x21 + 11 = 0x2C` = `,`。
> - 220 → 第二组第 $220-188=32$ 个。第二组先是 `0x00–0x20`，所以是 `0x20` = 空格。
> - 235 → 第二组第 47 个。`0x00–0x20` 占了 33 个，于是是 `0x7F` 之后第 14 个：`0x7F + 14 = 0x8D`。
> - 原串字节流：`Hello` `,` `␣` `F0 9F 8C 8D` `!` `␣` `E4 BD A0` `E5 A5 BD` `!`，共 20 字节。已确定的 5 个单字节 token 分别是 `,`、`8D`、`!`、`␣`、`!`；按顺序对齐，剩下的多字节 token 只能是 13225 = `Hello`、130321 = `␣ F0 9F 8C`、177519 = `E4 BD A0 E5 A5 BD`（你好）。
> - 本地用 tiktoken 验证一致。

**练习 3（A1 handout 里的例子）** 语料是 `low low low low low lower lower widest widest widest newest newest newest newest newest newest`，按空格 pre-tokenize，平局取字典序更大的对。手算前 6 次合并，并给出 `newest` 的切分。

> [!example]- 答案
> 词频 `{low: 5, lower: 2, widest: 3, newest: 6}`。第 1 轮相邻对计数：`lo 7, ow 7, we 8, er 2, wi 3, id 3, de 3, es 9, st 9, ne 6, ew 6`。`es` 与 `st` 并列，取字典序更大的 `st`。
> 继续：第 2 轮 `e st`（9）；第 3 轮 `lo`、`ow` 并列 7，取 `o w`；第 4 轮 `l ow`（7）；第 5 轮 `w est`、`n e`、`e w` 并列 6，取 `w est`；第 6 轮 `n e`、`e west` 并列 6，取 `n e`。
> 6 次合并：`s t`、`e st`、`o w`、`l ow`、`w est`、`n e`。`newest` → `[ne, west]`。

**练习 4（证明 encode 的快速版本正确）** 讲义的 `encode` 按训练顺序把每条合并规则在整个序列上各应用一遍。快速版本是：反复在当前序列中找**合并序号最小**的相邻对，把它的全部出现（从左到右、不重叠）合并，直到没有相邻对出现在规则表里。证明两者输出相同。

> [!example]- 答案
> 记第 $r$ 条规则为 $(a_r,b_r)\mapsto c_r$，序号越小越早学到。
>
> **事实 1：含 $c_r$ 的规则，序号都大于 $r$。** 训练时 $c_r$ 在第 $r$ 轮才产生，之后的轮次才可能统计到含它的对。
>
> **事实 2：把规则 $r$ 应用到一个"不含序号 $<r$ 的对"的序列上，结果不含序号 $\le r$ 的对。** 从左到右扫描时，若两个原有 token $a_r,b_r$ 在输出中相邻，它们在输入中也相邻，扫描到 $a_r$ 时就会被合并，矛盾；所以 $(a_r,b_r)$ 不再出现（$a_r=b_r$ 时如 `aaa` → `c a`，剩下的对含 $c_r$）。输出中两个原有 token 构成的相邻对在输入里就存在，序号不小于 $r$；新产生的对都含 $c_r$，由事实 1 序号 $>r$。
>
> 记朴素版本执行完规则 $0,\dots,r-1$ 后的序列为 $S_r$（$S_0$ 是字节序列），由事实 2 归纳，$S_r$ 不含序号 $<r$ 的对。设快速版本某一刻的序列 $T=S_{r}$，其中出现的最小序号为 $m\ge r$。对 $r\le s<m$，规则 $s$ 的对不在 $T$ 中，朴素版本执行它是空操作，所以 $S_m=T$；快速版本此时合并规则 $m$，得到 $S_{m+1}$。起点 $T=S_0$，归纳得快速版本始终走在朴素版本的轨迹上。当 $T=S_r$ 中没有任何规则的对时，朴素版本余下的规则全是空操作，两者终点相同。$\blacksquare$
>
> 本地用 60 条规则、3000 个随机字符串对拍，全部一致。

**练习 5（估算：训练要多久）** 70B 参数、1T tokens，用 B200（2.25 PFLOP/s）训练，MFU 取 50%。需要多少 GPU·天？1024 张卡要几天？

> [!example]- 答案
> $C=4.2\times10^{23}$ FLOPs。单卡有效速率 $2.25\times10^{15}\times0.5=1.125\times10^{15}$ FLOP/s。
> $4.2\times10^{23}\div1.125\times10^{15}\approx3.73\times10^{8}$ GPU·秒 ≈ **4,321 GPU·天**；1024 张卡约 **4.2 天**（忽略通信开销与故障重启）。

**练习 6（Chinchilla 配比）** 设 $C=6ND$ 且 $D=20N$。(a) 写出 $N_\text{opt}(C)$；(b) $C=10^{25}$ 时 $N$、$D$ 各是多少？(c) GPT-3（175B）实际训了 300B tokens，按这个配比应训多少？

> [!example]- 答案
> (a) $C=120N^2$，所以 $N_\text{opt}=\sqrt{C/120}$，$D_\text{opt}=20\sqrt{C/120}$。两者都 $\propto C^{1/2}$：算力翻 4 倍，模型和数据各翻 2 倍。
> (b) $N\approx2.89\times10^{11}$（289B），$D\approx5.77\times10^{12}$（5.8T）。
> (c) $175\text{B}\times20=3.5\text{T}$，是实际的 10 倍多——"GPT-3、PaLM 这一代 undertrained"说的就是这个。

**练习 7（Roller 表里的规律）** OPT 各规模的序列长度 $n=2048$，隐藏维度 $d$ 为：1536（760M，取同规模 GPT-3 的配置）、2048（1.3B）、2560（2.7B）、4096（6.7B）、5140（13B）、7168（30B）、9216（66B）、12288（175B）。(a) 估算每层每 token 的 FFN 运算量和"注意力打分 + 加权求和"的运算量；(b) 与表中 attn / FFN 之比对照。

> [!example]- 答案
> (a) FFN 是 $d\to4d\to d$ 两次矩阵乘法，共 $8d^2$ 次乘法，按"一乘一加"计 **$16d^2$** FLOPs。注意力：query 与 $n$ 个 key 做点积（$nd$ 次乘法），再对 $n$ 个 value 加权求和（$nd$ 次），计 **$4nd$** FLOPs。比值 $4nd/16d^2=n/(4d)$。
>
> (b)
>
> | 模型 | 表中 attn / FFN | $n/(4d)$ |
> |---|---|---|
> | 760M | 14.8 / 44 = 0.336 | 0.333 |
> | 1.3B | 12.7 / 51 = 0.249 | 0.250 |
> | 2.7B | 11.2 / 56 = 0.200 | 0.200 |
> | 6.7B | 8.1 / 65 = 0.125 | 0.125 |
> | 13B | 6.9 / 69 = 0.100 | 0.100 |
> | 30B | 5.3 / 74 = 0.072 | 0.071 |
> | 66B | 4.3 / 77 = 0.056 | 0.056 |
> | 175B | 3.3 / 80 = 0.041 | 0.042 |
>
> 全部吻合到 1% 左右。$n$ 不变时，规模越大，FFN 越占大头。

**练习 8（UNK 与 perplexity）** (a) 为什么把没见过的词统一映射成 UNK，会让 perplexity 失真？(b) 两个 tokenizer 不同的模型，能直接比较 per-token perplexity 吗？怎样比才公平？

> [!example]- 答案
> (a) 所有罕见词被并进 UNK 这一个大类，它频率高、很好预测；模型给 UNK 高概率就能拿到低 perplexity，却根本没预测出是哪个词。极端情况下几乎所有词都算 UNK，perplexity 可以趋近 1。
> (b) 不能：切法不同，每个 token 承载的信息量不同，per-token 的数字没有可比性。公平的做法是按**原始字节**归一化：整段文本的总负对数似然（以 2 为底）除以字节数，得到 **bits per byte**，它与切分方式无关。

**练习 9（编程，选做）** 在讲义代码的基础上实现 A1 风格的训练器：GPT-2 正则 pre-tokenization、块频数统计、相邻对计数的增量更新、字典序破平局。先用练习 3 的语料检查，再跑 [A1 仓库](https://github.com/stanford-cs336/assignment1-basics) 里的单元测试。

## Related

- 栏目索引：[[notes/cs336/index|CS336：从零构建语言模型]]
- 下一讲：02 PyTorch 与资源核算（待写）
- 数学背景：[[notes/deep-learning/12 Transformer|DL 12 Transformer]]（attention 的定义与复杂度）、[[notes/deep-learning/05 优化的数学|DL 05 优化的数学]]（Adam / AdamW）
- in-context learning 的理论：[[09 ICL 的数学表述：任务分布与贝叶斯预测器]]

## 参考

- **讲义**：[lecture_01.py](https://github.com/stanford-cs336/lectures/blob/main/lecture_01.py) · [trace](https://cs336.stanford.edu/lectures/?trace=lecture_01) · [课程主页](https://cs336.stanford.edu/)
- **A1**：[仓库](https://github.com/stanford-cs336/assignment1-basics) · [handout](https://github.com/stanford-cs336/assignment1-basics/blob/main/cs336_assignment1_basics.pdf)
- **Tokenization**：Karpathy, [Let's build the GPT Tokenizer](https://www.youtube.com/watch?v=zduSFxRajkE) · [tiktokenizer](https://tiktokenizer.vercel.app/?encoder=gpt2) · Gage 1994, [A New Algorithm for Data Compression](http://www.pennelynn.com/Documents/CUJ/HTML/94HTML/19940045.HTM) · Sennrich et al. 2016, [arXiv:1508.07909](https://arxiv.org/abs/1508.07909) · Radford et al. 2019, [GPT-2](https://cdn.openai.com/better-language-models/language_models_are_unsupervised_multitask_learners.pdf)
- **无 tokenizer 架构**：[ByT5](https://arxiv.org/abs/2105.13626) · [MEGABYTE](https://arxiv.org/abs/2305.07185) · [BLT](https://arxiv.org/abs/2412.09871) · [T-FREE](https://arxiv.org/abs/2406.19223) · [H-Net](https://arxiv.org/abs/2507.07955)
- **规模与效率**：Sutton, [The Bitter Lesson](http://www.incompleteideas.net/IncIdeas/BitterLesson.html) · Hernandez & Brown 2020, [arXiv:2005.04305](https://arxiv.org/abs/2005.04305) · Kaplan et al. 2020, [arXiv:2001.08361](https://arxiv.org/abs/2001.08361) · Hoffmann et al. 2022 (Chinchilla), [arXiv:2203.15556](https://arxiv.org/abs/2203.15556) · Wei et al. 2022, [arXiv:2206.07682](https://arxiv.org/abs/2206.07682) · Schaeffer et al. 2023, [arXiv:2304.15004](https://arxiv.org/abs/2304.15004) · [Roller 的 FLOPs 表](https://x.com/stephenroller/status/1579993017234382849)
- **架构与报告**：Shazeer 2020 (SwiGLU), [arXiv:2002.05202](https://arxiv.org/abs/2002.05202) · OpenAI 2023, [GPT-4 Technical Report](https://arxiv.org/abs/2303.08774)
- **对齐**：[PPO](https://arxiv.org/abs/1707.06347) · [InstructGPT](https://arxiv.org/abs/2203.02155) · [DPO](https://arxiv.org/abs/2305.18290) · [GRPO（DeepSeekMath）](https://arxiv.org/abs/2402.03300)
- **系统**：Williams, Waterman & Patterson 2009, [Roofline](https://dl.acm.org/doi/10.1145/1498765.1498785) · [How to Scale Your Model](https://jax-ml.github.io/scaling-book/)
- **Marin**：[marin.community](https://marin.community/)
