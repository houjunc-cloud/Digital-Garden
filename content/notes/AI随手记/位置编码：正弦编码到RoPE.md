tokenization要加上位置向量。

正弦编码：频率 $w_i := 10000^{-2i/d}$ ， 位置向量 $p_m:=(\sin mw_0,\cos mw_0, \sin mw_1, \cos mw_1, \cdots) \in \mathbb R^d$

为啥这么定义：
1. （线性平移）$p_{m+k} = T_k p_m$，相对位置差异从不依赖m的线性变换 $T_k$ 体现出来。直白地说就是往回看k个位置这个动作，必须用的同一个规则。原文的说法是“线性关系容易被神经网络学会”。而且从Transformer设计上看，$Q, K, V$ 被所有token共享，不可能训练出针对位置的权重调整，相对位置关系只能预处理掉。
2. （previous token head）多头注意力相当于学多个特征，理想情况（expect这个是因为在 GPT-2 等早期模型观察到了这个现象）是对每个$k$，总有一个头h能学到位置关系 $^t Q^h K^h = c T_{k}$ ，$c$ 充分大。则（如果masked就$n \le m$，后文只能看前文） $s_{mn} = c p_m^t T_k p_n = c p_m^t p_{n+k} = c \sum_{i} \cos (m-n-k)w_i = c \kappa (m-n-k)$，在 $m = n + k$ 的时候得分最高，softmax以后往前 $k$ 权重最大。又因为 $c$ 充分大，softmax以后大致是一个（比如 $k = 1$ 的时候）$$A^h = \begin{pmatrix}1&&&&\\1&0&&&\\0&1&0&&\\0&0&1&0&\\0&0&0&1&0\end{pmatrix}$$，则 $o_m = \sum_{m} a_{mn} v_n = v_{m-1} = V^h x_{m-1}$ 只有上一个位置贡献。
3. （平移不变）有Bochner定理，说的是平移不变正定kernel等价于正Borel测度（谱测度）的Fourier transform。
4. 原论文有实验验证，正弦编码如果换成可学习的位置嵌入，效果差不多。
