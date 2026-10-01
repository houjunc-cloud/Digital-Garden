tokenization要加上位置向量。

正弦编码：频率 $w_i := 10000^{-2i/d}$ ， 位置向量 $p_m:=(\sin mw_0,\cos mw_0, \sin mw_1, \cos mw_1, \cdots) \in \mathbb R^d$

为啥这么定义：
1. （线性平移）$p_{m+k} = T_k p_m$，相对位置差异从不依赖m的线性变换 $T_k$ 体现出来。直白地说就是往回看k个位置这个动作，必须用的同一个规则。而且从Transformer设计上看，$Q, K, V$ 被所有token共享，不可能训练出针对位置的权重调整，相对位置关系只能预处理掉。
2. （平移不变）$<p_m,p_n> = \sum_{i} \cos(n-m)w_i = \kappa(m-n)$。Bochner：平移不变kernel function 
3. 原论文有实验验证，正弦编码换成可学习的位置嵌入，效果差不多。
