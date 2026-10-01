tokenization要加上位置向量。

# 正弦编码
正弦编码：频率 $w_i := 10000^{-2i/d}$ ， 位置向量 $p_m:=(\sin mw_0,\cos mw_0, \sin mw_1, \cos mw_1, \cdots) \in \mathbb R^d$

为啥这么定义：
1. （线性平移）$p_{m+k} = T_k p_m$，相对位置差异从不依赖m的线性变换 $T_k$ 体现出来。直白地说就是往回看k个位置这个动作，必须用的同一个规则。原文的说法是“线性关系容易被神经网络学会”。而且从Transformer设计上看，$Q, K, V$ 被所有token共享，不可能训练出针对位置的权重调整，相对位置关系只能预处理掉。
2. （previous token head）多头注意力相当于学多个特征，理想情况（expect这个是因为在 GPT-2 等早期模型观察到了这个现象）是对每个$k$，总有一个头h能学到位置关系 $^t Q^h K^h = c T_{k}$ ，$c$ 充分大。则（如果masked就$n \le m$，后文只能看前文） $s_{mn} = c p_m^t T_k p_n = c p_m^t p_{n+k} = c \sum_{i} \cos (m-n-k)w_i = c \kappa (m-n-k)$，在 $m = n + k$ 的时候得分最高，softmax以后往前 $k$ 权重最大。又因为 $c$ 充分大，softmax以后大致是一个（比如 $k = 1$ 的时候）$$A^h = \begin{pmatrix}1&&&&\\1&0&&&\\0&1&0&&\\0&0&1&0&\\0&0&0&1&0\end{pmatrix}$$，则 $o_m = \sum_{m} a_{mn} v_n = v_{m-1} = V^h x_{m-1}$ 只有上一个位置贡献。
3. （平移不变）位置编码 $p: \mathbb Z \to \mathbb R^d$ 给出一个 $\mathbb Z$ 上的平移不变正定kernel $K(m,n) = <p_m, p_n> = \kappa(m-n)$。我们需要这个kernel本质上还是因为2的注意力机制（bilinear form）。关于这个有Bochner定理：平移不变正定kernel等价于正Borel测度（谱测度）的Fourier transform，放这里就是 $\kappa(t) = \int_{[-\pi, \pi]} e^{itw} d\mu (w)$  for some $\mu$。从这个出发可以证明有限维迫使谱测度离散，即 $\mu = \sum_i m_i \delta_{w_i}$。因此从设计角度讲，只要底层用Transformer并且位置编码是加法，那么位置编码就等价于选择频率。正弦编码是其中一种选择。
4. 频率取几何级数，相似度随距离按对数衰减几何级数 $\omega_i=b^{-2i/d}$ 相当于在 $[1/b,1]$ 上取了**对数均匀**的谱密度 $d\omega/\omega$。把求和看成黎曼和：
$$\frac{\kappa(D)}{d/2}\ \approx\ \int_0^1\cos(Db^{-u})\,du=\frac{\operatorname{Ci}(D)-\operatorname{Ci}(D/b)}{\ln b}\ \approx\ 1-\frac{\ln D+\gamma}{\ln b}\qquad(1\ll D\ll b).$$ 最后一步用了 $\operatorname{Ci}(x)\approx\gamma+\ln x$（$x\to0$）和 $\operatorname{Ci}(x)\to0$（$x\to\infty$）。所以区分1和2的距离和区分1000和2000的距离一样容易。
5. 原论文有实验验证，正弦编码如果换成可学习的位置嵌入，效果差不多。

# RoPE
从上面频率角度出发，**RoPE** 把平移不变直接放到了每个头的分数上：分数是 $q^\top R_{n-m}k$，无论 $W_Q,W_K$ 学成什么样，都是平移不变的。