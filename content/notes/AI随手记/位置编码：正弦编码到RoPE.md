tokenization以后要加上位置向量。

正弦编码：频率 $w_i := 10000^{-2i/d}$ ， 位置向量 $p_m:=(\sin mw_0,\cos mw_0, \sin mw_1, \cos mw_1, \cdots) \in \mathbb R^d$

为啥这么定义：
1. （线性平移）$p_{m+k} = T_k p_m$，相对位置差异从线性变换体现出来。
2. （平移不变）$<p_m,p_n> = \sum_{i} \cos(n-m)w_i = \kappa(m-n)$。Bochner：平移不变kernel function 

